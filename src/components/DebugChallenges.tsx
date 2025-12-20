import { useState, useEffect } from 'react';
import { supabase } from '@/integrations/supabase/client';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';

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

  const runConnectionTest = async () => {
    setLoading(true);
    try {
      const { data, error } = await supabase
        .from('challenges')
        .select('count', { count: 'exact', head: true });

      if (error) {
        setError(`❌ Connection failed: ${error.message}`);
      } else {
        setError('✅ Database connection successful!');
        fetchChallenges();
      }
    } catch (err: any) {
      setError(`❌ Connection error: ${err.message}`);
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
          <Button onClick={runConnectionTest} disabled={loading} size="sm" variant="outline">
            Test Connection
          </Button>
        </div>

        {error && (
          <div className="p-3 bg-destructive/10 border border-destructive/20 rounded text-sm">
            <strong>Status:</strong> {error}
          </div>
        )}

        <div className="space-y-2">
          <p className="text-sm">
            <strong>Total Challenges:</strong> {challenges.length}
          </p>
          
          {challenges.length > 0 && (
            <div className="space-y-2">
              <p className="text-sm font-semibold">Recent Challenges:</p>
              {challenges.slice(0, 3).map((challenge, index) => (
                <div key={index} className="p-2 bg-secondary/20 rounded text-xs">
                  <div><strong>Title:</strong> {challenge.title}</div>
                  <div><strong>Category:</strong> {challenge.category}</div>
                  <div><strong>Points:</strong> {challenge.points}</div>
                  <div><strong>Active:</strong> {challenge.is_active ? 'Yes' : 'No'}</div>
                  <div><strong>Author:</strong> {challenge.author || 'Not set'}</div>
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