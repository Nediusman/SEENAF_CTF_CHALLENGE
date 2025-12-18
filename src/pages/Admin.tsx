import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { motion, AnimatePresence } from 'framer-motion';
import { 
  Plus, Pencil, Trash2, Users, Flag, Settings, Loader2, X, 
  Copy, Download, Upload, ToggleLeft, ToggleRight, Shield, 
  Ban, RotateCcw, BarChart3, Eye, EyeOff, CheckSquare, Square,
  FileText, Link, TestTube
} from 'lucide-react';
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
import { setupSampleChallenges, clearAllChallenges } from '@/utils/setupChallenges';
import { loadBasicChallenges } from '@/utils/basicChallenges';

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
  author: string;
  instance_url: string;
}

const initialForm: ChallengeForm = {
  title: '',
  description: '',
  category: 'Web',
  difficulty: 'easy',
  points: 100,
  flag: '',
  hints: '',
  author: '',
  instance_url: '',
};

export default function Admin() {
  const [challenges, setChallenges] = useState<Challenge[]>([]);
  const [users, setUsers] = useState<Profile[]>([]);
  const [loading, setLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [form, setForm] = useState<ChallengeForm>(initialForm);
  const [submitting, setSubmitting] = useState(false);
  const [setupLoading, setSetupLoading] = useState(false);
  const [selectedChallenges, setSelectedChallenges] = useState<Set<string>>(new Set());
  const [bulkOperating, setBulkOperating] = useState(false);
  const [showStats, setShowStats] = useState(false);
  const [stats, setStats] = useState<any>(null);
  const [emergencyAdminMode, setEmergencyAdminMode] = useState(false);
  const [userChallenges, setUserChallenges] = useState<any[]>([]);
  const [loadingUserChallenges, setLoadingUserChallenges] = useState(false);

  const { user, role, loading: authLoading } = useAuth();
  const navigate = useNavigate();
  const { toast } = useToast();

  useEffect(() => {
    if (!authLoading) {
      if (!user) {
        navigate('/auth');
      } else if (role !== 'admin' && !emergencyAdminMode && user?.email !== 'nediusman@gmail.com') {
        navigate('/challenges');
        toast({
          title: "Access denied",
          description: "You don't have admin privileges.",
          variant: "destructive",
        });
      }
    }
  }, [user, role, authLoading, navigate, toast, emergencyAdminMode]);

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
      console.log('💾 Saving challenge:', { editingId, form, user: user?.id, role, emergencyMode: emergencyAdminMode });
      
      // Verify admin permissions first (allow emergency mode for admin email)
      if (role !== 'admin' && !emergencyAdminMode && user?.email !== 'nediusman@gmail.com') {
        throw new Error('Admin permissions required. Your current role: ' + (role || 'none'));
      }

      const hints = form.hints.split('\n').filter(h => h.trim());
      const challengeData = {
        title: form.title,
        description: form.description,
        category: form.category,
        difficulty: form.difficulty,
        points: form.points,
        flag: form.flag,
        hints: hints.length > 0 ? hints : null,
        author: form.author || null,
        instance_url: form.instance_url || null,
        is_active: true, // Ensure new challenges are active by default
      };

      console.log('📝 Challenge data to save:', challengeData);

      if (editingId) {
        console.log('✏️ Updating challenge:', editingId);
        const { data, error } = await supabase
          .from('challenges')
          .update(challengeData)
          .eq('id', editingId)
          .select();
        
        console.log('📊 Update result:', { data, error });
        
        if (error) {
          console.error('❌ Update error details:', {
            message: error.message,
            details: error.details,
            hint: error.hint,
            code: error.code
          });
          
          // Provide specific error messages
          if (error.code === '42501') {
            throw new Error('Database permission denied. Please run the emergency-admin-fix-v2.sql script in your Supabase dashboard.');
          } else if (error.code === '23505') {
            throw new Error('A challenge with this title already exists.');
          } else {
            throw error;
          }
        }
        
        toast({ 
          title: "Challenge updated successfully",
          description: `Updated "${form.title}"`
        });
      } else {
        console.log('➕ Creating new challenge');
        const { data, error } = await supabase
          .from('challenges')
          .insert(challengeData)
          .select();
        
        console.log('📊 Insert result:', { data, error });
        
        if (error) {
          console.error('❌ Insert error details:', {
            message: error.message,
            details: error.details,
            hint: error.hint,
            code: error.code
          });
          
          // Provide specific error messages
          if (error.code === '42501') {
            throw new Error('Database permission denied. Please run the emergency-admin-fix-v2.sql script in your Supabase dashboard.');
          } else if (error.code === '23505') {
            throw new Error('A challenge with this title already exists.');
          } else {
            throw error;
          }
        }
        
        toast({ 
          title: "Challenge created successfully",
          description: `Created "${form.title}"`
        });
      }

      setShowForm(false);
      setEditingId(null);
      setForm(initialForm);
      await fetchData();
    } catch (error: any) {
      console.error('💥 Challenge save failed:', error);
      toast({
        title: "Error saving challenge",
        description: error.message || "Database permission error. Run emergency-admin-fix-v2.sql in Supabase dashboard.",
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
      author: challenge.author || '',
      instance_url: challenge.instance_url || '',
    });
    setEditingId(challenge.id);
    setShowForm(true);
  };

  const handleDelete = async (id: string) => {
    if (!confirm('Are you sure you want to delete this challenge?')) return;

    try {
      console.log('🗑️ Deleting challenge:', { id, user: user?.id, role, emergencyMode: emergencyAdminMode });
      
      // Verify admin permissions first (allow emergency mode for admin email)
      if (role !== 'admin' && !emergencyAdminMode && user?.email !== 'nediusman@gmail.com') {
        throw new Error('Admin permissions required. Your current role: ' + (role || 'none'));
      }
      
      const { data, error } = await supabase
        .from('challenges')
        .delete()
        .eq('id', id)
        .select();
      
      console.log('📊 Delete result:', { data, error });
      
      if (error) {
        console.error('❌ Delete error details:', {
          message: error.message,
          details: error.details,
          hint: error.hint,
          code: error.code
        });
        
        if (error.code === '42501') {
          throw new Error('Database permission denied. Please run the emergency-admin-fix-v2.sql script in your Supabase dashboard.');
        } else {
          throw error;
        }
      }
      
      toast({ 
        title: "Challenge deleted successfully",
        description: `Deleted challenge`
      });
      
      await fetchData();
    } catch (error: any) {
      console.error('💥 Delete failed:', error);
      toast({
        title: "Error deleting challenge",
        description: error.message || "Run emergency-admin-fix-v2.sql in Supabase dashboard.",
        variant: "destructive",
      });
    }
  };

  const handleSetupSampleChallenges = async () => {
    if (!confirm('This will add sample challenges to your database. Continue?')) return;
    
    setSetupLoading(true);
    try {
      const result = await setupSampleChallenges();
      if (result.success) {
        toast({ 
          title: "Sample challenges added!", 
          description: "6 sample challenges have been added to your database." 
        });
        fetchData();
      } else {
        throw new Error('Setup failed');
      }
    } catch (error: any) {
      toast({
        title: "Setup failed",
        description: error.message || "Failed to add sample challenges",
        variant: "destructive",
      });
    } finally {
      setSetupLoading(false);
    }
  };

  const handleLoadBasicChallenges = async () => {
    if (!confirm('This will replace all existing challenges with 16 CTF challenges. Continue?')) return;
    
    setSetupLoading(true);
    try {
      const result = await loadBasicChallenges();
      if (result.success) {
        toast({ 
          title: "CTF challenges loaded!", 
          description: `${result.count} challenges have been added to your database.` 
        });
        fetchData();
      } else {
        throw new Error(result.error || 'Load failed');
      }
    } catch (error: any) {
      toast({
        title: "Load failed",
        description: error.message || "Failed to load CTF challenges",
        variant: "destructive",
      });
    } finally {
      setSetupLoading(false);
    }
  };

  // Enhanced Admin Functions
  const handleBulkDelete = async () => {
    if (selectedChallenges.size === 0) return;
    if (!confirm(`Delete ${selectedChallenges.size} selected challenges?`)) return;

    setBulkOperating(true);
    try {
      const { error } = await supabase
        .from('challenges')
        .delete()
        .in('id', Array.from(selectedChallenges));

      if (error) throw error;
      toast({ title: `${selectedChallenges.size} challenges deleted` });
      setSelectedChallenges(new Set());
      fetchData();
    } catch (error) {
      toast({
        title: "Bulk delete failed",
        variant: "destructive",
      });
    } finally {
      setBulkOperating(false);
    }
  };

  const handleToggleActive = async (challengeId: string, currentStatus: boolean) => {
    try {
      console.log('🔄 Toggling challenge status:', { challengeId, currentStatus, newStatus: !currentStatus });
      
      const { data, error } = await supabase
        .from('challenges')
        .update({ is_active: !currentStatus })
        .eq('id', challengeId)
        .select();

      console.log('📊 Toggle result:', { data, error });

      if (error) {
        console.error('❌ Toggle error:', error);
        throw error;
      }

      toast({ 
        title: `Challenge ${!currentStatus ? 'activated' : 'deactivated'}`,
        description: `Status updated successfully`
      });
      
      // Refresh data to show changes
      await fetchData();
    } catch (error: any) {
      console.error('💥 Toggle failed:', error);
      toast({
        title: "Failed to toggle challenge status",
        description: error.message || "Database error occurred",
        variant: "destructive",
      });
    }
  };

  const handleDuplicate = (challenge: Challenge) => {
    setForm({
      title: `${challenge.title} (Copy)`,
      description: challenge.description,
      category: challenge.category,
      difficulty: challenge.difficulty,
      points: challenge.points,
      flag: challenge.flag,
      hints: challenge.hints?.join('\n') || '',
      author: challenge.author || '',
      instance_url: challenge.instance_url || '',
    });
    setEditingId(null);
    setShowForm(true);
  };

  const handleExportChallenges = () => {
    const exportData = challenges.map(c => ({
      title: c.title,
      description: c.description,
      category: c.category,
      difficulty: c.difficulty,
      points: c.points,
      flag: c.flag,
      hints: c.hints,
      author: c.author,
      instance_url: c.instance_url,
    }));

    const blob = new Blob([JSON.stringify(exportData, null, 2)], { type: 'application/json' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `seenaf-ctf-challenges-${new Date().toISOString().split('T')[0]}.json`;
    a.click();
    URL.revokeObjectURL(url);
  };

  const handlePromoteUser = async (userId: string, username: string) => {
    if (!confirm(`Promote ${username} to admin?`)) return;

    try {
      console.log('👑 Promoting user to admin:', { userId, username });
      
      const { data, error } = await supabase
        .from('user_roles')
        .upsert({ user_id: userId, role: 'admin' })
        .select();

      console.log('📊 Promotion result:', { data, error });

      if (error) {
        console.error('❌ Promotion error:', error);
        throw error;
      }

      toast({ 
        title: `${username} promoted to admin`,
        description: "User role updated successfully"
      });
      
      await fetchData();
    } catch (error: any) {
      console.error('💥 Promotion failed:', error);
      toast({
        title: "Failed to promote user",
        description: error.message || "Database error occurred",
        variant: "destructive",
      });
    }
  };

  const handleResetUserScore = async (userId: string, username: string) => {
    if (!confirm(`Reset ${username}'s score to 0?`)) return;

    try {
      console.log('🔄 Resetting user score:', { userId, username });
      
      const { data, error } = await supabase
        .from('profiles')
        .update({ total_score: 0 })
        .eq('id', userId)
        .select();

      console.log('📊 Score reset result:', { data, error });

      if (error) {
        console.error('❌ Score reset error:', error);
        throw error;
      }

      toast({ 
        title: `${username}'s score reset`,
        description: "Score updated to 0 points"
      });
      
      await fetchData();
    } catch (error: any) {
      console.error('💥 Score reset failed:', error);
      toast({
        title: "Failed to reset score",
        description: error.message || "Database error occurred",
        variant: "destructive",
      });
    }
  };

  const handleRemoveUserFromChallenges = async (userId: string, username: string) => {
    if (!confirm(`Remove ${username} from ALL challenges? This will delete all their submissions and reset their progress.`)) return;

    try {
      console.log('🚫 Removing user from all challenges:', { userId, username });
      
      // Delete all submissions for this user
      const { data: deletedSubmissions, error: deleteError } = await supabase
        .from('submissions')
        .delete()
        .eq('user_id', userId)
        .select();

      if (deleteError) {
        console.error('❌ Delete submissions error:', deleteError);
        throw deleteError;
      }

      // Reset their score to 0
      const { data: updatedProfile, error: updateError } = await supabase
        .from('profiles')
        .update({ total_score: 0 })
        .eq('id', userId)
        .select();

      if (updateError) {
        console.error('❌ Update profile error:', updateError);
        throw updateError;
      }

      console.log('📊 User removal result:', { 
        deletedSubmissions: deletedSubmissions?.length || 0, 
        updatedProfile 
      });

      toast({ 
        title: `${username} removed from all challenges`,
        description: `Deleted ${deletedSubmissions?.length || 0} submissions and reset score to 0`
      });
      
      await fetchData();
    } catch (error: any) {
      console.error('💥 User removal failed:', error);
      toast({
        title: "Failed to remove user from challenges",
        description: error.message || "Database error occurred",
        variant: "destructive",
      });
    }
  };

  const handleRemoveUserFromSpecificChallenge = async (userId: string, challengeId: string, username: string, challengeTitle: string) => {
    if (!confirm(`Remove ${username} from "${challengeTitle}"? This will delete their submission for this challenge.`)) return;

    try {
      console.log('🚫 Removing user from specific challenge:', { userId, challengeId, username, challengeTitle });
      
      // Delete submission for this specific challenge
      const { data: deletedSubmission, error: deleteError } = await supabase
        .from('submissions')
        .delete()
        .eq('user_id', userId)
        .eq('challenge_id', challengeId)
        .select();

      if (deleteError) {
        console.error('❌ Delete specific submission error:', deleteError);
        throw deleteError;
      }

      // Recalculate user's total score
      const { data: userSubmissions, error: fetchError } = await supabase
        .from('submissions')
        .select(`
          challenge_id,
          challenges!inner(points)
        `)
        .eq('user_id', userId)
        .eq('is_correct', true);

      if (fetchError) {
        console.error('❌ Fetch user submissions error:', fetchError);
        throw fetchError;
      }

      const newTotalScore = userSubmissions?.reduce((sum, sub: any) => sum + (sub.challenges?.points || 0), 0) || 0;

      // Update user's score
      const { data: updatedProfile, error: updateError } = await supabase
        .from('profiles')
        .update({ total_score: newTotalScore })
        .eq('id', userId)
        .select();

      if (updateError) {
        console.error('❌ Update profile error:', updateError);
        throw updateError;
      }

      console.log('📊 Specific challenge removal result:', { 
        deletedSubmission: deletedSubmission?.length || 0, 
        newTotalScore,
        updatedProfile 
      });

      toast({ 
        title: `${username} removed from "${challengeTitle}"`,
        description: `Submission deleted. New score: ${newTotalScore} points`
      });
      
      await fetchData();
    } catch (error: any) {
      console.error('💥 Specific challenge removal failed:', error);
      toast({
        title: "Failed to remove user from challenge",
        description: error.message || "Database error occurred",
        variant: "destructive",
      });
    }
  };

  const fetchStats = async () => {
    try {
      const [challengeStats, userStats, submissionStats] = await Promise.all([
        supabase.from('challenges').select('category, difficulty, is_active'),
        supabase.from('profiles').select('total_score, created_at'),
        supabase.from('submissions').select('is_correct, submitted_at')
      ]);

      const stats = {
        challenges: {
          total: challengeStats.data?.length || 0,
          active: challengeStats.data?.filter(c => c.is_active).length || 0,
          byCategory: challengeStats.data?.reduce((acc: any, c) => {
            acc[c.category] = (acc[c.category] || 0) + 1;
            return acc;
          }, {}) || {},
          byDifficulty: challengeStats.data?.reduce((acc: any, c) => {
            acc[c.difficulty] = (acc[c.difficulty] || 0) + 1;
            return acc;
          }, {}) || {},
        },
        users: {
          total: userStats.data?.length || 0,
          avgScore: userStats.data?.reduce((sum, u) => sum + u.total_score, 0) / (userStats.data?.length || 1) || 0,
        },
        submissions: {
          total: submissionStats.data?.length || 0,
          correct: submissionStats.data?.filter(s => s.is_correct).length || 0,
        }
      };

      setStats(stats);
    } catch (error) {
      console.error('Error fetching stats:', error);
    }
  };

  const fetchUserChallenges = async () => {
    setLoadingUserChallenges(true);
    try {
      // Get all users with their solved challenges
      const { data: submissions, error } = await supabase
        .from('submissions')
        .select(`
          user_id,
          challenge_id,
          is_correct,
          submitted_at,
          profiles!inner(username),
          challenges!inner(title, points, category, difficulty)
        `)
        .eq('is_correct', true)
        .order('submitted_at', { ascending: false });

      if (error) throw error;

      // Group by user
      const userChallengeMap = submissions?.reduce((acc: any, sub: any) => {
        const userId = sub.user_id;
        if (!acc[userId]) {
          acc[userId] = {
            userId,
            username: sub.profiles?.username || 'Unknown',
            solvedChallenges: []
          };
        }
        acc[userId].solvedChallenges.push({
          challengeId: sub.challenge_id,
          challengeTitle: sub.challenges?.title || 'Unknown',
          points: sub.challenges?.points || 0,
          category: sub.challenges?.category || 'Unknown',
          difficulty: sub.challenges?.difficulty || 'easy',
          solvedAt: sub.submitted_at
        });
        return acc;
      }, {}) || {};

      setUserChallenges(Object.values(userChallengeMap));
    } catch (error) {
      console.error('Error fetching user challenges:', error);
      toast({
        title: "Failed to load user challenges",
        description: "Could not fetch user-challenge data",
        variant: "destructive",
      });
    } finally {
      setLoadingUserChallenges(false);
    }
  };

  const handleSelectAll = () => {
    if (selectedChallenges.size === challenges.length) {
      setSelectedChallenges(new Set());
    } else {
      setSelectedChallenges(new Set(challenges.map(c => c.id)));
    }
  };

  const handleSelectChallenge = (challengeId: string) => {
    const newSelected = new Set(selectedChallenges);
    if (newSelected.has(challengeId)) {
      newSelected.delete(challengeId);
    } else {
      newSelected.add(challengeId);
    }
    setSelectedChallenges(newSelected);
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

        {/* Admin Debug Panel */}
        <Card className="mb-6 bg-blue-500/10 border-blue-500/30">
          <CardContent className="p-4">
            <h3 className="text-blue-400 font-bold mb-2">🔧 Admin Debug Panel</h3>
            <div className="grid grid-cols-2 md:grid-cols-4 gap-4 text-sm">
              <div>
                <strong>User:</strong> {user?.email}
              </div>
              <div>
                <strong>Role:</strong> {role || 'Loading...'}
              </div>
              <div>
                <strong>User ID:</strong> {user?.id}
              </div>
              <div>
                <strong>Auth Status:</strong> {authLoading ? 'Loading' : 'Ready'}
              </div>
            </div>
            <div className="mt-2 flex gap-2">
              <Button 
                onClick={fetchData} 
                size="sm" 
                variant="outline"
              >
                🔄 Refresh Data
              </Button>
              <Button 
                onClick={async () => {
                  try {
                    const { data, error } = await supabase.from('challenges').select('id, title, is_active').limit(5);
                    console.log('🧪 Test query result:', { data, error });
                    toast({
                      title: "Test Query Complete",
                      description: `Found ${data?.length || 0} challenges. Check console for details.`,
                    });
                  } catch (error) {
                    console.error('🧪 Test query failed:', error);
                  }
                }}
                size="sm" 
                variant="outline"
              >
                🧪 Test Database
              </Button>
              <Button 
                onClick={async () => {
                  try {
                    // Test admin permissions by trying to update a challenge
                    const { data: challenges } = await supabase.from('challenges').select('id, is_active').limit(1);
                    if (challenges && challenges.length > 0) {
                      const testChallenge = challenges[0];
                      const { data, error } = await supabase
                        .from('challenges')
                        .update({ is_active: testChallenge.is_active }) // Update with same value (safe test)
                        .eq('id', testChallenge.id)
                        .select();
                      
                      console.log('🔑 Admin permission test:', { data, error });
                      toast({
                        title: error ? "Admin Test Failed" : "Admin Test Passed",
                        description: error ? error.message : "You have admin update permissions",
                        variant: error ? "destructive" : "default"
                      });
                    }
                  } catch (error: any) {
                    console.error('🔑 Admin test failed:', error);
                    toast({
                      title: "Admin Test Failed",
                      description: error.message,
                      variant: "destructive"
                    });
                  }
                }}
                size="sm" 
                variant="outline"
              >
                🔑 Test Admin Permissions
              </Button>
              <Button 
                onClick={async () => {
                  if (!user) return;
                  try {
                    const { data, error } = await supabase
                      .from('user_roles')
                      .upsert({ user_id: user.id, role: 'admin' })
                      .select();
                    
                    console.log('👑 Force admin role result:', { data, error });
                    
                    if (error) throw error;
                    
                    toast({
                      title: "Admin Role Set",
                      description: "Refreshing page to apply changes...",
                    });
                    
                    // Refresh the page to reload auth state
                    setTimeout(() => window.location.reload(), 1000);
                  } catch (error: any) {
                    console.error('👑 Force admin failed:', error);
                    toast({
                      title: "Failed to Set Admin Role",
                      description: error.message,
                      variant: "destructive"
                    });
                  }
                }}
                size="sm" 
                variant="default"
              >
                👑 Force Admin Role
              </Button>
              <Button 
                onClick={() => {
                  // Emergency admin mode - copy SQL to clipboard
                  const sqlScript = `-- EMERGENCY ADMIN FIX - Copy this and run in Supabase SQL Editor

-- Step 1: Disable RLS completely
ALTER TABLE challenges DISABLE ROW LEVEL SECURITY;
ALTER TABLE user_roles DISABLE ROW LEVEL SECURITY;
ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;

-- Step 2: Grant all permissions
GRANT ALL ON ALL TABLES IN SCHEMA public TO authenticated;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO authenticated;

-- Step 3: Create/update admin role
INSERT INTO user_roles (user_id, role)
SELECT id, 'admin' FROM auth.users WHERE email = 'nediusman@gmail.com'
ON CONFLICT (user_id) DO UPDATE SET role = 'admin';

-- Step 4: Verify
SELECT 'Admin setup complete' as status;`;

                  navigator.clipboard.writeText(sqlScript).then(() => {
                    toast({
                      title: "SQL Script Copied!",
                      description: "Paste this into your Supabase SQL Editor and run it.",
                    });
                  }).catch(() => {
                    toast({
                      title: "Copy Failed",
                      description: "Please manually copy the SQL from direct-uuid-fix.sql file.",
                      variant: "destructive"
                    });
                  });
                }}
                size="sm" 
                variant="destructive"
              >
                🚨 Emergency SQL Fix
              </Button>
              {user?.email === 'nediusman@gmail.com' && (
                <Button 
                  onClick={() => {
                    setEmergencyAdminMode(!emergencyAdminMode);
                    toast({
                      title: emergencyAdminMode ? "Emergency Mode Disabled" : "Emergency Mode Enabled",
                      description: emergencyAdminMode ? "Normal role checks restored" : "Bypassing role checks for admin functions",
                      variant: emergencyAdminMode ? "default" : "destructive"
                    });
                  }}
                  size="sm" 
                  variant={emergencyAdminMode ? "destructive" : "outline"}
                >
                  {emergencyAdminMode ? "🔓 Disable Emergency Mode" : "🔒 Enable Emergency Mode"}
                </Button>
              )}
            </div>
            {emergencyAdminMode && (
              <div className="mt-3 p-3 bg-red-500/20 border border-red-500/30 rounded-lg">
                <p className="text-red-400 text-sm font-bold">
                  ⚠️ EMERGENCY ADMIN MODE ACTIVE - Role checks bypassed for nediusman@gmail.com
                </p>
              </div>
            )}
          </CardContent>
        </Card>

        <Tabs defaultValue="challenges" className="space-y-6">
          <TabsList className="bg-secondary/50">
            <TabsTrigger value="challenges" className="gap-2">
              <Flag className="h-4 w-4" />
              Challenges ({challenges.length})
            </TabsTrigger>
            <TabsTrigger value="users" className="gap-2">
              <Users className="h-4 w-4" />
              Users ({users.length})
            </TabsTrigger>
            <TabsTrigger value="user-challenges" className="gap-2">
              <Ban className="h-4 w-4" />
              User-Challenge Management
            </TabsTrigger>
            <TabsTrigger value="stats" className="gap-2" onClick={() => !showStats && fetchStats()}>
              <BarChart3 className="h-4 w-4" />
              Statistics
            </TabsTrigger>
          </TabsList>

          <TabsContent value="challenges">
            <div className="flex flex-col gap-4 mb-6">
              <div className="flex justify-between items-center">
                <h2 className="font-mono text-xl">Challenge Management</h2>
                <div className="flex gap-2">
                  {challenges.length === 0 && (
                    <>
                      <Button
                        variant="default"
                        onClick={handleLoadBasicChallenges}
                        disabled={setupLoading}
                      >
                        {setupLoading ? (
                          <Loader2 className="h-4 w-4 animate-spin" />
                        ) : (
                          <>
                            <Flag className="h-4 w-4" />
                            Load CTF Challenges
                          </>
                        )}
                      </Button>
                      <Button
                        variant="outline"
                        onClick={handleSetupSampleChallenges}
                        disabled={setupLoading}
                        size="sm"
                      >
                        {setupLoading ? (
                          <Loader2 className="h-4 w-4 animate-spin" />
                        ) : (
                          'Add Basic Challenges'
                        )}
                      </Button>
                    </>
                  )}
                  <Button
                    variant="default"
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
              </div>

              {/* Bulk Operations */}
              {challenges.length > 0 && (
                <div className="flex items-center justify-between p-4 bg-secondary/20 rounded-lg border">
                  <div className="flex items-center gap-4">
                    <Button
                      variant="ghost"
                      size="sm"
                      onClick={handleSelectAll}
                      className="gap-2"
                    >
                      {selectedChallenges.size === challenges.length ? (
                        <CheckSquare className="h-4 w-4" />
                      ) : (
                        <Square className="h-4 w-4" />
                      )}
                      Select All ({selectedChallenges.size}/{challenges.length})
                    </Button>
                  </div>
                  
                  <div className="flex gap-2">
                    <Button
                      variant="outline"
                      size="sm"
                      onClick={handleExportChallenges}
                      className="gap-2"
                    >
                      <Download className="h-4 w-4" />
                      Export All
                    </Button>
                    
                    {selectedChallenges.size > 0 && (
                      <Button
                        variant="destructive"
                        size="sm"
                        onClick={handleBulkDelete}
                        disabled={bulkOperating}
                        className="gap-2"
                      >
                        {bulkOperating ? (
                          <Loader2 className="h-4 w-4 animate-spin" />
                        ) : (
                          <Trash2 className="h-4 w-4" />
                        )}
                        Delete Selected ({selectedChallenges.size})
                      </Button>
                    )}
                  </div>
                </div>
              )}
            </div>



            <AnimatePresence>
              {showForm && (
                <motion.div
                  initial={{ opacity: 0, height: 0 }}
                  animate={{ opacity: 1, height: 'auto' }}
                  exit={{ opacity: 0, height: 0 }}
                  className="mb-6"
                >
                  <Card className="glass border-primary/20">
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
                              {['Web', 'Crypto', 'Forensics', 'Network', 'Reverse', 'Pwn', 'OSINT', 'Stego', 'Misc'].map(cat => (
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
                        <Input
                          placeholder="Author (optional)"
                          value={form.author}
                          onChange={(e) => setForm({ ...form, author: e.target.value })}
                        />
                        <Input
                          placeholder="Instance URL (optional)"
                          value={form.instance_url}
                          onChange={(e) => setForm({ ...form, instance_url: e.target.value })}
                          className="md:col-span-2"
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
                          <Button type="submit" variant="default" disabled={submitting}>
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
                  <Card className={cn(
                    "hover:border-primary/30 transition-colors",
                    selectedChallenges.has(challenge.id) && "border-primary/50 bg-primary/5"
                  )}>
                    <CardContent className="flex items-center gap-4 p-4">
                      <Button
                        variant="ghost"
                        size="icon"
                        onClick={() => handleSelectChallenge(challenge.id)}
                        className="flex-shrink-0"
                      >
                        {selectedChallenges.has(challenge.id) ? (
                          <CheckSquare className="h-4 w-4 text-primary" />
                        ) : (
                          <Square className="h-4 w-4" />
                        )}
                      </Button>

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
                          {challenge.instance_url && (
                            <Badge variant="outline" className="text-xs bg-blue-500/10 text-blue-400">
                              <Link className="h-3 w-3 mr-1" />
                              URL
                            </Badge>
                          )}
                        </div>
                        <p className="text-sm text-muted-foreground line-clamp-1">{challenge.description}</p>
                        <div className="flex items-center gap-4 mt-2 text-xs text-muted-foreground">
                          <span>Flag: {challenge.flag}</span>
                          {challenge.author && <span>Author: {challenge.author}</span>}
                          {challenge.hints && <span>Hints: {challenge.hints.length}</span>}
                        </div>
                      </div>

                      <div className="text-right">
                        <p className="font-mono font-bold text-primary">{challenge.points} pts</p>
                        <p className="text-xs text-muted-foreground">
                          {new Date(challenge.created_at).toLocaleDateString()}
                        </p>
                      </div>

                      <div className="flex gap-1">
                        <Button
                          variant="ghost"
                          size="icon"
                          onClick={() => handleToggleActive(challenge.id, challenge.is_active)}
                          title={challenge.is_active ? 'Deactivate' : 'Activate'}
                        >
                          {challenge.is_active ? (
                            <EyeOff className="h-4 w-4 text-orange-500" />
                          ) : (
                            <Eye className="h-4 w-4 text-green-500" />
                          )}
                        </Button>
                        <Button
                          variant="ghost"
                          size="icon"
                          onClick={() => handleDuplicate(challenge)}
                          title="Duplicate"
                        >
                          <Copy className="h-4 w-4" />
                        </Button>
                        <Button
                          variant="ghost"
                          size="icon"
                          onClick={() => handleEdit(challenge)}
                          title="Edit"
                        >
                          <Pencil className="h-4 w-4" />
                        </Button>
                        <Button
                          variant="ghost"
                          size="icon"
                          onClick={() => handleDelete(challenge.id)}
                          title="Delete"
                        >
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
            <div className="flex justify-between items-center mb-6">
              <h2 className="font-mono text-xl">User Management ({users.length})</h2>
              <div className="flex gap-2">
                <Button
                  variant="outline"
                  size="sm"
                  onClick={fetchUserChallenges}
                  disabled={loadingUserChallenges}
                >
                  {loadingUserChallenges ? (
                    <Loader2 className="h-4 w-4 animate-spin mr-2" />
                  ) : (
                    <Ban className="h-4 w-4 mr-2" />
                  )}
                  Load Challenge Data
                </Button>
              </div>
            </div>

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
                        <div className="flex items-center gap-2">
                          <p className="font-mono font-semibold">{player.username}</p>
                          {player.id === user?.id && (
                            <Badge variant="outline" className="text-xs">You</Badge>
                          )}
                        </div>
                        <p className="text-xs text-muted-foreground">
                          Joined {new Date(player.created_at).toLocaleDateString()}
                        </p>
                        <p className="text-xs text-muted-foreground">
                          ID: {player.id}
                        </p>
                      </div>
                      <div className="text-right">
                        <p className="font-mono font-bold text-primary">{player.total_score}</p>
                        <p className="text-xs text-muted-foreground">points</p>
                      </div>
                      <div className="flex gap-1">
                        {player.id !== user?.id && (
                          <>
                            <Button
                              variant="ghost"
                              size="icon"
                              onClick={() => handlePromoteUser(player.id, player.username)}
                              title="Promote to Admin"
                            >
                              <Shield className="h-4 w-4 text-blue-500" />
                            </Button>
                            <Button
                              variant="ghost"
                              size="icon"
                              onClick={() => handleResetUserScore(player.id, player.username)}
                              title="Reset Score"
                            >
                              <RotateCcw className="h-4 w-4 text-orange-500" />
                            </Button>
                            <Button
                              variant="ghost"
                              size="icon"
                              onClick={() => handleRemoveUserFromChallenges(player.id, player.username)}
                              title="Remove from All Challenges"
                            >
                              <Ban className="h-4 w-4 text-red-500" />
                            </Button>
                          </>
                        )}
                      </div>
                    </CardContent>
                  </Card>
                </motion.div>
              ))}
            </div>
          </TabsContent>

          <TabsContent value="user-challenges">
            <div className="flex justify-between items-center mb-6">
              <h2 className="font-mono text-xl">User-Challenge Management</h2>
              <Button onClick={fetchUserChallenges} variant="outline" size="sm" disabled={loadingUserChallenges}>
                {loadingUserChallenges ? (
                  <Loader2 className="h-4 w-4 animate-spin mr-2" />
                ) : (
                  <RotateCcw className="h-4 w-4 mr-2" />
                )}
                Load Data
              </Button>
            </div>

            {loadingUserChallenges ? (
              <div className="flex items-center justify-center py-12">
                <Loader2 className="h-8 w-8 animate-spin text-primary" />
              </div>
            ) : userChallenges.length === 0 ? (
              <div className="text-center py-12">
                <Ban className="h-12 w-12 mx-auto text-muted-foreground mb-4" />
                <p className="text-muted-foreground">No user-challenge data loaded. Click "Load Data" to fetch.</p>
              </div>
            ) : (
              <div className="space-y-4">
                {userChallenges.map((userChallenge: any, index: number) => (
                  <motion.div
                    key={userChallenge.userId}
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ delay: index * 0.05 }}
                  >
                    <Card>
                      <CardHeader>
                        <div className="flex items-center justify-between">
                          <div>
                            <CardTitle className="flex items-center gap-2">
                              <Users className="h-5 w-5" />
                              {userChallenge.username}
                            </CardTitle>
                            <p className="text-sm text-muted-foreground">
                              {userChallenge.solvedChallenges.length} challenges solved
                            </p>
                          </div>
                          <Button
                            variant="destructive"
                            size="sm"
                            onClick={() => handleRemoveUserFromChallenges(userChallenge.userId, userChallenge.username)}
                          >
                            <Ban className="h-4 w-4 mr-2" />
                            Remove from All
                          </Button>
                        </div>
                      </CardHeader>
                      <CardContent>
                        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3">
                          {userChallenge.solvedChallenges.map((challenge: any) => (
                            <div
                              key={challenge.challengeId}
                              className="flex items-center justify-between p-3 rounded-lg bg-secondary/20 border"
                            >
                              <div className="flex-1">
                                <div className="flex items-center gap-2 mb-1">
                                  <p className="font-mono text-sm font-semibold">{challenge.challengeTitle}</p>
                                  <Badge variant="outline" className="text-xs">{challenge.category}</Badge>
                                </div>
                                <div className="flex items-center gap-2 text-xs text-muted-foreground">
                                  <Badge className={cn("border text-xs", difficultyConfig[challenge.difficulty]?.color)}>
                                    {challenge.difficulty}
                                  </Badge>
                                  <span>{challenge.points} pts</span>
                                  <span>{new Date(challenge.solvedAt).toLocaleDateString()}</span>
                                </div>
                              </div>
                              <Button
                                variant="ghost"
                                size="icon"
                                onClick={() => handleRemoveUserFromSpecificChallenge(
                                  userChallenge.userId,
                                  challenge.challengeId,
                                  userChallenge.username,
                                  challenge.challengeTitle
                                )}
                                title="Remove from this challenge"
                              >
                                <X className="h-4 w-4 text-red-500" />
                              </Button>
                            </div>
                          ))}
                        </div>
                      </CardContent>
                    </Card>
                  </motion.div>
                ))}
              </div>
            )}
          </TabsContent>

          <TabsContent value="stats">
            <div className="flex justify-between items-center mb-6">
              <h2 className="font-mono text-xl">Platform Statistics</h2>
              <Button onClick={fetchStats} variant="outline" size="sm">
                <RotateCcw className="h-4 w-4 mr-2" />
                Refresh
              </Button>
            </div>

            {stats && (
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                {/* Challenge Statistics */}
                <Card>
                  <CardHeader>
                    <CardTitle className="flex items-center gap-2">
                      <Flag className="h-5 w-5" />
                      Challenges
                    </CardTitle>
                  </CardHeader>
                  <CardContent className="space-y-4">
                    <div className="flex justify-between">
                      <span>Total:</span>
                      <span className="font-bold">{stats.challenges.total}</span>
                    </div>
                    <div className="flex justify-between">
                      <span>Active:</span>
                      <span className="font-bold text-green-500">{stats.challenges.active}</span>
                    </div>
                    <div className="space-y-2">
                      <p className="text-sm font-semibold">By Category:</p>
                      {Object.entries(stats.challenges.byCategory).map(([cat, count]) => (
                        <div key={cat} className="flex justify-between text-sm">
                          <span>{cat}:</span>
                          <span>{count as number}</span>
                        </div>
                      ))}
                    </div>
                  </CardContent>
                </Card>

                {/* User Statistics */}
                <Card>
                  <CardHeader>
                    <CardTitle className="flex items-center gap-2">
                      <Users className="h-5 w-5" />
                      Users
                    </CardTitle>
                  </CardHeader>
                  <CardContent className="space-y-4">
                    <div className="flex justify-between">
                      <span>Total Users:</span>
                      <span className="font-bold">{stats.users.total}</span>
                    </div>
                    <div className="flex justify-between">
                      <span>Avg Score:</span>
                      <span className="font-bold">{Math.round(stats.users.avgScore)}</span>
                    </div>
                  </CardContent>
                </Card>

                {/* Submission Statistics */}
                <Card>
                  <CardHeader>
                    <CardTitle className="flex items-center gap-2">
                      <FileText className="h-5 w-5" />
                      Submissions
                    </CardTitle>
                  </CardHeader>
                  <CardContent className="space-y-4">
                    <div className="flex justify-between">
                      <span>Total:</span>
                      <span className="font-bold">{stats.submissions.total}</span>
                    </div>
                    <div className="flex justify-between">
                      <span>Correct:</span>
                      <span className="font-bold text-green-500">{stats.submissions.correct}</span>
                    </div>
                    <div className="flex justify-between">
                      <span>Success Rate:</span>
                      <span className="font-bold">
                        {stats.submissions.total > 0 
                          ? Math.round((stats.submissions.correct / stats.submissions.total) * 100)
                          : 0}%
                      </span>
                    </div>
                  </CardContent>
                </Card>

                {/* Difficulty Distribution */}
                <Card className="md:col-span-2 lg:col-span-3">
                  <CardHeader>
                    <CardTitle>Challenge Difficulty Distribution</CardTitle>
                  </CardHeader>
                  <CardContent>
                    <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                      {Object.entries(stats.challenges.byDifficulty).map(([diff, count]) => (
                        <div key={diff} className="text-center p-4 rounded-lg bg-secondary/20">
                          <div className={cn("text-2xl font-bold", difficultyConfig[diff as DifficultyLevel]?.color)}>
                            {count as number}
                          </div>
                          <div className="text-sm capitalize">{diff}</div>
                        </div>
                      ))}
                    </div>
                  </CardContent>
                </Card>
              </div>
            )}
          </TabsContent>
        </Tabs>
      </div>
    </Layout>
  );
}
