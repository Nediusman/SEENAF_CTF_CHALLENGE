import { useState } from 'react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { ExternalLink, Download, Tool, Globe } from 'lucide-react';

interface LaunchTesterProps {
  challenge: {
    title: string;
    category: string;
    instance_url?: string;
  };
}

export function LaunchTester({ challenge }: LaunchTesterProps) {
  const [testResult, setTestResult] = useState<string>('');

  const testLaunch = async () => {
    if (!challenge.instance_url) {
      setTestResult('❌ No launch URL - This is a text-based challenge');
      return;
    }

    try {
      // Test if URL is accessible
      const response = await fetch(challenge.instance_url, { 
        method: 'HEAD', 
        mode: 'no-cors' 
      });
      
      setTestResult('✅ Launch URL is accessible');
      
      // Actually open the URL
      window.open(challenge.instance_url, '_blank');
      
    } catch (error) {
      setTestResult('⚠️ URL may not be accessible, but opening anyway...');
      window.open(challenge.instance_url, '_blank');
    }
  };

  const getButtonIcon = () => {
    if (!challenge.instance_url) return null;
    
    if (challenge.category === 'Web') return <Globe className="h-4 w-4" />;
    if (['Forensics', 'Network', 'Reverse', 'Pwn', 'Stego'].includes(challenge.category)) {
      return <Download className="h-4 w-4" />;
    }
    return <Tool className="h-4 w-4" />;
  };

  const getButtonText = () => {
    if (!challenge.instance_url) return 'No Launch Needed';
    
    if (challenge.category === 'Web') return 'Launch Web Challenge';
    if (['Forensics', 'Network', 'Reverse', 'Pwn', 'Stego'].includes(challenge.category)) {
      return 'Download Challenge Files';
    }
    return 'Open Tools';
  };

  const getUrlType = () => {
    if (!challenge.instance_url) return 'Text-based challenge';
    
    if (challenge.instance_url.includes('picoctf.org')) return 'PicoCTF Platform';
    if (challenge.instance_url.includes('artifacts.picoctf.net')) return 'Real CTF Files';
    if (challenge.instance_url.includes('cyberchef.org')) return 'CyberChef Tool';
    if (challenge.instance_url.includes('crackmes.one')) return 'Crackme Platform';
    if (challenge.instance_url.includes('osintframework.com')) return 'OSINT Tools';
    return 'External Resource';
  };

  return (
    <Card className="border-blue-500/30 bg-blue-500/5">
      <CardHeader className="pb-3">
        <CardTitle className="text-sm flex items-center gap-2">
          <ExternalLink className="h-4 w-4" />
          Launch Test: {challenge.title}
        </CardTitle>
      </CardHeader>
      <CardContent className="space-y-3">
        <div className="flex items-center gap-2">
          <Badge variant="outline">{challenge.category}</Badge>
          <Badge variant="secondary" className="text-xs">
            {getUrlType()}
          </Badge>
        </div>
        
        {challenge.instance_url && (
          <div className="text-xs text-muted-foreground font-mono bg-black/20 p-2 rounded">
            {challenge.instance_url}
          </div>
        )}
        
        <div className="flex gap-2">
          <Button
            onClick={testLaunch}
            size="sm"
            className={challenge.instance_url ? "bg-blue-600 hover:bg-blue-700" : "bg-gray-600"}
            disabled={!challenge.instance_url}
          >
            {getButtonIcon()}
            <span className="ml-2">{getButtonText()}</span>
          </Button>
        </div>
        
        {testResult && (
          <div className="text-xs p-2 rounded bg-secondary/50">
            {testResult}
          </div>
        )}
      </CardContent>
    </Card>
  );
}