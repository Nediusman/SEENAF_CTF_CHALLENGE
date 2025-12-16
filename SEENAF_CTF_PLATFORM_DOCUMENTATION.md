# SEENAF_CTF Platform - Complete Architecture Documentation

## 🏗️ **PLATFORM OVERVIEW**

SEENAF_CTF is a modern Capture The Flag (CTF) platform built with React, TypeScript, Supabase, and Tailwind CSS. It provides a complete cybersecurity training environment with challenges across 9 categories.

## 📁 **PROJECT STRUCTURE**

```
seenaf-ctf/
├── public/                          # Static assets
│   ├── favicon.svg                  # Custom SEENAF_CTF icon
│   ├── seenaf-ctf-icon.svg         # Brand icon
│   ├── manifest.json               # PWA configuration
│   └── ...
├── src/
│   ├── components/                  # Reusable UI components
│   │   ├── layout/                 # Layout components
│   │   │   ├── Layout.tsx          # Main layout wrapper
│   │   │   └── Navbar.tsx          # Navigation bar
│   │   ├── challenges/             # Challenge-specific components
│   │   │   ├── ChallengeCard.tsx   # Individual challenge display
│   │   │   ├── ChallengeDetailModal.tsx # Challenge details & submission
│   │   │   ├── LocalChallengeRunner.tsx # Interactive challenge solver
│   │   │   └── LaunchTester.tsx    # Launch functionality tester
│   │   ├── ui/                     # Base UI components (shadcn/ui)
│   │   ├── SupabaseDebug.tsx       # Database connection debugger
│   │   └── DebugChallenges.tsx     # Challenge debugging tools
│   ├── pages/                      # Main application pages
│   │   ├── Index.tsx               # Landing page
│   │   ├── Auth.tsx                # Authentication (login/register)
│   │   ├── Challenges.tsx          # Challenge browser
│   │   └── Admin.tsx               # Admin panel
│   ├── hooks/                      # Custom React hooks
│   │   ├── useAuth.tsx             # Authentication logic
│   │   └── use-toast.tsx           # Toast notifications
│   ├── integrations/               # External service integrations
│   │   └── supabase/
│   │       └── client.ts           # Supabase client configuration
│   ├── types/                      # TypeScript type definitions
│   │   └── database.ts             # Database schema types
│   ├── utils/                      # Utility functions
│   │   ├── basicChallenges.ts      # Challenge data and loading
│   │   ├── setupChallenges.ts      # Challenge setup utilities
│   │   └── testConnection.ts       # Connection testing
│   └── lib/                        # Core utilities
│       └── utils.ts                # General utility functions
├── supabase/                       # Database migrations
│   └── migrations/
└── *.sql                          # Database setup scripts
```

## 🗄️ **DATABASE ARCHITECTURE**

### **Core Tables:**

#### 1. **challenges** (Main challenge data)
```sql
CREATE TABLE public.challenges (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT NOT NULL,                    -- Challenge name
    description TEXT NOT NULL,              -- Challenge description
    category TEXT NOT NULL,                 -- Web, Crypto, Forensics, etc.
    difficulty TEXT NOT NULL,               -- easy, medium, hard, insane
    points INTEGER NOT NULL DEFAULT 100,    -- Points awarded
    flag TEXT NOT NULL,                     -- Correct flag
    hints TEXT[],                          -- Array of hints
    is_active BOOLEAN DEFAULT true,         -- Challenge visibility
    author TEXT,                           -- Challenge creator
    instance_url TEXT,                     -- Launch URL (optional)
    solver_count INTEGER DEFAULT 0,        -- Number of solvers
    likes_count INTEGER DEFAULT 0,         -- Like count
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

#### 2. **user_roles** (Role-based access control)
```sql
CREATE TABLE public.user_roles (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    role TEXT NOT NULL CHECK (role IN ('admin', 'player')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, role)
);
```

#### 3. **profiles** (User profiles and scores)
```sql
CREATE TABLE public.profiles (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    username TEXT UNIQUE,
    avatar_url TEXT,
    total_score INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

#### 4. **submissions** (Flag submissions and scoring)
```sql
CREATE TABLE public.submissions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    challenge_id UUID REFERENCES public.challenges(id) ON DELETE CASCADE,
    submitted_flag TEXT NOT NULL,
    is_correct BOOLEAN DEFAULT false,
    submitted_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### **Row Level Security (RLS) Policies:**
- **challenges**: Public read for active challenges, admin write access
- **user_roles**: Users can view their own roles
- **profiles**: Public read, users can update their own
- **submissions**: Users can view/insert their own submissions

## 🔐 **AUTHENTICATION SYSTEM**

### **Authentication Flow:**
```typescript
// useAuth.tsx - Custom authentication hook
export function useAuth() {
  const [user, setUser] = useState<User | null>(null);
  const [profile, setProfile] = useState<Profile | null>(null);
  const [role, setRole] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);

  // 1. Check current session
  useEffect(() => {
    supabase.auth.getSession().then(({ data: { session } }) => {
      setUser(session?.user ?? null);
      if (session?.user) {
        fetchUserProfile(session.user.id);
        fetchUserRole(session.user.id);
      }
      setLoading(false);
    });

    // 2. Listen for auth changes
    const { data: { subscription } } = supabase.auth.onAuthStateChange(
      async (event, session) => {
        setUser(session?.user ?? null);
        if (session?.user) {
          await fetchUserProfile(session.user.id);
          await fetchUserRole(session.user.id);
        } else {
          setProfile(null);
          setRole(null);
        }
        setLoading(false);
      }
    );

    return () => subscription.unsubscribe();
  }, []);
}
```

### **Role-Based Access Control:**
- **Players**: Can view challenges, submit flags, see leaderboard
- **Admins**: Full access + challenge management + user management

## 🎯 **CHALLENGE SYSTEM**

### **Challenge Categories (9 total):**
1. **Web Exploitation** - XSS, SQL injection, CSRF, etc.
2. **Cryptography** - Ciphers, hashing, encryption
3. **Forensics** - File analysis, memory dumps, network captures
4. **Network Analysis** - PCAP analysis, traffic inspection
5. **Reverse Engineering** - Binary analysis, disassembly
6. **Binary Exploitation (Pwn)** - Buffer overflows, format strings
7. **OSINT** - Open source intelligence gathering
8. **Steganography** - Hidden data in files
9. **Miscellaneous** - Programming, logic puzzles

### **Challenge Difficulty Levels:**
- **Easy** (100-200 points) - Beginner friendly
- **Medium** (200-400 points) - Intermediate skills
- **Hard** (400-600 points) - Advanced techniques
- **Insane** (600+ points) - Expert level

### **Challenge Launch System:**

#### **Launch Button Logic:**
```typescript
// ChallengeCard.tsx - Launch button implementation
const handleLaunchInstance = (e: React.MouseEvent) => {
  e.stopPropagation();
  if (challenge.instance_url) {
    window.open(challenge.instance_url, '_blank');
  } else {
    onClick(); // Open challenge modal for text-based challenges
  }
};

// Button rendering logic
{challenge.instance_url ? (
  <Button onClick={handleLaunchInstance}>
    <Play className="h-3 w-3 mr-2" />
    {challenge.category === 'Forensics' || challenge.category === 'Network' ? 
     'Download Files' : 'Launch Challenge'}
  </Button>
) : (
  challenge.category === 'Crypto' && (
    <Button onClick={onClick} className="bg-green-600">
      <Flag className="h-3 w-3 mr-2" />
      Solve Challenge
    </Button>
  )
)}
```

#### **Launch URL Types:**
- **Web Challenges**: Live CTF environments (PicoCTF, XSS Game)
- **Forensics/Network**: Downloadable files (PCAP, images, binaries)
- **Crypto Tools**: Online cipher tools (CyberChef, FactorDB)
- **Text-based Crypto**: No launch needed (Base64, Caesar, ROT13)

## 🎮 **CHALLENGE INTERACTION FLOW**

### **1. Challenge Discovery:**
```typescript
// Challenges.tsx - Main challenge browser
const fetchChallenges = async () => {
  const { data, error } = await supabase
    .from('challenges')
    .select('*')
    .eq('is_active', true)
    .order('points', { ascending: true });
  
  setChallenges(data || []);
};

// Filtering and search
const filteredChallenges = challenges.filter(c => {
  const matchesSearch = c.title.toLowerCase().includes(search.toLowerCase());
  const matchesCategory = categoryFilter === 'All' || c.category === categoryFilter;
  const matchesDifficulty = difficultyFilter === 'all' || c.difficulty === difficultyFilter;
  return matchesSearch && matchesCategory && matchesDifficulty;
});
```

### **2. Challenge Detail Modal:**
```typescript
// ChallengeDetailModal.tsx - Detailed challenge view
export function ChallengeDetailModal({ challenge, onSolved }) {
  const [flag, setFlag] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!user || !flag.trim()) return;

    const isCorrect = flag.trim() === challenge.flag;

    // Submit to database
    const { error } = await supabase.from('submissions').insert({
      user_id: user.id,
      challenge_id: challenge.id,
      submitted_flag: flag.trim(),
      is_correct: isCorrect,
    });

    if (isCorrect) {
      toast({ title: "Flag captured!", description: `+${challenge.points} points!` });
      onSolved();
    }
  };
}
```

### **3. Scoring System:**
```typescript
// Automatic score calculation on correct submission
const updateUserScore = async (userId: string, points: number) => {
  const { data: profile } = await supabase
    .from('profiles')
    .select('total_score')
    .eq('id', userId)
    .single();

  await supabase
    .from('profiles')
    .update({ total_score: (profile?.total_score || 0) + points })
    .eq('id', userId);
};
```

## 🛠️ **ADMIN PANEL SYSTEM**

### **Admin Features:**
1. **Challenge Management** - Create, edit, delete challenges
2. **User Management** - View users, scores, submissions
3. **Bulk Operations** - Load challenge sets, clear database
4. **Debug Tools** - Connection testing, data verification

### **Challenge Creation Form:**
```typescript
// Admin.tsx - Challenge creation
const handleSubmit = async (e: React.FormEvent) => {
  const challengeData = {
    title: form.title,
    description: form.description,
    category: form.category,
    difficulty: form.difficulty,
    points: form.points,
    flag: form.flag,
    hints: form.hints.split('\n').filter(h => h.trim()),
    author: form.author || null,
    instance_url: form.instance_url || null,
  };

  const { data, error } = await supabase
    .from('challenges')
    .insert(challengeData)
    .select();
};
```

### **Bulk Challenge Loading:**
```typescript
// basicChallenges.ts - 52 pre-built challenges
export const loadBasicChallenges = async () => {
  const challenges = [
    // Web Challenges
    {
      title: 'Inspect HTML',
      description: 'Find the flag in the HTML source code.',
      category: 'Web',
      difficulty: 'easy',
      points: 100,
      flag: 'SEENAF{1nsp3ct_th3_html_s0urc3}',
      hints: ['Right-click and view source', 'Look for HTML comments'],
    },
    // ... 51 more challenges across all categories
  ];

  await supabase.from('challenges').insert(challenges);
};
```

## 🎨 **UI/UX DESIGN SYSTEM**

### **Design Philosophy:**
- **Hacking Terminal Aesthetic** - Dark theme with green accents
- **Matrix-style Background** - Falling code animation
- **Cyberpunk Elements** - Neon colors, glitch effects
- **Professional Layout** - Clean, organized interface

### **Key UI Components:**

#### **1. Landing Page (Index.tsx):**
- Hero section with animated terminal
- Live challenge showcase
- Category overview
- Social media integration
- Rotating hacker slogans

#### **2. Challenge Cards (ChallengeCard.tsx):**
- Difficulty badges with color coding
- Category tags
- Point values
- Solved status indicators
- Launch buttons (conditional)

#### **3. Challenge Modal (ChallengeDetailModal.tsx):**
- PicoCTF-style layout
- Author information
- Numbered hints system
- Launch instance functionality
- Flag submission form
- Like/solver statistics

### **Styling System:**
```css
/* index.css - Custom styling */
.text-glow {
  text-shadow: 0 0 10px currentColor;
}

.glass {
  backdrop-filter: blur(10px);
  background: rgba(0, 0, 0, 0.1);
}

.matrix-bg {
  background: linear-gradient(45deg, #0a0a0a 0%, #1a1a2e 50%, #16213e 100%);
}
```

## 🔧 **DEVELOPMENT WORKFLOW**

### **Environment Setup:**
1. **Frontend**: React + TypeScript + Vite
2. **Backend**: Supabase (PostgreSQL + Auth + Storage)
3. **Styling**: Tailwind CSS + shadcn/ui
4. **State Management**: React hooks + Context
5. **Animations**: Framer Motion

### **Key Configuration Files:**

#### **.env Configuration:**
```env
VITE_SUPABASE_URL="https://your-project.supabase.co"
VITE_SUPABASE_PUBLISHABLE_KEY="your-anon-key"
```

#### **Supabase Client Setup:**
```typescript
// src/integrations/supabase/client.ts
import { createClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_PUBLISHABLE_KEY;

export const supabase = createClient(supabaseUrl, supabaseAnonKey);
```

### **Database Setup Scripts:**
- **new-supabase-setup.sql** - Complete database initialization
- **load-all-52-challenges.sql** - Load all challenge data
- **fix-launch-functionality.sql** - Configure launch URLs

## 🚀 **DEPLOYMENT & SCALING**

### **Production Considerations:**
1. **Database Optimization** - Indexes on frequently queried columns
2. **CDN Integration** - Static asset delivery
3. **Caching Strategy** - Challenge data caching
4. **Security Hardening** - RLS policies, input validation
5. **Monitoring** - Error tracking, performance metrics

### **Scaling Architecture:**
- **Horizontal Scaling** - Multiple Supabase instances
- **Challenge Hosting** - Separate infrastructure for live challenges
- **File Storage** - CDN for challenge files
- **Load Balancing** - Multiple frontend deployments

## 🔍 **DEBUGGING & MAINTENANCE**

### **Debug Components:**
- **SupabaseDebug.tsx** - Database connection testing
- **DebugChallenges.tsx** - Challenge data verification
- **LaunchTester.tsx** - Launch functionality testing

### **Common Issues & Solutions:**
1. **No challenges visible** - Check RLS policies, user authentication
2. **Launch buttons not working** - Verify instance_url values
3. **Authentication errors** - Check Supabase configuration
4. **Scoring issues** - Verify submissions table and triggers

## 📊 **ANALYTICS & METRICS**

### **Tracked Metrics:**
- Challenge solve rates
- User engagement patterns
- Popular challenge categories
- Average solve times
- User progression paths

### **Performance Monitoring:**
- Database query performance
- Frontend load times
- Challenge launch success rates
- User session analytics

## 🔮 **FUTURE ENHANCEMENTS**

### **Planned Features:**
1. **Team Competitions** - Multi-user team support
2. **Live Events** - Timed CTF competitions
3. **Achievement System** - Badges and milestones
4. **Challenge Ratings** - User feedback system
5. **Advanced Analytics** - Detailed progress tracking
6. **Mobile App** - React Native implementation
7. **API Integration** - External challenge sources
8. **Containerized Challenges** - Docker-based environments

---

## 📝 **SUMMARY**

SEENAF_CTF is a comprehensive CTF platform that combines modern web technologies with cybersecurity education. The platform provides:

- **52 challenges** across 9 categories
- **Role-based access control** (admin/player)
- **Interactive challenge environments**
- **Real-time scoring and leaderboards**
- **Professional admin panel**
- **Responsive, accessible design**
- **Scalable architecture**

The codebase is well-structured, documented, and ready for production deployment with room for future enhancements and scaling.