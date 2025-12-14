import { motion } from 'framer-motion';
import { Flag, Zap, Lock, CheckCircle } from 'lucide-react';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Challenge } from '@/types/database';
import { cn } from '@/lib/utils';

interface ChallengeCardProps {
  challenge: Challenge;
  solved?: boolean;
  onClick: () => void;
  index: number;
}

const difficultyConfig = {
  easy: { color: 'bg-success/20 text-success border-success/30', label: 'Easy' },
  medium: { color: 'bg-yellow-500/20 text-yellow-400 border-yellow-500/30', label: 'Medium' },
  hard: { color: 'bg-orange-500/20 text-orange-400 border-orange-500/30', label: 'Hard' },
  insane: { color: 'bg-destructive/20 text-destructive border-destructive/30', label: 'Insane' },
};

export function ChallengeCard({ challenge, solved, onClick, index }: ChallengeCardProps) {
  const difficulty = difficultyConfig[challenge.difficulty];

  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay: index * 0.05 }}
      whileHover={{ scale: 1.02 }}
      whileTap={{ scale: 0.98 }}
    >
      <Card
        variant={solved ? "default" : "glow"}
        className={cn(
          "cursor-pointer relative overflow-hidden group",
          solved && "border-success/30 bg-success/5"
        )}
        onClick={onClick}
      >
        {solved && (
          <div className="absolute top-3 right-3">
            <CheckCircle className="h-5 w-5 text-success" />
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
          
          <div className="flex items-center justify-between">
            <Badge className={cn("border", difficulty.color)}>
              {difficulty.label}
            </Badge>
            <div className="flex items-center gap-1 text-primary font-mono font-bold">
              <Zap className="h-4 w-4" />
              <span>{challenge.points}</span>
              <span className="text-xs text-muted-foreground font-normal">pts</span>
            </div>
          </div>
        </CardContent>
      </Card>
    </motion.div>
  );
}
