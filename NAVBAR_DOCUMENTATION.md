# Navbar.tsx - Line-by-Line Documentation

## **File Purpose**: Navigation bar component with authentication, role-based menu, and user profile display

### **Imports Section (Lines 1-6)**
```typescript
// Line 1: React Router hooks for navigation and location detection
import { Link, useLocation, useNavigate } from 'react-router-dom';

// Line 2: Framer Motion for smooth animations
import { motion } from 'framer-motion';

// Line 3: Lucide React icons for UI elements
import { Terminal, Trophy, Flag, Settings, LogOut, User } from 'lucide-react';

// Line 4: Reusable button component from UI library
import { Button } from '@/components/ui/button';

// Line 5: Custom authentication hook
import { useAuth } from '@/hooks/useAuth';
```

### **Component Declaration (Line 7)**
```typescript
// Line 7: Export function component named Navbar
export function Navbar() {
```

### **Hooks and State (Lines 8-10)**
```typescript
// Line 8: Destructure authentication data and functions from useAuth hook
const { user, profile, role, signOut } = useAuth();

// Line 9: Get current route location for active nav highlighting
const location = useLocation();

// Line 10: Navigation function for programmatic routing
const navigate = useNavigate();
```

### **Sign Out Handler (Lines 12-15)**
```typescript
// Line 12: Async function to handle user logout
const handleSignOut = async () => {
  // Line 13: Call signOut function from auth hook
  await signOut();
  // Line 14: Redirect to home page after logout
  navigate('/');
};
```

### **Navigation Items Configuration (Lines 17-24)**
```typescript
// Line 17: Define base navigation items array
const navItems = [
  // Line 18: Challenges page navigation item
  { path: '/challenges', label: 'Challenges', icon: Flag },
  // Line 19: Leaderboard page navigation item  
  { path: '/leaderboard', label: 'Leaderboard', icon: Trophy },
];

// Line 22: Conditional admin menu item
if (role === 'admin') {
  // Line 23: Add admin panel to navigation for admin users
  navItems.push({ path: '/admin', label: 'Admin', icon: Settings });
}
```

### **Component JSX Return (Lines 26-82)**
```typescript
// Line 26: Return JSX with motion wrapper for animations
return (
  // Lines 27-31: Animated navigation container with glass effect
  <motion.nav
    initial={{ y: -20, opacity: 0 }}    // Start position: above and transparent
    animate={{ y: 0, opacity: 1 }}      // End position: normal and opaque
    className="fixed top-0 left-0 right-0 z-50 glass border-b border-border/50"
  >
    // Line 32: Container with responsive padding
    <div className="container mx-auto px-4">
      // Line 33: Flex container for navbar content
      <div className="flex items-center justify-between h-16">
        
        // Lines 34-40: Logo/Brand section
        <Link to="/" className="flex items-center gap-2 group">
          // Line 35: Terminal icon with hover effects
          <Terminal className="h-6 w-6 text-primary group-hover:text-glow transition-all" />
          // Lines 36-39: Brand text with hover glow effect
          <span className="font-mono font-bold text-lg text-primary group-hover:text-glow">
            SEENAF_CTF
          </span>
        </Link>

        // Lines 42-58: Main navigation menu (desktop only)
        {user && (
          <div className="hidden md:flex items-center gap-1">
            // Lines 44-57: Map through navigation items
            {navItems.map((item) => {
              // Line 45: Extract icon component
              const Icon = item.icon;
              // Line 46: Check if current route matches item path
              const isActive = location.pathname === item.path;
              // Line 47: Return navigation link
              return (
                <Link key={item.path} to={item.path}>
                  // Lines 49-55: Navigation button with active state
                  <Button
                    variant={isActive ? "default" : "ghost"}  // Highlight active page
                    size="sm"
                    className="gap-2"
                  >
                    // Line 53: Icon for navigation item
                    <Icon className="h-4 w-4" />
                    // Line 54: Label text
                    {item.label}
                  </Button>
                </Link>
              );
            })}
          </div>
        )}

        // Lines 60-81: User profile and authentication section
        <div className="flex items-center gap-3">
          {user ? (
            // Lines 62-78: Authenticated user display
            <>
              // Lines 63-69: User profile info (hidden on small screens)
              <div className="hidden sm:flex items-center gap-2 px-3 py-1.5 rounded-lg bg-secondary/50 border border-border">
                <User className="h-4 w-4 text-primary" />           // User icon
                <span className="font-mono text-sm">{profile?.username}</span>  // Username
                <span className="text-primary font-bold">{profile?.total_score ?? 0}</span>  // Score
                <span className="text-muted-foreground text-xs">pts</span>      // Points label
              </div>
              // Lines 70-72: Logout button
              <Button variant="ghost" size="icon" onClick={handleSignOut}>
                <LogOut className="h-4 w-4" />
              </Button>
            </>
          ) : (
            // Lines 74-78: Login button for unauthenticated users
            <Link to="/auth">
              <Button variant="outline" size="sm">
                Login
              </Button>
            </Link>
          )}
        </div>
      </div>
    </div>
  </motion.nav>
);
```

## **Component Features:**

### **🎨 Visual Features:**
- **Glass morphism effect** with backdrop blur
- **Smooth animations** on mount with Framer Motion
- **Hover effects** on logo and navigation items
- **Active state highlighting** for current page
- **Responsive design** with mobile-friendly layout

### **🔐 Authentication Integration:**
- **Conditional rendering** based on user authentication status
- **Role-based navigation** (admin panel for admins only)
- **User profile display** with username and score
- **Logout functionality** with redirect

### **📱 Responsive Behavior:**
- **Desktop**: Full navigation menu with user profile
- **Mobile**: Collapsed menu (navigation hidden on small screens)
- **Tablet**: Partial profile info hidden on small screens

### **🎯 Accessibility Features:**
- **Semantic HTML** with proper nav element
- **Keyboard navigation** support through Button components
- **Screen reader friendly** with descriptive labels
- **Focus management** with proper tab order

### **⚡ Performance Optimizations:**
- **Conditional rendering** to avoid unnecessary DOM elements
- **Memoized navigation items** (could be optimized further)
- **Efficient re-renders** through proper hook usage
- **Lazy icon loading** through Lucide React

This navbar serves as the main navigation hub for the entire SEENAF_CTF platform, providing seamless user experience with authentication awareness and role-based access control.