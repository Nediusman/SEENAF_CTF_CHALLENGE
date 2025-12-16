// Simple connection test
import { supabase } from '@/integrations/supabase/client';

export async function testConnection() {
  console.log('🔍 Testing Supabase Connection...');
  
  try {
    // Test 1: Check environment
    console.log('📋 Environment:', {
      url: import.meta.env.VITE_SUPABASE_URL,
      hasKey: !!import.meta.env.VITE_SUPABASE_PUBLISHABLE_KEY
    });

    // Test 2: Simple query
    const { data, error, count } = await supabase
      .from('challenges')
      .select('*', { count: 'exact' });
    
    console.log('📊 Database Results:', {
      count,
      data: data?.slice(0, 3), // First 3 challenges
      error
    });

    return {
      success: !error,
      count,
      challenges: data,
      error
    };
  } catch (err) {
    console.error('💥 Connection Error:', err);
    return {
      success: false,
      error: err
    };
  }
}

// Run test immediately when imported
testConnection();