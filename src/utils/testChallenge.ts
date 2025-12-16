import { supabase } from '@/integrations/supabase/client';

export const addTestChallenge = async () => {
  try {
    console.log('🧪 Adding test challenge...');
    
    const testChallenge = {
      title: 'Test Challenge',
      description: 'This is a test challenge to verify the database is working.',
      category: 'Web',
      difficulty: 'easy',
      points: 50,
      flag: 'SEENAF{test_flag}',
      hints: ['This is just a test', 'Check if the database is working'],
      is_active: true
    };

    const { data, error } = await supabase
      .from('challenges')
      .insert(testChallenge)
      .select();

    if (error) {
      console.error('❌ Error inserting test challenge:', error);
      return { success: false, error: error.message };
    }

    console.log('✅ Test challenge added:', data);
    return { success: true, data };
  } catch (error: any) {
    console.error('💥 Test challenge error:', error);
    return { success: false, error: error.message };
  }
};

export const checkChallengesTable = async () => {
  try {
    console.log('🔍 Checking challenges table...');
    
    const { data, error, count } = await supabase
      .from('challenges')
      .select('*', { count: 'exact' })
      .limit(5);

    console.log('📊 Table check result:', { data, error, count });
    
    if (error) {
      return { success: false, error: error.message };
    }

    return { 
      success: true, 
      count: count || 0, 
      sample: data || [],
      hasNewFields: data && data.length > 0 ? data[0].hasOwnProperty('author') : false
    };
  } catch (error: any) {
    console.error('💥 Table check error:', error);
    return { success: false, error: error.message };
  }
};