// User Model - Handles user data operations
import { supabase } from '@/integrations/supabase/client';
import { Profile, AppRole } from '@/types/database';

export class UserModel {
  // Get user profile by ID
  static async getProfile(userId: string): Promise<Profile | null> {
    try {
      const { data, error } = await supabase
        .from('profiles')
        .select('*')
        .eq('id', userId)
        .single();

      if (error) throw error;
      return data as Profile;
    } catch (error) {
      console.error('Error fetching user profile:', error);
      return null;
    }
  }

  // Get user role by ID
  static async getUserRole(userId: string): Promise<AppRole | null> {
    try {
      const { data, error } = await supabase
        .from('user_roles')
        .select('role')
        .eq('user_id', userId)
        .single();

      if (error) throw error;
      return data.role as AppRole;
    } catch (error) {
      console.error('Error fetching user role:', error);
      return null;
    }
  }

  // Get all users (admin only)
  static async getAllUsers(): Promise<Profile[]> {
    try {
      const { data, error } = await supabase
        .from('profiles')
        .select('*')
        .order('total_score', { ascending: false });

      if (error) throw error;
      return data as Profile[];
    } catch (error) {
      console.error('Error fetching all users:', error);
      return [];
    }
  }

  // Update user profile
  static async updateProfile(userId: string, updates: Partial<Profile>): Promise<boolean> {
    try {
      const { error } = await supabase
        .from('profiles')
        .update(updates)
        .eq('id', userId);

      if (error) throw error;
      return true;
    } catch (error) {
      console.error('Error updating profile:', error);
      return false;
    }
  }

  // Grant admin role
  static async grantAdminRole(userId: string): Promise<boolean> {
    try {
      const { error } = await supabase
        .from('user_roles')
        .insert({ user_id: userId, role: 'admin' });

      if (error) throw error;
      return true;
    } catch (error) {
      console.error('Error granting admin role:', error);
      return false;
    }
  }
}