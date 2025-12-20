import { supabase } from '@/integrations/supabase/client';

export class AuthSecurity {
  // Password strength validation
  static validatePasswordStrength(password: string): {
    isValid: boolean;
    errors: string[];
    score: number;
  } {
    const errors: string[] = [];
    let score = 0;

    // Minimum length
    if (password.length < 12) {
      errors.push('Password must be at least 12 characters long');
    } else {
      score += 1;
    }

    // Character variety
    if (!/[a-z]/.test(password)) {
      errors.push('Password must contain lowercase letters');
    } else {
      score += 1;
    }

    if (!/[A-Z]/.test(password)) {
      errors.push('Password must contain uppercase letters');
    } else {
      score += 1;
    }

    if (!/\d/.test(password)) {
      errors.push('Password must contain numbers');
    } else {
      score += 1;
    }

    if (!/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password)) {
      errors.push('Password must contain special characters');
    } else {
      score += 1;
    }

    // Common password check
    const commonPasswords = [
      'password', '123456', 'qwerty', 'admin', 'letmein',
      'welcome', 'monkey', '1234567890', 'password123'
    ];
    
    if (commonPasswords.some(common => 
      password.toLowerCase().includes(common.toLowerCase())
    )) {
      errors.push('Password contains common patterns');
      score -= 2;
    }

    return {
      isValid: errors.length === 0 && score >= 4,
      errors,
      score: Math.max(0, score)
    };
  }

  // Multi-factor authentication
  static async enableMFA(userId: string, method: 'totp' | 'sms' = 'totp') {
    try {
      const { data, error } = await supabase.auth.mfa.enroll({
        factorType: method,
        friendlyName: `${method.toUpperCase()} Authentication`
      });

      if (error) throw error;
      return { success: true, data };
    } catch (error: any) {
      console.error('MFA enrollment failed:', error);
      return { success: false, error: error.message };
    }
  }

  // Session security
  static async validateSession(sessionToken?: string): Promise<boolean> {
    try {
      const { data: { user }, error } = sessionToken 
        ? await supabase.auth.getUser(sessionToken)
        : await supabase.auth.getUser();
      
      if (error || !user) return false;

      // Check session expiry
      const session = await supabase.auth.getSession();
      if (!session.data.session) return false;

      // Validate session integrity
      const sessionAge = Date.now() - new Date(session.data.session.created_at).getTime();
      const maxAge = 24 * 60 * 60 * 1000; // 24 hours

      return sessionAge < maxAge;
    } catch {
      return false;
    }
  }

  // Rate limiting for authentication attempts
  static createAuthRateLimit() {
    const attempts = new Map<string, { count: number; resetTime: number }>();
    
    return {
      checkLimit: (identifier: string, maxAttempts: number = 5, windowMs: number = 15 * 60 * 1000) => {
        const now = Date.now();
        const record = attempts.get(identifier);
        
        if (!record || now > record.resetTime) {
          attempts.set(identifier, { count: 1, resetTime: now + windowMs });
          return { allowed: true, remaining: maxAttempts - 1 };
        }
        
        if (record.count >= maxAttempts) {
          return { 
            allowed: false, 
            remaining: 0, 
            retryAfter: Math.ceil((record.resetTime - now) / 1000) 
          };
        }
        
        record.count++;
        return { allowed: true, remaining: maxAttempts - record.count };
      },
      
      reset: (identifier: string) => {
        attempts.delete(identifier);
      }
    };
  }

  // Generate secure session token
  static generateSecureToken(): string {
    const array = new Uint8Array(32);
    crypto.getRandomValues(array);
    return Array.from(array, byte => byte.toString(16).padStart(2, '0')).join('');
  }

  // Validate user permissions
  static async validateUserPermissions(userId: string, requiredRole: string): Promise<boolean> {
    try {
      const { data, error } = await supabase
        .from('user_roles')
        .select('role')
        .eq('user_id', userId)
        .single();

      if (error || !data) return false;

      const roleHierarchy = {
        'player': 0,
        'moderator': 1,
        'admin': 2
      };

      const userLevel = roleHierarchy[data.role as keyof typeof roleHierarchy] ?? 0;
      const requiredLevel = roleHierarchy[requiredRole as keyof typeof roleHierarchy] ?? 0;

      return userLevel >= requiredLevel;
    } catch {
      return false;
    }
  }
}