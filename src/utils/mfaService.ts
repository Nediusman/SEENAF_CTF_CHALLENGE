// Multi-Factor Authentication Service
import { supabase } from '@/integrations/supabase/client';
import { SecurityMonitor } from './securityMonitor';

export interface MFASetupResult {
  success: boolean;
  qrCode?: string;
  secret?: string;
  backupCodes?: string[];
  error?: string;
}

export interface MFAVerifyResult {
  success: boolean;
  error?: string;
}

export class MFAService {
  // Generate TOTP secret and QR code
  static async setupTOTP(userId: string): Promise<MFASetupResult> {
    try {
      // Generate a secure secret
      const secret = this.generateTOTPSecret();
      
      // Create QR code data
      const qrData = `otpauth://totp/SEENAF%20CTF:${userId}?secret=${secret}&issuer=SEENAF%20CTF`;
      
      // Generate backup codes
      const backupCodes = this.generateBackupCodes();
      
      // Store MFA settings in database
      const { error } = await supabase
        .from('user_mfa')
        .upsert({
          user_id: userId,
          totp_secret: secret,
          backup_codes: backupCodes,
          is_enabled: false, // User needs to verify first
          created_at: new Date().toISOString()
        });

      if (error) throw error;

      SecurityMonitor.logSecurityEvent({
        type: 'mfa_setup_initiated',
        severity: 'low',
        userId,
        description: 'User initiated MFA setup'
      });

      return {
        success: true,
        qrCode: qrData,
        secret,
        backupCodes
      };
    } catch (error: any) {
      SecurityMonitor.logSecurityEvent({
        type: 'mfa_setup_failed',
        severity: 'medium',
        userId,
        description: 'MFA setup failed',
        metadata: { error: error.message }
      });

      return {
        success: false,
        error: error.message || 'Failed to setup MFA'
      };
    }
  }

  // Verify TOTP code and enable MFA
  static async verifyAndEnableTOTP(userId: string, code: string): Promise<MFAVerifyResult> {
    try {
      // Get user's MFA settings
      const { data: mfaData, error: fetchError } = await supabase
        .from('user_mfa')
        .select('totp_secret, is_enabled')
        .eq('user_id', userId)
        .single();

      if (fetchError || !mfaData) {
        throw new Error('MFA not set up for this user');
      }

      // Verify the TOTP code
      const isValid = this.verifyTOTPCode(mfaData.totp_secret, code);
      
      if (!isValid) {
        SecurityMonitor.logSecurityEvent({
          type: 'mfa_verification_failed',
          severity: 'medium',
          userId,
          description: 'Invalid MFA code provided'
        });

        return {
          success: false,
          error: 'Invalid verification code'
        };
      }

      // Enable MFA
      const { error: updateError } = await supabase
        .from('user_mfa')
        .update({ 
          is_enabled: true,
          verified_at: new Date().toISOString()
        })
        .eq('user_id', userId);

      if (updateError) throw updateError;

      SecurityMonitor.logSecurityEvent({
        type: 'mfa_enabled',
        severity: 'low',
        userId,
        description: 'MFA successfully enabled for user'
      });

      return { success: true };
    } catch (error: any) {
      return {
        success: false,
        error: error.message || 'Failed to verify MFA code'
      };
    }
  }

  // Verify MFA during login
  static async verifyMFALogin(userId: string, code: string): Promise<MFAVerifyResult> {
    try {
      // Get user's MFA settings
      const { data: mfaData, error: fetchError } = await supabase
        .from('user_mfa')
        .select('totp_secret, backup_codes, is_enabled')
        .eq('user_id', userId)
        .single();

      if (fetchError || !mfaData || !mfaData.is_enabled) {
        return {
          success: false,
          error: 'MFA not enabled for this user'
        };
      }

      // Check if it's a backup code
      if (mfaData.backup_codes && mfaData.backup_codes.includes(code)) {
        // Remove used backup code
        const updatedBackupCodes = mfaData.backup_codes.filter(c => c !== code);
        
        await supabase
          .from('user_mfa')
          .update({ backup_codes: updatedBackupCodes })
          .eq('user_id', userId);

        SecurityMonitor.logSecurityEvent({
          type: 'mfa_backup_code_used',
          severity: 'medium',
          userId,
          description: 'Backup code used for MFA verification'
        });

        return { success: true };
      }

      // Verify TOTP code
      const isValid = this.verifyTOTPCode(mfaData.totp_secret, code);
      
      if (!isValid) {
        SecurityMonitor.logSecurityEvent({
          type: 'mfa_login_failed',
          severity: 'high',
          userId,
          description: 'Failed MFA verification during login'
        });

        return {
          success: false,
          error: 'Invalid MFA code'
        };
      }

      SecurityMonitor.logSecurityEvent({
        type: 'mfa_login_success',
        severity: 'low',
        userId,
        description: 'Successful MFA verification during login'
      });

      return { success: true };
    } catch (error: any) {
      return {
        success: false,
        error: error.message || 'Failed to verify MFA'
      };
    }
  }

  // Check if user has MFA enabled
  static async isMFAEnabled(userId: string): Promise<boolean> {
    try {
      const { data, error } = await supabase
        .from('user_mfa')
        .select('is_enabled')
        .eq('user_id', userId)
        .single();

      return !error && data?.is_enabled === true;
    } catch {
      return false;
    }
  }

  // Disable MFA (requires current verification)
  static async disableMFA(userId: string, code: string): Promise<MFAVerifyResult> {
    try {
      // First verify the current code
      const verifyResult = await this.verifyMFALogin(userId, code);
      if (!verifyResult.success) {
        return verifyResult;
      }

      // Disable MFA
      const { error } = await supabase
        .from('user_mfa')
        .update({ 
          is_enabled: false,
          disabled_at: new Date().toISOString()
        })
        .eq('user_id', userId);

      if (error) throw error;

      SecurityMonitor.logSecurityEvent({
        type: 'mfa_disabled',
        severity: 'medium',
        userId,
        description: 'MFA disabled for user account'
      });

      return { success: true };
    } catch (error: any) {
      return {
        success: false,
        error: error.message || 'Failed to disable MFA'
      };
    }
  }

  // Generate TOTP secret
  private static generateTOTPSecret(): string {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
    let secret = '';
    for (let i = 0; i < 32; i++) {
      secret += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    return secret;
  }

  // Generate backup codes
  private static generateBackupCodes(): string[] {
    const codes: string[] = [];
    for (let i = 0; i < 10; i++) {
      const code = Math.random().toString(36).substring(2, 10).toUpperCase();
      codes.push(code);
    }
    return codes;
  }

  // Verify TOTP code (simplified implementation)
  private static verifyTOTPCode(secret: string, code: string): boolean {
    // This is a simplified implementation
    // In production, use a proper TOTP library like 'otplib'
    
    if (!secret || !code || code.length !== 6) {
      return false;
    }

    // For demo purposes, accept any 6-digit code
    // Replace with actual TOTP verification
    const isNumeric = /^\d{6}$/.test(code);
    return isNumeric;
  }
}

// Database schema for MFA (run this in Supabase)
export const MFA_SCHEMA = `
-- Create user_mfa table
CREATE TABLE IF NOT EXISTS user_mfa (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  totp_secret TEXT,
  backup_codes TEXT[],
  is_enabled BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  verified_at TIMESTAMP WITH TIME ZONE,
  disabled_at TIMESTAMP WITH TIME ZONE,
  UNIQUE(user_id)
);

-- Enable RLS
ALTER TABLE user_mfa ENABLE ROW LEVEL SECURITY;

-- RLS policies
CREATE POLICY "Users can manage their own MFA" ON user_mfa
  FOR ALL USING (auth.uid() = user_id);

-- Indexes
CREATE INDEX idx_user_mfa_user_id ON user_mfa(user_id);
CREATE INDEX idx_user_mfa_enabled ON user_mfa(user_id, is_enabled);
`;