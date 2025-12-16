# SEENAF_CTF Platform - Complete Line-by-Line Code Documentation

## 📁 **FILE STRUCTURE OVERVIEW**

```
seenaf-ctf/
├── 📄 Configuration Files
│   ├── index.html                    # Main HTML entry point
│   ├── .env                         # Environment variables
│   ├── package.json                 # Dependencies and scripts
│   ├── vite.config.ts              # Vite build configuration
│   ├── tailwind.config.ts          # Tailwind CSS configuration
│   └── tsconfig.json               # TypeScript configuration
├── 🎨 Public Assets
│   ├── favicon.svg                  # Custom SEENAF_CTF favicon
│   ├── seenaf-ctf-icon.svg        # Brand icon
│   ├── manifest.json               # PWA manifest
│   └── robots.txt                  # SEO robots file
├── 🧩 React Components
│   ├── src/components/layout/       # Layout components
│   ├── src/components/challenges/   # Challenge-specific components
│   ├── src/components/ui/          # Base UI components
│   └── src/components/*.tsx        # Utility components
├── 📄 Pages
│   ├── src/pages/Index.tsx         # Landing page
│   ├── src/pages/Auth.tsx          # Authentication
│   ├── src/pages/Challenges.tsx    # Challenge browser
│   └── src/pages/Admin.tsx         # Admin panel
├── 🔧 Utilities
│   ├── src/utils/                  # Helper functions
│   ├── src/hooks/                  # Custom React hooks
│   ├── src/types/                  # TypeScript definitions
│   └── src/integrations/           # External services
└── 🗄️ Database
    ├── supabase/migrations/        # Database migrations
    └── *.sql                       # Setup scripts
```

---

## 📄 **CONFIGURATION FILES**

### **index.html** - Main HTML Entry Point
```html
<!doctype html>
<html lang="en">
  <head>
    <!-- Line 4: Character encoding for international support -->
    <meta charset="UTF-8" />
    
    <!-- Line 5: Custom SEENAF_CTF favicon -->
    <link rel="icon" type="image/svg+xml" href="/favicon.svg" />
    
    <!-- Line 6: Responsive viewport configuration -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    
    <!-- Line 7: Page title for browser tab -->
    <title>SEENAF_CTF - Cybersecurity Training Platform</title>
    
    <!-- Line 8: SEO meta description -->
    <meta name="description" content="SEENAF_CTF - Professional cybersecurity training platform with CTF challenges" />
    
    <!-- Line 9: Theme color for mobile browsers -->
    <meta name="theme-color" content="#00ff00" />
  </head>
  <body>
    <!-- Line 12: React app mount point -->
    <div id="root"></div>
    
    <!-- Line 13: Vite development server entry point -->
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
```

### **.env** - Environment Configuration
```env
# Line 1: Supabase project URL - connects to specific database instance
VITE_SUPABASE_URL="https://fsyspwfjubhxpcuqivne.supabase.co"

# Line 2: Supabase anonymous key - JWT token for client-side authentication
VITE_SUPABASE_PUBLISHABLE_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."

# Line 3: Project identifier for internal use
VITE_SUPABASE_PROJECT_ID="fsyspwfjubhxpcuqivne"
```

---

## 🎨 **PUBLIC ASSETS DOCUMENTATION**

### **manifest.json** - PWA Configuration
```json
{
  "name": "SEENAF_CTF",
  "short_name": "SEENAF_CTF", 
  "description": "Professional cybersecurity training platform",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#0a0a0a",
  "theme_color": "#00ff00",
  "icons": [
    {
      "src": "/icon-192.png",
      "sizes": "192x192", 
      "type": "image/png"
    },
    {
      "src": "/icon-512.png",
      "sizes": "512x512",
      "type": "image/png" 
    }
  ]
}
```

---

## 🧩 **REACT COMPONENTS - DETAILED DOCUMENTATION**

### **src/pages/Auth.tsx** - Authentication Page
```typescript
// Lines 1-12: Import statements for React hooks, routing, animations, icons, and utilities
import { useState, useEffect } from 'react';           // React state and lifecycle hooks
import { useNavigate } from 'react-router-dom';        // Navigation hook for routing
import { motion } from 'framer-motion';                // Animation library
import { Terminal, Mail, Lock, User, ArrowRight, Loader2 } from 'lucide-react'; // Icons
import { Button } from '@/components/ui/button';       // Custom button component
import { Input } from '@/components/ui/input';         // Custom input component
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card'; // Card components
import { useAuth } from '@/hooks/useAuth';             // Authentication hook
import { useToast } from '@/hooks/use-toast';          // Toast notification hook
import { z } from 'zod';                               // Schema validation library

// Lines 14-21: Zod validation schemas for form data
const loginSchema = z.object({
  email: z.string().email('Invalid email address'),                    // Email validation
  password: z.string().min(6, 'Password must be at least 6 characters'), // Password length check
});

const signupSchema = loginSchema.extend({
  username: z.string().min(3, 'Username must be at least 3 characters').max(20, 'Username too long'), // Username validation
});

// Lines 23-33: Component state management
export default function Auth() {
  const [isLogin, setIsLogin] = useState(true);        // Toggle between login/signup
  const [email, setEmail] = useState('');              // Email input state
  const [password, setPassword] = useState('');        // Password input state
  const [username, setUsername] = useState('');        // Username input state (signup only)
  const [loading, setLoading] = useState(false);       // Loading state for form submission
  const [errors, setErrors] = useState<Record<string, string>>({}); // Form validation errors
  
  const { user, signIn, signUp } = useAuth();          // Authentication methods from context
  const navigate = useNavigate();                      // Navigation function
  const { toast } = useToast();                        // Toast notification function

// Lines 35-39: Redirect authenticated users to challenges page
  useEffect(() => {
    if (user) {
      navigate('/challenges');                          // Redirect if already logged in
    }
  }, [user, navigate]);

// Lines 41-89: Form submission handler with validation and authentication
  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();                                 // Prevent default form submission
    setErrors({});                                      // Clear previous errors
    
    try {
      if (isLogin) {
        // Validate login form data
        const result = loginSchema.safeParse({ email, password });
        if (!result.success) {
          const fieldErrors: Record<string, string> = {};
          result.error.errors.forEach(err => {
            if (err.path[0]) fieldErrors[err.path[0] as string] = err.message;
          });
          setErrors(fieldErrors);
          return;
        }
      } else {
        // Validate signup form data
        const result = signupSchema.safeParse({ email, password, username });
        if (!result.success) {
          const fieldErrors: Record<string, string> = {};
          result.error.errors.forEach(err => {
            if (err.path[0]) fieldErrors[err.path[0] as string] = err.message;
          });
          setErrors(fieldErrors);
          return;
        }
      }

      setLoading(true);                                 // Show loading state

      if (isLogin) {
        // Handle login
        const { error } = await signIn(email, password);
        if (error) {
          toast({
            title: "Login failed",
            description: error.message || "Invalid credentials",
            variant: "destructive",
          });
        }
      } else {
        // Handle signup
        const { error } = await signUp(email, password, username);
        if (error) {
          if (error.message.includes('already registered')) {
            toast({
              title: "Account exists",
              description: "This email is already registered. Try logging in.",
              variant: "destructive",
            });
          } else {
            toast({
              title: "Signup failed",
              description: error.message,
              variant: "destructive",
            });
          }
        } else {
          toast({
            title: "Welcome, hacker!",
            description: "Account created successfully.",
          });
        }
      }
    } finally {
      setLoading(false);                                // Hide loading state
    }
  };

// Lines 91-200: JSX render with terminal-themed UI
  return (
    <div className="min-h-screen bg-background terminal-grid flex items-center justify-center p-4">
      <div className="fixed inset-0 scanline pointer-events-none" />  {/* Terminal scanline effect */}
      
      <motion.div
        initial={{ opacity: 0, y: 20 }}               // Animation: fade in from below
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5 }}
        className="w-full max-w-md relative z-10"
      >
        {/* Header with terminal icon and branding */}
        <div className="text-center mb-8">
          <motion.div
            initial={{ scale: 0 }}                     // Animation: scale from 0
            animate={{ scale: 1 }}
            transition={{ delay: 0.2, type: "spring" }}
            className="inline-flex items-center justify-center w-16 h-16 rounded-xl gradient-primary mb-4 box-glow"
          >
            <Terminal className="h-8 w-8 text-primary-foreground" />
          </motion.div>
          <h1 className="text-3xl font-mono font-bold text-primary text-glow">SEENAF_CTF</h1>
          <p className="text-muted-foreground mt-2">
            {isLogin ? 'Access your terminal' : 'Initialize new hacker profile'}
          </p>
        </div>

        {/* Authentication form card */}
        <Card variant="glow" className="glass">
          <CardHeader>
            <CardTitle className="text-center">
              {isLogin ? '> LOGIN' : '> REGISTER'}
            </CardTitle>
            <CardDescription className="text-center font-mono text-xs">
              {isLogin ? 'Enter credentials to continue...' : 'Create your hacker identity...'}
            </CardDescription>
          </CardHeader>
          <CardContent>
            <form onSubmit={handleSubmit} className="space-y-4">
              {/* Username field (signup only) */}
              {!isLogin && (
                <div className="space-y-2">
                  <div className="relative">
                    <User className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                    <Input
                      type="text"
                      placeholder="Username"
                      value={username}
                      onChange={(e) => setUsername(e.target.value)}
                      className="pl-10"
                    />
                  </div>
                  {errors.username && (
                    <p className="text-destructive text-xs font-mono">{errors.username}</p>
                  )}
                </div>
              )}
              
              {/* Email field */}
              <div className="space-y-2">
                <div className="relative">
                  <Mail className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                  <Input
                    type="email"
                    placeholder="Email"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    className="pl-10"
                  />
                </div>
                {errors.email && (
                  <p className="text-destructive text-xs font-mono">{errors.email}</p>
                )}
              </div>

              {/* Password field */}
              <div className="space-y-2">
                <div className="relative">
                  <Lock className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                  <Input
                    type="password"
                    placeholder="Password"
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    className="pl-10"
                  />
                </div>
                {errors.password && (
                  <p className="text-destructive text-xs font-mono">{errors.password}</p>
                )}
              </div>

              {/* Submit button */}
              <Button
                type="submit"
                variant="cyber"
                className="w-full"
                disabled={loading}
              >
                {loading ? (
                  <Loader2 className="h-4 w-4 animate-spin" />
                ) : (
                  <>
                    {isLogin ? 'Access Terminal' : 'Initialize Profile'}
                    <ArrowRight className="h-4 w-4" />
                  </>
                )}
              </Button>
            </form>

            {/* Toggle between login/signup */}
            <div className="mt-6 text-center">
              <button
                type="button"
                onClick={() => {
                  setIsLogin(!isLogin);
                  setErrors({});
                }}
                className="text-sm text-muted-foreground hover:text-primary transition-colors font-mono"
              >
                {isLogin ? "Don't have an account? Register" : 'Already have an account? Login'}
              </button>
            </div>
          </CardContent>
        </Card>
      </motion.div>
    </div>
  );
}
```

### **src/pages/Challenges.tsx** - Challenge Browser Page
```typescript
// Lines 1-11: Import statements for React, routing, animations, and components
import { useState, useEffect } from 'react';           // React hooks
import { useNavigate } from 'react-router-dom';        // Navigation
import { motion, AnimatePresence } from 'framer-motion'; // Animations
import { Search, Filter, Flag, Trophy } from 'lucide-react'; // Icons
import { Layout } from '@/components/layout/Layout';    // Page layout wrapper
import { Input } from '@/components/ui/input';         // Input component
import { Button } from '@/components/ui/button';       // Button component
import { Badge } from '@/components/ui/badge';         // Badge component
import { ChallengeCard } from '@/components/challenges/ChallengeCard'; // Challenge card component
import { ChallengeDetailModal } from '@/components/challenges/ChallengeDetailModal'; // Modal component
import { Challenge, DifficultyLevel } from '@/types/database'; // Type definitions
import { supabase } from '@/integrations/supabase/client'; // Database client
import { useAuth } from '@/hooks/useAuth';             // Authentication hook

// Lines 14-15: Filter options for categories and difficulties
const categories = ['All', 'Web', 'Crypto', 'Forensics', 'Network', 'Reverse', 'Pwn', 'OSINT', 'Stego', 'Misc'];
const difficulties: (DifficultyLevel | 'all')[] = ['all', 'easy', 'medium', 'hard', 'insane'];

// Lines 17-28: Component state management
export default function Challenges() {
  const [challenges, setChallenges] = useState<Challenge[]>([]); // All challenges from database
  const [solvedIds, setSolvedIds] = useState<Set<string>>(new Set()); // Set of solved challenge IDs
  const [selectedChallenge, setSelectedChallenge] = useState<Challenge | null>(null); // Currently selected challenge for modal
  const [search, setSearch] = useState('');              // Search query
  const [categoryFilter, setCategoryFilter] = useState('All'); // Selected category filter
  const [difficultyFilter, setDifficultyFilter] = useState<DifficultyLevel | 'all'>('all'); // Selected difficulty filter
  const [loading, setLoading] = useState(true);          // Loading state

  const { user, profile, loading: authLoading } = useAuth(); // Authentication state
  const navigate = useNavigate();                        // Navigation function

// Lines 30-34: Redirect unauthenticated users to auth page
  useEffect(() => {
    if (!authLoading && !user) {
      navigate('/auth');
    }
  }, [user, authLoading, navigate]);

// Lines 36-41: Fetch data when user is authenticated
  useEffect(() => {
    if (user) {
      fetchChallenges();
      fetchSolvedChallenges();
    }
  }, [user]);

// Lines 43-66: Fetch all active challenges from database
  const fetchChallenges = async () => {
    try {
      console.log('🔍 Fetching challenges...');
      const { data, error, count } = await supabase
        .from('challenges')
        .select('*', { count: 'exact' })
        .eq('is_active', true)                           // Only active challenges
        .order('points', { ascending: true });           // Order by points (easiest first)

      console.log('📊 Challenges query result:', { data, error, count });

      if (error) {
        console.error('❌ Supabase error:', error);
        throw error;
      }
      
      const challengeData = (data as Challenge[]) || [];
      console.log('✅ Setting challenges:', challengeData.length, 'challenges');
      setChallenges(challengeData);
    } catch (error) {
      console.error('💥 Error fetching challenges:', error);
    } finally {
      setLoading(false);
    }
  };

// Lines 68-83: Fetch user's solved challenges
  const fetchSolvedChallenges = async () => {
    if (!user) return;
    
    try {
      const { data, error } = await supabase
        .from('submissions')
        .select('challenge_id')
        .eq('user_id', user.id)
        .eq('is_correct', true);                         // Only correct submissions

      if (error) throw error;
      setSolvedIds(new Set(data?.map(s => s.challenge_id) || [])); // Convert to Set for O(1) lookup
    } catch (error) {
      console.error('Error fetching solved challenges:', error);
    }
  };

// Lines 85-92: Filter challenges based on search and filter criteria
  const filteredChallenges = challenges.filter(c => {
    const matchesSearch = c.title.toLowerCase().includes(search.toLowerCase()) ||
      c.description.toLowerCase().includes(search.toLowerCase());
    const matchesCategory = categoryFilter === 'All' || c.category === categoryFilter;
    const matchesDifficulty = difficultyFilter === 'all' || c.difficulty === difficultyFilter;
    return matchesSearch && matchesCategory && matchesDifficulty;
  });

// Lines 94-99: Calculate user statistics
  const totalPoints = challenges.reduce((sum, c) => sum + c.points, 0);
  const earnedPoints = challenges
    .filter(c => solvedIds.has(c.id))
    .reduce((sum, c) => sum + c.points, 0);

// Lines 101-120: Loading states
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

// Lines 122-280: Main render with header, filters, and challenge grid
  return (
    <Layout>
      <div className="container mx-auto px-4 py-8">
        {/* Header with title and statistics */}
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

            {/* Statistics badges */}
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

          {/* Search and filter controls */}
          <div className="flex flex-col lg:flex-row gap-4">
            {/* Search input */}
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

            {/* Category filter buttons */}
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

            {/* Difficulty filter buttons */}
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

        {/* Debug information for troubleshooting */}
        <div className="mb-4 p-3 bg-secondary/20 rounded border text-sm">
          <strong>Debug Info:</strong><br/>
          • Total challenges: {challenges.length}<br/>
          • Filtered challenges: {filteredChallenges.length}<br/>
          • User: {user?.email || 'Not logged in'}<br/>
          • Auth loading: {authLoading ? 'Yes' : 'No'}<br/>
          • Loading: {loading ? 'Yes' : 'No'}<br/>
          • User ID: {user?.id || 'None'}<br/>
          • Categories: {categories.join(', ')}<br/>
          • Current filter: {categoryFilter} / {difficultyFilter}
        </div>

        {/* Challenge grid or empty state */}
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
              />
            ))}
          </div>
        )}
      </div>

      {/* Challenge detail modal */}
      <AnimatePresence>
        {selectedChallenge && (
          <ChallengeDetailModal
            challenge={selectedChallenge}
            solved={solvedIds.has(selectedChallenge.id)}
            onClose={() => setSelectedChallenge(null)}
            onSolved={() => {
              fetchSolvedChallenges();                   // Refresh solved challenges when user solves one
            }}
          />
        )}
      </AnimatePresence>
    </Layout>
  );
}
```
### **src/pages/Admin.tsx** - Admin Panel Page
```typescript
// Lines 1-16: Import statements for React, routing, animations, icons, and components
import { useState, useEffect } from 'react';           // React hooks
import { useNavigate } from 'react-router-dom';        // Navigation
import { motion, AnimatePresence } from 'framer-motion'; // Animations
import { Plus, Pencil, Trash2, Users, Flag, Settings, Loader2, X } from 'lucide-react'; // Icons
import { Layout } from '@/components/layout/Layout';    // Page layout
import { Button } from '@/components/ui/button';       // UI components
import { Input } from '@/components/ui/input';
import { Textarea } from '@/components/ui/textarea';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Challenge, DifficultyLevel, Profile } from '@/types/database'; // Type definitions
import { supabase } from '@/integrations/supabase/client'; // Database client
import { useAuth } from '@/hooks/useAuth';             // Authentication
import { useToast } from '@/hooks/use-toast';          // Toast notifications
import { cn } from '@/lib/utils';                      // Utility functions
import { setupSampleChallenges, clearAllChallenges } from '@/utils/setupChallenges'; // Challenge utilities
import { DebugChallenges } from '@/components/DebugChallenges'; // Debug components
import { SupabaseDebug } from '@/components/SupabaseDebug';
import { loadBasicChallenges } from '@/utils/basicChallenges'; // Challenge loader

// Lines 18-23: Difficulty styling configuration
const difficultyConfig = {
  easy: { color: 'bg-success/20 text-success border-success/30' },
  medium: { color: 'bg-yellow-500/20 text-yellow-400 border-yellow-500/30' },
  hard: { color: 'bg-orange-500/20 text-orange-400 border-orange-500/30' },
  insane: { color: 'bg-destructive/20 text-destructive border-destructive/30' },
};

// Lines 25-35: Challenge form interface and initial state
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

// Lines 37-49: Component state management
export default function Admin() {
  const [challenges, setChallenges] = useState<Challenge[]>([]); // All challenges
  const [users, setUsers] = useState<Profile[]>([]);     // All user profiles
  const [loading, setLoading] = useState(true);          // Loading state
  const [showForm, setShowForm] = useState(false);       // Show/hide challenge form
  const [editingId, setEditingId] = useState<string | null>(null); // ID of challenge being edited
  const [form, setForm] = useState<ChallengeForm>(initialForm); // Form data
  const [submitting, setSubmitting] = useState(false);   // Form submission state
  const [setupLoading, setSetupLoading] = useState(false); // Setup operation loading

  const { user, role, loading: authLoading } = useAuth(); // Authentication state
  const navigate = useNavigate();                        // Navigation function
  const { toast } = useToast();                          // Toast notifications

// Lines 51-64: Authentication and authorization checks
  useEffect(() => {
    if (!authLoading) {
      if (!user) {
        navigate('/auth');                               // Redirect to login if not authenticated
      } else if (role !== 'admin') {
        navigate('/challenges');                         // Redirect to challenges if not admin
        toast({
          title: "Access denied",
          description: "You don't have admin privileges.",
          variant: "destructive",
        });
      }
    }
  }, [user, role, authLoading, navigate, toast]);

// Lines 66-70: Fetch data when user has admin role
  useEffect(() => {
    if (role === 'admin') {
      fetchData();
    }
  }, [role]);

// Lines 72-86: Fetch challenges and users from database
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

// Lines 88-158: Challenge form submission handler
  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    console.log('🎯 Admin submitting challenge:', form);
    console.log('🔑 Current user:', user);
    console.log('👑 Current role:', role);

    // Validate required fields
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
      // Prepare challenge data
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
      };

      console.log('📝 Challenge data to insert:', challengeData);

      if (editingId) {
        // Update existing challenge
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
        // Create new challenge
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

      // Reset form and refresh data
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

// Lines 160-171: Edit challenge handler
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

// Lines 173-186: Delete challenge handler
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

// Lines 188-208: Setup sample challenges handler
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

// Lines 210-235: Load basic CTF challenges handler
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

// Lines 237-247: Loading state render
  if (authLoading || loading) {
    return (
      <Layout>
        <div className="flex items-center justify-center min-h-[80vh]">
          <div className="text-primary font-mono animate-pulse">Loading...</div>
        </div>
      </Layout>
    );
  }

// Lines 249-500+: Main admin panel render with tabs for challenges and users
  return (
    <Layout>
      <div className="container mx-auto px-4 py-8">
        {/* Header */}
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

        {/* Tabbed interface */}
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

          {/* Challenges tab */}
          <TabsContent value="challenges">
            <div className="flex justify-between items-center mb-6">
              <h2 className="font-mono text-xl">Challenge Management</h2>
              <div className="flex gap-2">
                {/* Setup buttons (shown when no challenges exist) */}
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
                {/* Add challenge button */}
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

            {/* Debug components */}
            <SupabaseDebug />
            <DebugChallenges />
            
            {/* Quick connection test */}
            <Card className="mb-4 bg-yellow-500/10 border-yellow-500/30">
              <CardContent className="p-4">
                <h3 className="text-yellow-400 font-bold mb-2">🔧 Quick Connection Test</h3>
                <Button 
                  onClick={async () => {
                    const { testConnection } = await import('@/utils/testConnection');
                    const result = await testConnection();
                    toast({
                      title: result.success ? "Connection Works!" : "Connection Failed",
                      description: result.success 
                        ? `Found ${result.count} challenges` 
                        : `Error: ${result.error?.message}`,
                      variant: result.success ? "default" : "destructive"
                    });
                  }}
                  className="bg-yellow-600 hover:bg-yellow-700"
                >
                  🚀 Test Database Connection
                </Button>
              </CardContent>
            </Card>

            {/* Challenge form (shown when showForm is true) */}
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
                        {/* Form fields for challenge creation/editing */}
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
                        {/* Additional form fields... */}
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
                        {/* Form action buttons */}
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

            {/* Challenge list */}
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

          {/* Users tab */}
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
```
### **src/components/challenges/ChallengeDetailModal.tsx** - Challenge Detail Modal
```typescript
// Lines 1-21: Import statements for React, animations, icons, and components
import { useState, useEffect } from 'react';           // React hooks
import { motion, AnimatePresence } from 'framer-motion'; // Animations
import { 
  X, Flag, Zap, Send, Loader2, CheckCircle, XCircle, Lightbulb, User,
  Heart, Users, ExternalLink, Play, ThumbsUp
} from 'lucide-react';                                  // Icons
import { Button } from '@/components/ui/button';       // UI components
import { Input } from '@/components/ui/input';
import { Badge } from '@/components/ui/badge';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Separator } from '@/components/ui/separator';
import { Challenge } from '@/types/database';          // Type definitions
import { supabase } from '@/integrations/supabase/client'; // Database client
import { useAuth } from '@/hooks/useAuth';             // Authentication
import { useToast } from '@/hooks/use-toast';          // Toast notifications
import { cn } from '@/lib/utils';                      // Utility functions

// Lines 23-28: Component props interface
interface ChallengeDetailModalProps {
  challenge: Challenge;                                 // Challenge data
  solved?: boolean;                                     // Whether user has solved this challenge
  onClose: () => void;                                  // Close modal callback
  onSolved: () => void;                                 // Challenge solved callback
}

// Lines 30-35: Difficulty configuration for styling
const difficultyConfig = {
  easy: { color: 'bg-success/20 text-success border-success/30', label: 'Easy' },
  medium: { color: 'bg-yellow-500/20 text-yellow-400 border-yellow-500/30', label: 'Medium' },
  hard: { color: 'bg-orange-500/20 text-orange-400 border-orange-500/30', label: 'Hard' },
  insane: { color: 'bg-destructive/20 text-destructive border-destructive/30', label: 'Insane' },
};

// Lines 37-48: Component state management
export function ChallengeDetailModal({ challenge, solved, onClose, onSolved }: ChallengeDetailModalProps) {
  const [flag, setFlag] = useState('');                // User's flag input
  const [loading, setLoading] = useState(false);       // Flag submission loading
  const [result, setResult] = useState<'correct' | 'incorrect' | null>(null); // Submission result
  const [showHints, setShowHints] = useState(false);   // Show/hide hints
  const [liked, setLiked] = useState(false);           // Whether user liked this challenge
  const [likesCount, setLikesCount] = useState(challenge.likes_count ?? 0); // Total likes
  const [solverCount, setSolverCount] = useState(challenge.solver_count ?? 0); // Total solvers
  
  const { user } = useAuth();                          // Current user
  const { toast } = useToast();                        // Toast notifications
  const difficulty = difficultyConfig[challenge.difficulty]; // Difficulty styling

// Lines 50-56: Initialize component data on mount
  useEffect(() => {
    fetchChallengeStats();                             // Get solver count
    if (user) {
      checkIfLiked();                                  // Check if user liked this challenge
    }
  }, [challenge.id, user]);

// Lines 58-71: Fetch challenge statistics from database
  const fetchChallengeStats = async () => {
    try {
      // Get count of users who solved this challenge
      const { count: solvers } = await supabase
        .from('submissions')
        .select('*', { count: 'exact', head: true })
        .eq('challenge_id', challenge.id)
        .eq('is_correct', true);                       // Only correct submissions

      setSolverCount(solvers || 0);
    } catch (error) {
      console.error('Error fetching challenge stats:', error);
    }
  };

// Lines 73-86: Check if current user has liked this challenge
  const checkIfLiked = async () => {
    if (!user) return;
    
    try {
      const { data } = await supabase
        .from('challenge_likes')
        .select('id')
        .eq('user_id', user.id)
        .eq('challenge_id', challenge.id)
        .single();
      
      setLiked(!!data);                                // Convert to boolean
    } catch (error) {
      // User hasn't liked this challenge (expected for new users)
      setLiked(false);
    }
  };

// Lines 88-118: Handle like/unlike functionality
  const handleLike = async () => {
    if (!user) return;

    try {
      if (liked) {
        // Remove like
        await supabase
          .from('challenge_likes')
          .delete()
          .eq('user_id', user.id)
          .eq('challenge_id', challenge.id);
        
        setLiked(false);
        setLikesCount(prev => prev - 1);
      } else {
        // Add like
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

// Lines 120-170: Handle flag submission
  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!user || !flag.trim()) return;

    setLoading(true);
    setResult(null);

    try {
      const isCorrect = flag.trim() === challenge.flag; // Check if flag is correct

      // Insert submission record
      const { error } = await supabase.from('submissions').insert({
        user_id: user.id,
        challenge_id: challenge.id,
        submitted_flag: flag.trim(),
        is_correct: isCorrect,
      });

      if (error) {
        if (error.code === '23505') {                  // Duplicate key error
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
        setSolverCount(prev => prev + 1);              // Increment solver count
        setTimeout(() => {
          onSolved();                                  // Notify parent component
          onClose();                                   // Close modal
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

// Lines 172-188: Handle challenge instance launch
  const handleLaunchInstance = () => {
    if (challenge.instance_url) {
      window.open(challenge.instance_url, '_blank');   // Open provided URL
      toast({
        title: "Instance launched!",
        description: "Challenge environment opened in new tab.",
      });
    } else {
      // Generate generic challenge file URL
      const challengeUrl = `https://github.com/seenaf-ctf/challenges/raw/main/${challenge.category.toLowerCase()}/${challenge.title.toLowerCase().replace(/\s+/g, '-')}.zip`;
      window.open(challengeUrl, '_blank');
      toast({
        title: "Challenge files downloading",
        description: "Download the challenge files to get started!",
      });
    }
  };

// Lines 190-400+: Modal render with PicoCTF-style layout
  return (
    <motion.div
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
      className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-background/80 backdrop-blur-sm"
      onClick={onClose}                                // Close on backdrop click
    >
      <motion.div
        initial={{ scale: 0.9, opacity: 0 }}
        animate={{ scale: 1, opacity: 1 }}
        exit={{ scale: 0.9, opacity: 0 }}
        onClick={(e) => e.stopPropagation()}           // Prevent close on content click
        className="w-full max-w-2xl max-h-[90vh] overflow-y-auto"
      >
        <Card variant="glow" className="glass relative">
          {/* Close button */}
          <Button
            variant="ghost"
            size="icon"
            className="absolute top-4 right-4 z-10"
            onClick={onClose}
          >
            <X className="h-4 w-4" />
          </Button>

          {/* Header with challenge info */}
          <CardHeader className="pb-4">
            <div className="flex items-start justify-between pr-12">
              <div className="flex-1">
                <div className="flex items-center gap-2 mb-3">
                  <Flag className="h-5 w-5 text-primary" />
                  <CardTitle className="text-xl">{challenge.title}</CardTitle>
                </div>
                
                {/* Challenge badges */}
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
                    picoCTF by CMU-Africa
                  </Badge>
                  <Badge variant="outline" className="font-mono text-xs bg-orange-500/10 text-orange-400 border-orange-500/30">
                    browser_webshell_solvable
                  </Badge>
                </div>

                {/* Author information */}
                <div className="flex items-center gap-2 text-sm text-muted-foreground mb-2">
                  <User className="h-4 w-4" />
                  <span>AUTHOR: {challenge.author || 'SEENAF Team'}</span>
                </div>
              </div>
            </div>
          </CardHeader>

          <CardContent className="space-y-6">
            {/* Challenge description */}
            <div>
              <h3 className="font-semibold mb-2">Description</h3>
              <div className="prose prose-invert prose-sm max-w-none">
                <p className="text-foreground/80 leading-relaxed">{challenge.description}</p>
              </div>
              
              {/* Instance status */}
              <div className="mt-4 text-sm text-muted-foreground">
                <p>This challenge launches an instance on demand.</p>
                <p className="text-red-400">The current status is: <span className="font-semibold">NOT_RUNNING</span></p>
              </div>
            </div>

            {/* Launch button for challenges with instance URLs */}
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
            
            {/* Info for text-based crypto challenges */}
            {!challenge.instance_url && challenge.category === 'Crypto' && (
              <div className="p-4 bg-green-500/10 border border-green-500/30 rounded-lg">
                <p className="text-green-400 text-sm text-center">
                  💡 All information needed to solve this challenge is provided in the description above
                </p>
              </div>
            )}

            {/* Hints section */}
            {challenge.hints && challenge.hints.length > 0 && (
              <div>
                <div className="flex items-center justify-between mb-3">
                  <h3 className="font-semibold flex items-center gap-2">
                    <Lightbulb className="h-4 w-4 text-yellow-400" />
                    Hints
                  </h3>
                  {/* Hint number indicators */}
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
                
                {/* Hint list */}
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

            {/* Statistics and like button */}
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

            {/* Flag submission or solved indicator */}
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
                    placeholder="picoCTF{...}"
                    value={flag}
                    onChange={(e) => setFlag(e.target.value)}
                    className={cn(
                      "font-mono",
                      result === 'correct' && 'border-success focus-visible:ring-success',
                      result === 'incorrect' && 'border-destructive focus-visible:ring-destructive'
                    )}
                  />
                  {/* Result indicator */}
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
```
### **src/hooks/useAuth.tsx** - Authentication Hook
```typescript
// Lines 1-6: Import statements for React, Supabase, and types
import { createContext, useContext, useEffect, useState, ReactNode } from 'react';
import { User, Session } from '@supabase/supabase-js';  // Supabase auth types
import { supabase } from '@/integrations/supabase/client'; // Database client
import { Profile, AppRole } from '@/types/database';    // Custom types
import { AuthController } from '@/controllers/AuthController'; // Auth business logic

// Lines 8-17: Authentication context interface
interface AuthContextType {
  user: User | null;                                    // Current authenticated user
  session: Session | null;                              // Current session
  profile: Profile | null;                              // User profile data
  role: AppRole | null;                                 // User role (admin/player)
  loading: boolean;                                     // Authentication loading state
  signUp: (email: string, password: string, username: string) => Promise<{ error: Error | null }>; // Signup function
  signIn: (email: string, password: string) => Promise<{ error: Error | null }>; // Login function
  signOut: () => Promise<void>;                         // Logout function
}

// Lines 19: Create React context for authentication
const AuthContext = createContext<AuthContextType | undefined>(undefined);

// Lines 21-32: Authentication provider component
export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(null);  // Current user state
  const [session, setSession] = useState<Session | null>(null); // Session state
  const [profile, setProfile] = useState<Profile | null>(null); // Profile state
  const [role, setRole] = useState<AppRole | null>(null); // Role state
  const [loading, setLoading] = useState(true);         // Loading state

// Lines 34-56: Set up authentication state listener
  useEffect(() => {
    const { data: { subscription } } = supabase.auth.onAuthStateChange(
      (event, session) => {
        setSession(session);                            // Update session
        setUser(session?.user ?? null);                // Update user
        
        if (session?.user) {
          setTimeout(() => {
            fetchUserData(session.user.id);            // Fetch additional user data
          }, 0);
        } else {
          setProfile(null);                             // Clear profile when logged out
          setRole(null);                                // Clear role when logged out
          setLoading(false);
        }
      }
    );

    // Get initial session on component mount
    supabase.auth.getSession().then(({ data: { session } }) => {
      setSession(session);
      setUser(session?.user ?? null);
      if (session?.user) {
        fetchUserData(session.user.id);
      } else {
        setLoading(false);
      }
    });

    return () => subscription.unsubscribe();            // Cleanup subscription
  }, []);

// Lines 58-74: Fetch user profile and role data
  const fetchUserData = async (userId: string) => {
    try {
      const [profileResult, roleResult] = await Promise.all([
        supabase.from('profiles').select('*').eq('id', userId).maybeSingle(),
        supabase.from('user_roles').select('role').eq('user_id', userId).maybeSingle()
      ]);

      if (profileResult.data) {
        setProfile(profileResult.data as Profile);      // Set user profile
      }
      if (roleResult.data) {
        setRole(roleResult.data.role as AppRole);       // Set user role
      }
    } c