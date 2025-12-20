import { supabase } from '@/integrations/supabase/client';

export const setupSampleChallenges = async () => {
  try {
    console.log('🚀 Setting up sample challenges...');
    
    // Note: Challenge data should be loaded from database or server-side
    // This function now only verifies the challenges table exists
    const { data, error } = await supabase
      .from('challenges')
      .select('count', { count: 'exact', head: true });

    if (error) {
      console.error('❌ Error checking challenges table:', error);
      return { success: false, error: error.message };
    }

    console.log('✅ Challenges table verified');
    return { 
      success: true, 
      message: 'Use SQL scripts to load challenge data securely'
    };
  } catch (error: any) {
    console.error('💥 Error setting up challenges:', error);
    return { success: false, error: error.message };
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