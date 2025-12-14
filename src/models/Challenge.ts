// Challenge Model - Handles challenge data operations
import { supabase } from '@/integrations/supabase/client';
import { Challenge, DifficultyLevel } from '@/types/database';

export interface CreateChallengeData {
  title: string;
  description: string;
  category: string;
  difficulty: DifficultyLevel;
  points: number;
  flag: string;
  hints?: string[];
}

export class ChallengeModel {
  // Get all active challenges
  static async getActiveChallenges(): Promise<Challenge[]> {
    try {
      const { data, error } = await supabase
        .from('challenges')
        .select('*')
        .eq('is_active', true)
        .order('created_at', { ascending: false });

      if (error) throw error;
      return data as Challenge[];
    } catch (error) {
      console.error('Error fetching challenges:', error);
      return [];
    }
  }

  // Get all challenges (admin only)
  static async getAllChallenges(): Promise<Challenge[]> {
    try {
      const { data, error } = await supabase
        .from('challenges')
        .select('*')
        .order('created_at', { ascending: false });

      if (error) throw error;
      return data as Challenge[];
    } catch (error) {
      console.error('Error fetching all challenges:', error);
      return [];
    }
  }

  // Get challenge by ID
  static async getChallengeById(id: string): Promise<Challenge | null> {
    try {
      const { data, error } = await supabase
        .from('challenges')
        .select('*')
        .eq('id', id)
        .single();

      if (error) throw error;
      return data as Challenge;
    } catch (error) {
      console.error('Error fetching challenge:', error);
      return null;
    }
  }

  // Create new challenge (admin only)
  static async createChallenge(challengeData: CreateChallengeData): Promise<Challenge | null> {
    try {
      const { data, error } = await supabase
        .from('challenges')
        .insert(challengeData)
        .select()
        .single();

      if (error) throw error;
      return data as Challenge;
    } catch (error) {
      console.error('Error creating challenge:', error);
      return null;
    }
  }

  // Update challenge (admin only)
  static async updateChallenge(id: string, updates: Partial<CreateChallengeData>): Promise<Challenge | null> {
    try {
      const { data, error } = await supabase
        .from('challenges')
        .update(updates)
        .eq('id', id)
        .select()
        .single();

      if (error) throw error;
      return data as Challenge;
    } catch (error) {
      console.error('Error updating challenge:', error);
      return null;
    }
  }

  // Delete challenge (admin only)
  static async deleteChallenge(id: string): Promise<boolean> {
    try {
      const { error } = await supabase
        .from('challenges')
        .delete()
        .eq('id', id);

      if (error) throw error;
      return true;
    } catch (error) {
      console.error('Error deleting challenge:', error);
      return false;
    }
  }

  // Get challenges by category
  static async getChallengesByCategory(category: string): Promise<Challenge[]> {
    try {
      const { data, error } = await supabase
        .from('challenges')
        .select('*')
        .eq('category', category)
        .eq('is_active', true)
        .order('points', { ascending: true });

      if (error) throw error;
      return data as Challenge[];
    } catch (error) {
      console.error('Error fetching challenges by category:', error);
      return [];
    }
  }

  // Get challenges by difficulty
  static async getChallengesByDifficulty(difficulty: DifficultyLevel): Promise<Challenge[]> {
    try {
      const { data, error } = await supabase
        .from('challenges')
        .select('*')
        .eq('difficulty', difficulty)
        .eq('is_active', true)
        .order('points', { ascending: true });

      if (error) throw error;
      return data as Challenge[];
    } catch (error) {
      console.error('Error fetching challenges by difficulty:', error);
      return [];
    }
  }
}