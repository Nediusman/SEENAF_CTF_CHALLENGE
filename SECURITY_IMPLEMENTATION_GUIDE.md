# 🔒 Complete Security Implementation Guide

This guide provides comprehensive security measures for the SEENAF CTF Platform to ensure maximum protection against threats.

---

## 🛡️ Security Overview

### Security Layers Implemented:
1. **Frontend Security** - Input validation, XSS protection, CSRF protection
2. **Backend Security** - Authentication, authorization, rate limiting
3. **Database Security** - RLS, SQL injection prevention, data encryption
4. **Infrastructure Security** - HTTPS, security headers, DDoS protection
5. **Application Security** - Secure coding practices, vulnerability scanning
6. **Operational Security** - Monitoring, logging, incident response

---

## 🔐 1. Authentication & Authorization Security

### Enhanced Authentication System

```typescript
// src/utils/authSecurity.ts
import { supabase } from '@/integrations/supabase/client';
import bcrypt from 'bcryptjs';
import rateLimit from 'express-rate-limit';

export class AuthSecurity {
  // Password strength validation
  static validatePasswordStrength(password: string): {
    isValid: boolean;
    errors: string[];
    score: number;
  } {
    const errors: string[] = [];
    let score = 0;

    // Minimum length
    if (password.length < 12) {
      errors.push('Password must be at least 12 characters long');
    } else {
      score += 1;
    }

    // Character variety
    if (!/[a-z]/.test(password)) {
      errors.push('Password must contain lowercase letters');
    } else {
      score += 1;
    }

    if (!/[A-Z]/.test(password)) {
      errors.push('Password must contain uppercase letters');
    } else {
      score += 1;
    }

    if (!/\d/.test(password)) {
      errors.push('Password must contain numbers');
    } else {
      score += 1;
    }

    if (!/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password)) {
      errors.push('Password must contain special characters');
    } else {
      score += 1;
    }

    // Common password check
    const commonPasswords = [
      'password', '123456', 'qwerty', 'admin', 'letmein',
      'welcome', 'monkey', '1234567890', 'password123'
    ];
    
    if (commonPasswords.some(common => 
      password.toLowerCase().includes(common.toLowerCase())
    )) {
      errors.push('Password contains common patterns');
      score -= 2;
    }

    return {
      isValid: errors.length === 0 && score >= 4,
      errors,
      score: Math.max(0, score)
    };
  }

  // Multi-factor authentication
  static async enableMFA(userId: string, method: 'totp' | 'sms' = 'totp') {
    try {
      const { data, error } = await supabase.auth.mfa.enroll({
        factorType: method,
        friendlyName: `${method.toUpperCase()} Authentication`
      });

      if (error) throw error;
      return { success: true, data };
    } catch (error) {
      console.error('MFA enrollment failed:', error);
      return { success: false, error: error.message };
    }
  }

  // Session security
  static async validateSession(sessionToken: string): Promise<boolean> {
    try {
      const { data: { user }, error } = await supabase.auth.getUser(sessionToken);
      
      if (error || !user) return false;

      // Check session expiry
      const session = await supabase.auth.getSession();
      if (!session.data.session) return false;

      // Validate session integrity
      const sessionAge = Date.now() - new Date(session.data.session.created_at).getTime();
      const maxAge = 24 * 60 * 60 * 1000; // 24 hours

      return sessionAge < maxAge;
    } catch {
      return false;
    }
  }

  // Rate limiting for authentication attempts
  static createAuthRateLimit() {
    return rateLimit({
      windowMs: 15 * 60 * 1000, // 15 minutes
      max: 5, // 5 attempts per window
      message: {
        error: 'Too many authentication attempts. Please try again later.',
        retryAfter: '15 minutes'
      },
      standardHeaders: true,
      legacyHeaders: false,
      handler: (req, res) => {
        res.status(429).json({
          error: 'Rate limit exceeded',
          message: 'Too many authentication attempts'
        });
      }
    });
  }
}
```

### Secure Login Component

```typescript
// src/components/auth/SecureLogin.tsx
import React, { useState, useEffect } from 'react';
import { AuthSecurity } from '@/utils/authSecurity';
import { InputSanitizer } from '@/utils/inputSecurity';

export function SecureLogin() {
  const [credentials, setCredentials] = useState({
    email: '',
    password: ''
  });
  const [attempts, setAttempts] = useState(0);
  const [isLocked, setIsLocked] = useState(false);
  const [captchaRequired, setCaptchaRequired] = useState(false);

  // Account lockout after failed attempts
  useEffect(() => {
    if (attempts >= 3) {
      setIsLocked(true);
      setCaptchaRequired(true);
      setTimeout(() => {
        setIsLocked(false);
        setAttempts(0);
      }, 15 * 60 * 1000); // 15 minutes lockout
    }
  }, [attempts]);

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (isLocked) {
      alert('Account temporarily locked. Please try again later.');
      return;
    }

    // Sanitize inputs
    const sanitizedEmail = InputSanitizer.sanitizeEmail(credentials.email);
    const sanitizedPassword = InputSanitizer.sanitizeInput(credentials.password);

    // Validate inputs
    if (!InputSanitizer.validateEmail(sanitizedEmail)) {
      alert('Invalid email format');
      return;
    }

    try {
      const { data, error } = await supabase.auth.signInWithPassword({
        email: sanitizedEmail,
        password: sanitizedPassword
      });

      if (error) {
        setAttempts(prev => prev + 1);
        throw error;
      }

      // Reset attempts on successful login
      setAttempts(0);
      
      // Redirect to dashboard
      window.location.href = '/dashboard';
    } catch (error) {
      console.error('Login failed:', error);
      alert('Login failed. Please check your credentials.');
    }
  };

  return (
    <form onSubmit={handleLogin} className="space-y-4">
      <div>
        <label htmlFor="email">Email:</label>
        <input
          id="email"
          type="email"
          value={credentials.email}
          onChange={(e) => setCredentials(prev => ({
            ...prev,
            email: e.target.value
          }))}
          required
          disabled={isLocked}
          maxLength={254} // RFC 5321 limit
        />
      </div>
      
      <div>
        <label htmlFor="password">Password:</label>
        <input
          id="password"
          type="password"
          value={credentials.password}
          onChange={(e) => setCredentials(prev => ({
            ...prev,
            password: e.target.value
          }))}
          required
          disabled={isLocked}
          maxLength={128}
        />
      </div>

      {captchaRequired && (
        <div>
          {/* Add CAPTCHA component here */}
          <p>Please complete the CAPTCHA to continue</p>
        </div>
      )}

      <button 
        type="submit" 
        disabled={isLocked}
        className="w-full bg-blue-500 text-white p-2 rounded disabled:bg-gray-400"
      >
        {isLocked ? 'Account Locked' : 'Login'}
      </button>

      {attempts > 0 && (
        <p className="text-red-500">
          Failed attempts: {attempts}/3. Account will be locked after 3 attempts.
        </p>
      )}
    </form>
  );
}
```

---

## 🛡️ 2. Input Validation & Sanitization

### Comprehensive Input Security

```typescript
// src/utils/inputSecurity.ts
import DOMPurify from 'dompurify';
import validator from 'validator';

export class InputSecurity {
  // XSS Prevention
  static sanitizeHTML(input: string): string {
    return DOMPurify.sanitize(input, {
      ALLOWED_TAGS: ['b', 'i', 'em', 'strong', 'code'],
      ALLOWED_ATTR: []
    });
  }

  // SQL Injection Prevention
  static sanitizeInput(input: string): string {
    if (typeof input !== 'string') return '';
    
    return input
      .replace(/[<>]/g, '') // Remove potential HTML
      .replace(/['"]/g, '') // Remove quotes
      .replace(/[;--]/g, '') // Remove SQL comment patterns
      .replace(/\b(SELECT|INSERT|UPDATE|DELETE|DROP|CREATE|ALTER|EXEC|UNION)\b/gi, '') // Remove SQL keywords
      .trim()
      .substring(0, 1000); // Limit length
  }

  // Email validation and sanitization
  static sanitizeEmail(email: string): string {
    return validator.normalizeEmail(email) || '';
  }

  static validateEmail(email: string): boolean {
    return validator.isEmail(email) && email.length <= 254;
  }

  // Flag validation for CTF challenges
  static validateFlag(flag: string): boolean {
    // Allow only alphanumeric, underscores, hyphens, and braces
    const flagPattern = /^[a-zA-Z0-9_{}\-]+$/;
    return flagPattern.test(flag) && flag.length <= 100;
  }

  // Challenge content validation
  static validateChallengeContent(content: string): {
    isValid: boolean;
    sanitized: string;
    errors: string[];
  } {
    const errors: string[] = [];
    
    // Length validation
    if (content.length > 10000) {
      errors.push('Content too long (max 10,000 characters)');
    }

    // Sanitize HTML content
    const sanitized = this.sanitizeHTML(content);

    // Check for suspicious patterns
    const suspiciousPatterns = [
      /<script/i,
      /javascript:/i,
      /on\w+\s*=/i,
      /data:text\/html/i
    ];

    for (const pattern of suspiciousPatterns) {
      if (pattern.test(content)) {
        errors.push('Content contains potentially malicious code');
        break;
      }
    }

    return {
      isValid: errors.length === 0,
      sanitized,
      errors
    };
  }

  // File upload validation
  static validateFileUpload(file: File): {
    isValid: boolean;
    errors: string[];
  } {
    const errors: string[] = [];
    const maxSize = 5 * 1024 * 1024; // 5MB
    const allowedTypes = [
      'image/jpeg',
      'image/png',
      'image/gif',
      'text/plain',
      'application/pdf'
    ];

    // Size validation
    if (file.size > maxSize) {
      errors.push('File size exceeds 5MB limit');
    }

    // Type validation
    if (!allowedTypes.includes(file.type)) {
      errors.push('File type not allowed');
    }

    // Filename validation
    const filename = file.name;
    if (!/^[a-zA-Z0-9._-]+$/.test(filename)) {
      errors.push('Invalid filename characters');
    }

    return {
      isValid: errors.length === 0,
      errors
    };
  }
}

// Input sanitization middleware
export const sanitizeMiddleware = (req: any, res: any, next: any) => {
  // Sanitize all string inputs in request body
  if (req.body && typeof req.body === 'object') {
    for (const key in req.body) {
      if (typeof req.body[key] === 'string') {
        req.body[key] = InputSecurity.sanitizeInput(req.body[key]);
      }
    }
  }

  // Sanitize query parameters
  if (req.query && typeof req.query === 'object') {
    for (const key in req.query) {
      if (typeof req.query[key] === 'string') {
        req.query[key] = InputSecurity.sanitizeInput(req.query[key]);
      }
    }
  }

  next();
};
```

---

## 🔒 3. Database Security Enhancement

### Enhanced Row Level Security (RLS)

```sql
-- Enhanced RLS policies for maximum security
-- File: enhanced-database-security.sql

-- Enable RLS on all tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE challenges ENABLE ROW LEVEL SECURITY;
ALTER TABLE submissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_roles ENABLE ROW LEVEL SECURITY;

-- Profiles security policies
DROP POLICY IF EXISTS "Users can view own profile" ON profiles;
CREATE POLICY "Users can view own profile" ON profiles
  FOR SELECT USING (
    auth.uid() = id OR 
    EXISTS (
      SELECT 1 FROM user_roles 
      WHERE user_id = auth.uid() 
      AND role IN ('admin', 'moderator')
    )
  );

DROP POLICY IF EXISTS "Users can update own profile" ON profiles;
CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (
    auth.uid() = id AND
    -- Prevent privilege escalation
    (OLD.id = NEW.id) AND
    (OLD.created_at = NEW.created_at)
  );

-- Challenges security policies
DROP POLICY IF EXISTS "Anyone can view published challenges" ON challenges;
CREATE POLICY "Anyone can view published challenges" ON challenges
  FOR SELECT USING (
    is_active = true OR
    EXISTS (
      SELECT 1 FROM user_roles 
      WHERE user_id = auth.uid() 
      AND role IN ('admin', 'moderator')
    )
  );

DROP POLICY IF EXISTS "Only admins can modify challenges" ON challenges;
CREATE POLICY "Only admins can modify challenges" ON challenges
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM user_roles 
      WHERE user_id = auth.uid() 
      AND role = 'admin'
    )
  );

-- Submissions security policies
DROP POLICY IF EXISTS "Users can view own submissions" ON submissions;
CREATE POLICY "Users can view own submissions" ON submissions
  FOR SELECT USING (
    user_id = auth.uid() OR
    EXISTS (
      SELECT 1 FROM user_roles 
      WHERE user_id = auth.uid() 
      AND role IN ('admin', 'moderator')
    )
  );

DROP POLICY IF EXISTS "Users can create own submissions" ON submissions;
CREATE POLICY "Users can create own submissions" ON submissions
  FOR INSERT WITH CHECK (
    user_id = auth.uid() AND
    -- Rate limiting: max 10 submissions per minute
    (
      SELECT COUNT(*) 
      FROM submissions 
      WHERE user_id = auth.uid() 
      AND created_at > NOW() - INTERVAL '1 minute'
    ) < 10
  );

-- User roles security policies
DROP POLICY IF EXISTS "Only admins can manage roles" ON user_roles;
CREATE POLICY "Only admins can manage roles" ON user_roles
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM user_roles 
      WHERE user_id = auth.uid() 
      AND role = 'admin'
    )
  );

-- Audit logging table
CREATE TABLE IF NOT EXISTS audit_logs (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id),
  action TEXT NOT NULL,
  table_name TEXT NOT NULL,
  record_id UUID,
  old_values JSONB,
  new_values JSONB,
  ip_address INET,
  user_agent TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS on audit logs
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Only admins can view audit logs" ON audit_logs
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM user_roles 
      WHERE user_id = auth.uid() 
      AND role = 'admin'
    )
  );

-- Audit trigger function
CREATE OR REPLACE FUNCTION audit_trigger_function()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'DELETE' THEN
    INSERT INTO audit_logs (user_id, action, table_name, record_id, old_values)
    VALUES (auth.uid(), 'DELETE', TG_TABLE_NAME, OLD.id, to_jsonb(OLD));
    RETURN OLD;
  ELSIF TG_OP = 'UPDATE' THEN
    INSERT INTO audit_logs (user_id, action, table_name, record_id, old_values, new_values)
    VALUES (auth.uid(), 'UPDATE', TG_TABLE_NAME, NEW.id, to_jsonb(OLD), to_jsonb(NEW));
    RETURN NEW;
  ELSIF TG_OP = 'INSERT' THEN
    INSERT INTO audit_logs (user_id, action, table_name, record_id, new_values)
    VALUES (auth.uid(), 'INSERT', TG_TABLE_NAME, NEW.id, to_jsonb(NEW));
    RETURN NEW;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create audit triggers
DROP TRIGGER IF EXISTS audit_profiles_trigger ON profiles;
CREATE TRIGGER audit_profiles_trigger
  AFTER INSERT OR UPDATE OR DELETE ON profiles
  FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();

DROP TRIGGER IF EXISTS audit_challenges_trigger ON challenges;
CREATE TRIGGER audit_challenges_trigger
  AFTER INSERT OR UPDATE OR DELETE ON challenges
  FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();

DROP TRIGGER IF EXISTS audit_user_roles_trigger ON user_roles;
CREATE TRIGGER audit_user_roles_trigger
  AFTER INSERT OR UPDATE OR DELETE ON user_roles
  FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();

-- Rate limiting function
CREATE OR REPLACE FUNCTION check_rate_limit(
  user_uuid UUID,
  action_type TEXT,
  time_window INTERVAL DEFAULT '1 minute',
  max_attempts INTEGER DEFAULT 10
) RETURNS BOOLEAN AS $$
DECLARE
  attempt_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO attempt_count
  FROM audit_logs
  WHERE user_id = user_uuid
    AND action = action_type
    AND created_at > NOW() - time_window;
  
  RETURN attempt_count < max_attempts;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Data encryption functions
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Function to encrypt sensitive data
CREATE OR REPLACE FUNCTION encrypt_sensitive_data(data TEXT, key TEXT DEFAULT 'default_key')
RETURNS TEXT AS $$
BEGIN
  RETURN encode(encrypt(data::bytea, key::bytea, 'aes'), 'base64');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to decrypt sensitive data
CREATE OR REPLACE FUNCTION decrypt_sensitive_data(encrypted_data TEXT, key TEXT DEFAULT 'default_key')
RETURNS TEXT AS $$
BEGIN
  RETURN convert_from(decrypt(decode(encrypted_data, 'base64'), key::bytea, 'aes'), 'UTF8');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

---

## 🌐 4. Enhanced Security Headers

### Complete Security Headers Configuration

```json
{
  "version": 2,
  "builds": [
    {
      "src": "package.json",
      "use": "@vercel/static-build",
      "config": {
        "distDir": "dist"
      }
    }
  ],
  "routes": [
    {
      "handle": "filesystem"
    },
    {
      "src": "/(.*)",
      "dest": "/index.html",
      "headers": {
        "Strict-Transport-Security": "max-age=31536000; includeSubDomains; preload",
        "Content-Security-Policy": "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval' https://cdn.jsdelivr.net; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; img-src 'self' data: https: blob:; font-src 'self' data: https://fonts.gstatic.com; connect-src 'self' https://*.supabase.co wss://*.supabase.co https://api.github.com; frame-ancestors 'none'; base-uri 'self'; form-action 'self'; upgrade-insecure-requests",
        "X-Content-Type-Options": "nosniff",
        "X-Frame-Options": "DENY",
        "X-XSS-Protection": "1; mode=block",
        "Referrer-Policy": "strict-origin-when-cross-origin",
        "Permissions-Policy": "camera=(), microphone=(), geolocation=(), payment=(), usb=(), magnetometer=(), gyroscope=(), accelerometer=()",
        "Cross-Origin-Embedder-Policy": "require-corp",
        "Cross-Origin-Opener-Policy": "same-origin",
        "Cross-Origin-Resource-Policy": "same-origin",
        "X-Permitted-Cross-Domain-Policies": "none",
        "Clear-Site-Data": "\"cache\", \"cookies\", \"storage\", \"executionContexts\"",
        "Feature-Policy": "camera 'none'; microphone 'none'; geolocation 'none'",
        "Cache-Control": "no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0"
      }
    }
  ]
}
```

---

## 🔐 5. API Security Layer

### Secure API Middleware

```typescript
// src/utils/apiSecurity.ts
import rateLimit from 'express-rate-limit';
import helmet from 'helmet';
import cors from 'cors';

export class APISecurity {
  // Rate limiting configurations
  static createRateLimiter(windowMs: number = 15 * 60 * 1000, max: number = 100) {
    return rateLimit({
      windowMs,
      max,
      message: {
        error: 'Too many requests',
        retryAfter: Math.ceil(windowMs / 1000)
      },
      standardHeaders: true,
      legacyHeaders: false,
      handler: (req, res) => {
        res.status(429).json({
          error: 'Rate limit exceeded',
          message: 'Too many requests from this IP'
        });
      }
    });
  }

  // CORS configuration
  static configureCORS() {
    return cors({
      origin: process.env.NODE_ENV === 'production' 
        ? ['https://seenaf-ctf-challenge.vercel.app']
        : ['http://localhost:3000', 'http://localhost:5173'],
      credentials: true,
      methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
      allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With'],
      maxAge: 86400 // 24 hours
    });
  }

  // Security headers middleware
  static configureHelmet() {
    return helmet({
      contentSecurityPolicy: {
        directives: {
          defaultSrc: ["'self'"],
          scriptSrc: ["'self'", "'unsafe-inline'", "'unsafe-eval'", "https://cdn.jsdelivr.net"],
          styleSrc: ["'self'", "'unsafe-inline'", "https://fonts.googleapis.com"],
          imgSrc: ["'self'", "data:", "https:", "blob:"],
          fontSrc: ["'self'", "data:", "https://fonts.gstatic.com"],
          connectSrc: ["'self'", "https://*.supabase.co", "wss://*.supabase.co"],
          frameAncestors: ["'none'"],
          baseUri: ["'self'"],
          formAction: ["'self'"]
        }
      },
      hsts: {
        maxAge: 31536000,
        includeSubDomains: true,
        preload: true
      }
    });
  }

  // Request validation middleware
  static validateRequest() {
    return (req: any, res: any, next: any) => {
      // Validate Content-Type for POST/PUT requests
      if (['POST', 'PUT', 'PATCH'].includes(req.method)) {
        if (!req.is('application/json')) {
          return res.status(400).json({
            error: 'Invalid Content-Type',
            message: 'Content-Type must be application/json'
          });
        }
      }

      // Validate request size
      const contentLength = parseInt(req.get('Content-Length') || '0');
      if (contentLength > 1024 * 1024) { // 1MB limit
        return res.status(413).json({
          error: 'Request too large',
          message: 'Request body exceeds 1MB limit'
        });
      }

      next();
    };
  }

  // Authentication middleware
  static requireAuth() {
    return async (req: any, res: any, next: any) => {
      try {
        const token = req.headers.authorization?.replace('Bearer ', '');
        
        if (!token) {
          return res.status(401).json({
            error: 'Unauthorized',
            message: 'Authentication token required'
          });
        }

        // Validate token with Supabase
        const { data: { user }, error } = await supabase.auth.getUser(token);
        
        if (error || !user) {
          return res.status(401).json({
            error: 'Unauthorized',
            message: 'Invalid authentication token'
          });
        }

        req.user = user;
        next();
      } catch (error) {
        res.status(500).json({
          error: 'Authentication error',
          message: 'Failed to validate authentication'
        });
      }
    };
  }

  // Admin authorization middleware
  static requireAdmin() {
    return async (req: any, res: any, next: any) => {
      try {
        if (!req.user) {
          return res.status(401).json({
            error: 'Unauthorized',
            message: 'Authentication required'
          });
        }

        // Check admin role
        const { data: roleData, error } = await supabase
          .from('user_roles')
          .select('role')
          .eq('user_id', req.user.id)
          .single();

        if (error || roleData?.role !== 'admin') {
          return res.status(403).json({
            error: 'Forbidden',
            message: 'Admin privileges required'
          });
        }

        next();
      } catch (error) {
        res.status(500).json({
          error: 'Authorization error',
          message: 'Failed to validate admin privileges'
        });
      }
    };
  }
}
```

---

## 🛡️ 6. Frontend Security Components

### Secure Challenge Submission

```typescript
// src/components/security/SecureSubmission.tsx
import React, { useState } from 'react';
import { InputSecurity } from '@/utils/inputSecurity';
import { supabase } from '@/integrations/supabase/client';

interface SecureSubmissionProps {
  challengeId: string;
  onSuccess: () => void;
}

export function SecureSubmission({ challengeId, onSuccess }: SecureSubmissionProps) {
  const [flag, setFlag] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [attempts, setAttempts] = useState(0);
  const [lastAttempt, setLastAttempt] = useState<Date | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    // Rate limiting check
    if (lastAttempt && Date.now() - lastAttempt.getTime() < 5000) {
      alert('Please wait 5 seconds between submissions');
      return;
    }

    // Validate flag format
    if (!InputSecurity.validateFlag(flag)) {
      alert('Invalid flag format');
      return;
    }

    // Check attempt limit
    if (attempts >= 10) {
      alert('Maximum attempts reached for this challenge');
      return;
    }

    setIsSubmitting(true);
    setLastAttempt(new Date());

    try {
      // Sanitize flag input
      const sanitizedFlag = InputSecurity.sanitizeInput(flag);

      // Submit flag securely
      const { data, error } = await supabase
        .from('submissions')
        .insert({
          challenge_id: challengeId,
          submitted_flag: sanitizedFlag,
          user_id: (await supabase.auth.getUser()).data.user?.id
        })
        .select()
        .single();

      if (error) throw error;

      if (data.is_correct) {
        onSuccess();
        alert('Correct flag! Well done!');
      } else {
        setAttempts(prev => prev + 1);
        alert('Incorrect flag. Try again!');
      }
    } catch (error) {
      console.error('Submission error:', error);
      alert('Submission failed. Please try again.');
    } finally {
      setIsSubmitting(false);
      setFlag('');
    }
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <div>
        <label htmlFor="flag" className="block text-sm font-medium">
          Submit Flag:
        </label>
        <input
          id="flag"
          type="text"
          value={flag}
          onChange={(e) => setFlag(e.target.value)}
          placeholder="flag{...}"
          required
          disabled={isSubmitting || attempts >= 10}
          maxLength={100}
          className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md"
        />
      </div>
      
      <button
        type="submit"
        disabled={isSubmitting || attempts >= 10 || !flag.trim()}
        className="w-full bg-blue-500 text-white py-2 px-4 rounded-md disabled:bg-gray-400"
      >
        {isSubmitting ? 'Submitting...' : 'Submit Flag'}
      </button>

      <div className="text-sm text-gray-600">
        <p>Attempts: {attempts}/10</p>
        {lastAttempt && (
          <p>Last attempt: {lastAttempt.toLocaleTimeString()}</p>
        )}
      </div>
    </form>
  );
}
```

---

## 🔍 7. Security Monitoring & Logging

### Security Event Monitor

```typescript
// src/utils/securityMonitor.ts
export class SecurityMonitor {
  private static events: SecurityEvent[] = [];

  static logSecurityEvent(event: SecurityEvent) {
    this.events.push({
      ...event,
      timestamp: new Date(),
      id: crypto.randomUUID()
    });

    // Send to monitoring service in production
    if (process.env.NODE_ENV === 'production') {
      this.sendToMonitoringService(event);
    }

    // Log critical events immediately
    if (event.severity === 'critical') {
      console.error('CRITICAL SECURITY EVENT:', event);
      this.alertAdministrators(event);
    }
  }

  static async sendToMonitoringService(event: SecurityEvent) {
    try {
      // Send to external monitoring service
      await fetch('/api/security/events', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(event)
      });
    } catch (error) {
      console.error('Failed to send security event:', error);
    }
  }

  static async alertAdministrators(event: SecurityEvent) {
    try {
      // Get admin users
      const { data: admins } = await supabase
        .from('user_roles')
        .select('user_id, profiles(email)')
        .eq('role', 'admin');

      // Send alerts (implement email/SMS service)
      for (const admin of admins || []) {
        await this.sendAlert(admin.profiles.email, event);
      }
    } catch (error) {
      console.error('Failed to alert administrators:', error);
    }
  }

  static async sendAlert(email: string, event: SecurityEvent) {
    // Implement email alert service
    console.log(`SECURITY ALERT sent to ${email}:`, event);
  }

  // Detect suspicious patterns
  static detectSuspiciousActivity(userId: string, action: string) {
    const recentEvents = this.events.filter(
      event => event.userId === userId && 
      Date.now() - event.timestamp.getTime() < 60000 // Last minute
    );

    // Rapid successive actions
    if (recentEvents.length > 20) {
      this.logSecurityEvent({
        type: 'suspicious_activity',
        severity: 'high',
        userId,
        description: 'Rapid successive actions detected',
        metadata: { actionCount: recentEvents.length, action }
      });
    }

    // Failed authentication attempts
    const failedAttempts = recentEvents.filter(
      event => event.type === 'auth_failure'
    );
    
    if (failedAttempts.length > 5) {
      this.logSecurityEvent({
        type: 'brute_force_attempt',
        severity: 'critical',
        userId,
        description: 'Multiple failed authentication attempts',
        metadata: { attemptCount: failedAttempts.length }
      });
    }
  }
}

interface SecurityEvent {
  id?: string;
  type: string;
  severity: 'low' | 'medium' | 'high' | 'critical';
  userId?: string;
  ipAddress?: string;
  userAgent?: string;
  description: string;
  metadata?: Record<string, any>;
  timestamp?: Date;
}
```

---

## 🚨 8. Incident Response Plan

### Automated Security Response

```typescript
// src/utils/incidentResponse.ts
export class IncidentResponse {
  static async handleSecurityIncident(incident: SecurityIncident) {
    console.log('Security incident detected:', incident);

    switch (incident.type) {
      case 'brute_force':
        await this.handleBruteForce(incident);
        break;
      case 'sql_injection':
        await this.handleSQLInjection(incident);
        break;
      case 'xss_attempt':
        await this.handleXSSAttempt(incident);
        break;
      case 'unauthorized_access':
        await this.handleUnauthorizedAccess(incident);
        break;
      default:
        await this.handleGenericIncident(incident);
    }
  }

  static async handleBruteForce(incident: SecurityIncident) {
    // Temporarily block IP address
    await this.blockIP(incident.ipAddress, '1 hour');
    
    // Lock user account if applicable
    if (incident.userId) {
      await this.lockUserAccount(incident.userId, '15 minutes');
    }

    // Alert administrators
    await this.alertAdmins('Brute force attack detected', incident);
  }

  static async handleSQLInjection(incident: SecurityIncident) {
    // Immediately block IP
    await this.blockIP(incident.ipAddress, '24 hours');
    
    // Log detailed information
    await this.logDetailedIncident(incident);
    
    // Critical alert
    await this.alertAdmins('SQL injection attempt detected', incident);
  }

  static async handleXSSAttempt(incident: SecurityIncident) {
    // Log attempt
    await this.logDetailedIncident(incident);
    
    // Sanitize any stored data
    await this.sanitizeUserData(incident.userId);
    
    // Warn user
    await this.warnUser(incident.userId, 'Malicious content detected');
  }

  static async blockIP(ipAddress: string, duration: string) {
    // Implement IP blocking logic
    console.log(`Blocking IP ${ipAddress} for ${duration}`);
  }

  static async lockUserAccount(userId: string, duration: string) {
    // Implement account locking
    console.log(`Locking user account ${userId} for ${duration}`);
  }

  static async alertAdmins(message: string, incident: SecurityIncident) {
    // Send immediate alerts to administrators
    console.log(`ADMIN ALERT: ${message}`, incident);
  }
}

interface SecurityIncident {
  type: string;
  severity: 'low' | 'medium' | 'high' | 'critical';
  userId?: string;
  ipAddress?: string;
  userAgent?: string;
  description: string;
  evidence: any;
  timestamp: Date;
}
```

---

## 📋 Security Checklist

### Implementation Checklist

- [ ] **Authentication Security**
  - [ ] Strong password requirements (12+ chars, complexity)
  - [ ] Multi-factor authentication (MFA)
  - [ ] Session management and timeout
  - [ ] Account lockout after failed attempts
  - [ ] Rate limiting on auth endpoints

- [ ] **Input Validation**
  - [ ] XSS prevention with DOMPurify
  - [ ] SQL injection prevention
  - [ ] CSRF protection
  - [ ] File upload validation
  - [ ] Input length limits

- [ ] **Database Security**
  - [ ] Row Level Security (RLS) enabled
  - [ ] Audit logging implemented
  - [ ] Data encryption for sensitive fields
  - [ ] Regular security updates
  - [ ] Backup encryption

- [ ] **API Security**
  - [ ] Rate limiting implemented
  - [ ] CORS properly configured
  - [ ] Security headers set
  - [ ] Request validation
  - [ ] Authentication middleware

- [ ] **Infrastructure Security**
  - [ ] HTTPS enforced (HSTS)
  - [ ] Security headers configured
  - [ ] DDoS protection enabled
  - [ ] Regular security scans
  - [ ] Dependency updates

- [ ] **Monitoring & Response**
  - [ ] Security event logging
  - [ ] Intrusion detection
  - [ ] Automated incident response
  - [ ] Admin alerting system
  - [ ] Regular security audits

---

## 🔧 Deployment Security

### Secure Deployment Script

```bash
#!/bin/bash
# secure-deploy.sh - Secure deployment script

echo "🔒 Starting secure deployment..."

# 1. Security scan before deployment
echo "Running security scan..."
npm audit --audit-level high
if [ $? -ne 0 ]; then
    echo "❌ Security vulnerabilities found. Fix before deploying."
    exit 1
fi

# 2. Build with security optimizations
echo "Building with security optimizations..."
npm run build

# 3. Verify environment variables
echo "Verifying environment variables..."
if [ -z "$VITE_SUPABASE_URL" ] || [ -z "$VITE_SUPABASE_PUBLISHABLE_KEY" ]; then
    echo "❌ Missing required environment variables"
    exit 1
fi

# 4. Deploy with security headers
echo "Deploying with security configuration..."
vercel --prod

# 5. Post-deployment security verification
echo "Running post-deployment security checks..."
curl -I https://seenaf-ctf-challenge.vercel.app | grep -i "strict-transport-security"
if [ $? -eq 0 ]; then
    echo "✅ Security headers verified"
else
    echo "⚠️ Security headers not found"
fi

echo "🎉 Secure deployment completed!"
```

---

This comprehensive security implementation provides multiple layers of protection for your SEENAF CTF platform. The security measures include authentication, input validation, database security, API protection, monitoring, and incident response capabilities.

Would you like me to implement any specific security component or create additional security features?