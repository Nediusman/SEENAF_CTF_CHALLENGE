import React, { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { 
  Shield, AlertTriangle, Activity, Users, Globe, 
  TrendingUp, Eye, Lock, Zap, RefreshCw, Download,
  AlertCircle, CheckCircle, XCircle, Clock
} from 'lucide-react';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Progress } from '@/components/ui/progress';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { SecurityMonitor, SecurityMetrics } from '@/utils/securityMonitor';
import { useToast } from '@/hooks/use-toast';

interface SecurityDashboardProps {
  className?: string;
}

export function SecurityDashboard({ className }: SecurityDashboardProps) {
  const [metrics, setMetrics] = useState<SecurityMetrics | null>(null);
  const [events, setEvents] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [autoRefresh, setAutoRefresh] = useState(true);
  const { toast } = useToast();

  useEffect(() => {
    loadSecurityData();
    
    if (autoRefresh) {
      const interval = setInterval(loadSecurityData, 30000); // Refresh every 30 seconds
      return () => clearInterval(interval);
    }
  }, [autoRefresh]);

  const loadSecurityData = async () => {
    try {
      const [metricsData, eventsData] = await Promise.all([
        SecurityMonitor.getSecurityMetrics(),
        SecurityMonitor.getSecurityEvents({ limit: 50 })
      ]);
      
      setMetrics(metricsData);
      setEvents(eventsData);
    } catch (error) {
      console.error('Failed to load security data:', error);
      toast({
        title: "Failed to load security data",
        description: "Please try refreshing the page",
        variant: "destructive"
      });
    } finally {
      setLoading(false);
    }
  };

  const getSeverityColor = (severity: string) => {
    switch (severity) {
      case 'critical': return 'text-red-500 bg-red-500/20 border-red-500/30';
      case 'high': return 'text-orange-500 bg-orange-500/20 border-orange-500/30';
      case 'medium': return 'text-yellow-500 bg-yellow-500/20 border-yellow-500/30';
      case 'low': return 'text-green-500 bg-green-500/20 border-green-500/30';
      default: return 'text-gray-500 bg-gray-500/20 border-gray-500/30';
    }
  };

  const getSeverityIcon = (severity: string) => {
    switch (severity) {
      case 'critical': return <XCircle className="h-4 w-4" />;
      case 'high': return <AlertTriangle className="h-4 w-4" />;
      case 'medium': return <AlertCircle className="h-4 w-4" />;
      case 'low': return <CheckCircle className="h-4 w-4" />;
      default: return <Clock className="h-4 w-4" />;
    }
  };

  const getThreatLevel = (score: number) => {
    if (score >= 80) return { level: 'Critical', color: 'text-red-500', bg: 'bg-red-500' };
    if (score >= 60) return { level: 'High', color: 'text-orange-500', bg: 'bg-orange-500' };
    if (score >= 40) return { level: 'Medium', color: 'text-yellow-500', bg: 'bg-yellow-500' };
    if (score >= 20) return { level: 'Low', color: 'text-blue-500', bg: 'bg-blue-500' };
    return { level: 'Minimal', color: 'text-green-500', bg: 'bg-green-500' };
  };

  const exportSecurityReport = () => {
    const report = {
      timestamp: new Date().toISOString(),
      metrics,
      recentEvents: events.slice(0, 20),
      summary: {
        threatLevel: metrics ? getThreatLevel(metrics.threatScore).level : 'Unknown',
        totalEvents: metrics?.totalEvents || 0,
        criticalEvents: metrics?.criticalEvents || 0
      }
    };

    const blob = new Blob([JSON.stringify(report, null, 2)], { type: 'application/json' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `security-report-${new Date().toISOString().split('T')[0]}.json`;
    a.click();
    URL.revokeObjectURL(url);

    toast({
      title: "Security report exported",
      description: "Report has been downloaded successfully"
    });
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center p-8">
        <div className="text-center">
          <RefreshCw className="h-8 w-8 animate-spin mx-auto mb-2 text-primary" />
          <p className="text-muted-foreground">Loading security dashboard...</p>
        </div>
      </div>
    );
  }

  const threatInfo = metrics ? getThreatLevel(metrics.threatScore) : null;

  return (
    <div className={`space-y-6 ${className}`}>
      {/* Header */}
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-3">
          <Shield className="h-8 w-8 text-primary" />
          <div>
            <h2 className="text-2xl font-bold text-primary">Security Dashboard</h2>
            <p className="text-muted-foreground">Real-time security monitoring and threat detection</p>
          </div>
        </div>
        
        <div className="flex items-center gap-2">
          <Button
            onClick={() => setAutoRefresh(!autoRefresh)}
            variant={autoRefresh ? "default" : "outline"}
            size="sm"
          >
            <Activity className="h-4 w-4 mr-2" />
            {autoRefresh ? 'Auto-refresh ON' : 'Auto-refresh OFF'}
          </Button>
          
          <Button onClick={loadSecurityData} variant="outline" size="sm">
            <RefreshCw className="h-4 w-4 mr-2" />
            Refresh
          </Button>
          
          <Button onClick={exportSecurityReport} variant="outline" size="sm">
            <Download className="h-4 w-4 mr-2" />
            Export Report
          </Button>
        </div>
      </div>

      {/* Threat Level Alert */}
      {threatInfo && metrics && metrics.threatScore > 40 && (
        <motion.div
          initial={{ opacity: 0, y: -20 }}
          animate={{ opacity: 1, y: 0 }}
          className={`p-4 rounded-lg border ${
            metrics.threatScore >= 80 ? 'bg-red-500/10 border-red-500/30' :
            metrics.threatScore >= 60 ? 'bg-orange-500/10 border-orange-500/30' :
            'bg-yellow-500/10 border-yellow-500/30'
          }`}
        >
          <div className="flex items-center gap-3">
            <AlertTriangle className={`h-6 w-6 ${threatInfo.color}`} />
            <div>
              <h3 className={`font-bold ${threatInfo.color}`}>
                {threatInfo.level} Threat Level Detected
              </h3>
              <p className="text-sm text-muted-foreground">
                Threat score: {metrics.threatScore}/100 - Immediate attention recommended
              </p>
            </div>
          </div>
        </motion.div>
      )}

      {/* Metrics Overview */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <Card>
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-muted-foreground">Total Events (24h)</p>
                <p className="text-2xl font-bold">{metrics?.totalEvents || 0}</p>
              </div>
              <Activity className="h-8 w-8 text-blue-500" />
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-muted-foreground">Critical Events</p>
                <p className="text-2xl font-bold text-red-500">{metrics?.criticalEvents || 0}</p>
              </div>
              <AlertTriangle className="h-8 w-8 text-red-500" />
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-muted-foreground">Unique Users</p>
                <p className="text-2xl font-bold">{metrics?.uniqueUsers || 0}</p>
              </div>
              <Users className="h-8 w-8 text-green-500" />
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-muted-foreground">Unique IPs</p>
                <p className="text-2xl font-bold">{metrics?.uniqueIPs || 0}</p>
              </div>
              <Globe className="h-8 w-8 text-purple-500" />
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Threat Score */}
      {metrics && (
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Zap className="h-5 w-5" />
              Threat Assessment
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              <div className="flex items-center justify-between">
                <span className="text-sm font-medium">Current Threat Level</span>
                <Badge className={`${getSeverityColor(threatInfo?.level.toLowerCase() || 'low')}`}>
                  {threatInfo?.level || 'Unknown'}
                </Badge>
              </div>
              
              <div className="space-y-2">
                <div className="flex justify-between text-sm">
                  <span>Threat Score</span>
                  <span>{metrics.threatScore}/100</span>
                </div>
                <Progress 
                  value={metrics.threatScore} 
                  className="h-2"
                />
              </div>

              <div className="grid grid-cols-2 gap-4 text-sm">
                <div>
                  <span className="text-muted-foreground">Auth Failures:</span>
                  <span className="ml-2 font-medium">{metrics.authFailures}</span>
                </div>
                <div>
                  <span className="text-muted-foreground">Suspicious Activity:</span>
                  <span className="ml-2 font-medium">{metrics.suspiciousActivity}</span>
                </div>
                <div>
                  <span className="text-muted-foreground">High Severity:</span>
                  <span className="ml-2 font-medium">{metrics.highSeverityEvents}</span>
                </div>
                <div>
                  <span className="text-muted-foreground">Anomalies:</span>
                  <span className="ml-2 font-medium">{metrics.anomalies || 0}</span>
                </div>
              </div>
            </div>
          </CardContent>
        </Card>
      )}

      {/* Security Events */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <Eye className="h-5 w-5" />
            Recent Security Events
          </CardTitle>
        </CardHeader>
        <CardContent>
          <Tabs defaultValue="all" className="w-full">
            <TabsList className="grid w-full grid-cols-5">
              <TabsTrigger value="all">All</TabsTrigger>
              <TabsTrigger value="critical">Critical</TabsTrigger>
              <TabsTrigger value="high">High</TabsTrigger>
              <TabsTrigger value="medium">Medium</TabsTrigger>
              <TabsTrigger value="low">Low</TabsTrigger>
            </TabsList>
            
            {['all', 'critical', 'high', 'medium', 'low'].map(severity => (
              <TabsContent key={severity} value={severity} className="space-y-2">
                <div className="max-h-96 overflow-y-auto space-y-2">
                  {events
                    .filter(event => severity === 'all' || event.severity === severity)
                    .slice(0, 20)
                    .map((event, index) => (
                      <motion.div
                        key={index}
                        initial={{ opacity: 0, x: -20 }}
                        animate={{ opacity: 1, x: 0 }}
                        transition={{ delay: index * 0.05 }}
                        className={`p-3 rounded-lg border ${getSeverityColor(event.severity)}`}
                      >
                        <div className="flex items-start justify-between">
                          <div className="flex items-start gap-3">
                            {getSeverityIcon(event.severity)}
                            <div className="flex-1">
                              <div className="flex items-center gap-2 mb-1">
                                <span className="font-medium text-sm">{event.type}</span>
                                <Badge variant="outline" className="text-xs">
                                  {event.severity}
                                </Badge>
                              </div>
                              <p className="text-sm text-muted-foreground mb-2">
                                {event.description}
                              </p>
                              <div className="flex items-center gap-4 text-xs text-muted-foreground">
                                {event.timestamp && (
                                  <span>
                                    {new Date(event.timestamp).toLocaleString()}
                                  </span>
                                )}
                                {event.userId && (
                                  <span>User: {event.userId.substring(0, 8)}...</span>
                                )}
                                {event.ipAddress && (
                                  <span>IP: {event.ipAddress}</span>
                                )}
                              </div>
                            </div>
                          </div>
                        </div>
                      </motion.div>
                    ))}
                  
                  {events.filter(event => severity === 'all' || event.severity === severity).length === 0 && (
                    <div className="text-center py-8 text-muted-foreground">
                      <Shield className="h-12 w-12 mx-auto mb-2 opacity-50" />
                      <p>No {severity === 'all' ? '' : severity} security events found</p>
                    </div>
                  )}
                </div>
              </TabsContent>
            ))}
          </Tabs>
        </CardContent>
      </Card>
    </div>
  );
}