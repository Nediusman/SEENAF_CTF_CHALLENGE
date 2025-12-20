import { supabase } from '@/integrations/supabase/client';

// Function to add a single challenge
export async function addChallenge(challenge: {
  title: string;
  description: string;
  category: string;
  difficulty: 'easy' | 'medium' | 'hard' | 'insane';
  points: number;
  flag: string;
  hints?: string[];
}) {
  const { data, error } = await supabase
    .from('challenges')
    .insert(challenge)
    .select();

  if (error) {
    console.error('Error adding challenge:', error);
    return { success: false, error };
  }

  console.log('Challenge added successfully:', data);
  return { success: true, data };
}

// Function to add multiple challenges at once
export async function addMultipleChallenges(challenges: Array<{
  title: string;
  description: string;
  category: string;
  difficulty: 'easy' | 'medium' | 'hard' | 'insane';
  points: number;
  flag: string;
  hints?: string[];
}>) {
  for (const challenge of challenges) {
    await addChallenge(challenge);
  }
}

// Example usage:
// addChallenge({
//   title: 'My Challenge',
//   description: 'Challenge description',
//   category: 'Web',
//   difficulty: 'easy',
//   points: 100,
//   flag: 'CTF{my_flag}',
//   hints: ['Hint 1', 'Hint 2']
// });