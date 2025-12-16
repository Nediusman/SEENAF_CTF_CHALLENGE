import { supabase } from '@/integrations/supabase/client';

export const loadPicoCTFChallenges = async () => {
  const challenges = [
    // Web Challenges
    {
      title: 'Inspect HTML',
      description: 'Can you find the flag that\'s hiding in this webpage?\n\nThis is a basic web challenge where you need to examine the HTML source code of a webpage to find a hidden flag.',
      category: 'Web',
      difficulty: 'easy',
      points: 100,
      flag: 'SEENAF{1nsp3ct_th3_html_s0urc3}',
      hints: ['Try right-clicking and selecting "View Page Source"', 'Look for HTML comments', 'The flag might be in a hidden div or comment'],
      is_active: true
    },
    {
      title: 'Cookies',
      description: 'I heard you like cookies. Nom nom nom.\n\nThis challenge involves manipulating browser cookies to access restricted content.',
      category: 'Web',
      difficulty: 'easy',
      points: 150,
      flag: 'SEENAF{c00k13_m0nst3r_0mg}',
      hints: ['Check your browser\'s cookies for this site', 'Try changing cookie values', 'Look for cookies named "admin" or "role"'],
      is_active: true
    },
    {
      title: 'SQL Injection',
      description: 'Login as the admin user to get the flag.\n\nThis login form is vulnerable to SQL injection. The admin username is "admin".',
      category: 'Web',
      difficulty: 'medium',
      points: 250,
      flag: 'SEENAF{sql_1nj3ct10n_1s_d4ng3r0us}',
      hints: ['Try SQL injection in the password field', 'Use OR 1=1 to bypass authentication', 'Comment out the rest of the query with --'],
      is_active: true
    },
    {
      title: 'XSS Playground',
      description: 'This comment system doesn\'t properly sanitize user input. Can you execute JavaScript code?\n\nFind a way to execute JavaScript in the comment system.',
      category: 'Web',
      difficulty: 'medium',
      points: 300,
      flag: 'SEENAF{xss_4tt4ck_succ3ssful}',
      hints: ['Try injecting <script> tags in comments', 'Use alert() to test XSS', 'Look for input fields that reflect user data'],
      is_active: true
    },
    // Crypto Challenges
    {
      title: 'The Numbers',
      description: 'The numbers... what do they mean?\n\n13 9 3 15 3 20 6 { 20 8 5 14 21 13 2 5 18 19 13 1 19 15 14 }',
      category: 'Crypto',
      difficulty: 'easy',
      points: 100,
      flag: 'SEENAF{THENUMBERSMASON}',
      hints: ['These look like numbers representing letters', 'A=1, B=2, C=3, etc.', 'Convert each number to its corresponding letter'],
      is_active: true
    },
    {
      title: 'Caesar',
      description: 'Decrypt this message that was encrypted with a Caesar cipher.\n\nVHHQDI{FDHVDU_FLSKHU_LV_HDVB_SHDBV}',
      category: 'Crypto',
      difficulty: 'easy',
      points: 150,
      flag: 'SEENAF{CAESAR_CIPHER_IS_EASY_PEASY}',
      hints: ['This is a Caesar cipher', 'Try different shift values', 'The shift is likely 3 (classic Caesar)'],
      is_active: true
    },
    {
      title: 'Base64 Basics',
      description: 'Decode this Base64 encoded message to find the flag.\n\nU0VFTkFGe2Jhc2U2NF9pc19ub3RfZW5jcnlwdGlvbn0=',
      category: 'Crypto',
      difficulty: 'easy',
      points: 75,
      flag: 'SEENAF{base64_is_not_encryption}',
      hints: ['This looks like Base64 encoding', 'Use an online Base64 decoder', 'Look for the = padding at the end'],
      is_active: true
    },
    {
      title: 'Vigenère Cipher',
      description: 'This message was encrypted using a Vigenère cipher with the key "SEENAF".\n\nEncrypted: SEENAF{KQGQVKW_UQJLWV_QD_UVKQTM}',
      category: 'Crypto',
      difficulty: 'medium',
      points: 200,
      flag: 'SEENAF{VIGENERE_CIPHER_IS_STRONG}',
      hints: ['The key is "SEENAF"', 'Vigenère uses a repeating key', 'Try an online Vigenère decoder'],
      is_active: true
    },
    // Forensics Challenges
    {
      title: 'File Extensions',
      description: 'This file doesn\'t seem to be what it appears to be.\n\nDownload the file and determine its real type to extract the flag.',
      category: 'Forensics',
      difficulty: 'easy',
      points: 100,
      flag: 'SEENAF{f1l3_3xt3ns10ns_l13}',
      hints: ['Use the "file" command to check the real file type', 'The extension might be misleading', 'Try opening with different programs'],
      is_active: true
    },
    {
      title: 'Hidden Message',
      description: 'This image looks innocent, but there\'s a hidden message inside.\n\nUse steganography tools to find the hidden flag.',
      category: 'Forensics',
      difficulty: 'medium',
      points: 200,
      flag: 'SEENAF{st3g4n0gr4phy_m4st3r}',
      hints: ['Use steganography tools like steghide', 'Try the strings command on the image', 'Check the image metadata with exiftool'],
      is_active: true
    },
    {
      title: 'Wireshark Analysis',
      description: 'Can you find the flag in this network capture?\n\nAnalyze the PCAP file to find suspicious network traffic containing the flag.',
      category: 'Forensics',
      difficulty: 'medium',
      points: 250,
      flag: 'SEENAF{n3tw0rk_tr4ff1c_4n4lys1s}',
      hints: ['Use Wireshark to open the PCAP file', 'Look for HTTP traffic', 'Check POST requests and form data'],
      is_active: true
    },
    {
      title: 'Memory Dump',
      description: 'We captured the memory of a compromised system. The attacker left traces.\n\nAnalyze the memory dump to find the flag.',
      category: 'Forensics',
      difficulty: 'hard',
      points: 350,
      flag: 'SEENAF{m3m0ry_f0r3ns1cs_3xp3rt}',
      hints: ['Use Volatility framework', 'Look for suspicious processes', 'Check for injected code or strings'],
      is_active: true
    },
    // Network Analysis Challenges
    {
      title: 'What\'s a NET?',
      description: 'How about you find the flag in this network capture?\n\nBasic network analysis challenge - find the flag in HTTP traffic.',
      category: 'Network',
      difficulty: 'easy',
      points: 100,
      flag: 'SEENAF{n3tw0rk_b4s1cs_ftw}',
      hints: ['Use Wireshark to analyze the PCAP', 'Look for HTTP GET/POST requests', 'The flag might be in plain text'],
      is_active: true
    },
    {
      title: 'Shark on Wire 1',
      description: 'We found this packet capture. Recover the flag.\n\nIntermediate network forensics - the flag is encoded or hidden in the traffic.',
      category: 'Network',
      difficulty: 'medium',
      points: 200,
      flag: 'SEENAF{sh4rk_0n_w1r3_1s_c00l}',
      hints: ['Use Wireshark\'s "Follow TCP Stream" feature', 'Look for base64 encoded data', 'Check different protocols (HTTP, FTP, etc.)'],
      is_active: true
    },
    {
      title: 'DNS Exfiltration',
      description: 'Data was exfiltrated through DNS queries. Can you recover it?\n\nAnalyze DNS traffic to find the hidden data.',
      category: 'Network',
      difficulty: 'medium',
      points: 250,
      flag: 'SEENAF{dns_3xf1ltr4t10n_d3t3ct3d}',
      hints: ['Look for unusual DNS queries', 'Check for data encoded in subdomain names', 'The data might be base64 encoded'],
      is_active: true
    },
    {
      title: 'TFTP Transfer',
      description: 'Figure out how they moved the flag using TFTP.\n\nThis challenge involves analyzing TFTP (Trivial File Transfer Protocol) traffic.',
      category: 'Network',
      difficulty: 'hard',
      points: 300,
      flag: 'SEENAF{tftp_f1l3_tr4nsf3r_pwn3d}',
      hints: ['Look for TFTP traffic in the capture', 'TFTP uses UDP port 69', 'Extract the transferred file'],
      is_active: true
    }
  ];

  try {
    console.log('🚀 Loading PicoCTF-style challenges...');
    
    // Clear existing challenges first
    await supabase.from('challenges').delete().neq('id', '00000000-0000-0000-0000-000000000000');
    
    // Insert new challenges
    const { data, error } = await supabase
      .from('challenges')
      .insert(challenges)
      .select();

    if (error) {
      console.error('❌ Error loading challenges:', error);
      return { success: false, error: error.message };
    }

    console.log('✅ Successfully loaded', data?.length || 0, 'challenges');
    return { success: true, count: data?.length || 0 };
    
  } catch (error: any) {
    console.error('💥 Load challenges error:', error);
    return { success: false, error: error.message };
  }
};