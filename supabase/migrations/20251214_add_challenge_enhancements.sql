-- Add new fields to challenges table
ALTER TABLE challenges 
ADD COLUMN IF NOT EXISTS author TEXT,
ADD COLUMN IF NOT EXISTS instance_url TEXT,
ADD COLUMN IF NOT EXISTS solver_count INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS likes_count INTEGER DEFAULT 0;

-- Create challenge_likes table
CREATE TABLE IF NOT EXISTS challenge_likes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  challenge_id UUID REFERENCES challenges(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, challenge_id)
);

-- Enable RLS on challenge_likes
ALTER TABLE challenge_likes ENABLE ROW LEVEL SECURITY;

-- Create policies for challenge_likes
CREATE POLICY "Users can view all likes" ON challenge_likes FOR SELECT USING (true);
CREATE POLICY "Users can manage their own likes" ON challenge_likes FOR ALL USING (auth.uid() = user_id);

-- Create function to update solver count
CREATE OR REPLACE FUNCTION update_challenge_solver_count()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.is_correct = true AND (OLD IS NULL OR OLD.is_correct = false) THEN
    UPDATE challenges 
    SET solver_count = solver_count + 1 
    WHERE id = NEW.challenge_id;
  ELSIF OLD.is_correct = true AND NEW.is_correct = false THEN
    UPDATE challenges 
    SET solver_count = GREATEST(solver_count - 1, 0) 
    WHERE id = NEW.challenge_id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for solver count
DROP TRIGGER IF EXISTS trigger_update_solver_count ON submissions;
CREATE TRIGGER trigger_update_solver_count
  AFTER INSERT OR UPDATE ON submissions
  FOR EACH ROW
  EXECUTE FUNCTION update_challenge_solver_count();

-- Create function to update likes count
CREATE OR REPLACE FUNCTION update_challenge_likes_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE challenges 
    SET likes_count = likes_count + 1 
    WHERE id = NEW.challenge_id;
    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE challenges 
    SET likes_count = GREATEST(likes_count - 1, 0) 
    WHERE id = OLD.challenge_id;
    RETURN OLD;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for likes count
DROP TRIGGER IF EXISTS trigger_update_likes_count ON challenge_likes;
CREATE TRIGGER trigger_update_likes_count
  AFTER INSERT OR DELETE ON challenge_likes
  FOR EACH ROW
  EXECUTE FUNCTION update_challenge_likes_count();