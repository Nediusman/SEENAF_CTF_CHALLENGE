# SEENAF_CTF Platform - Code Flow & Logic Documentation

## 🔄 **APPLICATION FLOW DIAGRAM**

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Landing Page  │───▶│  Authentication │───▶│   Main App      │
│   (Index.tsx)   │    │   (Auth.tsx)    │    │  (Challenges)   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  Hero Section   │    │  Login/Register │    │ Challenge Grid  │
│  Live Demos     │    │  Role Detection │    │ Filter/Search   │
│  Categories     │    │  Profile Setup  │    │ Launch Buttons  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │                       │
                                ▼                       ▼
                    ┌─────────────────┐    ┌─────────────────┐
                    │   Admin Panel   │    │ Challenge Modal │
                    │  (Admin.tsx)    │    │ Flag Submission │
                    └─────────────────┘    │ Scoring System  │
                                           └─────────────────┘
```

## 🏗️ **COMPONENT HIERARCHY**

```
App
├── Layout
│   ├── Navbar
│   │   ├── Logo/Branding
│   │   ├── Navigation Links
│   │   ├── User Profile
│   │   └── Auth Status
│   └── Main Content Area
│       ├── Index (Landing Page)
│       │   ├── Hero Section
│       │   ├── Live Challenge Showcase
│       │   ├── Category Grid
│       │   ├── Statistics
│       │   └── Social Links
│       ├── Auth (Authentication)
│       │   ├── Login Form
│       │   ├── Register Form
│       │   └── Role Assignment
│       ├── Challenges (Main Platform)
│       │   ├── Search/Filter Bar
│       │   ├── Category Filters
│       │   ├── Challenge Grid
│       │   │   └── ChallengeCard[]
│       │   │       ├── Challenge Info
│       │   │       ├── Difficulty Badge
│       │   │       ├── Points Display
│       │   │       └── Launch Button
│       │   └── ChallengeDetailModal
│       │       ├── Challenge Description
│       │       ├── Hints System
│       │       ├── Launch Instance
│       │       ├── Flag Submission
│       │       └── Statistics
│       └── Admin (Management Panel)
│           ├── Challenge Management
│           │   ├── Create/Edit Forms
│           │   ├── Bulk Operations
│           │   └── Challenge List
│           ├── User Management
│           │   ├── User List
│           │   ├── Role Management
│           │   └── Score Tracking
│           └── Debug Tools
│               ├── SupabaseDebug
│               ├── DebugChallenges
│               └── Connection Tests
```

## 🔐 **AUTHENTICATION FLOW**

### **1. Initial Load:**
```typescript
// App startup sequence
useEffect(() => {
  // 1. Check existing session
  supabase.auth.getSession()
    .then(({ data: { session } }) => {
      if (session?.user) {
        setUser(session.user);
        // 2. Fetch user profile
        fetchUserProfile(session.user.id);
        // 3. Fetch user role
        fetchUserRole(session.user.id);
      }
    });

  // 4. Set up auth state listener
  const { data: { subscription } } = supabase.auth.onAuthStateChange(
    async (event, session) => {
      handleAuthChange(event, session);
    }
  );
}, []);
```

### **2. Login Process:**
```typescript
// Auth.tsx - Login flow
const handleLogin = async (email: string, password: string) => {
  // 1. Authenticate with Supabase
  const { data, error } = await supabase.auth.signInWithPassword({
    email,
    password,
  });

  if (error) {
    toast({ title: "Login failed", description: error.message });
    return;
  }

  // 2. Redirect based on role
  const userRole = await fetchUserRole(data.user.id);
  if (userRole === 'admin') {
    navigate('/admin');
  } else {
    navigate('/challenges');
  }
};
```

### **3. Role-Based Access Control:**
```typescript
// useAuth.tsx - Role checking
const fetchUserRole = async (userId: string) => {
  const { data, error } = await supabase
    .from('user_roles')
    .select('role')
    .eq('user_id', userId)
    .single();

  return data?.role || 'player';
};

// Route protection
useEffect(() => {
  if (!authLoading) {
    if (!user) {
      navigate('/auth');
    } else if (role !== 'admin' && location.pathname === '/admin') {
      navigate('/challenges');
      toast({ title: "Access denied" });
    }
  }
}, [user, role, authLoading]);
```

## 🎯 **CHALLENGE SYSTEM LOGIC**

### **1. Challenge Loading:**
```typescript
// Challenges.tsx - Data fetching
const fetchChallenges = async () => {
  console.log('🔍 Fetching challenges...');
  
  // Query active challenges with RLS
  const { data, error, count } = await supabase
    .from('challenges')
    .select('*', { count: 'exact' })
    .eq('is_active', true)
    .order('points', { ascending: true });

  if (error) {
    console.error('❌ Supabase error:', error);
    return;
  }
  
  setChallenges(data || []);
  
  // Also fetch solved challenges for current user
  fetchSolvedChallenges();
};

const fetchSolvedChallenges = async () => {
  if (!user) return;
  
  const { data, error } = await supabase
    .from('submissions')
    .select('challenge_id')
    .eq('user_id', user.id)
    .eq('is_correct', true);

  setSolvedIds(new Set(data?.map(s => s.challenge_id) || []));
};
```

### **2. Challenge Filtering:**
```typescript
// Real-time filtering logic
const filteredChallenges = challenges.filter(challenge => {
  // Text search
  const matchesSearch = challenge.title.toLowerCase().includes(search.toLowerCase()) ||
    challenge.description.toLowerCase().includes(search.toLowerCase());
  
  // Category filter
  const matchesCategory = categoryFilter === 'All' || challenge.category === categoryFilter;
  
  // Difficulty filter
  const matchesDifficulty = difficultyFilter === 'all' || challenge.difficulty === difficultyFilter;
  
  return matchesSearch && matchesCategory && matchesDifficulty;
});
```

### **3. Challenge Launch Logic:**
```typescript
// ChallengeCard.tsx - Launch button behavior
const handleLaunchInstance = (e: React.MouseEvent) => {
  e.stopPropagation(); // Prevent modal opening
  
  if (challenge.instance_url) {
    // Open external resource
    window.open(challenge.instance_url, '_blank');
    
    // Show appropriate toast
    toast({
      title: challenge.category === 'Web' ? "Challenge launched!" : "Files downloading",
      description: challenge.category === 'Web' ? 
        "Environment opened in new tab" : 
        "Challenge files are being downloaded"
    });
  } else {
    // For text-based challenges, open modal
    onClick();
  }
};

// Button text logic
const getButtonText = () => {
  if (!challenge.instance_url) return 'Solve Challenge';
  
  switch (challenge.category) {
    case 'Web': return 'Launch Challenge';
    case 'Forensics':
    case 'Network':
    case 'Reverse':
    case 'Pwn':
    case 'Stego': return 'Download Files';
    case 'Crypto': return 'Open Tools';
    default: return 'Open Resources';
  }
};
```

## 🏆 **SCORING SYSTEM**

### **1. Flag Submission:**
```typescript
// ChallengeDetailModal.tsx - Flag submission logic
const handleSubmit = async (e: React.FormEvent) => {
  e.preventDefault();
  if (!user || !flag.trim()) return;

  setLoading(true);
  setResult(null);

  try {
    // 1. Check if flag is correct
    const isCorrect = flag.trim() === challenge.flag;

    // 2. Insert submission record
    const { error } = await supabase.from('submissions').insert({
      user_id: user.id,
      challenge_id: challenge.id,
      submitted_flag: flag.trim(),
      is_correct: isCorrect,
    });

    if (error) {
      // Handle duplicate submission
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
      // 3. Update user score
      await updateUserScore(user.id, challenge.points);
      
      // 4. Update challenge solver count
      await updateChallengeStats(challenge.id);
      
      // 5. Show success message
      toast({
        title: "Flag captured!",
        description: `+${challenge.points} points added to your score!`,
      });

      // 6. Close modal and refresh
      setTimeout(() => {
        onSolved();
        onClose();
      }, 1500);
    }
  } catch (error: any) {
    console.error('💥 Error submitting flag:', error);
    toast({
      title: "Submission failed",
      description: error.message,
      variant: "destructive",
    });
  } finally {
    setLoading(false);
  }
};
```

### **2. Score Calculation:**
```typescript
// Automatic score updates
const updateUserScore = async (userId: string, points: number) => {
  // Get current score
  const { data: profile } = await supabase
    .from('profiles')
    .select('total_score')
    .eq('id', userId)
    .single();

  // Update with new points
  const newScore = (profile?.total_score || 0) + points;
  
  await supabase
    .from('profiles')
    .update({ total_score: newScore })
    .eq('id', userId);
};

const updateChallengeStats = async (challengeId: string) => {
  // Increment solver count
  const { data } = await supabase
    .from('challenges')
    .select('solver_count')
    .eq('id', challengeId)
    .single();

  await supabase
    .from('challenges')
    .update({ solver_count: (data?.solver_count || 0) + 1 })
    .eq('id', challengeId);
};
```

## 🛠️ **ADMIN PANEL LOGIC**

### **1. Challenge Management:**
```typescript
// Admin.tsx - Challenge CRUD operations
const handleSubmit = async (e: React.FormEvent) => {
  e.preventDefault();
  
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

    if (editingId) {
      // Update existing challenge
      const { data, error } = await supabase
        .from('challenges')
        .update(challengeData)
        .eq('id', editingId)
        .select();
      
      if (error) throw error;
      toast({ title: "Challenge updated successfully" });
    } else {
      // Create new challenge
      const { data, error } = await supabase
        .from('challenges')
        .insert(challengeData)
        .select();
      
      if (error) throw error;
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
      description: error.message,
      variant: "destructive",
    });
  } finally {
    setSubmitting(false);
  }
};
```

### **2. Bulk Operations:**
```typescript
// Loading pre-built challenge sets
const handleLoadBasicChallenges = async () => {
  if (!confirm('This will replace all existing challenges. Continue?')) return;
  
  setSetupLoading(true);
  try {
    const result = await loadBasicChallenges();
    if (result.success) {
      toast({ 
        title: "CTF challenges loaded!", 
        description: `${result.count} challenges added.` 
      });
      fetchData();
    } else {
      throw new Error(result.error || 'Load failed');
    }
  } catch (error: any) {
    toast({
      title: "Load failed",
      description: error.message,
      variant: "destructive",
    });
  } finally {
    setSetupLoading(false);
  }
};
```

## 🎨 **UI STATE MANAGEMENT**

### **1. Modal State:**
```typescript
// Challenge modal management
const [selectedChallenge, setSelectedChallenge] = useState<Challenge | null>(null);

// Open modal
const openChallengeModal = (challenge: Challenge) => {
  setSelectedChallenge(challenge);
};

// Close modal
const closeChallengeModal = () => {
  setSelectedChallenge(null);
};

// Modal rendering with AnimatePresence
<AnimatePresence>
  {selectedChallenge && (
    <ChallengeDetailModal
      challenge={selectedChallenge}
      solved={solvedIds.has(selectedChallenge.id)}
      onClose={closeChallengeModal}
      onSolved={() => {
        fetchSolvedChallenges();
      }}
    />
  )}
</AnimatePresence>
```

### **2. Filter State:**
```typescript
// Filter and search state management
const [search, setSearch] = useState('');
const [categoryFilter, setCategoryFilter] = useState('All');
const [difficultyFilter, setDifficultyFilter] = useState<DifficultyLevel | 'all'>('all');

// Real-time filtering
useEffect(() => {
  const filtered = challenges.filter(challenge => {
    const matchesSearch = challenge.title.toLowerCase().includes(search.toLowerCase());
    const matchesCategory = categoryFilter === 'All' || challenge.category === categoryFilter;
    const matchesDifficulty = difficultyFilter === 'all' || challenge.difficulty === difficultyFilter;
    return matchesSearch && matchesCategory && matchesDifficulty;
  });
  
  setFilteredChallenges(filtered);
}, [challenges, search, categoryFilter, difficultyFilter]);
```

## 🔍 **ERROR HANDLING & DEBUGGING**

### **1. Connection Testing:**
```typescript
// SupabaseDebug.tsx - Connection diagnostics
const testConnection = async () => {
  console.log('🔍 Testing Supabase Connection...');
  
  try {
    // Test environment variables
    const envVars = {
      url: import.meta.env.VITE_SUPABASE_URL,
      key: import.meta.env.VITE_SUPABASE_PUBLISHABLE_KEY?.substring(0, 20) + '...',
    };
    console.log('📋 Environment Variables:', envVars);
    
    // Test auth session
    const { data: session, error: authError } = await supabase.auth.getSession();
    console.log('👤 Auth Session:', session);
    
    // Test database connection
    const { count, error: countError } = await supabase
      .from('challenges')
      .select('*', { count: 'exact', head: true });
    console.log('📊 Challenges Count:', count);
    
    // Test data query
    const { data, error } = await supabase
      .from('challenges')
      .select('*')
      .limit(5);
    console.log('🎯 Sample Challenges:', data);
    
    return {
      success: !authError && !countError && !error,
      count,
      challenges: data,
      errors: { authError, countError, error }
    };
  } catch (error) {
    console.error('💥 Connection Error:', error);
    return { success: false, error };
  }
};
```

### **2. Error Boundaries:**
```typescript
// Global error handling
const handleError = (error: any, context: string) => {
  console.error(`💥 Error in ${context}:`, error);
  
  // Show user-friendly message
  toast({
    title: "Something went wrong",
    description: error.message || "Please try again later.",
    variant: "destructive",
  });
  
  // Log to monitoring service (if configured)
  // logError(error, context);
};
```

## 📊 **PERFORMANCE OPTIMIZATION**

### **1. Data Fetching:**
```typescript
// Optimized queries with select specific fields
const fetchChallenges = async () => {
  const { data, error } = await supabase
    .from('challenges')
    .select(`
      id,
      title,
      description,
      category,
      difficulty,
      points,
      flag,
      hints,
      instance_url,
      solver_count,
      likes_count,
      created_at
    `)
    .eq('is_active', true)
    .order('points', { ascending: true });
};
```

### **2. Memoization:**
```typescript
// Memoized filtered results
const filteredChallenges = useMemo(() => {
  return challenges.filter(challenge => {
    const matchesSearch = challenge.title.toLowerCase().includes(search.toLowerCase());
    const matchesCategory = categoryFilter === 'All' || challenge.category === categoryFilter;
    const matchesDifficulty = difficultyFilter === 'all' || challenge.difficulty === difficultyFilter;
    return matchesSearch && matchesCategory && matchesDifficulty;
  });
}, [challenges, search, categoryFilter, difficultyFilter]);
```

### **3. Lazy Loading:**
```typescript
// Lazy load challenge details
const ChallengeDetailModal = lazy(() => import('./ChallengeDetailModal'));

// Suspense wrapper
<Suspense fallback={<div>Loading challenge...</div>}>
  <ChallengeDetailModal {...props} />
</Suspense>
```

This comprehensive documentation covers the complete logic flow, component interactions, and system architecture of the SEENAF_CTF platform. Each section shows how the code connects and flows through the application.