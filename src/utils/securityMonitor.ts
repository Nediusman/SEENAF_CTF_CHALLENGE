import { supabase } from '@/integrations/supabase/client';

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

export class SecurityMonitor {
  private static events: SecurityEvent[] = [];
  private static maxEvents = 1000; // Keep last 1000 events in memory

  static logSecurityEvent(event: Omit<SecurityEvent, 'id' | 'timestamp'>) {
    const fullEvent: SecurityEvent = {
      ...event,
      timestamp: new Date(),
      id: crypto.randomUUID()
    };

    // Add to memory store
    this.events.push(fullEvent);
    
    // Keep only recent events
    if (this.events.length > this.maxEvents) {
      this.events = this.events.slice(-this.maxEvents);
    }

    // Send to monitoring service in production
    if (import.meta.env.PROD) {
      this.sendToMonitoringService(fullEvent);
    }

    // Log critical events immediately
    if (event.severity === 'critical') {
      console.error('CRITICAL SECURITY EVENT:', fullEvent);
      this.alertAdministrators(fullEvent);
    }

    // Store in database for persistence
    this.storeInDatabase(fullEvent);
  }

  static async sendToMonitoringService(event: SecurityEvent) {
    try {
      // In a real implementation, send to external monitoring service
      console.log('Security event logged:', event);
    } catch (error) {
      console.error('Failed to send security event:', error);
    }
  }

  static async storeInDatabase(event: SecurityEvent) {
    try {
      await supabase
        .from('audit_logs')
        .insert({
          action: event.type,
          table_name: 'security_events',
          new_values: {
            severity: event.severity,
            description: event.description,
            metadata: event.metadata
          },
          user_id: event.userId,
          ip_address: event.ipAddress,
          user_agent: event.userAgent
        });
    } catch (error) {
      console.error('Failed to store security event in database:', error);
    }
  }

  static async alertAdministrators(event: SecurityEvent) {
    try {
      // Get admin users
      const { data: admins } = await supabase
        .from('user_roles')
        .select('user_id, profiles(email)')
        .eq('role', 'admin');

      // In a real implementation, send alerts via email/SMS
      for (const admin of admins || []) {
        console.log(`SECURITY ALERT for admin ${admin.user_id}:`, event);
      }
    } catch (error) {
      console.error('Failed to alert administrators:', error);
    }
  }

  // Detect suspicious patterns
  static detectSuspiciousActivity(userId: string, action: string) {
    const now = Date.now();
    const oneMinuteAgo = now - 60000;
    
    const recentEvents = this.events.filter(
      event => event.userId === userId && 
      event.timestamp && event.timestamp.getTime() > oneMinuteAgo
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

    // Multiple different IPs for same user
    const uniqueIPs = new Set(recentEvents.map(e => e.ipAddress).filter(Boolean));
    if (uniqueIPs.size > 3) {
      this.logSecurityEvent({
        type: 'multiple_ip_access',
        severity: 'medium',
        userId,
        description: 'User accessed from multiple IP addresses',
        metadata: { ipCount: uniqueIPs.size, ips: Array.from(uniqueIPs) }
      });
    }
  }

  // Get security events for analysis
  static getSecurityEvents(filters?: {
    userId?: string;
    type?: string;
    severity?: string;
    since?: Date;
  }): SecurityEvent[] {
    let filteredEvents = [...this.events];

    if (filters) {
      if (filters.userId) {
        filteredEvents = filteredEvents.filter(e => e.userId === filters.userId);
      }
      if (filters.type) {
        filteredEvents = filteredEvents.filter(e => e.type === filters.type);
      }
      if (filters.severity) {
        filteredEvents = filteredEvents.filter(e => e.severity === filters.severity);
      }
      if (filters.since) {
        filteredEvents = filteredEvents.filter(e => 
          e.timestamp && e.timestamp >= filters.since!
        );
      }
    }

    return filteredEvents.sort((a, b) => 
      (b.timestamp?.getTime() || 0) - (a.timestamp?.getTime() || 0)
    );
  }

  // Security metrics
  static getSecurityMetrics() {
    const now = new Date();
    const last24Hours = new Date(now.getTime() - 24 * 60 * 60 * 1000);
    const recentEvents = this.events.filter(e => 
      e.timestamp && e.timestamp >= last24Hours
    );

    const metrics = {
      totalEvents: recentEvents.length,
      criticalEvents: recentEvents.filter(e => e.severity === 'critical').length,
      highSeverityEvents: recentEvents.filter(e => e.severity === 'high').length,
      authFailures: recentEvents.filter(e => e.type === 'auth_failure').length,
      suspiciousActivity: recentEvents.filter(e => e.type === 'suspicious_activity').length,
      uniqueUsers: new Set(recentEvents.map(e => e.userId).filter(Boolean)).size,
      uniqueIPs: new Set(recentEvents.map(e => e.ipAddress).filter(Boolean)).size
    };

    return metrics;
  }

  // Clear old events (for memory management)
  static clearOldEvents(olderThan: Date = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000)) {
    this.events = this.events.filter(e => 
      !e.timestamp || e.timestamp >= olderThan
    );
  }
}