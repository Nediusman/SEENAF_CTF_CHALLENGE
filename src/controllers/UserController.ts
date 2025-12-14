// User Controller - Handles user management business logic
import { UserModel } from '@/models/User';
import { SubmissionModel } from '@/models/Submission';
import { Profile } from '@/types/database';

export interface UserStats {
  totalScore: number;
  challengesSolved: number;
  rank: number;
  recentSubmissions: number;
}

export interface LeaderboardEntry {
  rank: number;
  username: string;
  totalScore: number;
  challengesSolved: number;
}

export class UserController {
  // Get user profile with stats
  static async getUserProfile(userId: string): Promise<{ profile: Profile | null; stats: UserStats }> {
    try {
      console.log('👤 UserController: Getting user profile', userId);

      const [profile, submissions, leaderboard] = await Promise.all([
        UserModel.getProfile(userId),
        SubmissionModel.getUserSubmissions(userId),
        SubmissionModel.getLeaderboard()
      ]);

      const solvedChallenges = submissions.filter(sub => sub.is_correct).length;
      const recentSubmissions = submissions.filter(sub => {
        const submissionDate = new Date(sub.submitted_at);
        const weekAgo = new Date();
        weekAgo.setDate(weekAgo.getDate() - 7);
        return submissionDate > weekAgo;
      }).length;

      // Calculate rank
      const userRank = leaderboard.findIndex(entry => entry.id === userId) + 1;

      const stats: UserStats = {
        totalScore: profile?.total_score || 0,
        challengesSolved: solvedChallenges,
        rank: userRank || 0,
        recentSubmissions
      };

      console.log('✅ User profile retrieved with stats');
      return { profile, stats };

    } catch (error) {
      console.error('💥 Error getting user profile:', error);
      return {
        profile: null,
        stats: {
          totalScore: 0,
          challengesSolved: 0,
          rank: 0,
          recentSubmissions: 0
        }
      };
    }
  }

  // Get leaderboard
  static async getLeaderboard(limit: number = 50): Promise<LeaderboardEntry[]> {
    try {
      console.log('🏆 UserController: Getting leaderboard');

      const leaderboardData = await SubmissionModel.getLeaderboard();

      const leaderboard: LeaderboardEntry[] = await Promise.all(
        leaderboardData.slice(0, limit).map(async (entry, index) => {
          const submissions = await SubmissionModel.getUserSubmissions(entry.id);
          const challengesSolved = submissions.filter(sub => sub.is_correct).length;

          return {
            rank: index + 1,
            username: entry.username,
            totalScore: entry.total_score,
            challengesSolved
          };
        })
      );

      console.log(`✅ Retrieved leaderboard with ${leaderboard.length} entries`);
      return leaderboard;

    } catch (error) {
      console.error('💥 Error getting leaderboard:', error);
      return [];
    }
  }

  // Get all users (admin only)
  static async getAllUsers(): Promise<Profile[]> {
    try {
      console.log('👑 UserController: Getting all users (admin)');

      const users = await UserModel.getAllUsers();

      console.log(`✅ Retrieved ${users.length} users`);
      return users;

    } catch (error) {
      console.error('💥 Error getting all users:', error);
      return [];
    }
  }

  // Update user profile
  static async updateUserProfile(userId: string, updates: Partial<Profile>): Promise<{ success: boolean; error?: string }> {
    try {
      console.log('✏️ UserController: Updating user profile', userId);

      // Validate updates
      if (updates.username && updates.username.length < 3) {
        return {
          success: false,
          error: 'Username must be at least 3 characters long'
        };
      }

      const success = await UserModel.updateProfile(userId, updates);

      if (!success) {
        return {
          success: false,
          error: 'Failed to update profile'
        };
      }

      console.log('✅ User profile updated successfully');
      return { success: true };

    } catch (error: any) {
      console.error('💥 Error updating user profile:', error);
      return {
        success: false,
        error: error.message || 'Failed to update profile'
      };
    }
  }

  // Grant admin privileges (super admin only)
  static async grantAdminRole(userId: string): Promise<{ success: boolean; error?: string }> {
    try {
      console.log('👑 UserController: Granting admin role', userId);

      const success = await UserModel.grantAdminRole(userId);

      if (!success) {
        return {
          success: false,
          error: 'Failed to grant admin role'
        };
      }

      console.log('✅ Admin role granted successfully');
      return { success: true };

    } catch (error: any) {
      console.error('💥 Error granting admin role:', error);
      return {
        success: false,
        error: error.message || 'Failed to grant admin role'
      };
    }
  }

  // Get user activity summary
  static async getUserActivity(userId: string): Promise<{
    totalSubmissions: number;
    correctSubmissions: number;
    incorrectSubmissions: number;
    successRate: number;
    lastActivity: string | null;
  }> {
    try {
      const submissions = await SubmissionModel.getUserSubmissions(userId);

      const correctSubmissions = submissions.filter(sub => sub.is_correct).length;
      const incorrectSubmissions = submissions.length - correctSubmissions;
      const successRate = submissions.length > 0 ? (correctSubmissions / submissions.length) * 100 : 0;
      const lastActivity = submissions.length > 0 ? submissions[0].submitted_at : null;

      return {
        totalSubmissions: submissions.length,
        correctSubmissions,
        incorrectSubmissions,
        successRate: Math.round(successRate * 100) / 100,
        lastActivity
      };

    } catch (error) {
      console.error('💥 Error getting user activity:', error);
      return {
        totalSubmissions: 0,
        correctSubmissions: 0,
        incorrectSubmissions: 0,
        successRate: 0,
        lastActivity: null
      };
    }
  }
}