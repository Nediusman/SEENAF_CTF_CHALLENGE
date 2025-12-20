import { useState } from 'react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { supabase } from '@/integrations/supabase/client';
import { useAuth } from '@/hooks/useAuth';
import { toast } from 'sonner';

export function SubmissionDebugger() {
  const [testFlag, setTestFlag] = useState('');
  const [challengeTitle, setChallengeTitle] = useState('');
  const [loading, setLoading] = useState(false);
  const [results, setResults] = useState<any[]>([]);
  
  const { user } = useAuth();

  const testSubmission = async () => {
    if (!user) {
      toast.error('Not authenticated');
      return;
    }

    setLoading(true);
    const testResults = [];

    try {
      // Step 1: Check authentication
      testResults.push({
        step: 'Authentication',
        status: user ? 'PASS' : 'FAIL',
        data: { userId: user?.id, email: user?.email }
      });

      // Step 2: Find challenge
      const { data: challenge, error: challengeError } = await supabase
        .from('challenges')
        .select('*')
        .eq('title', challengeTitle)
        .single();

      testResults.push({
        step: 'Find Challenge',
        status: challenge ? 'PASS' : 'FAIL',
        data: challenge,
        error: challengeError
      });

      if (!challenge) {
        setResults(testResults);
        return;
      }

      // Step 3: Check flag correctness
      const isCorrect = testFlag.trim() === challenge.flag;
      testResults.push({
        step: 'Flag Check',
        status: isCorrect ? 'PASS' : 'FAIL',
        data: { 
          submitted: testFlag.trim(), 
          expected: challenge.flag, 
          match: isCorrect 
        }
      });

      // Step 4: Test submission insert
      const { data: submission, error: submissionError } = await supabase
        .from('submissions')
        .insert({
          user_id: user.id,
          challenge_id: challenge.id,
          submitted_flag: testFlag.trim(),
          is_correct: isCorrect,
        })
        .select();

      testResults.push({
        step: 'Insert Submission',
        status: submission ? 'PASS' : 'FAIL',
        data: submission,
        error: submissionError
      });

      // Step 5: Verify submission was saved
      if (submission && submission[0]) {
        const { data: savedSubmission, error: fetchError } = await supabase
          .from('submissions')
          .select('*')
          .eq('id', submission[0].id)
          .single();

        testResults.push({
          step: 'Verify Saved',
          status: savedSubmission ? 'PASS' : 'FAIL',
          data: savedSubmission,
          error: fetchError
        });
      }

      // Step 6: Check user's solved challenges
      const { data: userSubmissions, error: userError } = await supabase
        .from('submissions')
        .select('challenge_id')
        .eq('user_id', user.id)
        .eq('is_correct', true);

      testResults.push({
        step: 'User Solved Challenges',
        status: userSubmissions ? 'PASS' : 'FAIL',
        data: { count: userSubmissions?.length || 0, submissions: userSubmissions },
        error: userError
      });

      if (isCorrect) {
        toast.success('Test submission successful!');
      } else {
        toast.error('Flag was incorrect, but submission system works');
      }

    } catch (error) {
      testResults.push({
        step: 'Unexpected Error',
        status: 'FAIL',
        error: error
      });
      toast.error('Test failed with error');
    } finally {
      setResults(testResults);
      setLoading(false);
    }
  };

  const testDatabaseConnection = async () => {
    try {
      const { data, error } = await supabase
        .from('challenges')
        .select('count')
        .limit(1);

      if (error) {
        toast.error(`Database error: ${error.message}`);
      } else {
        toast.success('Database connection successful');
      }
    } catch (error) {
      toast.error('Database connection failed');
    }
  };

  return (
    <Card className="w-full max-w-4xl mx-auto">
      <CardHeader>
        <CardTitle>🔧 Submission System Debugger</CardTitle>
      </CardHeader>
      <CardContent className="space-y-4">
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <Input
            placeholder="Challenge Title"
            value={challengeTitle}
            onChange={(e) => setChallengeTitle(e.target.value)}
          />
          <Input
            placeholder="Test Flag"
            value={testFlag}
            onChange={(e) => setTestFlag(e.target.value)}
          />
        </div>
        
        <div className="flex gap-2">
          <Button onClick={testSubmission} disabled={loading}>
            {loading ? 'Testing...' : 'Test Submission'}
          </Button>
          <Button onClick={testDatabaseConnection} variant="outline">
            Test DB Connection
          </Button>
        </div>

        {results.length > 0 && (
          <div className="space-y-2">
            <h3 className="font-semibold">Test Results:</h3>
            {results.map((result, index) => (
              <div
                key={index}
                className={`p-3 rounded border ${
                  result.status === 'PASS' 
                    ? 'bg-green-500/10 border-green-500/30' 
                    : 'bg-red-500/10 border-red-500/30'
                }`}
              >
                <div className="flex items-center gap-2 mb-2">
                  <span className={`font-mono text-sm ${
                    result.status === 'PASS' ? 'text-green-400' : 'text-red-400'
                  }`}>
                    {result.status}
                  </span>
                  <span className="font-semibold">{result.step}</span>
                </div>
                {result.data && (
                  <pre className="text-xs bg-secondary/50 p-2 rounded overflow-auto">
                    {JSON.stringify(result.data, null, 2)}
                  </pre>
                )}
                {result.error && (
                  <pre className="text-xs bg-red-500/20 p-2 rounded overflow-auto text-red-300">
                    {JSON.stringify(result.error, null, 2)}
                  </pre>
                )}
              </div>
            ))}
          </div>
        )}
      </CardContent>
    </Card>
  );
}