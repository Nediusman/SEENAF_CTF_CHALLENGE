import { useState, useEffect } from 'react';
import { supabase } from '@/integrations/supabase/client';

export function SupabaseDebug() {
  const [connectionStatus, setConnectionStatus] = useState<any>({});
  const [challenges, setChallenges] = useState<any[]>([]);
  const [user, setUser] = useState<any>(null);

  useEffect(() => {
    testConnection();
  }, []);

  const testConnection = async () => {
    console.log('🔍 Testing Supabase Connection...');
    
    // Test 1: Environment Variables
    const envVars = {
      url: import.meta.env.VITE_SUPABASE_URL,
      key: import.meta.env.VITE_SUPABASE_PUBLISHABLE_KEY?.substring(0, 20) + '...',
    };
    
    console.log('📋 Environment Variables:', envVars);
    
    // Test 2: Auth Session
    try {
      const { data: session, error: authError } = await supabase.auth.getSession();
      console.log('👤 Auth Session:', session);
      setUser(session?.session?.user || null);
      
      if (authError) {
        console.error('❌ Auth Error:', authError);
      }
    } catch (error) {
      console.error('💥 Auth Connection Error:', error);
    }

    // Test 3: Database Connection
    try {
      const { count, error: countError } = await supabase
        .from('challenges')
        .select('*', { count: 'exact', head: true });
      
      console.log('📊 Challenges Count:', count);
      
      if (countError) {
        console.error('❌ Count Error:', countError);
      }
      
      setConnectionStatus(prev => ({ ...prev, count, countError }));
    } catch (error) {
      console.error('💥 Database Connection Error:', error);
      setConnectionStatus(prev => ({ ...prev, connectionError: error }));
    }

    // Test 4: Actual Data Query
    try {
      const { data, error } = await supabase
        .from('challenges')
        .select('*')
        .limit(5);
      
      console.log('🎯 Sample Challenges:', data);
      setChallenges(data || []);
      
      if (error) {
        console.error('❌ Query Error:', error);
      }
      
      setConnectionStatus(prev => ({ ...prev, queryError: error }));
    } catch (error) {
      console.error('💥 Query Connection Error:', error);
      setConnectionStatus(prev => ({ ...prev, queryError: error }));
    }
  };

  return (
    <div className="p-6 bg-black/80 border border-green-500/30 rounded-lg font-mono text-sm">
      <h3 className="text-green-400 font-bold mb-4">🔧 Supabase Connection Debug</h3>
      
      <div className="space-y-4">
        <div>
          <h4 className="text-yellow-400 font-semibold">Environment Variables:</h4>
          <p className="text-green-300">URL: {import.meta.env.VITE_SUPABASE_URL || '❌ Missing'}</p>
          <p className="text-green-300">Key: {import.meta.env.VITE_SUPABASE_PUBLISHABLE_KEY ? '✅ Present' : '❌ Missing'}</p>
        </div>

        <div>
          <h4 className="text-yellow-400 font-semibold">Authentication:</h4>
          <p className="text-green-300">User: {user ? `✅ ${user.email}` : '❌ Not logged in'}</p>
        </div>

        <div>
          <h4 className="text-yellow-400 font-semibold">Database Connection:</h4>
          <p className="text-green-300">
            Challenges Count: {connectionStatus.count !== undefined ? `✅ ${connectionStatus.count}` : '❌ Failed'}
          </p>
          {connectionStatus.countError && (
            <p className="text-red-400">Error: {connectionStatus.countError.message}</p>
          )}
        </div>

        <div>
          <h4 className="text-yellow-400 font-semibold">Sample Data:</h4>
          <p className="text-green-300">
            Challenges Loaded: {challenges.length > 0 ? `✅ ${challenges.length} challenges` : '❌ No data'}
          </p>
          {challenges.length > 0 && (
            <div className="mt-2 space-y-1">
              {challenges.map((challenge, index) => (
                <p key={index} className="text-blue-300 text-xs">
                  • {challenge.title} ({challenge.category})
                </p>
              ))}
            </div>
          )}
          {connectionStatus.queryError && (
            <p className="text-red-400">Error: {connectionStatus.queryError.message}</p>
          )}
        </div>

        <button 
          onClick={testConnection}
          className="px-4 py-2 bg-green-600 hover:bg-green-700 text-white rounded transition-colors"
        >
          🔄 Retest Connection
        </button>
      </div>
    </div>
  );
}