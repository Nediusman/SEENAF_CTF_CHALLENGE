import { motion } from 'framer-motion';
import { Flag, Zap, Lock, CheckCircle, Play } from 'lucide-react';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Challenge } from '@/types/database';
import { cn } from '@/lib/utils';

interface ChallengeCardProps {
  challenge: Challenge;
  solved?: boolean;
  onClick: () => void;
  index: number;
  isAdmin?: boolean;
}

const difficultyConfig = {
  easy: { color: 'bg-success/20 text-success border-success/30', label: 'Easy' },
  medium: { color: 'bg-yellow-500/20 text-yellow-400 border-yellow-500/30', label: 'Medium' },
  hard: { color: 'bg-orange-500/20 text-orange-400 border-orange-500/30', label: 'Hard' },
  insane: { color: 'bg-destructive/20 text-destructive border-destructive/30', label: 'Insane' },
};

export function ChallengeCard({ challenge, solved, onClick, index, isAdmin = false }: ChallengeCardProps) {
  const difficulty = difficultyConfig[challenge.difficulty];

  const handleLaunchInstance = (e: React.MouseEvent) => {
    e.stopPropagation(); // Prevent opening the modal
    if (challenge.instance_url) {
      window.open(challenge.instance_url, '_blank');
    } else {
      // For challenges without instance URL, open the challenge modal
      onClick();
    }
  };

  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay: index * 0.05 }}
      whileHover={{ scale: 1.02 }}
      whileTap={{ scale: 0.98 }}
    >
      <Card
        className={cn(
          "cursor-pointer relative overflow-hidden group",
          solved && "border-success/30 bg-success/5",
          !solved && "border-primary/20 hover:border-primary/40 transition-colors",
          !challenge.is_active && isAdmin && "border-orange-500/30 bg-orange-500/5 opacity-75"
        )}
        onClick={onClick}
      >
        {solved && (
          <div className="absolute top-3 right-3 z-10">
            <div className="flex items-center gap-1 bg-green-500 px-3 py-1 rounded-full border border-green-400 shadow-lg">
              <CheckCircle className="h-4 w-4 text-white" />
              <span className="text-xs font-mono text-white font-bold">SOLVED</span>
            </div>
          </div>
        )}
        
        {solved && (
          <div className="absolute inset-0 bg-green-500/10 pointer-events-none" />
        )}

        {!challenge.is_active && isAdmin && (
          <div className="absolute top-3 left-3 z-10">
            <div className="flex items-center gap-1 bg-orange-500 px-2 py-1 rounded-full border border-orange-400 shadow-lg">
              <span className="text-xs font-mono text-white font-bold">INACTIVE</span>
            </div>
          </div>
        )}
        
        <CardHeader className="pb-2">
          <div className="flex items-start justify-between">
            <div className="flex items-center gap-2">
              {solved ? (
                <Flag className="h-5 w-5 text-success" />
              ) : (
                <Lock className="h-5 w-5 text-primary group-hover:text-primary/80 transition-colors" />
              )}
              <Badge variant="outline" className="font-mono text-xs">
                {challenge.category}
              </Badge>
            </div>
          </div>
          <CardTitle className="text-lg group-hover:text-primary transition-colors">
            {challenge.title}
          </CardTitle>
        </CardHeader>
        
        <CardContent>
          <p className="text-sm text-muted-foreground line-clamp-2 mb-4">
            {challenge.description}
          </p>
          
          <div className="flex items-center justify-between mb-3">
            <Badge className={cn("border", difficulty.color)}>
              {difficulty.label}
            </Badge>
            <div className="flex items-center gap-1 text-primary font-mono font-bold">
              <Zap className="h-4 w-4" />
              <span>{challenge.points}</span>
              <span className="text-xs text-muted-foreground font-normal">pts</span>
            </div>
          </div>

          {/* Launch Instance Button - Show for all challenges except text-based crypto */}
          {challenge.instance_url ? (
            <Button
              onClick={handleLaunchInstance}
              size="sm"
              className="w-full bg-blue-600 hover:bg-blue-700 text-white"
            >
              <Play className="h-3 w-3 mr-2" />
              {challenge.category === 'Forensics' || challenge.category === 'Network' || challenge.category === 'Reverse' || challenge.category === 'Pwn' || challenge.category === 'Stego' ? 'Download Files' : 
               challenge.category === 'Web' ? 'Launch Challenge' : 'Open Tools'}
            </Button>
          ) : (
            // For text-based crypto challenges, show a different button
            challenge.category === 'Crypto' && (
              <Button
                onClick={onClick}
                size="sm"
                className="w-full bg-green-600 hover:bg-green-700 text-white"
              >
                <Flag className="h-3 w-3 mr-2" />
                Solve Challenge
              </Button>
            )
          )}
        </CardContent>
      </Card>
    </motion.div>
  );
}
