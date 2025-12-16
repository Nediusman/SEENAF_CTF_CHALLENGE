import { useState, useEffect } from 'react';
import { supabase } from '@/integrations/supabase/client';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { checkEverything, addSingleChallenge } from '@/utils/simpleDebug';

export function DebugChallenges() {
  const [challenges, setChallenges] = useState<any[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const fetchChallenges = async () => {
    setLoading(true);
    setError(null);
    try {
      console.log('🔍 Fetching challenges...');
      
      const { data, error, count } = await supabase
        .from('challenges')
        .select('*', { count: 'exact' })
        .order('created_at', { ascending: false });

      console.log('📊 Query result:', { data, error, count });

      if (error) {
        console.error('❌ Supabase error:', error);
        setError(error.message);
        return;
      }

      setChallenges(data || []);
      console.log('✅ Challenges loaded:', data?.length || 0);
    } catch (err: any) {
      console.error('💥 Fetch error:', err);
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const runFullDebug = async () => {
    setLoading(true);
    try {
      const result = await checkEverything();
      if (result.success) {
        setError(`✅ All Good! User: ${result.user}, Roles: ${result.roles?.join(', ')}, Challenges: ${result.challengeCount}`);
        fetchChallenges();
      } else {
        setError(`❌ Failed at ${result.step}: ${result.error}`);
      }
    } catch (err: any) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const testInsertion = async () => {
    setLoading(true);
    try {
      const result = await addSingleChallenge();
      if (result.success) {
        setError('✅ Single test challenge added successfully!');
        fetchChallenges();
      } else {
        setError(`❌ Insert failed: ${result.error}`);
      }
    } catch (err: any) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchChallenges();
  }, []);

  return (
    <Card className="mb-6">
      <CardHeader>
        <CardTitle className="text-lg">🔧 Debug: Challenges Status</CardTitle>
      </CardHeader>
      <CardContent className="space-y-4">
        <div className="flex gap-2 flex-wrap">
          <Button onClick={fetchChallenges} disabled={loading} size="sm">
            {loading ? 'Loading...' : 'Refresh'}
          </Button>
          <Button onClick={runFullDebug} disabled={loading} size="sm" variant="outline">
            Full Debug
          </Button>
          <Button onClick={testInsertion} disabled={loading} size="sm" variant="secondary">
            Add Single Challenge
          </Button>
        </div>

        {error && (
          <div className="p-3 bg-destructive/10 border border-destructive/20 rounded text-sm">
            <strong>Error:</strong> {error}
          </div>
        )}

        <div className="space-y-2">
          <p className="text-sm">
            <strong>Total Challenges:</strong> {challenges.length}
          </p>
          
          {challenges.length > 0 && (
            <div className="space-y-2">
              <p className="text-sm font-semibold">Challenges Found:</p>
              {challenges.slice(0, 3).map((challenge, index) => (
                <div key={index} className="p-2 bg-secondary/20 rounded text-xs">
                  <div><strong>Title:</strong> {challenge.title}</div>
                  <div><strong>Category:</strong> {challenge.category}</div>
                  <div><strong>Points:</strong> {challenge.points}</div>
                  <div><strong>Active:</strong> {challenge.is_active ? 'Yes' : 'No'}</div>
                  <div><strong>Author:</strong> {challenge.author || 'Not set'}</div>
                  <div><strong>Has new fields:</strong> {challenge.hasOwnProperty('solver_count') ? 'Yes' : 'No'}</div>
                </div>
              ))}
              {challenges.length > 3 && (
                <p className="text-xs text-muted-foreground">
                  ... and {challenges.length - 3} more challenges
                </p>
              )}
            </div>
          )}
        </div>
      </CardContent>
    </Card>
  );
}