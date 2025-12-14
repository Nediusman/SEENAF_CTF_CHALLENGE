import { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { X, Flag, Zap, Send, Loader2, CheckCircle, XCircle, Lightbulb } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Badge } from '@/components/ui/badge';
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card';
import { Challenge } from '@/types/database';
import { supabase } from '@/integrations/supabase/client';
import { useAuth } from '@/hooks/useAuth';
import { useToast } from '@/hooks/use-toast';
import { cn } from '@/lib/utils';

interface SubmitFlagModalProps {
  challenge: Challenge;
  solved?: boolean;
  onClose: () => void;
  onSolved: () => void;
}

const difficultyConfig = {
  easy: { color: 'bg-success/20 text-success border-success/30', label: 'Easy' },
  medium: { color: 'bg-yellow-500/20 text-yellow-400 border-yellow-500/30', label: 'Medium' },
  hard: { color: 'bg-orange-500/20 text-orange-400 border-orange-500/30', label: 'Hard' },
  insane: { color: 'bg-destructive/20 text-destructive border-destructive/30', label: 'Insane' },
};

export function SubmitFlagModal({ challenge, solved, onClose, onSolved }: SubmitFlagModalProps) {
  const [flag, setFlag] = useState('');
  const [loading, setLoading] = useState(false);
  const [result, setResult] = useState<'correct' | 'incorrect' | null>(null);
  const [showHints, setShowHints] = useState(false);
  
  const { user } = useAuth();
  const { toast } = useToast();
  const difficulty = difficultyConfig[challenge.difficulty];

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!user || !flag.trim()) return;

    setLoading(true);
    setResult(null);

    try {
      const isCorrect = flag.trim() === challenge.flag;

      const { error } = await supabase.from('submissions').insert({
        user_id: user.id,
        challenge_id: challenge.id,
        submitted_flag: flag.trim(),
        is_correct: isCorrect,
      });

      if (error) {
        if (error.code === '23505') {
          toast({
            title: "Already solved!",
            description: "You've already captured this flag.",
          });
          return;
        }
        throw error;
      }

      setResult(isCorrect ? 'correct' : 'incorrect');

      if (isCorrect) {
        toast({
          title: "Flag captured!",
          description: `+${challenge.points} points added to your score!`,
        });
        setTimeout(() => {
          onSolved();
          onClose();
        }, 1500);
      }
    } catch (error) {
      console.error('Error submitting flag:', error);
      toast({
        title: "Submission failed",
        description: "Something went wrong. Try again.",
        variant: "destructive",
      });
    } finally {
      setLoading(false);
    }
  };

  return (
    <motion.div
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
      className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-background/80 backdrop-blur-sm"
      onClick={onClose}
    >
      <motion.div
        initial={{ scale: 0.9, opacity: 0 }}
        animate={{ scale: 1, opacity: 1 }}
        exit={{ scale: 0.9, opacity: 0 }}
        onClick={(e) => e.stopPropagation()}
        className="w-full max-w-lg"
      >
        <Card variant="glow" className="glass relative">
          <Button
            variant="ghost"
            size="icon"
            className="absolute top-4 right-4"
            onClick={onClose}
          >
            <X className="h-4 w-4" />
          </Button>

          <CardHeader>
            <div className="flex items-center gap-2 mb-2">
              <Flag className="h-5 w-5 text-primary" />
              <Badge variant="outline" className="font-mono text-xs">
                {challenge.category}
              </Badge>
              <Badge className={cn("border", difficulty.color)}>
                {difficulty.label}
              </Badge>
            </div>
            <CardTitle>{challenge.title}</CardTitle>
            <CardDescription className="flex items-center gap-2">
              <Zap className="h-4 w-4 text-primary" />
              <span className="font-mono font-bold text-primary">{challenge.points}</span>
              <span>points</span>
            </CardDescription>
          </CardHeader>

          <CardContent className="space-y-4">
            <div className="prose prose-invert prose-sm max-w-none">
              <p className="text-foreground/80">{challenge.description}</p>
            </div>

            {challenge.hints && challenge.hints.length > 0 && (
              <div>
                <Button
                  variant="ghost"
                  size="sm"
                  className="text-muted-foreground"
                  onClick={() => setShowHints(!showHints)}
                >
                  <Lightbulb className="h-4 w-4 mr-2" />
                  {showHints ? 'Hide hints' : `Show hints (${challenge.hints.length})`}
                </Button>
                
                <AnimatePresence>
                  {showHints && (
                    <motion.div
                      initial={{ height: 0, opacity: 0 }}
                      animate={{ height: 'auto', opacity: 1 }}
                      exit={{ height: 0, opacity: 0 }}
                      className="overflow-hidden"
                    >
                      <ul className="mt-2 space-y-1 text-sm text-muted-foreground">
                        {challenge.hints.map((hint, i) => (
                          <li key={i} className="flex items-start gap-2">
                            <span className="text-primary font-mono">{i + 1}.</span>
                            {hint}
                          </li>
                        ))}
                      </ul>
                    </motion.div>
                  )}
                </AnimatePresence>
              </div>
            )}

            {solved ? (
              <div className="flex items-center gap-2 p-4 rounded-lg bg-success/10 border border-success/30">
                <CheckCircle className="h-5 w-5 text-success" />
                <span className="font-mono text-success">Challenge completed!</span>
              </div>
            ) : (
              <form onSubmit={handleSubmit} className="space-y-3">
                <div className="relative">
                  <Input
                    type="text"
                    placeholder="Enter flag..."
                    value={flag}
                    onChange={(e) => setFlag(e.target.value)}
                    className={cn(
                      result === 'correct' && 'border-success focus-visible:ring-success',
                      result === 'incorrect' && 'border-destructive focus-visible:ring-destructive'
                    )}
                  />
                  {result && (
                    <div className="absolute right-3 top-1/2 -translate-y-1/2">
                      {result === 'correct' ? (
                        <CheckCircle className="h-5 w-5 text-success" />
                      ) : (
                        <XCircle className="h-5 w-5 text-destructive" />
                      )}
                    </div>
                  )}
                </div>

                <Button
                  type="submit"
                  variant="cyber"
                  className="w-full"
                  disabled={loading || !flag.trim()}
                >
                  {loading ? (
                    <Loader2 className="h-4 w-4 animate-spin" />
                  ) : (
                    <>
                      <Send className="h-4 w-4" />
                      Submit Flag
                    </>
                  )}
                </Button>
              </form>
            )}
          </CardContent>
        </Card>
      </motion.div>
    </motion.div>
  );
}
