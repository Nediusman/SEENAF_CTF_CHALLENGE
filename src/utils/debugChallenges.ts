import { supabase } from '@/integrations/supabase/client';

export const debugChallengesFetch = async () => {
  console.log('🔍 Starting challenge debug...');
  
  try {
    // Test basic connection
    console.log('📡 Testing Supabase connection...');
    const { data: testData, error: testError } = await supabase
      .from('challenges')
      .select('count', { count: 'exact', head: true });
    
    if (testError) {
      console.error('❌ Connection error:', testError);
      return { success: false, error: testError.message };
    }
    
    console.log('✅ Connection successful, total challenges:', testData);
    
    // Test full query
    console.log('📊 Fetching all challenges...');
    const { data: challenges, error: fetchError } = await supabase
      .from('challenges')
      .select('*')
      .eq('is_active', true)
      .order('points', { ascending: true });
    
    if (fetchError) {
      console.error('❌ Fetch error:', fetchError);
      return { success: false, error: fetchError.message };
    }
    
    console.log('✅ Challenges fetched:', challenges?.length || 0);
    console.log('📋 Sample challenge:', challenges?.[0]);
    
    // Test user authentication
    const { data: { user }, error: authError } = await supabase.auth.getUser();
    console.log('👤 Current user:', user?.email || 'Not logged in');
    
    if (authError) {
      console.error('❌ Auth error:', authError);
    }
    
    return {
      success: true,
      challengeCount: challenges?.length || 0,
      challenges: challenges?.slice(0, 3), // First 3 for debugging
      user: user?.email || null
    };
    
  } catch (error: any) {
    console.error('💥 Debug error:', error);
    return { success: false, error: error.message };
  }
};

export const testChallengeInsertion = async () => {
  console.log('🧪 Testing challenge insertion...');
  
  try {
    const testChallenge = {
      title: 'Debug Test Challenge',
      description: 'This is a test challenge to verify database insertion works.',
      category: 'Web',
      difficulty: 'easy',
      points: 50,
      flag: 'SEENAF{debug_test_flag}',
      hints: ['This is just a test'],
      author: 'Debug Team',
      instance_url: null,
      solver_count: 0,
      likes_count: 0,
      is_active: true
    };

    const { data, error } = await supabase
      .from('challenges')
      .insert(testChallenge)
      .select();

    if (error) {
      console.error('❌ Insert error:', error);
      return { success: false, error: error.message };
    }

    console.log('✅ Test challenge inserted:', data);
    return { success: true, data };
    
  } catch (error: any) {
    console.error('💥 Insert test error:', error);
    return { success: false, error: error.message };
  }
};