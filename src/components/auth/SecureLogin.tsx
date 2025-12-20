import React, { useState, useEffect } from 'react';
import { AuthSecurity } from '@/utils/authSecurity';
import { InputSecurity } from '@/utils/inputSecurity';
import { SecurityMonitor } from '@/utils/securityMonitor';
import { supabase } from '@/integrations/supabase/client';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Alert, AlertDescription } from '@/components/ui/alert';
import { Shield, AlertTriangle, Lock } from 'lucide-react';

interface SecureLoginProps {
  onSuccess?: () => void;
  onError?: (error: string) => void;
}

export function SecureLogin({ onSuccess, onError }: SecureLoginProps) {
  const [credentials, setCredentials] = useState({
    email: '',
    password: ''
  });
  const [attempts, setAttempts] = useState(0);
  const [isLocked, setIsLocked] = useState(false);
  const [lockoutTime, setLockoutTime] = useState<Date | null>(null);
  const [isLoading, setIsLoading] = useState(false);
  const [errors, setErrors] = useState<string[]>([]);
  const [showPasswordStrength, setShowPasswordStrength] = useState(false);

  const rateLimiter = AuthSecurity.createAuthRateLimit();

  // Account lockout management
  useEffect(() => {
    if (attempts >= 3) {
      const lockoutDuration = 15 * 60 * 1000; // 15 minutes
      const unlockTime = new Date(Date.now() + lockoutDuration);
      
      setIsLocked(true);
      setLockoutTime(unlockTime);
      
      SecurityMonitor.logSecurityEvent({
        type: 'account_lockout',
        severity: 'medium',
        description: `Account locked after ${attempts} failed attempts`,
        metadata: { attempts, unlockTime }
      });

      const timeout = setTimeout(() => {
        setIsLocked(false);
        setAttempts(0);
        setLockoutTime(null);
      }, lockoutDuration);

      return () => clearTimeout(timeout);
    }
  }, [attempts]);

  // Real-time lockout countdown
  useEffect(() => {
    if (!isLocked || !lockoutTime) return;

    const interval = setInterval(() => {
      if (Date.now() >= lockoutTime.getTime()) {
        setIsLocked(false);
        setAttempts(0);
        setLockoutTime(null);
      }
    }, 1000);

    return () => clearInterval(interval);
  }, [isLocked, lockoutTime]);

  const validateInputs = (): boolean => {
    const newErrors: string[] = [];

    // Email validation
    const sanitizedEmail = InputSecurity.sanitizeEmail(credentials.email);
    if (!InputSecurity.validateEmail(sanitizedEmail)) {
      newErrors.push('Please enter a valid email address');
    }

    // Password validation
    if (!credentials.password) {
      newErrors.push('Password is required');
    } else if (credentials.password.length < 8) {
      newErrors.push('Password must be at least 8 characters long');
    }

    setErrors(newErrors);
    return newErrors.length === 0;
  };

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (isLocked) {
      const remainingTime = lockoutTime ? Math.ceil((lockoutTime.getTime() - Date.now()) / 1000) : 0;
      onError?.(`Account locked. Try again in ${Math.ceil(remainingTime / 60)} minutes.`);
      return;
    }

    if (!validateInputs()) {
      return;
    }

    // Rate limiting check
    const clientId = `${credentials.email}_${navigator.userAgent}`;
    const rateCheck = rateLimiter.checkLimit(clientId);
    
    if (!rateCheck.allowed) {
      SecurityMonitor.logSecurityEvent({
        type: 'rate_limit_exceeded',
        severity: 'medium',
        description: 'Login rate limit exceeded',
        metadata: { email: credentials.email, retryAfter: rateCheck.retryAfter }
      });
      
      onError?.(`Too many attempts. Try again in ${rateCheck.retryAfter} seconds.`);
      return;
    }

    setIsLoading(true);
    setErrors([]);

    try {
      // Sanitize inputs
      const sanitizedEmail = InputSecurity.sanitizeEmail(credentials.email);
      const sanitizedPassword = InputSecurity.sanitizeInput(credentials.password);

      // Attempt login
      const { data, error } = await supabase.auth.signInWithPassword({
        email: sanitizedEmail,
        password: sanitizedPassword
      });

      if (error) {
        setAttempts(prev => prev + 1);
        
        SecurityMonitor.logSecurityEvent({
          type: 'auth_failure',
          severity: 'low',
          description: 'Failed login attempt',
          metadata: { 
            email: sanitizedEmail, 
            error: error.message,
            attempt: attempts + 1
          }
        });

        throw error;
      }

      // Successful login
      SecurityMonitor.logSecurityEvent({
        type: 'auth_success',
        severity: 'low',
        userId: data.user?.id,
        description: 'Successful login',
        metadata: { email: sanitizedEmail }
      });

      // Reset attempts on successful login
      setAttempts(0);
      rateLimiter.reset(clientId);
      
      onSuccess?.();
    } catch (error: any) {
      console.error('Login failed:', error);
      onError?.(error.message || 'Login failed. Please check your credentials.');
    } finally {
      setIsLoading(false);
    }
  };

  const getRemainingLockoutTime = (): string => {
    if (!lockoutTime) return '';
    const remaining = Math.ceil((lockoutTime.getTime() - Date.now()) / 1000);
    const minutes = Math.floor(remaining / 60);
    const seconds = remaining % 60;
    return `${minutes}:${seconds.toString().padStart(2, '0')}`;
  };

  return (
    <div className="w-full max-w-md mx-auto space-y-6">
      <div className="text-center">
        <Shield className="mx-auto h-12 w-12 text-blue-600" />
        <h2 className="mt-2 text-2xl font-bold text-gray-900">Secure Login</h2>
        <p className="mt-2 text-sm text-gray-600">
          Protected by advanced security measures
        </p>
      </div>

      {errors.length > 0 && (
        <Alert variant="destructive">
          <AlertTriangle className="h-4 w-4" />
          <AlertDescription>
            <ul className="list-disc list-inside space-y-1">
              {errors.map((error, index) => (
                <li key={index}>{error}</li>
              ))}
            </ul>
          </AlertDescription>
        </Alert>
      )}

      {isLocked && (
        <Alert variant="destructive">
          <Lock className="h-4 w-4" />
          <AlertDescription>
            Account temporarily locked due to multiple failed attempts.
            <br />
            Unlock in: {getRemainingLockoutTime()}
          </AlertDescription>
        </Alert>
      )}

      <form onSubmit={handleLogin} className="space-y-4">
        <div>
          <Label htmlFor="email">Email Address</Label>
          <Input
            id="email"
            type="email"
            value={credentials.email}
            onChange={(e) => setCredentials(prev => ({
              ...prev,
              email: e.target.value
            }))}
            required
            disabled={isLocked || isLoading}
            maxLength={254}
            placeholder="Enter your email"
            className="mt-1"
          />
        </div>
        
        <div>
          <Label htmlFor="password">Password</Label>
          <Input
            id="password"
            type="password"
            value={credentials.password}
            onChange={(e) => {
              setCredentials(prev => ({
                ...prev,
                password: e.target.value
              }));
              setShowPasswordStrength(e.target.value.length > 0);
            }}
            required
            disabled={isLocked || isLoading}
            maxLength={128}
            placeholder="Enter your password"
            className="mt-1"
          />
          
          {showPasswordStrength && credentials.password && (
            <div className="mt-2 text-xs text-gray-600">
              {(() => {
                const strength = AuthSecurity.validatePasswordStrength(credentials.password);
                const colors = ['text-red-500', 'text-orange-500', 'text-yellow-500', 'text-green-500'];
                const labels = ['Weak', 'Fair', 'Good', 'Strong'];
                return (
                  <span className={colors[Math.min(strength.score, 3)]}>
                    Password strength: {labels[Math.min(strength.score, 3)]}
                  </span>
                );
              })()}
            </div>
          )}
        </div>

        <Button 
          type="submit" 
          disabled={isLocked || isLoading || !credentials.email || !credentials.password}
          className="w-full"
        >
          {isLoading ? 'Signing In...' : isLocked ? 'Account Locked' : 'Sign In'}
        </Button>

        <div className="text-center space-y-2">
          {attempts > 0 && (
            <p className="text-sm text-red-600">
              Failed attempts: {attempts}/3. Account will be locked after 3 attempts.
            </p>
          )}
          
          <div className="text-xs text-gray-500 space-y-1">
            <p>🔒 This login is protected by:</p>
            <ul className="list-disc list-inside text-left max-w-xs mx-auto">
              <li>Rate limiting</li>
              <li>Account lockout protection</li>
              <li>Input sanitization</li>
              <li>Security monitoring</li>
            </ul>
          </div>
        </div>
      </form>
    </div>
  );
}