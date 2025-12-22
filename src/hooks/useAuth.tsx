import { createContext, useContext, useEffect, useState, ReactNode } from 'react';
import { User, Session } from '@supabase/supabase-js';
import { supabase } from '@/integrations/supabase/client';
import { Profile, AppRole } from '@/types/database';
import { AuthController } from '@/controllers/AuthController';

interface AuthContextType {
  user: User | null;
  session: Session | null;
  profile: Profile | null;
  role: AppRole | null;
  loading: boolean;
  signUp: (email: string, password: string, username: string) => Promise<{ error: Error | null }>;
  signIn: (email: string, password: string) => Promise<{ error: Error | null }>;
  signOut: () => Promise<void>;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [session, setSession] = useState<Session | null>(null);
  const [profile, setProfile] = useState<Profile | null>(null);
  const [role, setRole] = useState<AppRole | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const { data: { subscription } } = supabase.auth.onAuthStateChange(
      (event, session) => {
        setSession(session);
        setUser(session?.user ?? null);
        
        if (session?.user) {
          setTimeout(() => {
            fetchUserData(session.user.id);
          }, 0);
        } else {
          setProfile(null);
          setRole(null);
          setLoading(false);
        }
      }
    );

    supabase.auth.getSession().then(({ data: { session } }) => {
      setSession(session);
      setUser(session?.user ?? null);
      if (session?.user) {
        fetchUserData(session.user.id);
      } else {
        setLoading(false);
      }
    });

    return () => subscription.unsubscribe();
  }, []);

  const fetchUserData = async (userId: string) => {
    try {
      console.log('👤 Fetching user data for:', userId);
      
      // First get profile
      const profileResult = await supabase
        .from('profiles')
        .select('*')
        .eq('id', userId)
        .maybeSingle();

      console.log('📊 Profile result:', profileResult);

      if (profileResult.data) {
        setProfile(profileResult.data as Profile);
      }

      // 🚨 EMERGENCY ADMIN BYPASS - Check user email first
      const { data: userData } = await supabase.auth.getUser();
      const userEmail = userData.user?.email;
      
      console.log('📧 User email:', userEmail);
      
      // Emergency admin access for your email
      if (userEmail === 'nediusman@gmail.com') {
        console.log('🚨 EMERGENCY ADMIN ACCESS GRANTED');
        setRole('admin');
        setLoading(false);
        return;
      }

      // Get role from database for other users
      try {
        let roleResult = await supabase
          .from('user_roles')
          .select('role')
          .eq('user_id', userId)
          .maybeSingle();

        console.log('👑 Role result:', roleResult);

        if (roleResult.data) {
          setRole(roleResult.data.role as AppRole);
          console.log('✅ Role set to:', roleResult.data.role);
        } else {
          console.log('⚠️ No role found, defaulting to player');
          setRole('player');
        }
      } catch (error) {
        console.log('⚠️ Error fetching role, defaulting to player');
        setRole('player');
      }
    } catch (error) {
      console.error('💥 Error fetching user data:', error);
      setRole('player'); // Safe default
    } finally {
      setLoading(false);
    }
  };

  const signUp = async (email: string, password: string, username: string) => {
    const result = await AuthController.signUp(email, password, username);
    
    if (result.success) {
      return { error: null };
    } else {
      return { error: new Error(result.error || 'Signup failed') };
    }
  };

  const signIn = async (email: string, password: string) => {
    const result = await AuthController.signIn(email, password);
    
    if (result.success) {
      setUser(result.user || null);
      setProfile(result.profile || null);
      setRole(result.role || null);
      setLoading(false);
      return { error: null };
    } else {
      return { error: new Error(result.error || 'Login failed') };
    }
  };

  const signOut = async () => {
    await AuthController.signOut();
    setUser(null);
    setSession(null);
    setProfile(null);
    setRole(null);
  };

  return (
    <AuthContext.Provider value={{ user, session, profile, role, loading, signUp, signIn, signOut }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
}