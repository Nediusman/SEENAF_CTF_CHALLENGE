import { supabase } from '@/integrations/supabase/client';

export const checkEverything = async () => {
  console.log('🔍 Starting comprehensive debug...');
  
  try {
    // 1. Check authentication
    console.log('👤 Checking authentication...');
    const { data: { user }, error: authError } = await supabase.auth.getUser();
    console.log('User:', user?.email || 'Not logged in');
    console.log('User ID:', user?.id || 'No ID');
    
    if (authError) {
      console.error('Auth error:', authError);
      return { step: 'auth', error: authError.message };
    }

    // 2. Check user roles
    console.log('🔑 Checking user roles...');
    const { data: roles, error: roleError } = await supabase
      .from('user_roles')
      .select('*')
      .eq('user_id', user?.id || '');
    
    console.log('User roles:', roles);
    if (roleError) {
      console.error('Role error:', roleError);
      return { step: 'roles', error: roleError.message };
    }

    // 3. Test basic table access
    console.log('📊 Testing table access...');
    const { data: testData, error: testError } = await supabase
      .from('challenges')
      .select('count', { count: 'exact', head: true });
    
    console.log('Table access result:', testData);
    if (testError) {
      console.error('Table access error:', testError);
      return { step: 'table_access', error: testError.message };
    }

    // 4. Try to fetch challenges
    console.log('🎯 Fetching challenges...');
    const { data: challenges, error: fetchError } = await supabase
      .from('challenges')
      .select('*')
      .limit(5);
    
    console.log('Challenges:', challenges?.length || 0);
    if (fetchError) {
      console.error('Fetch error:', fetchError);
      return { step: 'fetch', error: fetchError.message };
    }

    // 5. Try to insert a simple challenge (if admin)
    if (roles?.some(r => r.role === 'admin')) {
      console.log('🧪 Testing challenge insertion...');
      const testChallenge = {
        title: 'Simple Test',
        description: 'Test challenge',
        category: 'Web',
        difficulty: 'easy',
        points: 50,
        flag: 'SEENAF{test}',
        hints: ['Test hint'],
        is_active: true
      };

      const { data: insertData, error: insertError } = await supabase
        .from('challenges')
        .insert(testChallenge)
        .select();

      if (insertError) {
        console.error('Insert error:', insertError);
        return { step: 'insert', error: insertError.message };
      }
      
      console.log('✅ Insert successful:', insertData);
    }

    return { 
      success: true, 
      user: user?.email,
      roles: roles?.map(r => r.role),
      challengeCount: challenges?.length || 0
    };

  } catch (error: any) {
    console.error('💥 Debug error:', error);
    return { step: 'unknown', error: error.message };
  }
};

export const addSingleChallenge = async () => {
  console.log('🎯 Adding single test challenge...');
  
  try {
    const challenge = {
      title: 'Test Challenge',
      description: 'This is a simple test challenge to verify the system works.',
      category: 'Web',
      difficulty: 'easy',
      points: 100,
      flag: 'SEENAF{test_challenge_works}',
      hints: ['This is just a test', 'Check if you can see this challenge'],
      is_active: true
    };

    const { data, error } = await supabase
      .from('challenges')
      .insert(challenge)
      .select();

    if (error) {
      console.error('❌ Single challenge insert error:', error);
      return { success: false, error: error.message };
    }

    console.log('✅ Single challenge added:', data);
    return { success: true, data };

  } catch (error: any) {
    console.error('💥 Single challenge error:', error);
    return { success: false, error: error.message };
  }
};