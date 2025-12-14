// Auth Controller - Handles authentication business logic
import { supabase } from '@/integrations/supabase/client';
import { UserModel } from '@/models/User';
import { User } from '@supabase/supabase-js';
import { Profile, AppRole } from '@/types/database';

export interface AuthResult {
  success: boolean;
  user?: User;
  profile?: Profile;
  role?: AppRole;
  error?: string;
}

export class AuthController {
  // Admin credentials (hardcoded for now)
  private static readonly ADMIN_EMAIL = 'nediusman@gmail.com';
  private static readonly ADMIN_PASSWORD = '158595Nedi';
  private static readonly ADMIN_USERNAME = 'NEDIUSMAN';

  // Sign in user
  static async signIn(email: string, password: string): Promise<AuthResult> {
    try {
      console.log('🔐 AuthController: Sign in attempt', { email });

      // Check for hardcoded admin
      if (email === this.ADMIN_EMAIL && password === this.ADMIN_PASSWORD) {
        console.log('👑 Admin login detected');
        
        const adminUser = {
          id: 'admin-nediusman-123',
          email: this.ADMIN_EMAIL,
          user_metadata: { username: this.ADMIN_USERNAME },
          created_at: new Date().toISOString(),
          updated_at: new Date().toISOString()
        } as User;
        
        const adminProfile = {
          id: 'admin-nediusman-123',
          username: this.ADMIN_USERNAME,
          avatar_url: null,
          total_score: 9999,
          created_at: new Date().toISOString(),
          updated_at: new Date().toISOString()
        } as Profile;

        return {
          success: true,
          user: adminUser,
          profile: adminProfile,
          role: 'admin'
        };
      }

      // Regular Supabase authentication
      const { data, error } = await supabase.auth.signInWithPassword({
        email,
        password
      });

      if (error) {
        console.log('❌ Sign in failed:', error.message);
        return {
          success: false,
          error: error.message
        };
      }

      if (!data.user) {
        return {
          success: false,
          error: 'No user data returned'
        };
      }

      // Fetch user profile and role
      const [profile, role] = await Promise.all([
        UserModel.getProfile(data.user.id),
        UserModel.getUserRole(data.user.id)
      ]);

      console.log('✅ Sign in successful');
      return {
        success: true,
        user: data.user,
        profile: profile || undefined,
        role: role || 'player'
      };

    } catch (error: any) {
      console.error('💥 AuthController sign in error:', error);
      return {
        success: false,
        error: error.message || 'Sign in failed'
      };
    }
  }

  // Sign up user
  static async signUp(email: string, password: string, username: string): Promise<AuthResult> {
    try {
      console.log('📝 AuthController: Sign up attempt', { email, username });

      const { data, error } = await supabase.auth.signUp({
        email,
        password,
        options: {
          emailRedirectTo: `${window.location.origin}/`,
          data: { username }
        }
      });

      if (error) {
        console.log('❌ Sign up failed:', error.message);
        return {
          success: false,
          error: error.message
        };
      }

      console.log('✅ Sign up successful');
      return {
        success: true,
        user: data.user || undefined
      };

    } catch (error: any) {
      console.error('💥 AuthController sign up error:', error);
      return {
        success: false,
        error: error.message || 'Sign up failed'
      };
    }
  }

  // Sign out user
  static async signOut(): Promise<{ success: boolean; error?: string }> {
    try {
      console.log('🚪 AuthController: Sign out');

      const { error } = await supabase.auth.signOut();

      if (error) {
        return {
          success: false,
          error: error.message
        };
      }

      return { success: true };

    } catch (error: any) {
      console.error('💥 AuthController sign out error:', error);
      return {
        success: false,
        error: error.message || 'Sign out failed'
      };
    }
  }

  // Get current session
  static async getCurrentSession() {
    try {
      const { data: { session }, error } = await supabase.auth.getSession();
      
      if (error) {
        console.error('Error getting session:', error);
        return null;
      }

      return session;
    } catch (error) {
      console.error('Error in getCurrentSession:', error);
      return null;
    }
  }

  // Check if user is admin
  static isAdmin(role: AppRole | null): boolean {
    return role === 'admin';
  }
}