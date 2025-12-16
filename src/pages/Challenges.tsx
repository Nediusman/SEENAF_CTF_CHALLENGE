import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { motion, AnimatePresence } from 'framer-motion';
import { Search, Filter, Flag, Trophy } from 'lucide-react';
import { Layout } from '@/components/layout/Layout';
import { Input } from '@/components/ui/input';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { ChallengeCard } from '@/components/challenges/ChallengeCard';
import { ChallengeDetailModal } from '@/components/challenges/ChallengeDetailModal';
import { Challenge, DifficultyLevel } from '@/types/database';
import { supabase } from '@/integrations/supabase/client';
import { useAuth } from '@/hooks/useAuth';

const categories = ['All', 'Web', 'Crypto', 'Forensics', 'Network', 'Reverse', 'Pwn', 'OSINT', 'Stego', 'Misc'];
const difficulties: (DifficultyLevel | 'all')[] = ['all', 'easy', 'medium', 'hard', 'insane'];

export default function Challenges() {
  const [challenges, setChallenges] = useState<Challenge[]>([]);
  const [solvedIds, setSolvedIds] = useState<Set<string>>(new Set());
  const [selectedChallenge, setSelectedChallenge] = useState<Challenge | null>(null);
  const [search, setSearch] = useState('');
  const [categoryFilter, setCategoryFilter] = useState('All');
  const [difficultyFilter, setDifficultyFilter] = useState<DifficultyLevel | 'all'>('all');
  const [loading, setLoading] = useState(true);

  const { user, profile, role, loading: authLoading } = useAuth();
  const navigate = useNavigate();

  useEffect(() => {
    if (!authLoading && !user) {
      navigate('/auth');
    }
  }, [user, authLoading, navigate]);

  useEffect(() => {
    if (user && !authLoading) {
      fetchChallenges();
      fetchSolvedChallenges();
    }
  }, [user, role, authLoading]);

  const fetchChallenges = async () => {
    try {
      let query = supabase
        .from('challenges')
        .select('*')
        .order('points', { ascending: true });

      // Regular users only see active challenges, admins see all
      if (role !== 'admin') {
        query = query.eq('is_active', true);
      }

      const { data, error } = await query;

      if (error) throw error;
      
      const challengeData = (data as Challenge[]) || [];
      setChallenges(challengeData);
    } catch (error) {
      console.error('Error fetching challenges:', error);
    } finally {
      setLoading(false);
    }
  };

  const fetchSolvedChallenges = async () => {
    if (!user) return;
    
    try {
      const { data, error } = await supabase
        .from('submissions')
        .select('challenge_id')
        .eq('user_id', user.id)
        .eq('is_correct', true);

      if (error) throw error;
      
      const solvedChallengeIds = data?.map(s => s.challenge_id) || [];
      setSolvedIds(new Set(solvedChallengeIds));
    } catch (error) {
      console.error('Error fetching solved challenges:', error);
    }
  };

  const filteredChallenges = challenges.filter(c => {
    const matchesSearch = c.title.toLowerCase().includes(search.toLowerCase()) ||
      c.description.toLowerCase().includes(search.toLowerCase());
    const matchesCategory = categoryFilter === 'All' || c.category === categoryFilter;
    const matchesDifficulty = difficultyFilter === 'all' || c.difficulty === difficultyFilter;
    return matchesSearch && matchesCategory && matchesDifficulty;
  });

  const totalPoints = challenges.reduce((sum, c) => sum + c.points, 0);
  const earnedPoints = challenges
    .filter(c => solvedIds.has(c.id))
    .reduce((sum, c) => sum + c.points, 0);

  if (authLoading) {
    return (
      <Layout>
        <div className="flex items-center justify-center min-h-[80vh]">
          <div className="text-primary font-mono animate-pulse">Loading authentication...</div>
        </div>
      </Layout>
    );
  }

  if (loading) {
    return (
      <Layout>
        <div className="flex items-center justify-center min-h-[80vh]">
          <div className="text-primary font-mono animate-pulse">Loading challenges...</div>
        </div>
      </Layout>
    );
  }

  return (
    <Layout>
      <div className="container mx-auto px-4 py-8">
        {/* Header */}
        <motion.div
          initial={{ opacity: 0, y: -20 }}
          animate={{ opacity: 1, y: 0 }}
          className="mb-8"
        >
          <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-6">
            <div>
              <h1 className="text-3xl font-mono font-bold text-primary text-glow mb-2">
                {'>'} CHALLENGES
              </h1>
              <p className="text-muted-foreground">
                Capture flags, earn points, climb the leaderboard
              </p>
              {/* Progress bar */}
              {challenges.length > 0 && (
                <div className="mt-3">
                  <div className="flex items-center gap-2 mb-1">
                    <span className="text-xs font-mono text-muted-foreground">Progress:</span>
                    <span className="text-xs font-mono text-success font-bold">
                      {Math.round((solvedIds.size / challenges.length) * 100)}%
                    </span>
                  </div>
                  <div className="w-48 h-2 bg-secondary rounded-full overflow-hidden">
                    <div 
                      className="h-full bg-gradient-to-r from-success to-primary transition-all duration-500"
                      style={{ width: `${(solvedIds.size / challenges.length) * 100}%` }}
                    />
                  </div>
                </div>
              )}
            </div>

            <div className="flex items-center gap-4">
              <div className="flex items-center gap-2 px-4 py-2 rounded-lg bg-success/10 border border-success/30">
                <Flag className="h-5 w-5 text-success" />
                <span className="font-mono">
                  <span className="text-success font-bold text-lg">{solvedIds.size}</span>
                  <span className="text-muted-foreground">/{challenges.length} solved</span>
                </span>
              </div>
              <div className="flex items-center gap-2 px-4 py-2 rounded-lg bg-primary/10 border border-primary/30">
                <Trophy className="h-5 w-5 text-primary" />
                <span className="font-mono">
                  <span className="text-primary font-bold text-lg">{earnedPoints}</span>
                  <span className="text-muted-foreground">/{totalPoints} pts</span>
                </span>
              </div>
            </div>
          </div>

          {/* Filters */}
          <div className="flex flex-col lg:flex-row gap-4">
            <div className="relative flex-1">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
              <Input
                type="text"
                placeholder="Search challenges..."
                value={search}
                onChange={(e) => setSearch(e.target.value)}
                className="pl-10"
              />
            </div>

            <div className="flex flex-wrap gap-2">
              {categories.map(cat => (
                <Button
                  key={cat}
                  variant={categoryFilter === cat ? "default" : "outline"}
                  size="sm"
                  onClick={() => setCategoryFilter(cat)}
                >
                  {cat}
                </Button>
              ))}
            </div>

            <div className="flex gap-2">
              {difficulties.map(diff => (
                <Button
                  key={diff}
                  variant={difficultyFilter === diff ? "default" : "ghost"}
                  size="sm"
                  onClick={() => setDifficultyFilter(diff)}
                  className="capitalize"
                >
                  {diff === 'all' ? 'All Levels' : diff}
                </Button>
              ))}
            </div>
          </div>
        </motion.div>



        {/* Challenge Grid */}
        {filteredChallenges.length === 0 ? (
          <div className="text-center py-16">
            <Filter className="h-12 w-12 mx-auto text-muted-foreground mb-4" />
            <p className="text-muted-foreground font-mono">
              {challenges.length === 0 ? 'No challenges in database' : 'No challenges match your filters'}
            </p>
            {challenges.length === 0 && (
              <p className="text-xs text-muted-foreground mt-2">
                Go to Admin panel to add challenges
              </p>
            )}
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            {filteredChallenges.map((challenge, index) => (
              <ChallengeCard
                key={challenge.id}
                challenge={challenge}
                solved={solvedIds.has(challenge.id)}
                onClick={() => setSelectedChallenge(challenge)}
                index={index}
                isAdmin={role === 'admin'}
              />
            ))}
          </div>
        )}
      </div>

      {/* Challenge Detail Modal */}
      <AnimatePresence>
        {selectedChallenge && (
          <ChallengeDetailModal
            challenge={selectedChallenge}
            solved={solvedIds.has(selectedChallenge.id)}
            onClose={() => setSelectedChallenge(null)}
            onSolved={() => {
              fetchSolvedChallenges();
            }}
          />
        )}
      </AnimatePresence>
    </Layout>
  );
}
