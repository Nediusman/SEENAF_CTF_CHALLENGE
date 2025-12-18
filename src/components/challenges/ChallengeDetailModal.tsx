import { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { 
  X, 
  Flag, 
  Zap, 
  Send, 
  Loader2, 
  CheckCircle, 
  XCircle, 
  Lightbulb, 
  User,
  Heart,
  Users,
  ExternalLink,
  Play,
  ThumbsUp
} from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Badge } from '@/components/ui/badge';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Separator } from '@/components/ui/separator';
import { Challenge } from '@/types/database';
import { supabase } from '@/integrations/supabase/client';
import { useAuth } from '@/hooks/useAuth';
import { useToast } from '@/hooks/use-toast';
import { cn } from '@/lib/utils';
import { toast } from 'sonner';

interface ChallengeDetailModalProps {
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

export function ChallengeDetailModal({ challenge, solved, onClose, onSolved }: ChallengeDetailModalProps) {
  const [flag, setFlag] = useState('');
  const [loading, setLoading] = useState(false);
  const [result, setResult] = useState<'correct' | 'incorrect' | null>(null);
  const [showHints, setShowHints] = useState(false);
  const [liked, setLiked] = useState(false);
  const [likesCount, setLikesCount] = useState(challenge.likes_count ?? 0);
  const [solverCount, setSolverCount] = useState(challenge.solver_count ?? 0);
  const [localSolved, setLocalSolved] = useState(solved); // Local solved state
  
  const { user, role } = useAuth();
  const { toast } = useToast();
  const difficulty = difficultyConfig[challenge.difficulty];

  useEffect(() => {
    fetchChallengeStats();
    if (user) {
      checkIfLiked();
    }
  }, [challenge.id, user]);

  // Update local solved state when prop changes
  useEffect(() => {
    setLocalSolved(solved);
  }, [solved]);

  const fetchChallengeStats = async () => {
    try {
      // Get solver count
      const { count: solvers } = await supabase
        .from('submissions')
        .select('*', { count: 'exact', head: true })
        .eq('challenge_id', challenge.id)
        .eq('is_correct', true);

      setSolverCount(solvers || 0);
    } catch (error) {
      console.error('Error fetching challenge stats:', error);
    }
  };

  const checkIfLiked = async () => {
    if (!user) return;
    
    try {
      const { data } = await supabase
        .from('challenge_likes')
        .select('id')
        .eq('user_id', user.id)
        .eq('challenge_id', challenge.id)
        .single();
      
      setLiked(!!data);
    } catch (error) {
      // User hasn't liked this challenge
      setLiked(false);
    }
  };

  const handleLike = async () => {
    if (!user) return;

    try {
      if (liked) {
        await supabase
          .from('challenge_likes')
          .delete()
          .eq('user_id', user.id)
          .eq('challenge_id', challenge.id);
        
        setLiked(false);
        setLikesCount(prev => prev - 1);
      } else {
        await supabase
          .from('challenge_likes')
          .insert({
            user_id: user.id,
            challenge_id: challenge.id
          });
        
        setLiked(true);
        setLikesCount(prev => prev + 1);
      }
    } catch (error) {
      console.error('Error toggling like:', error);
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!user || !flag.trim()) return;

    // Prevent submissions on inactive challenges for non-admins
    if (!challenge.is_active && role !== 'admin') {
      toast({
        title: "Challenge unavailable",
        description: "This challenge is currently inactive.",
        variant: "destructive",
      });
      return;
    }

    setLoading(true);
    setResult(null);

    try {
      const isCorrect = flag.trim() === challenge.flag;
      
      console.log('Submission attempt:', {
        user_id: user.id,
        challenge_id: challenge.id,
        submitted_flag: flag.trim(),
        expected_flag: challenge.flag,
        is_correct: isCorrect
      });

      const { data, error } = await supabase.from('submissions').insert({
        user_id: user.id,
        challenge_id: challenge.id,
        submitted_flag: flag.trim(),
        is_correct: isCorrect,
      }).select();

      if (error) {
        console.error('Submission error:', error);
        if (error.code === '23505') {
          toast({
            title: "Already solved!",
            description: "You've already captured this flag.",
          });
          return;
        }
        throw error;
      }
      
      console.log('Submission successful:', data);

      setResult(isCorrect ? 'correct' : 'incorrect');

      if (isCorrect) {
        toast({
          title: "Flag captured!",
          description: `+${challenge.points} points added to your score!`,
        });
        setSolverCount(prev => prev + 1);
        
        // Immediately update local solved state and call onSolved
        setLocalSolved(true);
        onSolved();
        
        // Show success message with sonner toast
        toast.success("🎉 Challenge Solved!", {
          description: `You earned ${challenge.points} points!`,
          duration: 5000,
        });
        
        // Keep modal open longer to show the solved message
        setTimeout(() => {
          onClose();
        }, 3000);
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

  const handleLaunchInstance = () => {
    if (challenge.instance_url) {
      window.open(challenge.instance_url, '_blank');
      toast({
        title: "Instance launched!",
        description: "Challenge environment opened in new tab.",
      });
    } else {
      // Create a generic challenge file URL based on challenge info
      const challengeUrl = `https://github.com/seenaf-ctf/challenges/raw/main/${challenge.category.toLowerCase()}/${challenge.title.toLowerCase().replace(/\s+/g, '-')}.zip`;
      window.open(challengeUrl, '_blank');
      toast({
        title: "Challenge files downloading",
        description: "Download the challenge files to get started!",
      });
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
        className="w-full max-w-2xl max-h-[90vh] overflow-y-auto"
      >
        <Card variant="glow" className="glass relative">
          <Button
            variant="ghost"
            size="icon"
            className="absolute top-4 right-4 z-10"
            onClick={onClose}
          >
            <X className="h-4 w-4" />
          </Button>

          <CardHeader className="pb-4">
            <div className="flex items-start justify-between pr-12">
              <div className="flex-1">
                <div className="flex items-center gap-2 mb-3">
                  <Flag className="h-5 w-5 text-primary" />
                  <CardTitle className="text-xl">{challenge.title}</CardTitle>
                </div>
                
                <div className="flex flex-wrap items-center gap-2 mb-4">
                  <Badge className={cn("border", difficulty.color)}>
                    {difficulty.label}
                  </Badge>
                  <Badge variant="outline" className="font-mono text-xs bg-primary/10">
                    {challenge.category}
                  </Badge>
                  <Badge variant="outline" className="font-mono text-xs bg-blue-500/10 text-blue-400 border-blue-500/30">
                    Web Exploitation
                  </Badge>
                  <Badge variant="outline" className="font-mono text-xs bg-purple-500/10 text-purple-400 border-purple-500/30">
                    SEENAF_CTF Platform
                  </Badge>
                  <Badge variant="outline" className="font-mono text-xs bg-orange-500/10 text-orange-400 border-orange-500/30">
                    browser_webshell_solvable
                  </Badge>
                  {!challenge.is_active && role === 'admin' && (
                    <Badge variant="destructive" className="font-mono text-xs">
                      INACTIVE - ADMIN VIEW
                    </Badge>
                  )}
                </div>

                <div className="flex items-center gap-2 text-sm text-muted-foreground mb-2">
                  <User className="h-4 w-4" />
                  <span>AUTHOR: {challenge.author || 'SEENAF Team'}</span>
                </div>
              </div>
            </div>
          </CardHeader>

          <CardContent className="space-y-6">
            {/* Description */}
            <div>
              <h3 className="font-semibold mb-2">Description</h3>
              <div className="prose prose-invert prose-sm max-w-none">
                <p className="text-foreground/80 leading-relaxed">{challenge.description}</p>
              </div>
              
              <div className="mt-4 text-sm text-muted-foreground">
                <p>This challenge launches an instance on demand.</p>
                <p className="text-red-400">The current status is: <span className="font-semibold">NOT_RUNNING</span></p>
              </div>
            </div>

            {/* Launch Instance Button - Show for most challenges */}
            {challenge.instance_url && (
              <div>
                <Button 
                  onClick={handleLaunchInstance}
                  className="w-full bg-blue-600 hover:bg-blue-700 text-white"
                  size="lg"
                >
                  <Play className="h-4 w-4 mr-2" />
                  {challenge.category === 'Web' ? 'Launch Web Challenge' :
                   challenge.category === 'Forensics' || challenge.category === 'Network' || challenge.category === 'Reverse' || challenge.category === 'Pwn' || challenge.category === 'Stego' ? 'Download Challenge Files' :
                   challenge.category === 'Crypto' ? 'Open Cipher Tools' :
                   'Open Challenge Resources'}
                </Button>
              </div>
            )}
            
            {/* For text-based crypto challenges without launch buttons */}
            {!challenge.instance_url && challenge.category === 'Crypto' && (
              <div className="p-4 bg-green-500/10 border border-green-500/30 rounded-lg">
                <p className="text-green-400 text-sm text-center">
                  💡 All information needed to solve this challenge is provided in the description above
                </p>
              </div>
            )}

            {/* Hints */}
            {challenge.hints && challenge.hints.length > 0 && (
              <div>
                <div className="flex items-center justify-between mb-3">
                  <h3 className="font-semibold flex items-center gap-2">
                    <Lightbulb className="h-4 w-4 text-yellow-400" />
                    Hints
                  </h3>
                  <div className="flex items-center gap-2">
                    {challenge.hints.map((_, index) => (
                      <div
                        key={index}
                        className="w-6 h-6 rounded-full bg-blue-600 text-white text-xs flex items-center justify-center font-mono"
                      >
                        {index + 1}
                      </div>
                    ))}
                  </div>
                </div>
                
                <div className="space-y-2">
                  {challenge.hints.map((hint, index) => (
                    <div key={index} className="flex items-start gap-3 p-3 rounded-lg bg-secondary/30 border border-border/50">
                      <div className="w-6 h-6 rounded-full bg-blue-600 text-white text-xs flex items-center justify-center font-mono flex-shrink-0 mt-0.5">
                        {index + 1}
                      </div>
                      <p className="text-sm text-foreground/80 flex-1">{hint}</p>
                    </div>
                  ))}
                </div>
              </div>
            )}

            <Separator />

            {/* Stats */}
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-6">
                <div className="flex items-center gap-2 text-sm">
                  <Users className="h-4 w-4 text-muted-foreground" />
                  <span className="font-mono">{solverCount} users solved</span>
                </div>
                <div className="flex items-center gap-2 text-sm">
                  <Zap className="h-4 w-4 text-primary" />
                  <span className="font-mono font-bold text-primary">{challenge.points}</span>
                  <span className="text-muted-foreground">pts</span>
                </div>
              </div>
              
              <div className="flex items-center gap-2">
                <span className="text-sm text-muted-foreground">{Math.round((solverCount / Math.max(solverCount + 100, 200)) * 100)}% Liked</span>
                <Button
                  variant="ghost"
                  size="sm"
                  onClick={handleLike}
                  className={cn(
                    "gap-2",
                    liked && "text-red-400 hover:text-red-300"
                  )}
                >
                  <ThumbsUp className={cn("h-4 w-4", liked && "fill-current")} />
                </Button>
              </div>
            </div>

            {/* Flag Submission */}
            {(solved || localSolved) ? (
              <div className="flex items-center justify-center gap-3 p-6 rounded-lg bg-green-600/20 border-2 border-green-500 backdrop-blur-sm">
                <div className="flex items-center justify-center w-12 h-12 rounded-full bg-green-500">
                  <CheckCircle className="h-8 w-8 text-white" />
                </div>
                <div className="text-center">
                  <div className="font-mono text-green-400 font-bold text-xl">🎉 CHALLENGE SOLVED! 🎉</div>
                  <div className="text-sm text-green-300 mt-1">You've successfully captured the flag!</div>
                </div>
              </div>
            ) : (
              <form onSubmit={handleSubmit} className="space-y-3">
                <div className="relative">
                  <Input
                    type="text"
                    placeholder="SEENAF{...}"
                    value={flag}
                    onChange={(e) => setFlag(e.target.value)}
                    className={cn(
                      "font-mono",
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
                  className="w-full bg-blue-600 hover:bg-blue-700 text-white"
                  disabled={loading || !flag.trim()}
                >
                  {loading ? (
                    <Loader2 className="h-4 w-4 animate-spin" />
                  ) : (
                    <>
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