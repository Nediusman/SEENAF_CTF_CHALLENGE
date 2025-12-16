import { supabase } from '@/integrations/supabase/client';

export const setupSampleChallenges = async () => {
  // First, let's try with the basic schema (without new fields)
  const challenges = [
    {
      title: 'Crack the Gate 1',
      description: `We're in the middle of an investigation. One of our persons of interest, or player, is believed to be hiding sensitive data inside a restricted web portal. We've uncovered the email address he uses to log in.

Unfortunately, we don't know the password, and the usual guessing techniques haven't worked. But something feels off... it's almost like the developer left a secret way in. Can you figure it out?

Additional details will be available after launching your challenge instance.`,
      category: 'Web',
      difficulty: 'easy' as const,
      points: 100,
      flag: 'SEENAF{html_source_code_inspection}',
      hints: ['Right-click and view source', 'Look for HTML comments', 'Check for hidden form fields'],
      is_active: true
    },
    {
      title: 'Cookie Monster Secret Recipe',
      description: `A famous bakery has digitized their secret cookie recipe and stored it on their website. The recipe is protected, but rumor has it that the protection isn't as strong as they think.

Can you find the secret ingredient?`,
      category: 'Web',
      difficulty: 'easy' as const,
      points: 150,
      flag: 'SEENAF{cookie_manipulation_master}',
      hints: ['Check browser cookies', 'Try modifying cookie values'],
      is_active: true
    },
    {
      title: 'SQL Injection Login',
      description: 'This login form looks vulnerable to SQL injection. Can you bypass the authentication and gain access to the admin panel?',
      category: 'Web',
      difficulty: 'medium' as const,
      points: 200,
      flag: 'SEENAF{sql_injection_bypass}',
      hints: ['Try using OR 1=1', 'Comment out the password check with --', 'Look for error messages'],
      is_active: true
    },
    {
      title: 'Caesar Cipher',
      description: 'Decode this message: VHHQDI{FDHVDU_FLSKHU_FUDFNHG}',
      category: 'Crypto',
      difficulty: 'easy' as const,
      points: 150,
      flag: 'SEENAF{CAESAR_CIPHER_CRACKED}',
      hints: ['This is a simple substitution cipher', 'Try shifting letters by 3 positions', 'A becomes D, B becomes E, etc.'],
      is_active: true
    },
    {
      title: 'Base64 Decode',
      description: 'Decode this Base64 string: U0VFTkFGe2Jhc2U2NF9kZWNvZGluZ19tYXN0ZXJ9',
      category: 'Crypto',
      difficulty: 'easy' as const,
      points: 100,
      flag: 'SEENAF{base64_decoding_master}',
      hints: ['This looks like Base64 encoding', 'Use an online Base64 decoder', 'Look for the = padding'],
      is_active: true
    },
    {
      title: 'Buffer Overflow Basic',
      description: 'This program has a buffer overflow vulnerability. Exploit it to get the flag from the server.',
      category: 'Pwn',
      difficulty: 'hard' as const,
      points: 400,
      flag: 'SEENAF{buffer_overflow_pwned}',
      hints: ['Find the buffer size', 'Overwrite the return address', 'Use a debugger to analyze'],
      is_active: true
    }
  ];

  try {
    console.log('🚀 Setting up sample challenges...');
    
    for (const challenge of challenges) {
      const { data, error } = await supabase
        .from('challenges')
        .insert(challenge)
        .select();
      
      if (error) {
        console.error(`❌ Error inserting ${challenge.title}:`, error);
      } else {
        console.log(`✅ Added challenge: ${challenge.title}`);
      }
    }
    
    console.log('🎉 Sample challenges setup complete!');
    return { success: true };
  } catch (error) {
    console.error('💥 Error setting up challenges:', error);
    return { success: false, error };
  }
};

// Function to clear all challenges (use with caution!)
export const clearAllChallenges = async () => {
  try {
    const { error } = await supabase
      .from('challenges')
      .delete()
      .neq('id', '00000000-0000-0000-0000-000000000000'); // Delete all
    
    if (error) throw error;
    console.log('🗑️ All challenges cleared');
    return { success: true };
  } catch (error) {
    console.error('❌ Error clearing challenges:', error);
    return { success: false, error };
  }
};