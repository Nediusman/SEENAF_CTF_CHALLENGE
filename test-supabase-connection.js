// Test Supabase Connection
// Run this in browser console to test connection

console.log('🔍 Testing Supabase Connection...');

// Check environment variables
console.log('Environment Variables:');
console.log('VITE_SUPABASE_URL:', import.meta.env.VITE_SUPABASE_URL);
console.log('VITE_SUPABASE_PUBLISHABLE_KEY:', import.meta.env.VITE_SUPABASE_PUBLISHABLE_KEY);

// Test supabase client
import { supabase } from './src/integrations/supabase/client.ts';

// Test basic connection
console.log('🔗 Supabase Client:', supabase);

// Test auth
supabase.auth.getSession().then(({ data, error }) => {
  console.log('👤 Auth Session:', data);
  if (error) console.error('❌ Auth Error:', error);
});

// Test database connection
supabase
  .from('challenges')
  .select('count', { count: 'exact', head: true })
  .then(({ count, error }) => {
    console.log('📊 Challenges Count:', count);
    if (error) console.error('❌ Database Error:', error);
  });

// Test with actual query
supabase
  .from('challenges')
  .select('*')
  .limit(5)
  .then(({ data, error }) => {
    console.log('🎯 Sample Challenges:', data);
    if (error) console.error('❌ Query Error:', error);
  });