# 🔒 Security Quick Reference Guide

**⚠️ CRITICAL: Hardcoded credentials have been removed from this platform. See CRITICAL_SECURITY_FIX.md for details.**

Quick reference for using the security features in SEENAF CTF Platform.

---

## 🚨 SECURITY ALERT

**IMMEDIATE ACTION REQUIRED:**
1. **Change admin password immediately** - old credentials were exposed in JavaScript bundle
2. **Redeploy application** to remove exposed credentials
3. **Set up proper database admin role** (see fix guide)
4. **Monitor for unauthorized access**

See `CRITICAL_SECURITY_FIX.md` for complete details.

---

## 🚀 Quick Start

### 1. Deploy Security
```bash
# Apply database security
# Run enhanced-database-security.sql in Supabase SQL Editor

# Deploy with security checks
./secure-deploy.sh
```

### 2. Use Secure Components
```tsx
// Secure Login
import { SecureLogin } from '@/components/auth/SecureLogin';
<SecureLogin onSuccess={() => {}} onError={(e) => {}} />

// Secure Submission
import { SecureSubmission } from '@/components/security/SecureSubmission';
<SecureSubmission challengeId="..." onSuccess={() => {}} />
```

---

## 🛡️ Security Utilities

### Input Security
```typescript
import { InputSecurity } from '@/utils/inputSecurity';

// Sanitize HTML (prevent XSS)
const safe = InputSecurity.sanitizeHTML(userInput);

// Sanitize general input (prevent SQL injection)
const clean = InputSecurity.sanitizeInput(userInput);

// Validate email
if (InputSecurity.validateEmail(email)) {
  const sanitized = InputSecurity.sanitizeEmail(email);
}

// Validate flag format
if (InputSecurity.validateFlag(flag)) {
  // Flag is valid
}

// Validate username
const result = InputSecurity.validateUsername(username);
if (!result.isValid) {
  console.log(result.errors);
}

// Validate file upload
const fileCheck = InputSecurity.validateFileUpload(file);
if (!fileCheck.isValid) {
  console.log(fileCheck.errors);
}
```

### Authentication Security
```typescript
import { AuthSecurity } from '@/utils/authSecurity';

// Validate password strength
const strength = AuthSecurity.validatePasswordStrength(password);
if (!strength.isValid) {
  console.log('Errors:', strength.errors);
  console.log('Score:', strength.score); // 0-5
}

// Enable MFA
await AuthSecurity.enableMFA(userId, 'totp');

// Validate session
const isValid = await AuthSecurity.validateSession();

// Check user permissions
const hasAccess = await AuthSecurity.validateUserPermissions(userId, 'admin');

// Create rate limiter
const limiter = AuthSecurity.createAuthRateLimit();
const check = limiter.checkLimit('user-id', 5, 15 * 60 * 1000);
if (!check.allowed) {
  console.log('Rate limited. Retry after:', check.retryAfter);
}
```

### Security Monitoring
```typescript
import { SecurityMonitor } from '@/utils/securityMonitor';

// Log security event
SecurityMonitor.logSecurityEvent({
  type: 'auth_failure',
  severity: 'medium', // 'low' | 'medium' | 'high' | 'critical'
  userId: user.id,
  description: 'Failed login attempt',
  metadata: { email: email, attempt: 3 }
});

// Detect suspicious activity
SecurityMonitor.detectSuspiciousActivity(userId, 'login');

// Get security metrics
const metrics = SecurityMonitor.getSecurityMetrics();
console.log('Critical events:', metrics.criticalEvents);
console.log('Auth failures:', metrics.authFailures);

// Get filtered events
const events = SecurityMonitor.getSecurityEvents({
  userId: userId,
  type: 'auth_failure',
  severity: 'critical',
  since: new Date(Date.now() - 24 * 60 * 60 * 1000)
});
```

---

## 🗄️ Database Security Functions

### Check User Role
```sql
-- Check if user is admin
SELECT is_admin('user-uuid');
SELECT is_admin(); -- Uses current user

-- Check if user is moderator or admin
SELECT is_moderator_or_admin('user-uuid');

-- Get user role
SELECT get_user_role('user-uuid');
SELECT get_user_role(); -- Uses current user
```

### Rate Limiting
```sql
-- Check rate limit
SELECT check_rate_limit(
  'user-uuid',
  'flag_submission',
  '1 minute'::interval,
  10
);
```

### Data Encryption
```sql
-- Encrypt sensitive data
SELECT encrypt_sensitive_data('sensitive-data', 'encryption-key');

-- Decrypt sensitive data
SELECT decrypt_sensitive_data('encrypted-data', 'encryption-key');
```

### Query Audit Logs
```sql
-- View recent audit logs (admin only)
SELECT * FROM audit_logs 
ORDER BY created_at DESC 
LIMIT 100;

-- View logs for specific user
SELECT * FROM audit_logs 
WHERE user_id = 'user-uuid'
ORDER BY created_at DESC;

-- View logs for specific action
SELECT * FROM audit_logs 
WHERE action = 'UPDATE'
AND table_name = 'challenges'
ORDER BY created_at DESC;
```

---

## 🔍 Security Testing

### Test Authentication Security
```bash
# Test account lockout
# 1. Try logging in with wrong password 3 times
# 2. Verify account is locked for 15 minutes
# 3. Check security event logs

# Test rate limiting
# 1. Try logging in rapidly
# 2. Verify rate limit message appears
# 3. Wait for cooldown period
```

### Test Submission Security
```bash
# Test flag validation
# 1. Submit invalid flag format
# 2. Verify validation error

# Test rate limiting
# 1. Submit flags rapidly
# 2. Verify 5-second cooldown

# Test attempt limits
# 1. Submit 10 incorrect flags
# 2. Verify max attempts reached
```

### Test Security Headers
```bash
# Check HSTS
curl -I https://seenaf-ctf-challenge.vercel.app | grep -i "strict-transport-security"

# Check CSP
curl -I https://seenaf-ctf-challenge.vercel.app | grep -i "content-security-policy"

# Check all headers
curl -I https://seenaf-ctf-challenge.vercel.app
```

---

## 🚨 Security Event Types

### Event Types
- `auth_success` - Successful authentication
- `auth_failure` - Failed authentication attempt
- `signup_success` - Successful account creation
- `signup_failure` - Failed signup attempt
- `flag_submission` - Flag submission attempt
- `challenge_solved` - Challenge solved successfully
- `account_lockout` - Account locked due to failed attempts
- `rate_limit_exceeded` - Rate limit exceeded
- `suspicious_activity` - Suspicious activity detected
- `brute_force_attempt` - Brute force attack detected
- `potential_brute_force` - Multiple incorrect submissions
- `multiple_ip_access` - User accessed from multiple IPs
- `submission_error` - Flag submission error
- `max_attempts_exceeded` - Maximum attempts exceeded

### Severity Levels
- `low` - Normal operations, informational
- `medium` - Potential security concern
- `high` - Security issue requiring attention
- `critical` - Critical security incident, immediate action required

---

## 📊 Security Metrics

### Available Metrics
```typescript
const metrics = SecurityMonitor.getSecurityMetrics();

// Returns:
{
  totalEvents: number,           // Total events in last 24h
  criticalEvents: number,        // Critical severity events
  highSeverityEvents: number,    // High severity events
  authFailures: number,          // Failed auth attempts
  suspiciousActivity: number,    // Suspicious activities
  uniqueUsers: number,           // Unique users with events
  uniqueIPs: number             // Unique IP addresses
}
```

---

## 🔧 Common Patterns

### Secure Form Submission
```typescript
const handleSubmit = async (e: React.FormEvent) => {
  e.preventDefault();
  
  // 1. Validate inputs
  if (!InputSecurity.validateEmail(email)) {
    setError('Invalid email');
    return;
  }
  
  // 2. Sanitize inputs
  const sanitizedEmail = InputSecurity.sanitizeEmail(email);
  const sanitizedInput = InputSecurity.sanitizeInput(input);
  
  // 3. Submit with error handling
  try {
    const result = await submitData(sanitizedEmail, sanitizedInput);
    
    // 4. Log success
    SecurityMonitor.logSecurityEvent({
      type: 'data_submission',
      severity: 'low',
      description: 'Data submitted successfully'
    });
  } catch (error) {
    // 5. Log failure
    SecurityMonitor.logSecurityEvent({
      type: 'submission_error',
      severity: 'medium',
      description: 'Data submission failed',
      metadata: { error: error.message }
    });
  }
};
```

### Secure API Call
```typescript
const secureApiCall = async (endpoint: string, data: any) => {
  // 1. Validate session
  const isValid = await AuthSecurity.validateSession();
  if (!isValid) {
    throw new Error('Invalid session');
  }
  
  // 2. Sanitize data
  const sanitizedData = Object.keys(data).reduce((acc, key) => {
    acc[key] = InputSecurity.sanitizeInput(data[key]);
    return acc;
  }, {} as any);
  
  // 3. Make request
  const response = await fetch(endpoint, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(sanitizedData)
  });
  
  // 4. Log result
  SecurityMonitor.logSecurityEvent({
    type: 'api_call',
    severity: 'low',
    description: `API call to ${endpoint}`,
    metadata: { status: response.status }
  });
  
  return response.json();
};
```

---

## 🎯 Best Practices

### Always Do
✅ Sanitize all user inputs
✅ Validate data before processing
✅ Log security events
✅ Use secure components
✅ Check permissions before actions
✅ Handle errors gracefully
✅ Monitor security metrics

### Never Do
❌ Trust user input without validation
❌ Store passwords in plain text
❌ Expose sensitive data in logs
❌ Skip input sanitization
❌ Ignore security events
❌ Use weak passwords
❌ Disable security features

---

## 📞 Quick Help

### Issue: Account Locked
**Fix:** Wait 15 minutes or contact admin

### Issue: Rate Limited
**Fix:** Wait for cooldown period (5-15 seconds)

### Issue: Invalid Input
**Fix:** Check validation rules and format

### Issue: Security Event Not Logged
**Fix:** Verify SecurityMonitor.logSecurityEvent() is called

### Issue: Headers Not Applied
**Fix:** Redeploy with `./secure-deploy.sh`

---

**🔒 Keep your platform secure! 🔒**

*Quick Reference v1.0*