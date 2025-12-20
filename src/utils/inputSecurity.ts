export class InputSecurity {
  // XSS Prevention - Basic sanitization without external dependencies
  static sanitizeHTML(input: string): string {
    if (typeof input !== 'string') return '';
    
    return input
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#x27;')
      .replace(/\//g, '&#x2F;');
  }

  // SQL Injection Prevention
  static sanitizeInput(input: string): string {
    if (typeof input !== 'string') return '';
    
    return input
      .replace(/[<>]/g, '') // Remove potential HTML
      .replace(/['"]/g, '') // Remove quotes
      .replace(/[;-]/g, '') // Remove SQL comment patterns
      .replace(/\b(SELECT|INSERT|UPDATE|DELETE|DROP|CREATE|ALTER|EXEC|UNION)\b/gi, '') // Remove SQL keywords
      .trim()
      .substring(0, 1000); // Limit length
  }

  // Email validation and sanitization
  static sanitizeEmail(email: string): string {
    if (typeof email !== 'string') return '';
    return email.toLowerCase().trim();
  }

  static validateEmail(email: string): boolean {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email) && email.length <= 254;
  }

  // Flag validation for CTF challenges
  static validateFlag(flag: string): boolean {
    if (typeof flag !== 'string') return false;
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
    
    if (typeof content !== 'string') {
      return {
        isValid: false,
        sanitized: '',
        errors: ['Content must be a string']
      };
    }
    
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

  // Username validation
  static validateUsername(username: string): {
    isValid: boolean;
    errors: string[];
  } {
    const errors: string[] = [];
    
    if (typeof username !== 'string') {
      return { isValid: false, errors: ['Username must be a string'] };
    }

    // Length check
    if (username.length < 3 || username.length > 20) {
      errors.push('Username must be between 3 and 20 characters');
    }

    // Character check
    if (!/^[a-zA-Z0-9_-]+$/.test(username)) {
      errors.push('Username can only contain letters, numbers, underscores, and hyphens');
    }

    // Reserved names
    const reservedNames = ['admin', 'root', 'system', 'null', 'undefined'];
    if (reservedNames.includes(username.toLowerCase())) {
      errors.push('Username is reserved');
    }

    return {
      isValid: errors.length === 0,
      errors
    };
  }

  // URL validation
  static validateURL(url: string): boolean {
    try {
      const urlObj = new URL(url);
      return ['http:', 'https:'].includes(urlObj.protocol);
    } catch {
      return false;
    }
  }

  // Sanitize for display (prevent XSS in user-generated content)
  static sanitizeForDisplay(input: string): string {
    if (typeof input !== 'string') return '';
    
    return input
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#x27;')
      .replace(/\//g, '&#x2F;');
  }
}