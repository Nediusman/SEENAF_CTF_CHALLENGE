// Submission Model - Handles submission data operations
import { supabase } from '@/integrations/supabase/client';
import { Submission } from '@/types/database';

export interface CreateSubmissionData {
  user_id: string;
  challenge_id: string;
  submitted_flag: string;
  is_correct: boolean;
}

export class SubmissionModel {
  // Submit flag for challenge
  static async submitFlag(userId: string, challengeId: string, flag: string): Promise<{ success: boolean; isCorrect: boolean; message: string }> {
    try {
      // First, get the correct flag from the challenge
      const { data: challenge, error: challengeError } = await supabase
        .from('challenges')
        .select('flag, points, title')
        .eq('id', challengeId)
        .single();

      if (challengeError) throw challengeError;

      const isCorrect = challenge.flag === flag;

      // Check if user already solved this challenge
      const { data: existingSubmission } = await supabase
        .from('submissions')
        .select('*')
        .eq('user_id', userId)
        .eq('challenge_id', challengeId)
        .eq('is_correct', true)
        .single();

      if (existingSubmission) {
        return {
          success: false,
          isCorrect: false,
          message: 'You have already solved this challenge!'
        };
      }

      // Create submission record
      const { error: submissionError } = await supabase
        .from('submissions')
        .insert({
          user_id: userId,
          challenge_id: challengeId,
          submitted_flag: flag,
          is_correct: isCorrect
        });

      if (submissionError) throw submissionError;

      if (isCorrect) {
        return {
          success: true,
          isCorrect: true,
          message: `Correct! You earned ${challenge.points} points for solving "${challenge.title}"`
        };
      } else {
        return {
          success: true,
          isCorrect: false,
          message: 'Incorrect flag. Try again!'
        };
      }
    } catch (error) {
      console.error('Error submitting flag:', error);
      return {
        success: false,
        isCorrect: false,
        message: 'Error submitting flag. Please try again.'
      };
    }
  }

  // Get user submissions
  static async getUserSubmissions(userId: string): Promise<Submission[]> {
    try {
      const { data, error } = await supabase
        .from('submissions')
        .select('*')
        .eq('user_id', userId)
        .order('submitted_at', { ascending: false });

      if (error) throw error;
      return data as Submission[];
    } catch (error) {
      console.error('Error fetching user submissions:', error);
      return [];
    }
  }

  // Get all submissions (admin only)
  static async getAllSubmissions(): Promise<Submission[]> {
    try {
      const { data, error } = await supabase
        .from('submissions')
        .select(`
          *,
          profiles:user_id (username),
          challenges:challenge_id (title)
        `)
        .order('submitted_at', { ascending: false });

      if (error) throw error;
      return data as Submission[];
    } catch (error) {
      console.error('Error fetching all submissions:', error);
      return [];
    }
  }

  // Get solved challenges for user
  static async getSolvedChallenges(userId: string): Promise<string[]> {
    try {
      const { data, error } = await supabase
        .from('submissions')
        .select('challenge_id')
        .eq('user_id', userId)
        .eq('is_correct', true);

      if (error) throw error;
      return data.map(sub => sub.challenge_id);
    } catch (error) {
      console.error('Error fetching solved challenges:', error);
      return [];
    }
  }

  // Get leaderboard data
  static async getLeaderboard(): Promise<any[]> {
    try {
      const { data, error } = await supabase
        .from('profiles')
        .select('username, total_score, id')
        .order('total_score', { ascending: false })
        .limit(50);

      if (error) throw error;
      return data;
    } catch (error) {
      console.error('Error fetching leaderboard:', error);
      return [];
    }
  }
}