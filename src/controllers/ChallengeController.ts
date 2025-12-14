// Challenge Controller - Handles challenge business logic
import { ChallengeModel, CreateChallengeData } from '@/models/Challenge';
import { SubmissionModel } from '@/models/Submission';
import { Challenge, DifficultyLevel } from '@/types/database';

export interface ChallengeWithStatus extends Challenge {
  isSolved: boolean;
  userSubmissions?: number;
}

export class ChallengeController {
  // Get challenges for player (with solved status)
  static async getChallengesForPlayer(userId: string): Promise<ChallengeWithStatus[]> {
    try {
      console.log('🎯 ChallengeController: Getting challenges for player', userId);

      const [challenges, solvedChallengeIds] = await Promise.all([
        ChallengeModel.getActiveChallenges(),
        SubmissionModel.getSolvedChallenges(userId)
      ]);

      const challengesWithStatus: ChallengeWithStatus[] = challenges.map(challenge => ({
        ...challenge,
        isSolved: solvedChallengeIds.includes(challenge.id)
      }));

      console.log(`✅ Retrieved ${challengesWithStatus.length} challenges`);
      return challengesWithStatus;

    } catch (error) {
      console.error('💥 Error getting challenges for player:', error);
      return [];
    }
  }

  // Get all challenges for admin
  static async getChallengesForAdmin(): Promise<Challenge[]> {
    try {
      console.log('👑 ChallengeController: Getting all challenges for admin');

      const challenges = await ChallengeModel.getAllChallenges();

      console.log(`✅ Retrieved ${challenges.length} challenges for admin`);
      return challenges;

    } catch (error) {
      console.error('💥 Error getting challenges for admin:', error);
      return [];
    }
  }

  // Create new challenge (admin only)
  static async createChallenge(challengeData: CreateChallengeData): Promise<{ success: boolean; challenge?: Challenge; error?: string }> {
    try {
      console.log('➕ ChallengeController: Creating challenge', challengeData.title);

      // Validate required fields
      if (!challengeData.title || !challengeData.description || !challengeData.flag) {
        return {
          success: false,
          error: 'Title, description, and flag are required'
        };
      }

      // Validate flag format
      if (!challengeData.flag.startsWith('CTF{') || !challengeData.flag.endsWith('}')) {
        return {
          success: false,
          error: 'Flag must be in format CTF{...}'
        };
      }

      // Validate points
      if (challengeData.points < 1 || challengeData.points > 1000) {
        return {
          success: false,
          error: 'Points must be between 1 and 1000'
        };
      }

      const challenge = await ChallengeModel.createChallenge(challengeData);

      if (!challenge) {
        return {
          success: false,
          error: 'Failed to create challenge'
        };
      }

      console.log('✅ Challenge created successfully:', challenge.id);
      return {
        success: true,
        challenge
      };

    } catch (error: any) {
      console.error('💥 Error creating challenge:', error);
      return {
        success: false,
        error: error.message || 'Failed to create challenge'
      };
    }
  }

  // Update challenge (admin only)
  static async updateChallenge(id: string, updates: Partial<CreateChallengeData>): Promise<{ success: boolean; challenge?: Challenge; error?: string }> {
    try {
      console.log('✏️ ChallengeController: Updating challenge', id);

      const challenge = await ChallengeModel.updateChallenge(id, updates);

      if (!challenge) {
        return {
          success: false,
          error: 'Failed to update challenge'
        };
      }

      console.log('✅ Challenge updated successfully');
      return {
        success: true,
        challenge
      };

    } catch (error: any) {
      console.error('💥 Error updating challenge:', error);
      return {
        success: false,
        error: error.message || 'Failed to update challenge'
      };
    }
  }

  // Delete challenge (admin only)
  static async deleteChallenge(id: string): Promise<{ success: boolean; error?: string }> {
    try {
      console.log('🗑️ ChallengeController: Deleting challenge', id);

      const success = await ChallengeModel.deleteChallenge(id);

      if (!success) {
        return {
          success: false,
          error: 'Failed to delete challenge'
        };
      }

      console.log('✅ Challenge deleted successfully');
      return { success: true };

    } catch (error: any) {
      console.error('💥 Error deleting challenge:', error);
      return {
        success: false,
        error: error.message || 'Failed to delete challenge'
      };
    }
  }

  // Submit flag for challenge
  static async submitFlag(userId: string, challengeId: string, flag: string): Promise<{ success: boolean; isCorrect: boolean; message: string }> {
    try {
      console.log('🚩 ChallengeController: Submitting flag', { userId, challengeId });

      if (!flag.trim()) {
        return {
          success: false,
          isCorrect: false,
          message: 'Flag cannot be empty'
        };
      }

      const result = await SubmissionModel.submitFlag(userId, challengeId, flag.trim());

      console.log('✅ Flag submission result:', result);
      return result;

    } catch (error: any) {
      console.error('💥 Error submitting flag:', error);
      return {
        success: false,
        isCorrect: false,
        message: error.message || 'Failed to submit flag'
      };
    }
  }

  // Get challenges by category
  static async getChallengesByCategory(category: string, userId?: string): Promise<ChallengeWithStatus[]> {
    try {
      console.log('📂 ChallengeController: Getting challenges by category', category);

      const challenges = await ChallengeModel.getChallengesByCategory(category);

      if (userId) {
        const solvedChallengeIds = await SubmissionModel.getSolvedChallenges(userId);
        return challenges.map(challenge => ({
          ...challenge,
          isSolved: solvedChallengeIds.includes(challenge.id)
        }));
      }

      return challenges.map(challenge => ({ ...challenge, isSolved: false }));

    } catch (error) {
      console.error('💥 Error getting challenges by category:', error);
      return [];
    }
  }

  // Get challenge statistics
  static async getChallengeStats(): Promise<{
    total: number;
    byDifficulty: Record<DifficultyLevel, number>;
    byCategory: Record<string, number>;
  }> {
    try {
      const challenges = await ChallengeModel.getAllChallenges();

      const stats = {
        total: challenges.length,
        byDifficulty: {
          easy: 0,
          medium: 0,
          hard: 0,
          insane: 0
        } as Record<DifficultyLevel, number>,
        byCategory: {} as Record<string, number>
      };

      challenges.forEach(challenge => {
        stats.byDifficulty[challenge.difficulty]++;
        stats.byCategory[challenge.category] = (stats.byCategory[challenge.category] || 0) + 1;
      });

      return stats;

    } catch (error) {
      console.error('💥 Error getting challenge stats:', error);
      return {
        total: 0,
        byDifficulty: { easy: 0, medium: 0, hard: 0, insane: 0 },
        byCategory: {}
      };
    }
  }
}