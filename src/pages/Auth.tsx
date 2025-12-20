import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { motion } from 'framer-motion';
import { Terminal, Mail, Lock, User, ArrowRight, Loader2, Shield } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card';
import { useAuth } from '@/hooks/useAuth';
import { useToast } from '@/hooks/use-toast';
import { SecureLogin } from '@/components/auth/SecureLogin';
import { AuthSecurity } from '@/utils/authSecurity';
import { InputSecurity } from '@/utils/inputSecurity';
import { SecurityMonitor } from '@/utils/securityMonitor';
import { z } from 'zod';

const loginSchema = z.object({
  email: z.string().email('Invalid email address'),
  password: z.string().min(6, 'Password must be at least 6 characters'),
});

const signupSchema = loginSchema.extend({
  username: z.string().min(3, 'Username must be at least 3 characters').max(20, 'Username too long'),
});

export default function Auth() {
  const [isLogin, setIsLogin] = useState(true);
  const [useSecureLogin, setUseSecureLogin] = useState(true);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [username, setUsername] = useState('');
  const [loading, setLoading] = useState(false);
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [passwordStrength, setPasswordStrength] = useState<any>(null);
  
  const { user, signIn, signUp } = useAuth();
  const navigate = useNavigate();
  const { toast } = useToast();

  useEffect(() => {
    if (user) {
      navigate('/challenges');
    }
  }, [user, navigate]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setErrors({});
    
    try {
      if (isLogin) {
        const result = loginSchema.safeParse({ email, password });
        if (!result.success) {
          const fieldErrors: Record<string, string> = {};
          result.error.errors.forEach(err => {
            if (err.path[0]) fieldErrors[err.path[0] as string] = err.message;
          });
          setErrors(fieldErrors);
          return;
        }
      } else {
        const result = signupSchema.safeParse({ email, password, username });
        if (!result.success) {
          const fieldErrors: Record<string, string> = {};
          result.error.errors.forEach(err => {
            if (err.path[0]) fieldErrors[err.path[0] as string] = err.message;
          });
          setErrors(fieldErrors);
          return;
        }

        // Additional security validation for signup
        const emailValidation = InputSecurity.validateEmail(email);
        if (!emailValidation) {
          setErrors({ email: 'Invalid email format' });
          return;
        }

        const usernameValidation = InputSecurity.validateUsername(username);
        if (!usernameValidation.isValid) {
          setErrors({ username: usernameValidation.errors[0] });
          return;
        }

        const passwordValidation = AuthSecurity.validatePasswordStrength(password);
        if (!passwordValidation.isValid) {
          setErrors({ password: passwordValidation.errors[0] });
          return;
        }
      }

      setLoading(true);

      if (isLogin) {
        // Sanitize inputs
        const sanitizedEmail = InputSecurity.sanitizeEmail(email);
        const sanitizedPassword = InputSecurity.sanitizeInput(password);

        const { error } = await signIn(sanitizedEmail, sanitizedPassword);
        if (error) {
          SecurityMonitor.logSecurityEvent({
            type: 'auth_failure',
            severity: 'low',
            description: 'Failed login attempt via legacy form',
            metadata: { email: sanitizedEmail, error: error.message }
          });

          toast({
            title: "Login failed",
            description: error.message || "Invalid credentials",
            variant: "destructive",
          });
        }
      } else {
        // Sanitize inputs for signup
        const sanitizedEmail = InputSecurity.sanitizeEmail(email);
        const sanitizedUsername = InputSecurity.sanitizeInput(username);
        const sanitizedPassword = InputSecurity.sanitizeInput(password);

        const { error } = await signUp(sanitizedEmail, sanitizedPassword, sanitizedUsername);
        if (error) {
          SecurityMonitor.logSecurityEvent({
            type: 'signup_failure',
            severity: 'low',
            description: 'Failed signup attempt',
            metadata: { email: sanitizedEmail, error: error.message }
          });

          if (error.message.includes('already registered')) {
            toast({
              title: "Account exists",
              description: "This email is already registered. Try logging in.",
              variant: "destructive",
            });
          } else {
            toast({
              title: "Signup failed",
              description: error.message,
              variant: "destructive",
            });
          }
        } else {
          SecurityMonitor.logSecurityEvent({
            type: 'signup_success',
            severity: 'low',
            description: 'Successful account creation',
            metadata: { email: sanitizedEmail }
          });

          toast({
            title: "Welcome, hacker!",
            description: "Account created successfully.",
          });
        }
      }
    } finally {
      setLoading(false);
    }
  };

  const handlePasswordChange = (value: string) => {
    setPassword(value);
    if (!isLogin && value) {
      const strength = AuthSecurity.validatePasswordStrength(value);
      setPasswordStrength(strength);
    } else {
      setPasswordStrength(null);
    }
  };

  const handleSecureLoginSuccess = () => {
    toast({
      title: "Welcome back!",
      description: "Successfully logged in with enhanced security.",
    });
    navigate('/challenges');
  };

  const handleSecureLoginError = (error: string) => {
    toast({
      title: "Login failed",
      description: error,
      variant: "destructive",
    });
  };

  return (
    <div className="min-h-screen bg-background terminal-grid flex items-center justify-center p-4">
      <div className="fixed inset-0 scanline pointer-events-none" />
      
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5 }}
        className="w-full max-w-md relative z-10"
      >
        <div className="text-center mb-8">
          <motion.div
            initial={{ scale: 0 }}
            animate={{ scale: 1 }}
            transition={{ delay: 0.2, type: "spring" }}
            className="inline-flex items-center justify-center w-16 h-16 rounded-xl gradient-primary mb-4 box-glow"
          >
            <Terminal className="h-8 w-8 text-primary-foreground" />
          </motion.div>
          <h1 className="text-3xl font-mono font-bold text-primary text-glow">SEENAF_CTF</h1>
          <p className="text-muted-foreground mt-2">
            {isLogin ? 'Access your terminal' : 'Initialize new hacker profile'}
          </p>
        </div>

        <Card className="glass border-primary/20 shadow-lg shadow-primary/10">
          <CardHeader>
            <CardTitle className="text-center flex items-center justify-center gap-2">
              {isLogin && useSecureLogin && <Shield className="h-5 w-5 text-green-500" />}
              {isLogin ? '> SECURE LOGIN' : '> REGISTER'}
            </CardTitle>
            <CardDescription className="text-center font-mono text-xs">
              {isLogin 
                ? (useSecureLogin 
                    ? 'Enhanced security authentication...' 
                    : 'Enter credentials to continue...'
                  )
                : 'Create your hacker identity...'
              }
            </CardDescription>
            {isLogin && (
              <div className="flex justify-center mt-2">
                <Button
                  type="button"
                  variant="ghost"
                  size="sm"
                  onClick={() => setUseSecureLogin(!useSecureLogin)}
                  className="text-xs"
                >
                  {useSecureLogin ? 'Use Basic Login' : 'Use Secure Login'}
                </Button>
              </div>
            )}
          </CardHeader>
          <CardContent>
            {isLogin && useSecureLogin ? (
              <SecureLogin
                onSuccess={handleSecureLoginSuccess}
                onError={handleSecureLoginError}
              />
            ) : (
              <form onSubmit={handleSubmit} className="space-y-4">
              {!isLogin && (
                <div className="space-y-2">
                  <div className="relative">
                    <User className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                    <Input
                      type="text"
                      placeholder="Username"
                      value={username}
                      onChange={(e) => setUsername(e.target.value)}
                      className="pl-10"
                    />
                  </div>
                  {errors.username && (
                    <p className="text-destructive text-xs font-mono">{errors.username}</p>
                  )}
                </div>
              )}
              
              <div className="space-y-2">
                <div className="relative">
                  <Mail className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                  <Input
                    type="email"
                    placeholder="Email"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    className="pl-10"
                  />
                </div>
                {errors.email && (
                  <p className="text-destructive text-xs font-mono">{errors.email}</p>
                )}
              </div>

              <div className="space-y-2">
                <div className="relative">
                  <Lock className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                  <Input
                    type="password"
                    placeholder="Password"
                    value={password}
                    onChange={(e) => handlePasswordChange(e.target.value)}
                    className="pl-10"
                  />
                </div>
                {errors.password && (
                  <p className="text-destructive text-xs font-mono">{errors.password}</p>
                )}
                {!isLogin && passwordStrength && password && (
                  <div className="text-xs space-y-1">
                    <div className="flex items-center justify-between">
                      <span>Password Strength:</span>
                      <span className={
                        passwordStrength.score >= 4 ? 'text-green-500' :
                        passwordStrength.score >= 3 ? 'text-yellow-500' :
                        passwordStrength.score >= 2 ? 'text-orange-500' :
                        'text-red-500'
                      }>
                        {passwordStrength.score >= 4 ? 'Strong' :
                         passwordStrength.score >= 3 ? 'Good' :
                         passwordStrength.score >= 2 ? 'Fair' : 'Weak'}
                      </span>
                    </div>
                    {passwordStrength.errors.length > 0 && (
                      <ul className="text-red-400 text-xs list-disc list-inside">
                        {passwordStrength.errors.slice(0, 2).map((error: string, index: number) => (
                          <li key={index}>{error}</li>
                        ))}
                      </ul>
                    )}
                  </div>
                )}
              </div>

              <Button
                type="submit"
                variant="default"
                className="w-full"
                disabled={loading}
              >
                {loading ? (
                  <Loader2 className="h-4 w-4 animate-spin" />
                ) : (
                  <>
                    {isLogin ? 'Access Terminal' : 'Initialize Profile'}
                    <ArrowRight className="h-4 w-4" />
                  </>
                )}
              </Button>
            </form>
            )}

            {isLogin && useSecureLogin && (
              <div className="mt-4 text-center">
                <div className="text-xs text-green-600 bg-green-50 dark:bg-green-900/20 p-2 rounded border border-green-200 dark:border-green-800">
                  🔒 Enhanced Security Features Active:
                  <ul className="list-disc list-inside mt-1 text-left">
                    <li>Account lockout protection</li>
                    <li>Rate limiting</li>
                    <li>Input sanitization</li>
                    <li>Security monitoring</li>
                  </ul>
                </div>
              </div>
            )}

            <div className="mt-6 text-center">
              <button
                type="button"
                onClick={() => {
                  setIsLogin(!isLogin);
                  setErrors({});
                }}
                className="text-sm text-muted-foreground hover:text-primary transition-colors font-mono"
              >
                {isLogin ? "Don't have an account? Register" : 'Already have an account? Login'}
              </button>
            </div>
          </CardContent>
        </Card>
      </motion.div>
    </div>
  );
}
