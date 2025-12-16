# SEENAF_CTF Platform - API & Database Schema Documentation

## 🗄️ **DATABASE SCHEMA DETAILED**

### **Table Relationships:**
```
auth.users (Supabase Auth)
    ↓ (1:1)
profiles
    ↓ (1:many)
user_roles
    ↓ (many:1)
challenges ← submissions → auth.users
    ↓ (1:many)
challenge_likes
```

### **Complete Schema with Constraints:**

#### **1. challenges**
```sql
CREATE TABLE public.challenges (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT NOT NULL UNIQUE,
    description TEXT NOT NULL,
    category TEXT NOT NULL CHECK (category IN (
        'Web', 'Crypto', 'Forensics', 'Network', 
        'Reverse', 'Pwn', 'OSINT', 'Stego', 'Misc'
    )),
    difficulty TEXT NOT NULL CHECK (difficulty IN (
        'easy', 'medium', 'hard', 'insane'
    )),
    points INTEGER NOT NULL DEFAULT 100 CHECK (points > 0),
    flag TEXT NOT NULL,
    hints TEXT[] DEFAULT '{}',
    is_active BOOLEAN DEFAULT true,
    author TEXT,
    instance_url TEXT,
    solver_count INTEGER DEFAULT 0 CHECK (solver_count >= 0),
    likes_count INTEGER DEFAULT 0 CHECK (likes_count >= 0),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for performance
CREATE INDEX idx_challenges_category ON public.challenges(category);
CREATE INDEX idx_challenges_difficulty ON public.challenges(difficulty);
CREATE INDEX idx_challenges_active ON public.challenges(is_active);
CREATE INDEX idx_challenges_points ON public.challenges(points);
```

#### **2. user_roles**
```sql
CREATE TABLE public.user_roles (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    role TEXT NOT NULL CHECK (role IN ('admin', 'player')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, role)
);

-- Indexes
CREATE INDEX idx_user_roles_user_id ON public.user_roles(user_id);
CREATE INDEX idx_user_roles_role ON public.user_roles(role);
```

#### **3. profiles**
```sql
CREATE TABLE public.profiles (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    username TEXT UNIQUE,
    avatar_url TEXT,
    total_score INTEGER DEFAULT 0 CHECK (total_score >= 0),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_profiles_username ON public.profiles(username);
CREATE INDEX idx_profiles_score ON public.profiles(total_score DESC);
```

#### **4. submissions**
```sql
CREATE TABLE public.submissions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    challenge_id UUID NOT NULL REFERENCES public.challenges(id) ON DELETE CASCADE,
    submitted_flag TEXT NOT NULL,
    is_correct BOOLEAN DEFAULT false,
    submitted_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, challenge_id, is_correct) -- Prevent duplicate correct submissions
);

-- Indexes
CREATE INDEX idx_submissions_user_id ON public.submissions(user_id);
CREATE INDEX idx_submissions_challenge_id ON public.submissions(challenge_id);
CREATE INDEX idx_submissions_correct ON public.submissions(is_correct);
CREATE INDEX idx_submissions_time ON public.submissions(submitted_at DESC);
```

#### **5. challenge_likes (Optional)**
```sql
CREATE TABLE public.challenge_likes (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    challenge_id UUID NOT NULL REFERENCES public.challenges(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, challenge_id)
);
```

## 🔐 **ROW LEVEL SECURITY (RLS) POLICIES**

### **challenges Table:**
```sql
-- Enable RLS
ALTER TABLE public.challenges ENABLE ROW LEVEL SECURITY;

-- Anyone can view active challenges
CREATE POLICY "Anyone can view active challenges" ON public.challenges
    FOR SELECT USING (is_active = true);

-- Admins can manage all challenges
CREATE POLICY "Admins can manage challenges" ON public.challenges
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.user_roles 
            WHERE user_id = auth.uid() AND role = 'admin'
        )
    );
```

### **user_roles Table:**
```sql
ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;

-- Users can view their own roles
CREATE POLICY "Users can view their roles" ON public.user_roles
    FOR SELECT USING (user_id = auth.uid());

-- Only admins can manage roles
CREATE POLICY "Admins can manage roles" ON public.user_roles
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.user_roles 
            WHERE user_id = auth.uid() AND role = 'admin'
        )
    );
```

### **profiles Table:**
```sql
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Public can view all profiles (for leaderboard)
CREATE POLICY "Public can view profiles" ON public.profiles
    FOR SELECT USING (true);

-- Users can update their own profile
CREATE POLICY "Users can update own profile" ON public.profiles
    FOR UPDATE USING (id = auth.uid());

-- Users can insert their own profile
CREATE POLICY "Users can insert own profile" ON public.profiles
    FOR INSERT WITH CHECK (id = auth.uid());
```

### **submissions Table:**
```sql
ALTER TABLE public.submissions ENABLE ROW LEVEL SECURITY;

-- Users can view their own submissions
CREATE POLICY "Users can view own submissions" ON public.submissions
    FOR SELECT USING (user_id = auth.uid());

-- Users can insert their own submissions
CREATE POLICY "Users can insert own submissions" ON public.submissions
    FOR INSERT WITH CHECK (user_id = auth.uid());

-- Admins can view all submissions
CREATE POLICY "Admins can view all submissions" ON public.submissions
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.user_roles 
            WHERE user_id = auth.uid() AND role = 'admin'
        )
    );
```

## 🔄 **DATABASE FUNCTIONS & TRIGGERS**

### **1. Auto-update timestamps:**
```sql
-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply to relevant tables
CREATE TRIGGER update_challenges_updated_at 
    BEFORE UPDATE ON public.challenges 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_profiles_updated_at 
    BEFORE UPDATE ON public.profiles 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
```

### **2. Auto-create profile on user registration:**
```sql
-- Function to create profile when user registers
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, username)
    VALUES (NEW.id, NEW.email);
    
    -- Assign default player role
    INSERT INTO public.user_roles (user_id, role)
    VALUES (NEW.id, 'player');
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger on auth.users
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
```

### **3. Update solver count on correct submission:**
```sql
-- Function to update challenge solver count
CREATE OR REPLACE FUNCTION update_challenge_solver_count()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.is_correct = true THEN
        UPDATE public.challenges 
        SET solver_count = solver_count + 1
        WHERE id = NEW.challenge_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger on submissions
CREATE TRIGGER update_solver_count_trigger
    AFTER INSERT ON public.submissions
    FOR EACH ROW EXECUTE FUNCTION update_challenge_solver_count();
```

## 📡 **API ENDPOINTS (Supabase Client)**

### **Authentication Endpoints:**
```typescript
// Login
const { data, error } = await supabase.auth.signInWithPassword({
  email: 'user@example.com',
  password: 'password123'
});

// Register
const { data, error } = await supabase.auth.signUp({
  email: 'user@example.com',
  password: 'password123'
});

// Logout
const { error } = await supabase.auth.signOut();

// Get current session
const { data: { session } } = await supabase.auth.getSession();
```

### **Challenge Endpoints:**

#### **Get All Active Challenges:**
```typescript
const { data, error } = await supabase
  .from('challenges')
  .select('*')
  .eq('is_active', true)
  .order('points', { ascending: true });
```

#### **Get Challenge by ID:**
```typescript
const { data, error } = await supabase
  .from('challenges')
  .select('*')
  .eq('id', challengeId)
  .single();
```

#### **Create Challenge (Admin only):**
```typescript
const { data, error } = await supabase
  .from('challenges')
  .insert({
    title: 'New Challenge',
    description: 'Challenge description',
    category: 'Web',
    difficulty: 'easy',
    points: 100,
    flag: 'SEENAF{flag_here}',
    hints: ['Hint 1', 'Hint 2'],
    author: 'Admin User'
  })
  .select();
```

#### **Update Challenge (Admin only):**
```typescript
const { data, error } = await supabase
  .from('challenges')
  .update({
    title: 'Updated Title',
    points: 150
  })
  .eq('id', challengeId)
  .select();
```

#### **Delete Challenge (Admin only):**
```typescript
const { error } = await supabase
  .from('challenges')
  .delete()
  .eq('id', challengeId);
```

### **Submission Endpoints:**

#### **Submit Flag:**
```typescript
const { data, error } = await supabase
  .from('submissions')
  .insert({
    user_id: userId,
    challenge_id: challengeId,
    submitted_flag: 'SEENAF{user_flag}',
    is_correct: submittedFlag === correctFlag
  })
  .select();
```

#### **Get User Submissions:**
```typescript
const { data, error } = await supabase
  .from('submissions')
  .select(`
    *,
    challenges (
      title,
      category,
      points
    )
  `)
  .eq('user_id', userId)
  .order('submitted_at', { ascending: false });
```

#### **Get Solved Challenges:**
```typescript
const { data, error } = await supabase
  .from('submissions')
  .select('challenge_id')
  .eq('user_id', userId)
  .eq('is_correct', true);
```

### **User Management Endpoints:**

#### **Get User Profile:**
```typescript
const { data, error } = await supabase
  .from('profiles')
  .select('*')
  .eq('id', userId)
  .single();
```

#### **Update Profile:**
```typescript
const { data, error } = await supabase
  .from('profiles')
  .update({
    username: 'new_username',
    avatar_url: 'https://example.com/avatar.jpg'
  })
  .eq('id', userId)
  .select();
```

#### **Get User Role:**
```typescript
const { data, error } = await supabase
  .from('user_roles')
  .select('role')
  .eq('user_id', userId)
  .single();
```

#### **Get Leaderboard:**
```typescript
const { data, error } = await supabase
  .from('profiles')
  .select('username, total_score, created_at')
  .order('total_score', { ascending: false })
  .limit(50);
```

## 📊 **ANALYTICS QUERIES**

### **Challenge Statistics:**
```sql
-- Challenge solve rates
SELECT 
    c.title,
    c.category,
    c.difficulty,
    c.points,
    c.solver_count,
    ROUND(c.solver_count * 100.0 / NULLIF(total_users.count, 0), 2) as solve_rate
FROM public.challenges c
CROSS JOIN (
    SELECT COUNT(*) as count FROM auth.users
) total_users
WHERE c.is_active = true
ORDER BY solve_rate DESC;
```

### **User Progress:**
```sql
-- User solve statistics
SELECT 
    p.username,
    p.total_score,
    COUNT(s.id) as challenges_solved,
    COUNT(DISTINCT s.challenge_id) as unique_challenges,
    MIN(s.submitted_at) as first_solve,
    MAX(s.submitted_at) as last_solve
FROM public.profiles p
LEFT JOIN public.submissions s ON p.id = s.user_id AND s.is_correct = true
GROUP BY p.id, p.username, p.total_score
ORDER BY p.total_score DESC;
```

### **Category Performance:**
```sql
-- Performance by category
SELECT 
    c.category,
    COUNT(*) as total_challenges,
    AVG(c.solver_count) as avg_solvers,
    SUM(c.solver_count) as total_solves,
    AVG(c.points) as avg_points
FROM public.challenges c
WHERE c.is_active = true
GROUP BY c.category
ORDER BY avg_solvers DESC;
```

## 🔧 **UTILITY FUNCTIONS**

### **TypeScript Types:**
```typescript
// src/types/database.ts
export interface Challenge {
  id: string;
  title: string;
  description: string;
  category: 'Web' | 'Crypto' | 'Forensics' | 'Network' | 'Reverse' | 'Pwn' | 'OSINT' | 'Stego' | 'Misc';
  difficulty: 'easy' | 'medium' | 'hard' | 'insane';
  points: number;
  flag: string;
  hints?: string[];
  is_active: boolean;
  author?: string;
  instance_url?: string;
  solver_count: number;
  likes_count: number;
  created_at: string;
  updated_at: string;
}

export interface Profile {
  id: string;
  username?: string;
  avatar_url?: string;
  total_score: number;
  created_at: string;
  updated_at: string;
}

export interface Submission {
  id: string;
  user_id: string;
  challenge_id: string;
  submitted_flag: string;
  is_correct: boolean;
  submitted_at: string;
}

export interface UserRole {
  id: string;
  user_id: string;
  role: 'admin' | 'player';
  created_at: string;
}

export type DifficultyLevel = 'easy' | 'medium' | 'hard' | 'insane';
```

### **Database Helper Functions:**
```typescript
// src/utils/database.ts
export const calculateUserScore = async (userId: string): Promise<number> => {
  const { data, error } = await supabase
    .from('submissions')
    .select(`
      challenges (points)
    `)
    .eq('user_id', userId)
    .eq('is_correct', true);

  if (error) throw error;
  
  return data?.reduce((total, submission) => {
    return total + (submission.challenges?.points || 0);
  }, 0) || 0;
};

export const getChallengeStats = async (challengeId: string) => {
  const { data, error } = await supabase
    .from('submissions')
    .select('is_correct')
    .eq('challenge_id', challengeId);

  if (error) throw error;

  const totalAttempts = data?.length || 0;
  const correctAttempts = data?.filter(s => s.is_correct).length || 0;
  
  return {
    totalAttempts,
    correctAttempts,
    successRate: totalAttempts > 0 ? (correctAttempts / totalAttempts) * 100 : 0
  };
};

export const getUserRank = async (userId: string): Promise<number> => {
  const { data: userProfile } = await supabase
    .from('profiles')
    .select('total_score')
    .eq('id', userId)
    .single();

  const { count } = await supabase
    .from('profiles')
    .select('*', { count: 'exact', head: true })
    .gt('total_score', userProfile?.total_score || 0);

  return (count || 0) + 1;
};
```

## 🚀 **PERFORMANCE OPTIMIZATION**

### **Database Indexes:**
```sql
-- Composite indexes for common queries
CREATE INDEX idx_submissions_user_correct ON public.submissions(user_id, is_correct);
CREATE INDEX idx_challenges_category_active ON public.challenges(category, is_active);
CREATE INDEX idx_challenges_difficulty_points ON public.challenges(difficulty, points);

-- Partial indexes for active challenges only
CREATE INDEX idx_active_challenges_category ON public.challenges(category) 
WHERE is_active = true;

-- Index for leaderboard queries
CREATE INDEX idx_profiles_score_desc ON public.profiles(total_score DESC, username);
```

### **Query Optimization:**
```typescript
// Use select() to limit returned fields
const { data } = await supabase
  .from('challenges')
  .select('id, title, category, difficulty, points, solver_count')
  .eq('is_active', true);

// Use count for pagination
const { count } = await supabase
  .from('challenges')
  .select('*', { count: 'exact', head: true })
  .eq('category', 'Web');

// Use range for pagination
const { data } = await supabase
  .from('challenges')
  .select('*')
  .range(0, 9) // First 10 items
  .order('created_at', { ascending: false });
```

This comprehensive API and schema documentation provides all the technical details needed to understand, maintain, and extend the SEENAF_CTF platform's backend functionality.