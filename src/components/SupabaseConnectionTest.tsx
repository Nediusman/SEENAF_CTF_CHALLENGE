import { useState, useEffect } from 'react';
import { supabase } from '@/integrations/supabase/client';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';

export function SupabaseConnectionTest() {
  const [status, setStatus] = useState<string>('Not tested');
  const [challenges, setChallenges] = useState<any[]>([]);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  const testConnection = async () => {
    setLoading(true);
    setError(null);
    setStatus('Testing...');

    try {
      // Test 1: Basic connection
      const { data, error: connectionError } = await supabase
        .from('challenges')
        .select('count')
        .limit(1);

      if (connectionError) {
        throw new Error(`Connection failed: ${connectionError.message}`);
      }

      setStatus('Connected ✅');

      // Test 2: Fetch challenges
      const { data: challengeData, error: challengeError } = await supabase
        .from('challenges')
        .select('id, title, category, difficulty, is_active')
        .limit(10);

      if (challengeError) {
        throw new Error(`Challenge query failed: ${challengeError.message}`);
      }

      setChallenges(challengeData || []);
      setStatus(`Connected ✅ - Found ${challengeData?.length || 0} challenges`);

    } catch (err: any) {
      setError(err.message);
      setStatus('Failed ❌');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    testConnection();
  }, []);

  return (
    <Card className="w-full max-w-2xl mx-auto">
      <CardHeader>
        <CardTitle className="font-mono">🔍 Supabase Connection Test</CardTitle>
      </CardHeader>
      <CardContent className="space-y-4">
        <div>
          <strong>Status:</strong> <span className="font-mono">{status}</span>
        </div>

        {error && (
          <div className="p-3 bg-red-500/10 border border-red-500/30 rounded-lg">
            <strong className="text-red-400">Error:</strong>
            <pre className="text-sm mt-1 text-red-300">{error}</pre>
          </div>
        )}

        {challenges.length > 0 && (
          <div>
            <strong>Challenges Found:</strong>
            <div className="mt-2 space-y-1">
              {challenges.map((challenge) => (
                <div key={challenge.id} className="text-sm font-mono p-2 bg-secondary/20 rounded">
                  {challenge.title} ({challenge.category}) - {challenge.is_active ? 'Active' : 'Inactive'}
                </div>
              ))}
            </div>
          </div>
        )}

        <Button onClick={testConnection} disabled={loading} className="w-full">
          {loading ? 'Testing...' : 'Test Again'}
        </Button>

        <div className="text-xs text-muted-foreground font-mono">
          <div>URL: {import.meta.env.VITE_SUPABASE_URL}</div>
          <div>Project: {import.meta.env.VITE_SUPABASE_PROJECT_ID}</div>
        </div>
      </CardContent>
    </Card>
  );
}