import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { motion, AnimatePresence } from 'framer-motion';
import { Search, Filter, Flag, Trophy } from 'lucide-react';
import { Layout } from '@/components/layout/Layout';
import { Input } from '@/components/ui/input';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { ChallengeCard } from '@/components/challenges/ChallengeCard';
import { SubmitFlagModal } from '@/components/challenges/SubmitFlagModal';
import { Challenge, DifficultyLevel } from '@/types/database';
import { supabase } from '@/integrations/supabase/client';
import { useAuth } from '@/hooks/useAuth';

const categories = ['All', 'Web', 'Crypto', 'Pwn', 'Reverse', 'Forensics', 'Misc'];
const difficulties: (DifficultyLevel | 'all')[] = ['all', 'easy', 'medium', 'hard', 'insane'];

export default function Challenges() {
  const [challenges, setChallenges] = useState<Challenge[]>([]);
  const [solvedIds, setSolvedIds] = useState<Set<string>>(new Set());
  const [selectedChallenge, setSelectedChallenge] = useState<Challenge | null>(null);
  const [search, setSearch] = useState('');
  const [categoryFilter, setCategoryFilter] = useState('All');
  const [difficultyFilter, setDifficultyFilter] = useState<DifficultyLevel | 'all'>('all');
  const [loading, setLoading] = useState(true);

  const { user, profile, loading: authLoading } = useAuth();
  const navigate = useNavigate();

  useEffect(() => {
    if (!authLoading && !user) {
      navigate('/auth');
    }
  }, [user, authLoading, navigate]);

  useEffect(() => {
    if (user) {
      fetchChallenges();
      fetchSolvedChallenges();
    }
  }, [user]);

  const fetchChallenges = async () => {
    try {
      const { data, error } = await supabase
        .from('challenges')
        .select('*')
        .eq('is_active', true)
        .order('points', { ascending: true });

      if (error) throw error;
      setChallenges((data as Challenge[]) || []);
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
      setSolvedIds(new Set(data?.map(s => s.challenge_id) || []));
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
          <div className="text-primary font-mono animate-pulse">Loading...</div>
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
            </div>

            <div className="flex items-center gap-4">
              <div className="flex items-center gap-2 px-4 py-2 rounded-lg bg-secondary/50 border border-border">
                <Flag className="h-5 w-5 text-success" />
                <span className="font-mono">
                  <span className="text-success font-bold">{solvedIds.size}</span>
                  <span className="text-muted-foreground">/{challenges.length}</span>
                </span>
              </div>
              <div className="flex items-center gap-2 px-4 py-2 rounded-lg bg-secondary/50 border border-border">
                <Trophy className="h-5 w-5 text-primary" />
                <span className="font-mono">
                  <span className="text-primary font-bold">{earnedPoints}</span>
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
        {loading ? (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            {[...Array(6)].map((_, i) => (
              <div key={i} className="h-48 rounded-xl bg-card animate-pulse" />
            ))}
          </div>
        ) : filteredChallenges.length === 0 ? (
          <div className="text-center py-16">
            <Filter className="h-12 w-12 mx-auto text-muted-foreground mb-4" />
            <p className="text-muted-foreground font-mono">No challenges found</p>
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
              />
            ))}
          </div>
        )}
      </div>

      {/* Submit Flag Modal */}
      <AnimatePresence>
        {selectedChallenge && (
          <SubmitFlagModal
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
