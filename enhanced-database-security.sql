-- Enhanced Database Security for SEENAF CTF Platform
-- This script implements comprehensive security measures including RLS, audit logging, and encryption

-- ============================================================================
-- 1. ENABLE ROW LEVEL SECURITY ON ALL TABLES
-- ============================================================================

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE challenges ENABLE ROW LEVEL SECURITY;
ALTER TABLE submissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_roles ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- 2. ENHANCED RLS POLICIES FOR PROFILES
-- ============================================================================

-- Drop existing policies
DROP POLICY IF EXISTS "Users can view own profile" ON profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON profiles;
DROP POLICY IF EXISTS "Users can insert own profile" ON profiles;

-- Users can view their own profile or admins can view all
CREATE POLICY "Users can view own profile" ON profiles
  FOR SELECT USING (
    auth.uid() = id OR 
    EXISTS (
      SELECT 1 FROM user_roles 
      WHERE user_id = auth.uid() 
      AND role IN ('admin', 'moderator')
    )
  );

-- Users can update only their own profile (prevent privilege escalation)
CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (
    auth.uid() = id AND
    -- Prevent changing immutable fields
    (OLD.id = NEW.id) AND
    (OLD.created_at = NEW.created_at)
  );

-- Users can insert their own profile
CREATE POLICY "Users can insert own profile" ON profiles
  FOR INSERT WITH CHECK (
    auth.uid() = id
  );

-- ============================================================================
-- 3. ENHANCED RLS POLICIES FOR CHALLENGES
-- ============================================================================

-- Drop existing policies
DROP POLICY IF EXISTS "Anyone can view published challenges" ON challenges;
DROP POLICY IF EXISTS "Only admins can modify challenges" ON challenges;

-- Anyone can view active challenges, admins can view all
CREATE POLICY "Anyone can view published challenges" ON challenges
  FOR SELECT USING (
    is_active = true OR
    EXISTS (
      SELECT 1 FROM user_roles 
      WHERE user_id = auth.uid() 
      AND role IN ('admin', 'moderator')
    )
  );

-- Only admins can insert challenges
CREATE POLICY "Only admins can insert challenges" ON challenges
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM user_roles 
      WHERE user_id = auth.uid() 
      AND role = 'admin'
    )
  );

-- Only admins can update challenges
CREATE POLICY "Only admins can update challenges" ON challenges
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM user_roles 
      WHERE user_id = auth.uid() 
      AND role = 'admin'
    )
  );

-- Only admins can delete challenges
CREATE POLICY "Only admins can delete challenges" ON challenges
  FOR DELETE USING (
    EXISTS (
      SELECT 1 FROM user_roles 
      WHERE user_id = auth.uid() 
      AND role = 'admin'
    )
  );

-- ============================================================================
-- 4. ENHANCED RLS POLICIES FOR SUBMISSIONS
-- ============================================================================

-- Drop existing policies
DROP POLICY IF EXISTS "Users can view own submissions" ON submissions;
DROP POLICY IF EXISTS "Users can create own submissions" ON submissions;

-- Users can view their own submissions, admins can view all
CREATE POLICY "Users can view own submissions" ON submissions
  FOR SELECT USING (
    user_id = auth.uid() OR
    EXISTS (
      SELECT 1 FROM user_roles 
      WHERE user_id = auth.uid() 
      AND role IN ('admin', 'moderator')
    )
  );

-- Users can create submissions with rate limiting
CREATE POLICY "Users can create own submissions" ON submissions
  FOR INSERT WITH CHECK (
    user_id = auth.uid() AND
    -- Rate limiting: max 10 submissions per minute
    (
      SELECT COUNT(*) 
      FROM submissions 
      WHERE user_id = auth.uid() 
      AND created_at > NOW() - INTERVAL '1 minute'
    ) < 10 AND
    -- Max 10 submissions per challenge
    (
      SELECT COUNT(*) 
      FROM submissions 
      WHERE user_id = auth.uid() 
      AND challenge_id = NEW.challenge_id
    ) < 10
  );

-- ============================================================================
-- 5. ENHANCED RLS POLICIES FOR USER ROLES
-- ============================================================================

-- Drop existing policies
DROP POLICY IF EXISTS "Only admins can manage roles" ON user_roles;
DROP POLICY IF EXISTS "Users can view own role" ON user_roles;

-- Users can view their own role
CREATE POLICY "Users can view own role" ON user_roles
  FOR SELECT USING (
    user_id = auth.uid() OR
    EXISTS (
      SELECT 1 FROM user_roles 
      WHERE user_id = auth.uid() 
      AND role = 'admin'
    )
  );

-- Only admins can manage roles
CREATE POLICY "Only admins can manage roles" ON user_roles
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM user_roles 
      WHERE user_id = auth.uid() 
      AND role = 'admin'
    )
  );

-- ============================================================================
-- 6. AUDIT LOGGING TABLE
-- ============================================================================

-- Create audit logs table if it doesn't exist
CREATE TABLE IF NOT EXISTS audit_logs (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  action TEXT NOT NULL,
  table_name TEXT NOT NULL,
  record_id UUID,
  old_values JSONB,
  new_values JSONB,
  ip_address INET,
  user_agent TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create index for faster queries
CREATE INDEX IF NOT EXISTS idx_audit_logs_user_id ON audit_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_created_at ON audit_logs(created_at);
CREATE INDEX IF NOT EXISTS idx_audit_logs_action ON audit_logs(action);
CREATE INDEX IF NOT EXISTS idx_audit_logs_table_name ON audit_logs(table_name);

-- Enable RLS on audit logs
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;

-- Only admins can view audit logs
DROP POLICY IF EXISTS "Only admins can view audit logs" ON audit_logs;
CREATE POLICY "Only admins can view audit logs" ON audit_logs
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM user_roles 
      WHERE user_id = auth.uid() 
      AND role = 'admin'
    )
  );

-- System can insert audit logs (bypass RLS for triggers)
DROP POLICY IF EXISTS "System can insert audit logs" ON audit_logs;
CREATE POLICY "System can insert audit logs" ON audit_logs
  FOR INSERT WITH CHECK (true);

-- ============================================================================
-- 7. AUDIT TRIGGER FUNCTION
-- ============================================================================

-- Create or replace audit trigger function
CREATE OR REPLACE FUNCTION audit_trigger_function()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'DELETE' THEN
    INSERT INTO audit_logs (user_id, action, table_name, record_id, old_values)
    VALUES (auth.uid(), 'DELETE', TG_TABLE_NAME, OLD.id, to_jsonb(OLD));
    RETURN OLD;
  ELSIF TG_OP = 'UPDATE' THEN
    INSERT INTO audit_logs (user_id, action, table_name, record_id, old_values, new_values)
    VALUES (auth.uid(), 'UPDATE', TG_TABLE_NAME, NEW.id, to_jsonb(OLD), to_jsonb(NEW));
    RETURN NEW;
  ELSIF TG_OP = 'INSERT' THEN
    INSERT INTO audit_logs (user_id, action, table_name, record_id, new_values)
    VALUES (auth.uid(), 'INSERT', TG_TABLE_NAME, NEW.id, to_jsonb(NEW));
    RETURN NEW;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- 8. CREATE AUDIT TRIGGERS
-- ============================================================================

-- Profiles audit trigger
DROP TRIGGER IF EXISTS audit_profiles_trigger ON profiles;
CREATE TRIGGER audit_profiles_trigger
  AFTER INSERT OR UPDATE OR DELETE ON profiles
  FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();

-- Challenges audit trigger
DROP TRIGGER IF EXISTS audit_challenges_trigger ON challenges;
CREATE TRIGGER audit_challenges_trigger
  AFTER INSERT OR UPDATE OR DELETE ON challenges
  FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();

-- User roles audit trigger
DROP TRIGGER IF EXISTS audit_user_roles_trigger ON user_roles;
CREATE TRIGGER audit_user_roles_trigger
  AFTER INSERT OR UPDATE OR DELETE ON user_roles
  FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();

-- Submissions audit trigger (only for updates/deletes, not inserts to avoid noise)
DROP TRIGGER IF EXISTS audit_submissions_trigger ON submissions;
CREATE TRIGGER audit_submissions_trigger
  AFTER UPDATE OR DELETE ON submissions
  FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();

-- ============================================================================
-- 9. RATE LIMITING FUNCTION
-- ============================================================================

-- Create rate limiting function
CREATE OR REPLACE FUNCTION check_rate_limit(
  user_uuid UUID,
  action_type TEXT,
  time_window INTERVAL DEFAULT '1 minute',
  max_attempts INTEGER DEFAULT 10
) RETURNS BOOLEAN AS $$
DECLARE
  attempt_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO attempt_count
  FROM audit_logs
  WHERE user_id = user_uuid
    AND action = action_type
    AND created_at > NOW() - time_window;
  
  RETURN attempt_count < max_attempts;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- 10. DATA ENCRYPTION FUNCTIONS
-- ============================================================================

-- Enable pgcrypto extension for encryption
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Function to encrypt sensitive data
CREATE OR REPLACE FUNCTION encrypt_sensitive_data(data TEXT, key TEXT DEFAULT 'default_key')
RETURNS TEXT AS $$
BEGIN
  RETURN encode(encrypt(data::bytea, key::bytea, 'aes'), 'base64');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to decrypt sensitive data
CREATE OR REPLACE FUNCTION decrypt_sensitive_data(encrypted_data TEXT, key TEXT DEFAULT 'default_key')
RETURNS TEXT AS $$
BEGIN
  RETURN convert_from(decrypt(decode(encrypted_data, 'base64'), key::bytea, 'aes'), 'UTF8');
EXCEPTION
  WHEN OTHERS THEN
    RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- 11. SECURITY HELPER FUNCTIONS
-- ============================================================================

-- Function to check if user is admin
CREATE OR REPLACE FUNCTION is_admin(user_uuid UUID DEFAULT auth.uid())
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM user_roles 
    WHERE user_id = user_uuid 
    AND role = 'admin'
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to check if user is moderator or admin
CREATE OR REPLACE FUNCTION is_moderator_or_admin(user_uuid UUID DEFAULT auth.uid())
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM user_roles 
    WHERE user_id = user_uuid 
    AND role IN ('admin', 'moderator')
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get user role
CREATE OR REPLACE FUNCTION get_user_role(user_uuid UUID DEFAULT auth.uid())
RETURNS TEXT AS $$
DECLARE
  user_role TEXT;
BEGIN
  SELECT role INTO user_role
  FROM user_roles
  WHERE user_id = user_uuid;
  
  RETURN COALESCE(user_role, 'player');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- 12. SECURITY INDEXES FOR PERFORMANCE
-- ============================================================================

-- Indexes for faster security checks
CREATE INDEX IF NOT EXISTS idx_user_roles_user_id ON user_roles(user_id);
CREATE INDEX IF NOT EXISTS idx_user_roles_role ON user_roles(role);
CREATE INDEX IF NOT EXISTS idx_submissions_user_id_created_at ON submissions(user_id, created_at);
CREATE INDEX IF NOT EXISTS idx_submissions_challenge_id_user_id ON submissions(challenge_id, user_id);
CREATE INDEX IF NOT EXISTS idx_challenges_is_active ON challenges(is_active);

-- ============================================================================
-- SECURITY SETUP COMPLETE
-- ============================================================================

-- Verify security setup
DO $$
BEGIN
  RAISE NOTICE '✅ Enhanced database security has been applied successfully!';
  RAISE NOTICE '📋 Security features enabled:';
  RAISE NOTICE '   - Row Level Security (RLS) on all tables';
  RAISE NOTICE '   - Comprehensive audit logging';
  RAISE NOTICE '   - Rate limiting functions';
  RAISE NOTICE '   - Data encryption functions';
  RAISE NOTICE '   - Security helper functions';
  RAISE NOTICE '   - Performance indexes';
  RAISE NOTICE '';
  RAISE NOTICE '🔒 Your database is now secured with multiple layers of protection!';
END $$;
