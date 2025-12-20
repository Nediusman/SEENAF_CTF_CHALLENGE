import React, { useState, useEffect } from 'react';
import { InputSecurity } from '@/utils/inputSecurity';
import { SecurityMonitor } from '@/utils/securityMonitor';
import { supabase } from '@/integrations/supabase/client';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Alert, AlertDescription } from '@/components/ui/alert';
import { Progress } from '@/components/ui/progress';
import { Shield, Clock, AlertTriangle, CheckCircle, Flag } from 'lucide-react';

interface SecureSubmissionProps {
  challengeId: string;
  onSuccess: () => void;
  onError?: (error: string) => void;
}

export function SecureSubmission({ challengeId, onSuccess, onError }: SecureSubmissionProps) {
  const [flag, setFlag] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [attempts, setAttempts] = useState(0);
  const [lastAttempt, setLastAttempt] = useState<Date | null>(null);
  const [cooldownRemaining, setCooldownRemaining] = useState(0);
  const [validationErrors, setValidationErrors] = useState<string[]>([]);
  const [submissionHistory, setSubmissionHistory] = useState<Array<{
    flag: string;
    timestamp: Date;
    isCorrect?: boolean;
  }>>([]);

  const maxAttempts = 10;
  const cooldownSeconds = 5;

  // Cooldown timer
  useEffect(() => {
    if (cooldownRemaining > 0) {
      const timer = setTimeout(() => {
        setCooldownRemaining(prev => prev - 1);
      }, 1000);
      return () => clearTimeout(timer);
    }
  }, [cooldownRemaining]);

  // Load previous attempts for this challenge
  useEffect(() => {
    loadSubmissionHistory();
  }, [challengeId]);

  const loadSubmissionHistory = async () => {
    try {
      const { data: user } = await supabase.auth.getUser();
      if (!user.user) return;

      const { data, error } = await supabase
        .from('submissions')
        .select('submitted_flag, created_at, is_correct')
        .eq('challenge_id', challengeId)
        .eq('user_id', user.user.id)
        .order('created_at', { ascending: false })
        .limit(10);

      if (error) throw error;

      const history = data?.map(submission => ({
        flag: submission.submitted_flag,
        timestamp: new Date(submission.created_at),
        isCorrect: submission.is_correct
      })) || [];

      setSubmissionHistory(history);
      setAttempts(history.length);
    } catch (error) {
      console.error('Failed to load submission history:', error);
    }
  };

  const validateFlag = (): boolean => {
    const errors: string[] = [];

    // Basic validation
    if (!flag.trim()) {
      errors.push('Flag cannot be empty');
    }

    // Flag format validation
    if (!InputSecurity.validateFlag(flag)) {
      errors.push('Invalid flag format. Use only letters, numbers, underscores, hyphens, and braces.');
    }

    // Length validation
    if (flag.length > 100) {
      errors.push('Flag is too long (maximum 100 characters)');
    }

    // Check for duplicate submissions
    const isDuplicate = submissionHistory.some(
      submission => submission.flag.toLowerCase() === flag.toLowerCase()
    );
    
    if (isDuplicate) {
      errors.push('You have already submitted this flag');
    }

    setValidationErrors(errors);
    return errors.length === 0;
  };

  const checkRateLimit = (): boolean => {
    if (!lastAttempt) return true;
    
    const timeSinceLastAttempt = Date.now() - lastAttempt.getTime();
    const remainingCooldown = Math.max(0, cooldownSeconds * 1000 - timeSinceLastAttempt);
    
    if (remainingCooldown > 0) {
      setCooldownRemaining(Math.ceil(remainingCooldown / 1000));
      return false;
    }
    
    return true;
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    // Validate inputs
    if (!validateFlag()) {
      return;
    }

    // Check attempt limit
    if (attempts >= maxAttempts) {
      onError?.('Maximum attempts reached for this challenge');
      SecurityMonitor.logSecurityEvent({
        type: 'max_attempts_exceeded',
        severity: 'medium',
        description: 'User exceeded maximum submission attempts',
        metadata: { challengeId, attempts }
      });
      return;
    }

    // Check rate limiting
    if (!checkRateLimit()) {
      onError?.(`Please wait ${cooldownRemaining} seconds between submissions`);
      return;
    }

    setIsSubmitting(true);
    setLastAttempt(new Date());
    setValidationErrors([]);

    try {
      const { data: user } = await supabase.auth.getUser();
      if (!user.user) {
        throw new Error('User not authenticated');
      }

      // Sanitize flag input
      const sanitizedFlag = InputSecurity.sanitizeInput(flag);

      // Log submission attempt
      SecurityMonitor.logSecurityEvent({
        type: 'flag_submission',
        severity: 'low',
        userId: user.user.id,
        description: 'Flag submission attempt',
        metadata: { 
          challengeId, 
          flagLength: sanitizedFlag.length,
          attempt: attempts + 1
        }
      });

      // Submit flag securely
      const { data, error } = await supabase
        .from('submissions')
        .insert({
          challenge_id: challengeId,
          submitted_flag: sanitizedFlag,
          user_id: user.user.id
        })
        .select()
        .single();

      if (error) throw error;

      // Update local state
      const newSubmission = {
        flag: sanitizedFlag,
        timestamp: new Date(),
        isCorrect: data.is_correct
      };
      
      setSubmissionHistory(prev => [newSubmission, ...prev]);
      setAttempts(prev => prev + 1);

      if (data.is_correct) {
        SecurityMonitor.logSecurityEvent({
          type: 'challenge_solved',
          severity: 'low',
          userId: user.user.id,
          description: 'Challenge solved successfully',
          metadata: { challengeId, attempts: attempts + 1 }
        });

        onSuccess();
      } else {
        onError?.('Incorrect flag. Try again!');
        
        // Detect potential brute force attempts
        if (attempts >= 5) {
          SecurityMonitor.logSecurityEvent({
            type: 'potential_brute_force',
            severity: 'medium',
            userId: user.user.id,
            description: 'Multiple incorrect flag submissions',
            metadata: { challengeId, attempts: attempts + 1 }
          });
        }
      }
    } catch (error: any) {
      console.error('Submission error:', error);
      onError?.(error.message || 'Submission failed. Please try again.');
      
      SecurityMonitor.logSecurityEvent({
        type: 'submission_error',
        severity: 'medium',
        description: 'Flag submission failed',
        metadata: { challengeId, error: error.message }
      });
    } finally {
      setIsSubmitting(false);
      setFlag('');
      setCooldownRemaining(cooldownSeconds);
    }
  };

  const getProgressColor = () => {
    const percentage = (attempts / maxAttempts) * 100;
    if (percentage < 50) return 'bg-green-500';
    if (percentage < 80) return 'bg-yellow-500';
    return 'bg-red-500';
  };

  return (
    <div className="w-full max-w-md mx-auto space-y-6">
      <div className="text-center">
        <Flag className="mx-auto h-8 w-8 text-blue-600" />
        <h3 className="mt-2 text-lg font-semibold text-gray-900">Submit Flag</h3>
        <p className="text-sm text-gray-600">
          Secure submission with validation and rate limiting
        </p>
      </div>

      {/* Attempt Progress */}
      <div className="space-y-2">
        <div className="flex justify-between text-sm">
          <span>Attempts Used</span>
          <span className={attempts >= maxAttempts ? 'text-red-600 font-semibold' : ''}>
            {attempts}/{maxAttempts}
          </span>
        </div>
        <Progress 
          value={(attempts / maxAttempts) * 100} 
          className="h-2"
        />
        {attempts >= maxAttempts && (
          <p className="text-red-600 text-sm font-medium">
            Maximum attempts reached. Contact an administrator if you believe this is correct.
          </p>
        )}
      </div>

      {/* Validation Errors */}
      {validationErrors.length > 0 && (
        <Alert variant="destructive">
          <AlertTriangle className="h-4 w-4" />
          <AlertDescription>
            <ul className="list-disc list-inside space-y-1">
              {validationErrors.map((error, index) => (
                <li key={index}>{error}</li>
              ))}
            </ul>
          </AlertDescription>
        </Alert>
      )}

      {/* Cooldown Warning */}
      {cooldownRemaining > 0 && (
        <Alert>
          <Clock className="h-4 w-4" />
          <AlertDescription>
            Please wait {cooldownRemaining} seconds before submitting again.
          </AlertDescription>
        </Alert>
      )}

      {/* Submission Form */}
      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <Label htmlFor="flag" className="block text-sm font-medium">
            Flag Submission
          </Label>
          <Input
            id="flag"
            type="text"
            value={flag}
            onChange={(e) => setFlag(e.target.value)}
            placeholder="flag{...}"
            required
            disabled={isSubmitting || attempts >= maxAttempts || cooldownRemaining > 0}
            maxLength={100}
            className="mt-1 font-mono"
          />
          <p className="mt-1 text-xs text-gray-500">
            Enter the flag in the correct format (e.g., flag{example})
          </p>
        </div>
        
        <Button
          type="submit"
          disabled={
            isSubmitting || 
            attempts >= maxAttempts || 
            !flag.trim() || 
            cooldownRemaining > 0
          }
          className="w-full"
        >
          {isSubmitting ? (
            'Submitting...'
          ) : cooldownRemaining > 0 ? (
            `Wait ${cooldownRemaining}s`
          ) : attempts >= maxAttempts ? (
            'Max Attempts Reached'
          ) : (
            'Submit Flag'
          )}
        </Button>
      </form>

      {/* Security Features */}
      <div className="text-center">
        <div className="flex items-center justify-center space-x-2 text-xs text-gray-500">
          <Shield className="h-3 w-3" />
          <span>Protected by input validation & rate limiting</span>
        </div>
      </div>

      {/* Recent Submissions */}
      {submissionHistory.length > 0 && (
        <div className="space-y-2">
          <h4 className="text-sm font-medium text-gray-700">Recent Attempts</h4>
          <div className="max-h-32 overflow-y-auto space-y-1">
            {submissionHistory.slice(0, 5).map((submission, index) => (
              <div 
                key={index}
                className="flex items-center justify-between text-xs p-2 bg-gray-50 rounded"
              >
                <span className="font-mono truncate flex-1 mr-2">
                  {submission.flag}
                </span>
                <div className="flex items-center space-x-2">
                  {submission.isCorrect ? (
                    <CheckCircle className="h-3 w-3 text-green-500" />
                  ) : (
                    <AlertTriangle className="h-3 w-3 text-red-500" />
                  )}
                  <span className="text-gray-500">
                    {submission.timestamp.toLocaleTimeString()}
                  </span>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}