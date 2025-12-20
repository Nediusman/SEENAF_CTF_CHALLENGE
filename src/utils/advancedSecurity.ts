// Advanced Security Utilities
import DOMPurify from 'isomorphic-dompurify';

export class AdvancedSecurity {
  // Enhanced XSS Protection
  static sanitizeHTML(input: string): string {
    if (!input) return '';
    
    // Use DOMPurify for comprehensive XSS protection
    return DOMPurify.sanitize(input, {
      ALLOWED_TAGS: ['b', 'i', 'em', 'strong', 'code', 'pre'],
      ALLOWED_ATTR: [],
      KEEP_CONTENT: true,
      RETURN_DOM: false,
      RETURN_DOM_FRAGMENT: false,
      RETURN_DOM_IMPORT: false,
      SANITIZE_DOM: true,
      WHOLE_DOCUMENT: false,
      FORCE_BODY: false,
      SANITIZE_NAMED_PROPS: true,
      KEEP_CONTENT: false
    });
  }

  // Advanced SQL Injection Prevention
  static sanitizeForDatabase(input: string): string {
    if (!input) return '';
    
    return input
      .replace(/['"`;\\]/g, '') // Remove dangerous SQL characters
      .replace(/\b(SELECT|INSERT|UPDATE|DELETE|DROP|CREATE|ALTER|EXEC|UNION|SCRIPT|JAVASCRIPT|VBSCRIPT|ONLOAD|ONERROR|ONCLICK)\b/gi, '') // Remove SQL/JS keywords
      .replace(/--.*$/gm, '') // Remove SQL comments
      .replace(/\/\*[\s\S]*?\*\//g, '') // Remove block comments
      .replace(/\x00/g, '') // Remove null bytes
      .trim()
      .substring(0, 1000); // Limit length
  }

  // Command Injection Prevention
  static sanitizeCommand(input: string): string {
    if (!input) return '';
    
    return input
      .replace(/[;&|`$(){}[\]\\]/g, '') // Remove shell metacharacters
      .replace(/\.\./g, '') // Remove path traversal
      .replace(/[<>]/g, '') // Remove redirection
      .trim()
      .substring(0, 100);
  }

  // Path Traversal Prevention
  static sanitizePath(input: string): string {
    if (!input) return '';
    
    return input
      .replace(/\.\./g, '') // Remove ..
      .replace(/[\\\/]/g, '') // Remove slashes
      .replace(/[<>:"|?*]/g, '') // Remove invalid filename chars
      .trim()
      .substring(0, 255);
  }

  // Email Validation & Sanitization
  static validateAndSanitizeEmail(email: string): { isValid: boolean; sanitized: string; errors: string[] } {
    const errors: string[] = [];
    
    if (!email) {
      errors.push('Email is required');
      return { isValid: false, sanitized: '', errors };
    }

    // Basic sanitization
    const sanitized = email.toLowerCase().trim().substring(0, 254);
    
    // Enhanced email validation
    const emailRegex = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/;
    
    if (!emailRegex.test(sanitized)) {
      errors.push('Invalid email format');
    }

    // Check for suspicious patterns
    if (sanitized.includes('..')) {
      errors.push('Email contains invalid consecutive dots');
    }

    if (sanitized.startsWith('.') || sanitized.endsWith('.')) {
      errors.push('Email cannot start or end with a dot');
    }

    // Check for common attack patterns
    const suspiciousPatterns = [
      /script/i,
      /javascript/i,
      /vbscript/i,
      /onload/i,
      /onerror/i,
      /<.*>/,
      /['"`;]/
    ];

    for (const pattern of suspiciousPatterns) {
      if (pattern.test(sanitized)) {
        errors.push('Email contains suspicious content');
        break;
      }
    }

    return {
      isValid: errors.length === 0,
      sanitized,
      errors
    };
  }

  // Flag Validation (CTF specific)
  static validateFlag(flag: string): { isValid: boolean; sanitized: string; errors: string[] } {
    const errors: string[] = [];
    
    if (!flag) {
      errors.push('Flag is required');
      return { isValid: false, sanitized: '', errors };
    }

    // Sanitize flag
    const sanitized = flag.trim().substring(0, 200);
    
    // CTF flag format validation (adjust based on your format)
    const flagRegex = /^SEENAF\{[A-Za-z0-9_\-!@#$%^&*()+={}[\]|\\:";'<>?,./~`]+\}$/;
    
    if (!flagRegex.test(sanitized)) {
      errors.push('Invalid flag format. Expected: SEENAF{...}');
    }

    // Check for suspicious content
    const suspiciousPatterns = [
      /<script/i,
      /javascript:/i,
      /data:/i,
      /vbscript:/i,
      /on\w+=/i
    ];

    for (const pattern of suspiciousPatterns) {
      if (pattern.test(sanitized)) {
        errors.push('Flag contains suspicious content');
        break;
      }
    }

    return {
      isValid: errors.length === 0,
      sanitized,
      errors
    };
  }

  // Rate Limiting Helper
  static createRateLimiter(maxRequests: number, windowMs: number) {
    const requests = new Map<string, number[]>();
    
    return {
      checkLimit: (identifier: string): { allowed: boolean; retryAfter: number } => {
        const now = Date.now();
        const windowStart = now - windowMs;
        
        // Get existing requests for this identifier
        const userRequests = requests.get(identifier) || [];
        
        // Remove old requests outside the window
        const validRequests = userRequests.filter(time => time > windowStart);
        
        if (validRequests.length >= maxRequests) {
          const oldestRequest = Math.min(...validRequests);
          const retryAfter = Math.ceil((oldestRequest + windowMs - now) / 1000);
          return { allowed: false, retryAfter };
        }
        
        // Add current request
        validRequests.push(now);
        requests.set(identifier, validRequests);
        
        return { allowed: true, retryAfter: 0 };
      },
      
      reset: (identifier: string) => {
        requests.delete(identifier);
      }
    };
  }

  // Content Security Policy Violation Reporter
  static reportCSPViolation(violation: any) {
    console.warn('CSP Violation:', violation);
    
    // In production, send to your security monitoring service
    if (process.env.NODE_ENV === 'production') {
      // Example: Send to your monitoring service
      fetch('/api/security/csp-violation', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          violation,
          timestamp: new Date().toISOString(),
          userAgent: navigator.userAgent,
          url: window.location.href
        })
      }).catch(console.error);
    }
  }

  // Detect and prevent clickjacking
  static preventClickjacking() {
    if (window.top !== window.self) {
      // Page is in a frame - potential clickjacking
      console.warn('Potential clickjacking detected');
      window.top.location = window.self.location;
    }
  }

  // Secure random string generation
  static generateSecureToken(length: number = 32): string {
    const array = new Uint8Array(length);
    crypto.getRandomValues(array);
    return Array.from(array, byte => byte.toString(16).padStart(2, '0')).join('');
  }

  // Check for suspicious user agents
  static validateUserAgent(userAgent: string): { isSuspicious: boolean; reason?: string } {
    if (!userAgent) {
      return { isSuspicious: true, reason: 'Missing user agent' };
    }

    const suspiciousPatterns = [
      /bot/i,
      /crawler/i,
      /spider/i,
      /scraper/i,
      /curl/i,
      /wget/i,
      /python/i,
      /java/i,
      /go-http/i,
      /postman/i
    ];

    for (const pattern of suspiciousPatterns) {
      if (pattern.test(userAgent)) {
        return { isSuspicious: true, reason: `Suspicious user agent pattern: ${pattern}` };
      }
    }

    return { isSuspicious: false };
  }

  // Honeypot field validation (trap for bots)
  static validateHoneypot(honeypotValue: string): boolean {
    // Honeypot should always be empty for legitimate users
    return !honeypotValue || honeypotValue.trim() === '';
  }
}

// Initialize security measures
if (typeof window !== 'undefined') {
  // Prevent clickjacking
  AdvancedSecurity.preventClickjacking();
  
  // Listen for CSP violations
  document.addEventListener('securitypolicyviolation', (e) => {
    AdvancedSecurity.reportCSPViolation({
      blockedURI: e.blockedURI,
      disposition: e.disposition,
      documentURI: e.documentURI,
      effectiveDirective: e.effectiveDirective,
      originalPolicy: e.originalPolicy,
      referrer: e.referrer,
      statusCode: e.statusCode,
      violatedDirective: e.violatedDirective
    });
  });
}