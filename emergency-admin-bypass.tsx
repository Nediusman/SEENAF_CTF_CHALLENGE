// 🚨 EMERGENCY ADMIN BYPASS - TEMPORARY FIX
// Replace the fetchUserData function in src/hooks/useAuth.tsx with this version
// This adds emergency admin access for your email

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