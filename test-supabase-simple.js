// Simple Supabase connection test
import { createClient } from '@supabase/supabase-js';

const SUPABASE_URL = "https://fsyspwfjubhxpcuqivne.supabase.co";
const SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZzeXNwd2ZqdWJoeHBjdXFpdm5lIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM4ODA0MzEsImV4cCI6MjA3OTQ1NjQzMX0.p_OR44n9W27c1UufT2jKSh5wyAQLqoXWyWAfkbxfeLA";

const supabase = createClient(SUPABASE_URL, SUPABASE_KEY);

async function testConnection() {
  console.log('🔍 Testing Supabase connection...');
  
  try {
    // Test 1: Basic connection
    const { data, error } = await supabase.from('challenges').select('count').limit(1);
    
    if (error) {
      console.error('❌ Connection failed:', error.message);
      return false;
    }
    
    console.log('✅ Connection successful');
    
    // Test 2: Check if challenges table exists and has data
    const { data: challenges, error: challengeError } = await supabase
      .from('challenges')
      .select('id, title')
      .limit(5);
    
    if (challengeError) {
      console.error('❌ Challenges query failed:', challengeError.message);
      return false;
    }
    
    console.log(`✅ Found ${challenges?.length || 0} challenges`);
    if (challenges && challenges.length > 0) {
      console.log('📋 Sample challenges:', challenges.map(c => c.title));
    }
    
    return true;
    
  } catch (error) {
    console.error('💥 Test failed:', error);
    return false;
  }
}

testConnection();