# 🚀 Performance & Scaling Guide

This guide explains how many users your SEENAF CTF Platform can handle and how to scale it.

---

## 📊 Current Capacity

### Supabase Free Tier Limits

| Resource | Free Tier Limit | Impact on Users |
|----------|----------------|-----------------|
| Database Storage | 500 MB | ~10,000 users with full profiles |
| Bandwidth | 2 GB/month | ~1,000-5,000 active users/month |
| Monthly Active Users | 50,000 | Authentication limit |
| Concurrent Realtime | 500 | Live leaderboard connections |
| CPU Hours | 2 hours/day | Database processing time |

### Realistic Concurrent Users

**Conservative Estimate: 100-200 simultaneous users**
**Optimistic Estimate: 300-500 simultaneous users**

This depends on:
- User activity level
- Challenge complexity
- Real-time feature usage
- Database query efficiency

---

## 🎯 User Activity Impact

### High Impact Activities (Heavy Database Usage)

```
Activity                 | DB Impact | Bandwidth | Concurrent Limit
------------------------|-----------|-----------|------------------
Flag Submissions        | High      | Low       | ~50-100 users
Real-time Leaderboard   | Medium    | Medium    | ~500 users
Challenge Creation      | High      | Low       | ~10-20 admins
File Uploads           | Low       | High      | ~20-50 users
```

### Low Impact Activities (Light Usage)

```
Activity                 | DB Impact | Bandwidth | Concurrent Limit
------------------------|-----------|-----------|------------------
Browsing Challenges     | Low       | Low       | ~1000+ users
Reading Hints          | Low       | Low       | ~1000+ users
Viewing Profiles       | Low       | Low       | ~500+ users
Static Content         | None      | Low       | Unlimited
```

---

## 📈 Scaling Strategies

### 1. Immediate Optimizations (Free)

#### Database Optimizations

```sql
-- Add indexes for better performance
CREATE INDEX IF NOT EXISTS idx_submissions_user_id ON submissions(user_id);
CREATE INDEX IF NOT EXISTS idx_submissions_challenge_id ON submissions(challenge_id);
CREATE INDEX IF NOT EXISTS idx_challenges_category ON challenges(category);
CREATE INDEX IF NOT EXISTS idx_profiles_score ON profiles(score DESC);

-- Optimize leaderboard query
CREATE MATERIALIZED VIEW leaderboard_cache AS
SELECT 
  profiles.username,
  profiles.score,
  COUNT(submissions.id) as solved_challenges,
  profiles.updated_at
FROM profiles
LEFT JOIN submissions ON profiles.id = submissions.user_id
WHERE submissions.is_correct = true
GROUP BY profiles.id, profiles.username, profiles.score, profiles.updated_at
ORDER BY profiles.score DESC, profiles.updated_at ASC;

-- Refresh cache periodically
REFRESH MATERIALIZED VIEW leaderboard_cache;
```

#### Frontend Optimizations

```typescript
// Implement caching for challenges
const useCachedChallenges = () => {
  const [challenges, setChallenges] = useState([]);
  const [lastFetch, setLastFetch] = useState(0);
  
  useEffect(() => {
    const now = Date.now();
    const cacheTime = 5 * 60 * 1000; // 5 minutes
    
    if (now - lastFetch > cacheTime) {
      fetchChallenges().then(data => {
        setChallenges(data);
        setLastFetch(now);
        localStorage.setItem('challenges_cache', JSON.stringify({
          data,
          timestamp: now
        }));
      });
    } else {
      // Load from cache
      const cached = localStorage.getItem('challenges_cache');
      if (cached) {
        setChallenges(JSON.parse(cached).data);
      }
    }
  }, []);
  
  return challenges;
};

// Debounce flag submissions
const debouncedSubmit = useMemo(
  () => debounce(submitFlag, 1000),
  []
);
```

#### Real-time Optimizations

```typescript
// Limit real-time subscriptions
const useOptimizedLeaderboard = () => {
  const [leaderboard, setLeaderboard] = useState([]);
  
  useEffect(() => {
    // Only subscribe if user is viewing leaderboard
    if (isLeaderboardVisible) {
      const subscription = supabase
        .channel('leaderboard')
        .on('postgres_changes', {
          event: '*',
          schema: 'public',
          table: 'profiles'
        }, (payload) => {
          // Throttle updates to every 5 seconds
          throttledUpdate(payload);
        })
        .subscribe();
        
      return () => subscription.unsubscribe();
    }
  }, [isLeaderboardVisible]);
};
```

### 2. Supabase Pro Upgrade ($25/month)

**Capacity Increase:**
- **~1,000-2,000 simultaneous users**
- **8 GB database storage**
- **250 GB bandwidth**
- **Dedicated CPU**
- **Better performance**

**When to upgrade:**
- More than 200 regular users
- Frequent performance issues
- Need better reliability

### 3. Advanced Scaling (Team Plan $599/month)

**Capacity Increase:**
- **~5,000-10,000+ simultaneous users**
- **Unlimited storage and bandwidth**
- **High availability**
- **Multiple regions**
- **Priority support**

---

## 🔧 Performance Monitoring

### Add Performance Tracking

```typescript
// Add to your app
const usePerformanceMonitoring = () => {
  useEffect(() => {
    // Track page load times
    const observer = new PerformanceObserver((list) => {
      list.getEntries().forEach((entry) => {
        console.log(`${entry.name}: ${entry.duration}ms`);
        
        // Send to analytics (optional)
        if (entry.duration > 3000) {
          console.warn('Slow page load detected');
        }
      });
    });
    
    observer.observe({ entryTypes: ['navigation', 'measure'] });
    
    return () => observer.disconnect();
  }, []);
};

// Database query monitoring
const monitorQuery = async (queryName, queryFn) => {
  const start = performance.now();
  try {
    const result = await queryFn();
    const duration = performance.now() - start;
    
    console.log(`Query ${queryName}: ${duration}ms`);
    
    if (duration > 1000) {
      console.warn(`Slow query detected: ${queryName}`);
    }
    
    return result;
  } catch (error) {
    console.error(`Query failed: ${queryName}`, error);
    throw error;
  }
};
```

### Monitor Supabase Usage

```sql
-- Check database size
SELECT 
  schemaname,
  tablename,
  pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as size
FROM pg_tables 
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;

-- Check active connections
SELECT count(*) as active_connections 
FROM pg_stat_activity 
WHERE state = 'active';

-- Check slow queries
SELECT 
  query,
  mean_exec_time,
  calls
FROM pg_stat_statements 
ORDER BY mean_exec_time DESC 
LIMIT 10;
```

---

## 🎯 Load Testing

### Test Your Platform

```bash
# Install artillery for load testing
npm install -g artillery

# Create load test config
cat > load-test.yml << EOF
config:
  target: 'http://localhost:5173'
  phases:
    - duration: 60
      arrivalRate: 10
    - duration: 120
      arrivalRate: 50
    - duration: 60
      arrivalRate: 100

scenarios:
  - name: "Browse challenges"
    weight: 70
    flow:
      - get:
          url: "/"
      - get:
          url: "/challenges"
      - think: 5

  - name: "Submit flags"
    weight: 20
    flow:
      - post:
          url: "/api/submit"
          json:
            flag: "test_flag"
            challenge_id: 1
      - think: 10

  - name: "View leaderboard"
    weight: 10
    flow:
      - get:
          url: "/leaderboard"
      - think: 3
EOF

# Run load test
artillery run load-test.yml
```

---

## 📊 Capacity Planning

### User Growth Planning

| Users | Supabase Plan | Monthly Cost | Features |
|-------|---------------|--------------|----------|
| 1-200 | Free | $0 | Basic features |
| 200-1,000 | Pro | $25 | Better performance |
| 1,000-5,000 | Team | $599 | High availability |
| 5,000+ | Enterprise | Custom | Dedicated support |

### Resource Usage Estimates

```
100 Active Users:
- Database: ~50 MB
- Bandwidth: ~500 MB/month
- Concurrent connections: ~20-50

500 Active Users:
- Database: ~200 MB
- Bandwidth: ~2 GB/month
- Concurrent connections: ~100-200

1,000 Active Users:
- Database: ~400 MB
- Bandwidth: ~5 GB/month
- Concurrent connections: ~200-400
```

---

## 🚨 Warning Signs

### When to Scale Up

**Database Issues:**
- Query times > 2 seconds
- Connection timeouts
- Storage > 80% full

**Performance Issues:**
- Page load times > 5 seconds
- Real-time updates delayed
- User complaints about slowness

**Usage Issues:**
- Bandwidth limit warnings
- CPU hour warnings
- Connection limit reached

---

## 🔄 CDN & Caching

### Add CDN for Static Assets

```typescript
// Use CDN for images and static files
const CDN_URL = 'https://cdn.yoursite.com';

const optimizedImageUrl = (path: string) => {
  return `${CDN_URL}${path}?w=400&q=80`;
};

// Implement service worker for caching
// public/sw.js
self.addEventListener('fetch', (event) => {
  if (event.request.destination === 'image') {
    event.respondWith(
      caches.open('images').then(cache => {
        return cache.match(event.request).then(response => {
          return response || fetch(event.request).then(fetchResponse => {
            cache.put(event.request, fetchResponse.clone());
            return fetchResponse;
          });
        });
      })
    );
  }
});
```

---

## 📈 Horizontal Scaling

### Multiple Regions (Enterprise)

```yaml
# docker-compose.yml for multi-region
version: '3.8'
services:
  app-us:
    build: .
    environment:
      - REGION=us-east-1
      - SUPABASE_URL=${SUPABASE_URL_US}
    
  app-eu:
    build: .
    environment:
      - REGION=eu-west-1
      - SUPABASE_URL=${SUPABASE_URL_EU}
    
  load-balancer:
    image: nginx
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
```

---

## 🎯 Recommendations

### For Small CTF Events (< 100 users)
- ✅ **Free Supabase tier is sufficient**
- ✅ Implement basic optimizations
- ✅ Monitor usage regularly

### For Medium CTF Events (100-500 users)
- ✅ **Upgrade to Supabase Pro ($25/month)**
- ✅ Implement all optimizations
- ✅ Add performance monitoring
- ✅ Consider CDN for static assets

### For Large CTF Events (500+ users)
- ✅ **Supabase Team plan ($599/month)**
- ✅ Load testing before event
- ✅ Multiple database replicas
- ✅ Professional monitoring tools
- ✅ Dedicated support team

### For Enterprise/Continuous Use
- ✅ **Custom enterprise plan**
- ✅ Multi-region deployment
- ✅ Advanced caching strategies
- ✅ Dedicated infrastructure
- ✅ 24/7 monitoring

---

## 🔍 Monitoring Tools

### Free Monitoring
- Supabase Dashboard (built-in)
- Browser DevTools
- Console logging

### Paid Monitoring
- **Sentry** - Error tracking
- **DataDog** - Performance monitoring
- **New Relic** - Application monitoring
- **Pingdom** - Uptime monitoring

---

## 📞 Need Help?

If you're planning a large CTF event:

1. **Estimate your users** - How many participants?
2. **Test your load** - Run load tests
3. **Plan your budget** - Calculate Supabase costs
4. **Implement optimizations** - Follow this guide
5. **Monitor closely** - Watch performance during event

**Contact Supabase support for enterprise needs or custom scaling solutions.**

---

**Remember: It's better to over-provision for important events than to have performance issues during competition!**