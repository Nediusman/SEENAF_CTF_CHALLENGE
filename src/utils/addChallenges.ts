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
export async function addMultipleChallenges() {
  const challenges = [
    {
      title: 'Basic Web Challenge',
      description: 'Find the flag hidden in the HTML source code.',
      category: 'Web',
      difficulty: 'easy' as const,
      points: 100,
      flag: 'CTF{html_source_master}',
      hints: ['Right-click and view source', 'Look for HTML comments']
    },
    {
      title: 'SQL Injection',
      description: 'Bypass the login using SQL injection.',
      category: 'Web',
      difficulty: 'medium' as const,
      points: 200,
      flag: 'CTF{sql_injection_pwned}',
      hints: ['Try OR 1=1', 'Comment out with --']
    },
    {
      title: 'Caesar Cipher',
      description: 'Decode: FWI{FDHVDU_FLSKHU}',
      category: 'Crypto',
      difficulty: 'easy' as const,
      points: 150,
      flag: 'CTF{CAESAR_CIPHER}',
      hints: ['Shift by 3 positions', 'A becomes D, B becomes E']
    }
  ];

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