import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { motion, AnimatePresence } from 'framer-motion';
import { Plus, Pencil, Trash2, Users, Flag, Settings, Loader2, X } from 'lucide-react';
import { Layout } from '@/components/layout/Layout';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Textarea } from '@/components/ui/textarea';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Challenge, DifficultyLevel, Profile } from '@/types/database';
import { supabase } from '@/integrations/supabase/client';
import { useAuth } from '@/hooks/useAuth';
import { useToast } from '@/hooks/use-toast';
import { cn } from '@/lib/utils';

const difficultyConfig = {
  easy: { color: 'bg-success/20 text-success border-success/30' },
  medium: { color: 'bg-yellow-500/20 text-yellow-400 border-yellow-500/30' },
  hard: { color: 'bg-orange-500/20 text-orange-400 border-orange-500/30' },
  insane: { color: 'bg-destructive/20 text-destructive border-destructive/30' },
};

interface ChallengeForm {
  title: string;
  description: string;
  category: string;
  difficulty: DifficultyLevel;
  points: number;
  flag: string;
  hints: string;
}

const initialForm: ChallengeForm = {
  title: '',
  description: '',
  category: 'Web',
  difficulty: 'easy',
  points: 100,
  flag: '',
  hints: '',
};

export default function Admin() {
  const [challenges, setChallenges] = useState<Challenge[]>([]);
  const [users, setUsers] = useState<Profile[]>([]);
  const [loading, setLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [form, setForm] = useState<ChallengeForm>(initialForm);
  const [submitting, setSubmitting] = useState(false);

  const { user, role, loading: authLoading } = useAuth();
  const navigate = useNavigate();
  const { toast } = useToast();

  useEffect(() => {
    if (!authLoading) {
      if (!user) {
        navigate('/auth');
      } else if (role !== 'admin') {
        navigate('/challenges');
        toast({
          title: "Access denied",
          description: "You don't have admin privileges.",
          variant: "destructive",
        });
      }
    }
  }, [user, role, authLoading, navigate, toast]);

  useEffect(() => {
    if (role === 'admin') {
      fetchData();
    }
  }, [role]);

  const fetchData = async () => {
    try {
      const [challengesRes, usersRes] = await Promise.all([
        supabase.from('challenges').select('*').order('created_at', { ascending: false }),
        supabase.from('profiles').select('*').order('total_score', { ascending: false })
      ]);

      if (challengesRes.error) throw challengesRes.error;
      if (usersRes.error) throw usersRes.error;

      setChallenges((challengesRes.data as Challenge[]) || []);
      setUsers((usersRes.data as Profile[]) || []);
    } catch (error) {
      console.error('Error fetching data:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    console.log('🎯 Admin submitting challenge:', form);
    console.log('🔑 Current user:', user);
    console.log('👑 Current role:', role);

    if (!form.title || !form.description || !form.flag) {
      toast({
        title: "Validation error",
        description: "Please fill in all required fields.",
        variant: "destructive",
      });
      return;
    }

    setSubmitting(true);

    try {
      const hints = form.hints.split('\n').filter(h => h.trim());
      const challengeData = {
        title: form.title,
        description: form.description,
        category: form.category,
        difficulty: form.difficulty,
        points: form.points,
        flag: form.flag,
        hints: hints.length > 0 ? hints : null,
      };

      console.log('📝 Challenge data to insert:', challengeData);

      if (editingId) {
        console.log('✏️ Updating existing challenge:', editingId);
        const { data, error } = await supabase
          .from('challenges')
          .update(challengeData)
          .eq('id', editingId)
          .select();
        
        if (error) {
          console.error('❌ Update error:', error);
          throw error;
        }
        console.log('✅ Challenge updated:', data);
        toast({ title: "Challenge updated successfully" });
      } else {
        console.log('➕ Creating new challenge');
        const { data, error } = await supabase
          .from('challenges')
          .insert(challengeData)
          .select();
        
        if (error) {
          console.error('❌ Insert error:', error);
          console.error('Error details:', {
            message: error.message,
            details: error.details,
            hint: error.hint,
            code: error.code
          });
          throw error;
        }
        console.log('✅ Challenge created:', data);
        toast({ title: "Challenge created successfully" });
      }

      setShowForm(false);
      setEditingId(null);
      setForm(initialForm);
      fetchData();
    } catch (error: any) {
      console.error('💥 Error saving challenge:', error);
      toast({
        title: "Error saving challenge",
        description: error.message || "Something went wrong. Check console for details.",
        variant: "destructive",
      });
    } finally {
      setSubmitting(false);
    }
  };

  const handleEdit = (challenge: Challenge) => {
    setForm({
      title: challenge.title,
      description: challenge.description,
      category: challenge.category,
      difficulty: challenge.difficulty,
      points: challenge.points,
      flag: challenge.flag,
      hints: challenge.hints?.join('\n') || '',
    });
    setEditingId(challenge.id);
    setShowForm(true);
  };

  const handleDelete = async (id: string) => {
    if (!confirm('Are you sure you want to delete this challenge?')) return;

    try {
      const { error } = await supabase.from('challenges').delete().eq('id', id);
      if (error) throw error;
      toast({ title: "Challenge deleted" });
      fetchData();
    } catch (error) {
      console.error('Error deleting challenge:', error);
      toast({
        title: "Error deleting challenge",
        variant: "destructive",
      });
    }
  };

  if (authLoading || loading) {
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
        <motion.div
          initial={{ opacity: 0, y: -20 }}
          animate={{ opacity: 1, y: 0 }}
          className="mb-8"
        >
          <div className="flex items-center gap-3 mb-2">
            <Settings className="h-8 w-8 text-primary" />
            <h1 className="text-3xl font-mono font-bold text-primary text-glow">
              {'>'} ADMIN_PANEL
            </h1>
          </div>
          <p className="text-muted-foreground">Manage challenges and monitor players</p>
        </motion.div>

        <Tabs defaultValue="challenges" className="space-y-6">
          <TabsList className="bg-secondary/50">
            <TabsTrigger value="challenges" className="gap-2">
              <Flag className="h-4 w-4" />
              Challenges
            </TabsTrigger>
            <TabsTrigger value="users" className="gap-2">
              <Users className="h-4 w-4" />
              Users
            </TabsTrigger>
          </TabsList>

          <TabsContent value="challenges">
            <div className="flex justify-between items-center mb-6">
              <h2 className="font-mono text-xl">Challenge Management</h2>
              <Button
                variant="cyber"
                onClick={() => {
                  setForm(initialForm);
                  setEditingId(null);
                  setShowForm(true);
                }}
              >
                <Plus className="h-4 w-4" />
                Add Challenge
              </Button>
            </div>

            <AnimatePresence>
              {showForm && (
                <motion.div
                  initial={{ opacity: 0, height: 0 }}
                  animate={{ opacity: 1, height: 'auto' }}
                  exit={{ opacity: 0, height: 0 }}
                  className="mb-6"
                >
                  <Card variant="glow" className="glass">
                    <CardHeader className="flex flex-row items-center justify-between">
                      <CardTitle>{editingId ? 'Edit Challenge' : 'New Challenge'}</CardTitle>
                      <Button variant="ghost" size="icon" onClick={() => setShowForm(false)}>
                        <X className="h-4 w-4" />
                      </Button>
                    </CardHeader>
                    <CardContent>
                      <form onSubmit={handleSubmit} className="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <Input
                          placeholder="Title"
                          value={form.title}
                          onChange={(e) => setForm({ ...form, title: e.target.value })}
                        />
                        <div className="flex gap-2">
                          <Select
                            value={form.category}
                            onValueChange={(v) => setForm({ ...form, category: v })}
                          >
                            <SelectTrigger>
                              <SelectValue />
                            </SelectTrigger>
                            <SelectContent>
                              {['Web', 'Crypto', 'Pwn', 'Reverse', 'Forensics', 'Misc'].map(cat => (
                                <SelectItem key={cat} value={cat}>{cat}</SelectItem>
                              ))}
                            </SelectContent>
                          </Select>
                          <Select
                            value={form.difficulty}
                            onValueChange={(v) => setForm({ ...form, difficulty: v as DifficultyLevel })}
                          >
                            <SelectTrigger>
                              <SelectValue />
                            </SelectTrigger>
                            <SelectContent>
                              {['easy', 'medium', 'hard', 'insane'].map(d => (
                                <SelectItem key={d} value={d} className="capitalize">{d}</SelectItem>
                              ))}
                            </SelectContent>
                          </Select>
                        </div>
                        <Textarea
                          placeholder="Description"
                          value={form.description}
                          onChange={(e) => setForm({ ...form, description: e.target.value })}
                          className="md:col-span-2"
                        />
                        <Input
                          type="number"
                          placeholder="Points"
                          value={form.points}
                          onChange={(e) => setForm({ ...form, points: parseInt(e.target.value) || 0 })}
                        />
                        <Input
                          placeholder="Flag (e.g., CTF{...})"
                          value={form.flag}
                          onChange={(e) => setForm({ ...form, flag: e.target.value })}
                        />
                        <Textarea
                          placeholder="Hints (one per line)"
                          value={form.hints}
                          onChange={(e) => setForm({ ...form, hints: e.target.value })}
                          className="md:col-span-2"
                          rows={3}
                        />
                        <div className="md:col-span-2 flex justify-end gap-2">
                          <Button type="button" variant="ghost" onClick={() => setShowForm(false)}>
                            Cancel
                          </Button>
                          <Button type="submit" variant="cyber" disabled={submitting}>
                            {submitting ? (
                              <Loader2 className="h-4 w-4 animate-spin" />
                            ) : editingId ? (
                              'Update Challenge'
                            ) : (
                              'Create Challenge'
                            )}
                          </Button>
                        </div>
                      </form>
                    </CardContent>
                  </Card>
                </motion.div>
              )}
            </AnimatePresence>

            <div className="space-y-3">
              {challenges.map((challenge, index) => (
                <motion.div
                  key={challenge.id}
                  initial={{ opacity: 0, x: -20 }}
                  animate={{ opacity: 1, x: 0 }}
                  transition={{ delay: index * 0.03 }}
                >
                  <Card className="hover:border-primary/30 transition-colors">
                    <CardContent className="flex items-center gap-4 p-4">
                      <div className="flex-1">
                        <div className="flex items-center gap-2 mb-1">
                          <h3 className="font-mono font-semibold">{challenge.title}</h3>
                          <Badge variant="outline" className="text-xs">{challenge.category}</Badge>
                          <Badge className={cn("border text-xs", difficultyConfig[challenge.difficulty].color)}>
                            {challenge.difficulty}
                          </Badge>
                          {!challenge.is_active && (
                            <Badge variant="secondary" className="text-xs">Inactive</Badge>
                          )}
                        </div>
                        <p className="text-sm text-muted-foreground line-clamp-1">{challenge.description}</p>
                      </div>
                      <div className="text-right">
                        <p className="font-mono font-bold text-primary">{challenge.points} pts</p>
                      </div>
                      <div className="flex gap-2">
                        <Button variant="ghost" size="icon" onClick={() => handleEdit(challenge)}>
                          <Pencil className="h-4 w-4" />
                        </Button>
                        <Button variant="ghost" size="icon" onClick={() => handleDelete(challenge.id)}>
                          <Trash2 className="h-4 w-4 text-destructive" />
                        </Button>
                      </div>
                    </CardContent>
                  </Card>
                </motion.div>
              ))}
            </div>
          </TabsContent>

          <TabsContent value="users">
            <h2 className="font-mono text-xl mb-6">Registered Users ({users.length})</h2>
            <div className="space-y-2">
              {users.map((player, index) => (
                <motion.div
                  key={player.id}
                  initial={{ opacity: 0, x: -20 }}
                  animate={{ opacity: 1, x: 0 }}
                  transition={{ delay: index * 0.02 }}
                >
                  <Card>
                    <CardContent className="flex items-center gap-4 p-4">
                      <span className="w-8 text-center font-mono text-muted-foreground">
                        #{index + 1}
                      </span>
                      <div className="flex-1">
                        <p className="font-mono font-semibold">{player.username}</p>
                        <p className="text-xs text-muted-foreground">
                          Joined {new Date(player.created_at).toLocaleDateString()}
                        </p>
                      </div>
                      <div className="text-right">
                        <p className="font-mono font-bold text-primary">{player.total_score}</p>
                        <p className="text-xs text-muted-foreground">points</p>
                      </div>
                    </CardContent>
                  </Card>
                </motion.div>
              ))}
            </div>
          </TabsContent>
        </Tabs>
      </div>
    </Layout>
  );
}
