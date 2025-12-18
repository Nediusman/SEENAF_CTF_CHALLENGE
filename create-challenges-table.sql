-- CREATE CHALLENGES TABLE - Run this first if table doesn't exist

-- Create challenges table
CREATE TABLE IF NOT EXISTS challenges (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    category TEXT NOT NULL,
    difficulty TEXT NOT NULL CHECK (difficulty IN ('easy', 'medium', 'hard', 'insane')),
    points INTEGER NOT NULL DEFAULT 100,
    flag TEXT NOT NULL,
    hints TEXT[],
    author TEXT,
    instance_url TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Disable RLS for easier access
ALTER TABLE challenges DISABLE ROW LEVEL SECURITY;

-- Grant permissions
GRANT ALL ON challenges TO authenticated;
GRANT ALL ON challenges TO anon;

SELECT 'Challenges table created successfully!' as status;