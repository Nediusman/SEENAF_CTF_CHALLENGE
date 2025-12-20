import { useState } from 'react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { Badge } from '@/components/ui/badge';
import { Challenge } from '@/types/database';

interface LocalChallengeRunnerProps {
  challenge: Challenge;
  onFlagSubmit: (flag: string) => void;
}

export function LocalChallengeRunner({ challenge, onFlagSubmit }: LocalChallengeRunnerProps) {
  const [userInput, setUserInput] = useState('');
  const [result, setResult] = useState<string>('');

  // Local challenge implementations
  const runLocalChallenge = () => {
    switch (challenge.title) {
      case 'Inspect HTML':
        return renderInspectHTMLChallenge();
      case 'Base64 Basics':
        return renderBase64Challenge();
      case 'Caesar':
        return renderCaesarChallenge();
      case 'The Numbers':
        return renderNumbersChallenge();
      default:
        return null;
    }
  };

  const renderInspectHTMLChallenge = () => (
    <div className="space-y-4">
      <Card className="bg-secondary/20">
        <CardHeader>
          <CardTitle className="text-sm">Challenge Website</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="bg-white text-black p-4 rounded border">
            <h1>Welcome to SEENAF CTF!</h1>
            <p>This is a simple webpage. Can you find the hidden flag?</p>
            {/* Hidden flag removed for security - flags should only be in database */}
            {/* Challenge content would be loaded from server */}
            <div style={{ display: 'none' }}>
              Flag: [REDACTED - Check database]
            </div>
          </div>
          <p className="text-xs text-muted-foreground mt-2">
            💡 Right-click and select "Inspect Element" or "View Page Source"
          </p>
        </CardContent>
      </Card>
    </div>
  );

  const renderBase64Challenge = () => (
    <div className="space-y-4">
      <Card className="bg-secondary/20">
        <CardContent className="pt-6">
          <div className="text-center">
            <Badge variant="outline" className="mb-4">Encoded Message</Badge>
            <div className="font-mono text-lg bg-black/50 p-4 rounded">
              U0VFTkFGe2Jhc2U2NF9pc19ub3RfZW5jcnlwdGlvbn0=
            </div>
            <p className="text-sm text-muted-foreground mt-2">
              💡 This looks like Base64 encoding. Decode it to find the flag!
            </p>
          </div>
        </CardContent>
      </Card>
      
      <div className="flex gap-2">
        <Input
          placeholder="Try decoding the Base64 string..."
          value={userInput}
          onChange={(e) => setUserInput(e.target.value)}
        />
        <Button onClick={() => {
          const decoded = atob('U0VFTkFGe2Jhc2U2NF9pc19ub3RfZW5jcnlwdGlvbn0=');
          setResult(decoded);
        }}>
          Decode
        </Button>
      </div>
      
      {result && (
        <div className="p-3 bg-green-500/10 border border-green-500/30 rounded">
          <p className="text-green-400">Decoded: {result}</p>
        </div>
      )}
    </div>
  );

  const renderCaesarChallenge = () => (
    <div className="space-y-4">
      <Card className="bg-secondary/20">
        <CardContent className="pt-6">
          <div className="text-center">
            <Badge variant="outline" className="mb-4">Caesar Cipher</Badge>
            <div className="font-mono text-lg bg-black/50 p-4 rounded">
              VHHDQI{FDHVDU_FLSKHU_LV_HDVB_SHDBV}
            </div>
            <p className="text-sm text-muted-foreground mt-2">
              💡 This is encrypted with a Caesar cipher. Try different shift values!
            </p>
          </div>
        </CardContent>
      </Card>
      
      <div className="flex gap-2">
        <Input
          type="number"
          placeholder="Shift value (1-25)"
          value={userInput}
          onChange={(e) => setUserInput(e.target.value)}
        />
        <Button onClick={() => {
          const shift = parseInt(userInput) || 3;
          const cipher = 'VHHDQI{FDHVDU_FLSKHU_LV_HDVB_SHDBV}';
          const decoded = cipher.split('').map(char => {
            if (char.match(/[A-Z]/)) {
              return String.fromCharCode(((char.charCodeAt(0) - 65 - shift + 26) % 26) + 65);
            }
            return char;
          }).join('');
          setResult(decoded);
        }}>
          Decrypt
        </Button>
      </div>
      
      {result && (
        <div className="p-3 bg-green-500/10 border border-green-500/30 rounded">
          <p className="text-green-400">Decrypted: {result}</p>
        </div>
      )}
    </div>
  );

  const renderNumbersChallenge = () => (
    <div className="space-y-4">
      <Card className="bg-secondary/20">
        <CardContent className="pt-6">
          <div className="text-center">
            <Badge variant="outline" className="mb-4">Number Cipher</Badge>
            <div className="font-mono text-lg bg-black/50 p-4 rounded">
              13 9 3 15 3 20 6 {'{'}20 8 5 14 21 13 2 5 18 19 13 1 19 15 14{'}'}
            </div>
            <p className="text-sm text-muted-foreground mt-2">
              💡 Each number represents a letter. A=1, B=2, C=3, etc.
            </p>
          </div>
        </CardContent>
      </Card>
      
      <Button 
        className="w-full"
        onClick={() => {
          const numbers = [13, 9, 3, 15, 3, 20, 6];
          const flagNumbers = [20, 8, 5, 14, 21, 13, 2, 5, 18, 19, 13, 1, 19, 15, 14];
          
          const decode = (nums: number[]) => 
            nums.map(n => String.fromCharCode(n + 64)).join('');
          
          const prefix = decode(numbers);
          const flag = decode(flagNumbers);
          setResult(`${prefix}{${flag}}`);
        }}
      >
        Convert Numbers to Letters
      </Button>
      
      {result && (
        <div className="p-3 bg-green-500/10 border border-green-500/30 rounded">
          <p className="text-green-400">Decoded: {result}</p>
        </div>
      )}
    </div>
  );

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between">
        <h3 className="text-lg font-semibold">Interactive Challenge</h3>
        <Badge variant="outline">Local Environment</Badge>
      </div>
      
      {runLocalChallenge()}
      
      <div className="pt-4 border-t">
        <p className="text-sm text-muted-foreground mb-2">
          Found the flag? Submit it below:
        </p>
        <div className="flex gap-2">
          <Input
            placeholder="SEENAF{...}"
            value={userInput}
            onChange={(e) => setUserInput(e.target.value)}
          />
          <Button onClick={() => onFlagSubmit(userInput)}>
            Submit Flag
          </Button>
        </div>
      </div>
    </div>
  );
}