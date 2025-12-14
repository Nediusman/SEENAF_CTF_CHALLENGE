export type DifficultyLevel = 'easy' | 'medium' | 'hard' | 'insane';
export type AppRole = 'admin' | 'player';

export interface Profile {
  id: string;
  username: string;
  avatar_url: string | null;
  total_score: number;
  created_at: string;
  updated_at: string;
}

export interface Challenge {
  id: string;
  title: string;
  description: string;
  category: string;
  difficulty: DifficultyLevel;
  points: number;
  flag: string;
  hints: string[] | null;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

export interface Submission {
  id: string;
  user_id: string;
  challenge_id: string;
  submitted_flag: string;
  is_correct: boolean;
  submitted_at: string;
}

export interface UserRole {
  id: string;
  user_id: string;
  role: AppRole;
}
