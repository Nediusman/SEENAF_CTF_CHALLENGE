# SEENAF CTF Database Setup

## Step 1: Run Supabase Migrations

If you haven't already set up your Supabase database, you need to:

1. **Start Supabase locally** (if using local development):
   ```bash
   npx supabase start
   ```

2. **Or connect to your hosted Supabase project** and run the migrations:
   ```bash
   npx supabase db push
   ```

## Step 2: Add Sample Challenges

You have two options to add challenges to your database:

### Option A: Using Supabase Dashboard (Recommended)
1. Go to your Supabase project dashboard
2. Navigate to **SQL Editor**
3. Copy and paste the contents of `setup-challenges.sql`
4. Click **Run** to execute the SQL

### Option B: Using Command Line
```bash
# If using local Supabase
npx supabase db reset

# Then run the setup
psql -h localhost -p 54322 -d postgres -U postgres -f setup-challenges.sql
```

## Step 3: Create Admin User

To access the admin panel, you need to create an admin user:

1. **Register a new account** through the app at `/auth`
2. **Run this SQL** in Supabase SQL Editor (replace with your email):
   ```sql
   -- Replace 'your-email@example.com' with your actual email
   INSERT INTO user_roles (user_id, role)
   SELECT id, 'admin'
   FROM auth.users 
   WHERE email = 'your-email@example.com'
   ON CONFLICT (user_id, role) DO NOTHING;
   ```

## Step 4: Verify Setup

1. **Start your development server**:
   ```bash
   npm run dev
   ```

2. **Check the challenges page** at `/challenges`
3. **Login as admin** and check `/admin` to manage challenges

## Troubleshooting

### No Challenges Showing?
- Check if your Supabase connection is working
- Verify the migrations ran successfully
- Check browser console for any errors

### Can't Access Admin Panel?
- Make sure you've added the admin role to your user
- Check that you're logged in with the correct account

### Database Connection Issues?
- Verify your `.env` file has the correct Supabase credentials
- Check if your Supabase project is running

## Sample Challenges Included

The setup includes 14 sample challenges across all categories:
- **Web**: 4 challenges (including "Crack the Gate 1" from your screenshot)
- **Crypto**: 3 challenges
- **Forensics**: 2 challenges  
- **Reverse**: 1 challenge
- **Pwn**: 1 challenge
- **Misc**: 3 challenges

Each challenge includes:
- ✅ Title and description
- ✅ Author information
- ✅ Difficulty and points
- ✅ Hints system
- ✅ Instance URLs (where applicable)
- ✅ Realistic solver/like counts