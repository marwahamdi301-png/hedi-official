#!/bin/bash
echo "🚀 ZENITH Africa - Professional Upgrade Starting..."

# Install new dependencies
echo "📦 Installing dependencies..."
npm install @supabase/supabase-js framer-motion zustand react-hot-toast react-router-dom

# Create folder structure
mkdir -p src/{components,pages,lib,context,hooks}

# Supabase Client
cat > src/lib/supabase.js << 'EOF'
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL || 'https://your-project.supabase.co'
const supabaseKey = import.meta.env.VITE_SUPABASE_ANON_KEY || 'your-anon-key'

export const supabase = createClient(supabaseUrl, supabaseKey)

// Auth functions
export const signUp = async (email, password, fullName) => {
  const { data, error } = await supabase.auth.signUp({
    email,
    password,
    options: { data: { full_name: fullName } }
  })
  if (!error) {
    await supabase.from('users').insert({
      id: data.user.id,
      email,
      full_name: fullName,
      balance: 0,
      total_deposited: 0,
      total_profit: 0,
      referral_code: 'ZEN-' + Math.random().toString(36).substr(2, 8).toUpperCase()
    })
  }
  return { data, error }
}

export const signIn = async (email, password) => {
  return await supabase.auth.signInWithPassword({ email, password })
}

export const signOut = async () => {
  return await supabase.auth.signOut()
}

export const getCurrentUser = async () => {
  const { data: { user } } = await supabase.auth.getUser()
  if (user) {
    const { data: profile } = await supabase
      .from('users')
      .select('*')
      .eq('id', user.id)
      .single()
    return { ...user, profile }
  }
  return null
}
EOF

# Auth Context
cat > src/context/AuthContext.jsx << 'EOF'
import { createContext, useContext, useEffect, useState } from 'react'
import { supabase, getCurrentUser } from '../lib/supabase'

const AuthContext = createContext({})

export const useAuth = () => useContext(AuthContext)

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    getCurrentUser().then(user => {
      setUser(user)
      setLoading(false)
    })

    const { data: { subscription } } = supabase.auth.onAuthStateChange(async (event, session) => {
      if (session?.user) {
        const fullUser = await getCurrentUser()
        setUser(fullUser)
      } else {
        setUser(null)
      }
      setLoading(false)
    })

    return () => subscription.unsubscribe()
  }, [])

  return (
    <AuthContext.Provider value={{ user, loading, setUser }}>
      {children}
    </AuthContext.Provider>
  )
}
EOF

# Store for state management
cat > src/lib/store.js << 'EOF'
import { create } from 'zustand'

export const useStore = create((set) => ({
  balance: 0,
  dailyProfit: 0,
  totalDeposited: 0,
  investments: [],
  transactions: [],
  
  setBalance: (balance) => set({ balance }),
  setDailyProfit: (dailyProfit) => set({ dailyProfit }),
  setTotalDeposited: (totalDeposited) => set({ totalDeposited }),
  setInvestments: (investments) => set({ investments }),
  setTransactions: (transactions) => set({ transactions }),
  
  addTransaction: (tx) => set((state) => ({ 
    transactions: [tx, ...state.transactions] 
  })),
}))
EOF

# Profit Engine
cat > src/lib/profitEngine.js << 'EOF'
import { supabase } from './supabase'

// Investment Plans with daily returns
export const PLANS = {
  bronze: { name: 'البرونزية', dailyReturn: 0.008, minDeposit: 100, maxDeposit: 4999 },
  gold: { name: 'الذهبية', dailyReturn: 0.012, minDeposit: 5000, maxDeposit: 24999 },
  diamond: { name: 'الماسية', dailyReturn: 0.015, minDeposit: 25000, maxDeposit: Infinity },
  vip: { name: 'VIP', dailyReturn: 0.02, minDeposit: 50000, maxDeposit: Infinity }
}

// Calculate daily profit based on plan
export const calculateDailyProfit = (amount, planType) => {
  const plan = PLANS[planType] || PLANS.bronze
  return amount * plan.dailyReturn
}

// Process daily profits for all users (run via cron/edge function)
export const processDailyProfits = async () => {
  const { data: investments } = await supabase
    .from('investments')
    .select('*')
    .eq('status', 'active')

  for (const inv of investments || []) {
    const profit = calculateDailyProfit(inv.amount, inv.plan_type)
    
    // Add profit transaction
    await supabase.from('transactions').insert({
      user_id: inv.user_id,
      type: 'profit',
      amount: profit,
      description: `ربح يومي - ${PLANS[inv.plan_type]?.name || 'استثمار'}`,
      status: 'completed'
    })

    // Update user balance
    await supabase.rpc('increment_balance', { 
      user_id: inv.user_id, 
      amount: profit 
    })

    // Update investment total earned
    await supabase
      .from('investments')
      .update({ total_earned: inv.total_earned + profit })
      .eq('id', inv.id)
  }
}

// Get user investments
export const getUserInvestments = async (userId) => {
  const { data } = await supabase
    .from('investments')
    .select('*')
    .eq('user_id', userId)
    .order('created_at', { ascending: false })
  return data || []
}

// Get user transactions
export const getUserTransactions = async (userId) => {
  const { data } = await supabase
    .from('transactions')
    .select('*')
    .eq('user_id', userId)
    .order('created_at', { ascending: false })
    .limit(20)
  return data || []
}
EOF

# Crypto Wallets
cat > src/lib/wallets.js << 'EOF'
export const WALLETS = {
  USDT_TRC20: {
    address: 'TYourUSDTWalletAddressHere123456789',
    network: 'TRC20',
    icon: '💵',
    name: 'USDT (TRC20)',
    minDeposit: 50
  },
  USDT_ERC20: {
    address: '0xYourERC20WalletAddressHere123456789',
    network: 'ERC20', 
    icon: '💵',
    name: 'USDT (ERC20)',
    minDeposit: 100
  },
  BTC: {
    address: 'bc1YourBitcoinWalletAddressHere123456789',
    network: 'Bitcoin',
    icon: '₿',
    name: 'Bitcoin',
    minDeposit: 0.001
  },
  ZEN: {
    address: 'ZENYourZenithWalletAddressHere123456789',
    network: 'ZENITH',
    icon: '⚡',
    name: 'ZEN Token',
    minDeposit: 100
  }
}

export const createDepositRequest = async (supabase, userId, crypto, amount, txHash) => {
  return await supabase.from('deposits').insert({
    user_id: userId,
    crypto_type: crypto,
    amount,
    tx_hash: txHash,
    wallet_address: WALLETS[crypto].address,
    status: 'pending'
  })
}
EOF

# Updated main App with Router
cat > src/App.jsx << 'EOF'
import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";
import { AuthProvider } from "./context/AuthContext";
import { Toaster } from "react-hot-toast";
import { AnimatePresence } from "framer-motion";
import Home from "./pages/Home";
import Login from "./pages/Login";
import Register from "./pages/Register";
import Dashboard from "./pages/Dashboard";
import Deposit from "./pages/Deposit";
import Invest from "./pages/Invest";
import ProtectedRoute from "./components/ProtectedRoute";

export default function App() {
  return (
    <AuthProvider>
      <BrowserRouter>
        <Toaster position="top-center" toastOptions={{
          style: { background: '#1a1a24', color: '#fff', border: '1px solid rgba(245,197,24,0.2)' }
        }} />
        <AnimatePresence mode="wait">
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/login" element={<Login />} />
            <Route path="/register" element={<Register />} />
            <Route path="/dashboard" element={<ProtectedRoute><Dashboard /></ProtectedRoute>} />
            <Route path="/deposit" element={<ProtectedRoute><Deposit /></ProtectedRoute>} />
            <Route path="/invest" element={<ProtectedRoute><Invest /></ProtectedRoute>} />
            <Route path="*" element={<Navigate to="/" />} />
          </Routes>
        </AnimatePresence>
      </BrowserRouter>
    </AuthProvider>
  );
}
EOF

# Protected Route Component
cat > src/components/ProtectedRoute.jsx << 'EOF'
import { Navigate } from "react-router-dom";
import { useAuth } from "../context/AuthContext";

export default function ProtectedRoute({ children }) {
  const { user, loading } = useAuth();
  
  if (loading) {
    return (
      <div className="min-h-screen bg-[#0a0a0f] flex items-center justify-center">
        <div className="w-12 h-12 border-4 border-yellow-500 border-t-transparent rounded-full animate-spin"></div>
      </div>
    );
  }
  
  if (!user) return <Navigate to="/login" />;
  return children;
}
EOF

# Page Transition Component
cat > src/components/PageTransition.jsx << 'EOF'
import { motion } from "framer-motion";

export default function PageTransition({ children }) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      exit={{ opacity: 0, y: -20 }}
      transition={{ duration: 0.3, ease: "easeInOut" }}
    >
      {children}
    </motion.div>
  );
}
EOF

# Header Component
cat > src/components/Header.jsx << 'EOF'
import { Link, useNavigate } from "react-router-dom";
import { motion } from "framer-motion";
import { Zap, LogOut, LayoutDashboard, Menu, X } from "lucide-react";
import { useState } from "react";
import { useAuth } from "../context/AuthContext";
import { signOut } from "../lib/supabase";
import toast from "react-hot-toast";

export default function Header() {
  const { user } = useAuth();
  const navigate = useNavigate();
  const [menuOpen, setMenuOpen] = useState(false);

  const handleLogout = async () => {
    await signOut();
    toast.success("تم تسجيل الخروج");
    navigate("/");
  };

  return (
    <header className="fixed top-0 left-0 right-0 z-50 bg-[#0a0a0f]/90 backdrop-blur-xl border-b border-white/5">
      <div className="max-w-7xl mx-auto px-4 h-20 flex items-center justify-between">
        <Link to="/" className="flex items-center gap-3">
          <motion.div 
            whileHover={{ scale: 1.05, rotate: 5 }}
            className="w-12 h-12 rounded-xl bg-gradient-to-br from-yellow-400 to-yellow-600 flex items-center justify-center"
          >
            <Zap className="w-7 h-7 text-black" />
          </motion.div>
          <div>
            <span className="text-xl font-black bg-gradient-to-r from-yellow-400 to-yellow-200 bg-clip-text text-transparent">ZENITH</span>
            <span className="block text-[10px] text-yellow-500/60 tracking-widest">AFRICA</span>
          </div>
        </Link>

        {/* Desktop Nav */}
        <nav className="hidden md:flex items-center gap-4">
          {user ? (
            <>
              <Link to="/dashboard" className="flex items-center gap-2 px-5 py-2 rounded-xl bg-yellow-500/10 text-yellow-400 font-semibold hover:bg-yellow-500/20 transition">
                <LayoutDashboard className="w-4 h-4" /> لوحة التحكم
              </Link>
              <button onClick={handleLogout} className="flex items-center gap-2 px-5 py-2 rounded-xl text-red-400 hover:bg-red-500/10 transition">
                <LogOut className="w-4 h-4" /> خروج
              </button>
            </>
          ) : (
            <>
              <Link to="/login" className="px-5 py-2 text-gray-400 hover:text-white transition">دخول</Link>
              <Link to="/register" className="px-6 py-2 rounded-xl bg-gradient-to-r from-yellow-500 to-yellow-600 text-black font-bold hover:shadow-lg hover:shadow-yellow-500/30 transition">
                ابدأ الآن
              </Link>
            </>
          )}
        </nav>

        {/* Mobile Menu Button */}
        <button onClick={() => setMenuOpen(!menuOpen)} className="md:hidden p-2 text-gray-400">
          {menuOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
        </button>
      </div>

      {/* Mobile Menu */}
      {menuOpen && (
        <motion.div 
          initial={{ opacity: 0, y: -10 }}
          animate={{ opacity: 1, y: 0 }}
          className="md:hidden bg-[#0a0a0f] border-t border-white/5 px-4 py-4"
        >
          {user ? (
            <div className="space-y-2">
              <Link to="/dashboard" onClick={() => setMenuOpen(false)} className="block w-full text-center py-3 rounded-xl bg-yellow-500/10 text-yellow-400 font-semibold">
                لوحة التحكم
              </Link>
              <button onClick={() => { handleLogout(); setMenuOpen(false); }} className="block w-full text-center py-3 rounded-xl text-red-400">
                خروج
              </button>
            </div>
          ) : (
            <div className="space-y-2">
              <Link to="/login" onClick={() => setMenuOpen(false)} className="block w-full text-center py-3 text-gray-400">دخول</Link>
              <Link to="/register" onClick={() => setMenuOpen(false)} className="block w-full text-center py-3 rounded-xl bg-yellow-500 text-black font-bold">ابدأ الآن</Link>
            </div>
          )}
        </motion.div>
      )}
    </header>
  );
}
EOF

# Footer Component
cat > src/components/Footer.jsx << 'EOF'
import { Zap, Mail, MessageCircle, Code2, ExternalLink } from "lucide-react";
import { motion } from "framer-motion";

const LINKS = {
  email: "marwahamdi301@gmail.com",
  telegram: "https://wjslyrr.streamlit.app",
  github: "https://github.com/marwahamdi301-png/hedi-official",
  site: "https://zenith-africa.vercel.app"
};

export default function Footer() {
  return (
    <footer className="border-t border-white/5 py-16 px-4 bg-[#0a0a0f]">
      <div className="max-w-7xl mx-auto">
        <div className="grid md:grid-cols-4 gap-12 mb-12">
          {/* Brand */}
          <div>
            <div className="flex items-center gap-3 mb-4">
              <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-yellow-400 to-yellow-600 flex items-center justify-center">
                <Zap className="w-6 h-6 text-black" />
              </div>
              <span className="text-xl font-black bg-gradient-to-r from-yellow-400 to-yellow-200 bg-clip-text text-transparent">ZENITH</span>
            </div>
            <p className="text-gray-400 text-sm">المنصة الاستثمارية الرائدة في أفريقيا مع عوائد يومية مضمونة</p>
          </div>

          {/* Quick Links */}
          <div>
            <h4 className="text-white font-bold mb-4">روابط سريعة</h4>
            <ul className="space-y-2 text-gray-400 text-sm">
              <li><a href="/" className="hover:text-yellow-400 transition">الرئيسية</a></li>
              <li><a href="/dashboard" className="hover:text-yellow-400 transition">لوحة التحكم</a></li>
              <li><a href="/invest" className="hover:text-yellow-400 transition">خطط الاستثمار</a></li>
              <li><a href="/deposit" className="hover:text-yellow-400 transition">إيداع</a></li>
            </ul>
          </div>

          {/* Contact */}
          <div>
            <h4 className="text-white font-bold mb-4">تواصل معنا</h4>
            <ul className="space-y-3">
              <li>
                <motion.a 
                  href={"mailto:" + LINKS.email}
                  whileHover={{ x: 5 }}
                  className="flex items-center gap-2 text-gray-400 hover:text-yellow-400 transition text-sm"
                >
                  <Mail className="w-4 h-4" /> {LINKS.email}
                </motion.a>
              </li>
              <li>
                <motion.a 
                  href={LINKS.telegram}
                  target="_blank"
                  rel="noreferrer"
                  whileHover={{ x: 5 }}
                  className="flex items-center gap-2 text-gray-400 hover:text-yellow-400 transition text-sm"
                >
                  <MessageCircle className="w-4 h-4" /> Telegram <ExternalLink className="w-3 h-3" />
                </motion.a>
              </li>
              <li>
                <motion.a 
                  href={LINKS.github}
                  target="_blank"
                  rel="noreferrer"
                  whileHover={{ x: 5 }}
                  className="flex items-center gap-2 text-gray-400 hover:text-yellow-400 transition text-sm"
                >
                  <Code2 className="w-4 h-4" /> GitHub <ExternalLink className="w-3 h-3" />
                </motion.a>
              </li>
            </ul>
          </div>

          {/* Stats */}
          <div>
            <h4 className="text-white font-bold mb-4">إحصائيات</h4>
            <div className="space-y-2 text-sm">
              <div className="flex justify-between"><span className="text-gray-400">المستثمرين</span><span className="text-yellow-400 font-bold">25,000+</span></div>
              <div className="flex justify-between"><span className="text-gray-400">إجمالي الإيداعات</span><span className="text-yellow-400 font-bold">$5.2M+</span></div>
              <div className="flex justify-between"><span className="text-gray-400">الأرباح الموزعة</span><span className="text-green-400 font-bold">$1.8M+</span></div>
              <div className="flex justify-between"><span className="text-gray-400">الدول</span><span className="text-yellow-400 font-bold">35+</span></div>
            </div>
          </div>
        </div>

        <div className="border-t border-white/5 pt-8 flex flex-col md:flex-row items-center justify-between gap-4">
          <p className="text-gray-500 text-sm">© 2024 ZENITH Africa. جميع الحقوق محفوظة ❤️</p>
          <div className="flex gap-4">
            <a href={"mailto:" + LINKS.email} className="w-10 h-10 rounded-xl bg-white/5 flex items-center justify-center text-gray-400 hover:text-yellow-400 hover:bg-yellow-500/10 transition">
              <Mail className="w-5 h-5" />
            </a>
            <a href={LINKS.telegram} target="_blank" rel="noreferrer" className="w-10 h-10 rounded-xl bg-white/5 flex items-center justify-center text-gray-400 hover:text-yellow-400 hover:bg-yellow-500/10 transition">
              <MessageCircle className="w-5 h-5" />
            </a>
            <a href={LINKS.github} target="_blank" rel="noreferrer" className="w-10 h-10 rounded-xl bg-white/5 flex items-center justify-center text-gray-400 hover:text-yellow-400 hover:bg-yellow-500/10 transition">
              <Code2 className="w-5 h-5" />
            </a>
          </div>
        </div>
      </div>
    </footer>
  );
}
EOF

# Home Page
cat > src/pages/Home.jsx << 'EOF'
import { Link } from "react-router-dom";
import { motion } from "framer-motion";
import { ArrowLeft, Shield, TrendingUp, Users, Zap, Star, Crown, Gem, Check } from "lucide-react";
import Header from "../components/Header";
import Footer from "../components/Footer";
import PageTransition from "../components/PageTransition";

const plans = [
  { name: "البرونزية", icon: Star, daily: "0.8%", min: "$100", color: "text-amber-400", features: ["عائد 0.8% يومياً", "سحب يومي", "دعم بريدي"] },
  { name: "الذهبية", icon: Crown, daily: "1.2%", min: "$5,000", color: "text-yellow-400", popular: true, features: ["عائد 1.2% يومياً", "سحب فوري", "مدير حساب", "دعم 24/7"] },
  { name: "الماسية", icon: Gem, daily: "1.5%", min: "$25,000", color: "text-cyan-400", features: ["عائد 1.5% يومياً", "VIP سحب", "مستشار خاص"] },
  { name: "VIP", icon: Zap, daily: "2.0%", min: "$50,000", color: "text-purple-400", features: ["عائد 2% يومياً", "كل المميزات", "أولوية قصوى"] },
];

const stats = [
  { value: "$5.2M+", label: "أموال مُدارة" },
  { value: "25K+", label: "مستثمر" },
  { value: "2%", label: "ربح يومي" },
  { value: "35+", label: "دولة" },
];

export default function Home() {
  return (
    <PageTransition>
      <div className="min-h-screen bg-[#0a0a0f] text-white">
        <Header />
        
        {/* Hero */}
        <section className="min-h-screen flex items-center justify-center relative overflow-hidden pt-20">
          <div className="absolute top-1/4 right-1/4 w-[500px] h-[500px] bg-yellow-500/10 rounded-full blur-[150px]" />
          <div className="absolute bottom-1/4 left-1/4 w-[300px] h-[300px] bg-purple-500/10 rounded-full blur-[100px]" />
          
          <div className="relative z-10 text-center px-4 max-w-5xl mx-auto">
            <motion.div 
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              className="inline-flex items-center gap-2 px-5 py-2 rounded-full bg-yellow-500/10 border border-yellow-500/20 mb-8"
            >
              <span className="text-yellow-400 text-sm font-semibold">🏆 المنصة #1 في أفريقيا</span>
              <div className="w-2 h-2 bg-green-500 rounded-full animate-pulse" />
            </motion.div>
            
            <motion.h1 
              initial={{ opacity: 0, y: 30 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.1 }}
              className="text-5xl md:text-7xl font-black mb-6"
            >
              استثمر بذكاء مع
              <br />
              <span className="bg-gradient-to-r from-yellow-400 via-yellow-200 to-yellow-400 bg-clip-text text-transparent text-6xl md:text-8xl">
                ZENITH
              </span>
            </motion.h1>
            
            <motion.p 
              initial={{ opacity: 0, y: 30 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.2 }}
              className="text-xl text-gray-400 mb-10 max-w-2xl mx-auto"
            >
              منصة موثوقة مدعومة بعملة <span className="text-yellow-400 font-bold">ZEN</span> الرقمية.
              احصل على <span className="text-green-400 font-bold">2% أرباح يومية</span> مع أعلى معايير الأمان
            </motion.p>
            
            <motion.div 
              initial={{ opacity: 0, y: 30 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.3 }}
              className="flex flex-col sm:flex-row gap-4 justify-center mb-16"
            >
              <Link to="/register" className="group px-10 py-4 rounded-2xl bg-gradient-to-r from-yellow-500 to-yellow-600 text-black text-lg font-bold flex items-center gap-3 justify-center hover:shadow-lg hover:shadow-yellow-500/30 transition">
                ابدأ الاستثمار الآن
                <ArrowLeft className="w-5 h-5 group-hover:-translate-x-1 transition" />
              </Link>
              <Link to="/login" className="px-10 py-4 rounded-2xl border border-white/10 text-gray-300 hover:border-yellow-500/30 hover:bg-white/5 transition">
                تسجيل الدخول
              </Link>
            </motion.div>
            
            <motion.div 
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ delay: 0.4 }}
              className="grid grid-cols-2 md:grid-cols-4 gap-4 max-w-3xl mx-auto"
            >
              {stats.map((s, i) => (
                <motion.div 
                  key={i}
                  initial={{ opacity: 0, y: 20 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: 0.5 + i * 0.1 }}
                  whileHover={{ scale: 1.05, y: -5 }}
                  className="bg-white/5 backdrop-blur-xl border border-white/10 rounded-2xl p-5"
                >
                  <div className="text-2xl md:text-3xl font-black bg-gradient-to-r from-yellow-400 to-yellow-200 bg-clip-text text-transparent">{s.value}</div>
                  <div className="text-sm text-gray-500">{s.label}</div>
                </motion.div>
              ))}
            </motion.div>
          </div>
        </section>

        {/* Features */}
        <section className="py-24 px-4">
          <div className="max-w-7xl mx-auto">
            <motion.h2 
              initial={{ opacity: 0 }}
              whileInView={{ opacity: 1 }}
              className="text-4xl font-black text-center mb-16"
            >
              لماذا <span className="bg-gradient-to-r from-yellow-400 to-yellow-200 bg-clip-text text-transparent">ZENITH؟</span>
            </motion.h2>
            <div className="grid md:grid-cols-3 gap-6">
              {[
                [Shield, "أمان بنكي متقدم", "تشفير 256-bit مع حماية متعددة الطبقات"],
                [TrendingUp, "أرباح يومية 2%", "احصل على أرباحك كل 24 ساعة تلقائياً"],
                [Users, "برنامج إحالة", "اكسب 10% من استثمارات المُحالين"],
              ].map(([Icon, title, desc], i) => (
                <motion.div
                  key={i}
                  initial={{ opacity: 0, y: 30 }}
                  whileInView={{ opacity: 1, y: 0 }}
                  transition={{ delay: i * 0.1 }}
                  whileHover={{ y: -10, borderColor: "rgba(245,197,24,0.3)" }}
                  className="bg-white/5 backdrop-blur-xl border border-white/10 rounded-2xl p-8 transition"
                >
                  <div className="w-14 h-14 rounded-2xl bg-yellow-500/10 flex items-center justify-center mb-5">
                    <Icon className="w-7 h-7 text-yellow-400" />
                  </div>
                  <h3 className="text-xl font-bold mb-3">{title}</h3>
                  <p className="text-gray-400">{desc}</p>
                </motion.div>
              ))}
            </div>
          </div>
        </section>

        {/* Plans */}
        <section className="py-24 px-4 bg-gradient-to-b from-transparent via-yellow-500/5 to-transparent">
          <div className="max-w-7xl mx-auto">
            <motion.h2 
              initial={{ opacity: 0 }}
              whileInView={{ opacity: 1 }}
              className="text-4xl font-black text-center mb-16"
            >
              خطط <span className="bg-gradient-to-r from-yellow-400 to-yellow-200 bg-clip-text text-transparent">الاستثمار</span>
            </motion.h2>
            <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
              {plans.map((plan, i) => (
                <motion.div
                  key={i}
                  initial={{ opacity: 0, y: 30 }}
                  whileInView={{ opacity: 1, y: 0 }}
                  transition={{ delay: i * 0.1 }}
                  whileHover={{ y: -10 }}
                  className={`bg-white/5 backdrop-blur-xl border rounded-3xl p-6 relative ${plan.popular ? "border-yellow-500/50" : "border-white/10"}`}
                >
                  {plan.popular && (
                    <div className="absolute -top-3 left-1/2 -translate-x-1/2 bg-yellow-500 text-black px-4 py-1 rounded-full text-xs font-bold">
                      ⭐ الأكثر شعبية
                    </div>
                  )}
                  <div className="text-center mb-6">
                    <plan.icon className={`w-12 h-12 mx-auto mb-3 ${plan.color}`} />
                    <h3 className="text-xl font-bold">{plan.name}</h3>
                    <p className="text-gray-500 text-sm">الحد الأدنى: {plan.min}</p>
                  </div>
                  <div className="text-center p-4 rounded-2xl bg-white/5 mb-6">
                    <div className="text-4xl font-black bg-gradient-to-r from-yellow-400 to-yellow-200 bg-clip-text text-transparent">{plan.daily}</div>
                    <div className="text-gray-400 text-sm">عائد يومي</div>
                  </div>
                  <ul className="space-y-2 mb-6">
                    {plan.features.map((f, j) => (
                      <li key={j} className="flex items-center gap-2 text-sm text-gray-300">
                        <Check className="w-4 h-4 text-green-400 flex-shrink-0" /> {f}
                      </li>
                    ))}
                  </ul>
                  <Link to="/register" className={`block w-full py-3 rounded-xl text-center font-bold transition ${plan.popular ? "bg-gradient-to-r from-yellow-500 to-yellow-600 text-black" : "bg-white/5 hover:bg-white/10"}`}>
                    ابدأ الآن
                  </Link>
                </motion.div>
              ))}
            </div>
          </div>
        </section>

        <Footer />
      </div>
    </PageTransition>
  );
}
EOF

# Login Page
cat > src/pages/Login.jsx << 'EOF'
import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { motion } from "framer-motion";
import { Zap, Mail, Lock, ArrowLeft, Eye, EyeOff } from "lucide-react";
import { signIn } from "../lib/supabase";
import toast from "react-hot-toast";
import PageTransition from "../components/PageTransition";

export default function Login() {
  const navigate = useNavigate();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [showPass, setShowPass] = useState(false);
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    
    const { error } = await signIn(email, password);
    
    if (error) {
      toast.error(error.message || "فشل تسجيل الدخول");
    } else {
      toast.success("تم تسجيل الدخول بنجاح!");
      navigate("/dashboard");
    }
    setLoading(false);
  };

  return (
    <PageTransition>
      <div className="min-h-screen bg-[#0a0a0f] flex items-center justify-center px-4 py-12">
        <div className="absolute top-1/4 right-1/4 w-[400px] h-[400px] bg-yellow-500/10 rounded-full blur-[150px]" />
        
        <motion.div 
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          className="relative z-10 w-full max-w-md"
        >
          {/* Logo */}
          <Link to="/" className="flex items-center justify-center gap-3 mb-8">
            <div className="w-12 h-12 rounded-xl bg-gradient-to-br from-yellow-400 to-yellow-600 flex items-center justify-center">
              <Zap className="w-7 h-7 text-black" />
            </div>
            <span className="text-2xl font-black bg-gradient-to-r from-yellow-400 to-yellow-200 bg-clip-text text-transparent">ZENITH</span>
          </Link>

          <div className="bg-white/5 backdrop-blur-xl border border-white/10 rounded-3xl p-8">
            <h1 className="text-2xl font-bold text-center mb-2">تسجيل الدخول</h1>
            <p className="text-gray-400 text-center text-sm mb-8">ادخل إلى حسابك الاستثماري</p>

            <form onSubmit={handleSubmit} className="space-y-5">
              <div>
                <label className="text-sm text-gray-400 mb-2 block">البريد الإلكتروني</label>
                <div className="relative">
                  <Mail className="absolute right-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-500" />
                  <input
                    type="email"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    className="w-full bg-white/5 border border-white/10 rounded-xl py-3 pr-12 pl-4 text-white placeholder-gray-500 focus:border-yellow-500/50 focus:outline-none transition"
                    placeholder="your@email.com"
                    required
                  />
                </div>
              </div>

              <div>
                <label className="text-sm text-gray-400 mb-2 block">كلمة المرور</label>
                <div className="relative">
                  <Lock className="absolute right-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-500" />
                  <input
                    type={showPass ? "text" : "password"}
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    className="w-full bg-white/5 border border-white/10 rounded-xl py-3 pr-12 pl-12 text-white placeholder-gray-500 focus:border-yellow-500/50 focus:outline-none transition"
                    placeholder="••••••••"
                    required
                  />
                  <button type="button" onClick={() => setShowPass(!showPass)} className="absolute left-4 top-1/2 -translate-y-1/2 text-gray-500 hover:text-gray-300">
                    {showPass ? <EyeOff className="w-5 h-5" /> : <Eye className="w-5 h-5" />}
                  </button>
                </div>
              </div>

              <button
                type="submit"
                disabled={loading}
                className="w-full py-4 rounded-xl bg-gradient-to-r from-yellow-500 to-yellow-600 text-black font-bold flex items-center justify-center gap-2 hover:shadow-lg hover:shadow-yellow-500/30 transition disabled:opacity-50"
              >
                {loading ? (
                  <div className="w-5 h-5 border-2 border-black border-t-transparent rounded-full animate-spin" />
                ) : (
                  <>دخول <ArrowLeft className="w-5 h-5" /></>
                )}
              </button>
            </form>

            <p className="text-center text-gray-400 text-sm mt-6">
              ليس لديك حساب؟{" "}
              <Link to="/register" className="text-yellow-400 hover:underline">سجل الآن</Link>
            </p>
          </div>
        </motion.div>
      </div>
    </PageTransition>
  );
}
EOF

# Register Page
cat > src/pages/Register.jsx << 'EOF'
import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { motion } from "framer-motion";
import { Zap, Mail, Lock, User, ArrowLeft, Eye, EyeOff } from "lucide-react";
import { signUp } from "../lib/supabase";
import toast from "react-hot-toast";
import PageTransition from "../components/PageTransition";

export default function Register() {
  const navigate = useNavigate();
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [showPass, setShowPass] = useState(false);
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (password.length < 6) {
      toast.error("كلمة المرور يجب أن تكون 6 أحرف على الأقل");
      return;
    }
    
    setLoading(true);
    const { error } = await signUp(email, password, name);
    
    if (error) {
      toast.error(error.message || "فشل إنشاء الحساب");
    } else {
      toast.success("تم إنشاء الحساب بنجاح!");
      navigate("/dashboard");
    }
    setLoading(false);
  };

  return (
    <PageTransition>
      <div className="min-h-screen bg-[#0a0a0f] flex items-center justify-center px-4 py-12">
        <div className="absolute top-1/4 left-1/4 w-[400px] h-[400px] bg-purple-500/10 rounded-full blur-[150px]" />
        
        <motion.div 
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          className="relative z-10 w-full max-w-md"
        >
          <Link to="/" className="flex items-center justify-center gap-3 mb-8">
            <div className="w-12 h-12 rounded-xl bg-gradient-to-br from-yellow-400 to-yellow-600 flex items-center justify-center">
              <Zap className="w-7 h-7 text-black" />
            </div>
            <span className="text-2xl font-black bg-gradient-to-r from-yellow-400 to-yellow-200 bg-clip-text text-transparent">ZENITH</span>
          </Link>

          <div className="bg-white/5 backdrop-blur-xl border border-white/10 rounded-3xl p-8">
            <h1 className="text-2xl font-bold text-center mb-2">إنشاء حساب جديد</h1>
            <p className="text-gray-400 text-center text-sm mb-8">انضم إلى آلاف المستثمرين الناجحين</p>

            <form onSubmit={handleSubmit} className="space-y-5">
              <div>
                <label className="text-sm text-gray-400 mb-2 block">الاسم الكامل</label>
                <div className="relative">
                  <User className="absolute right-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-500" />
                  <input
                    type="text"
                    value={name}
                    onChange={(e) => setName(e.target.value)}
                    className="w-full bg-white/5 border border-white/10 rounded-xl py-3 pr-12 pl-4 text-white placeholder-gray-500 focus:border-yellow-500/50 focus:outline-none transition"
                    placeholder="أحمد محمد"
                    required
                  />
                </div>
              </div>

              <div>
                <label className="text-sm text-gray-400 mb-2 block">البريد الإلكتروني</label>
                <div className="relative">
                  <Mail className="absolute right-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-500" />
                  <input
                    type="email"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    className="w-full bg-white/5 border border-white/10 rounded-xl py-3 pr-12 pl-4 text-white placeholder-gray-500 focus:border-yellow-500/50 focus:outline-none transition"
                    placeholder="your@email.com"
                    required
                  />
                </div>
              </div>

              <div>
                <label className="text-sm text-gray-400 mb-2 block">كلمة المرور</label>
                <div className="relative">
                  <Lock className="absolute right-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-500" />
                  <input
                    type={showPass ? "text" : "password"}
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    className="w-full bg-white/5 border border-white/10 rounded-xl py-3 pr-12 pl-12 text-white placeholder-gray-500 focus:border-yellow-500/50 focus:outline-none transition"
                    placeholder="6 أحرف على الأقل"
                    required
                    minLength={6}
                  />
                  <button type="button" onClick={() => setShowPass(!showPass)} className="absolute left-4 top-1/2 -translate-y-1/2 text-gray-500 hover:text-gray-300">
                    {showPass ? <EyeOff className="w-5 h-5" /> : <Eye className="w-5 h-5" />}
                  </button>
                </div>
              </div>

              <button
                type="submit"
                disabled={loading}
                className="w-full py-4 rounded-xl bg-gradient-to-r from-yellow-500 to-yellow-600 text-black font-bold flex items-center justify-center gap-2 hover:shadow-lg hover:shadow-yellow-500/30 transition disabled:opacity-50"
              >
                {loading ? (
                  <div className="w-5 h-5 border-2 border-black border-t-transparent rounded-full animate-spin" />
                ) : (
                  <>إنشاء حساب <ArrowLeft className="w-5 h-5" /></>
                )}
              </button>
            </form>

            <p className="text-center text-gray-400 text-sm mt-6">
              لديك حساب؟{" "}
              <Link to="/login" className="text-yellow-400 hover:underline">سجل دخول</Link>
            </p>
          </div>
        </motion.div>
      </div>
    </PageTransition>
  );
}
EOF

# Dashboard Page
cat > src/pages/Dashboard.jsx << 'EOF'
import { useState, useEffect } from "react";
import { Link } from "react-router-dom";
import { motion } from "framer-motion";
import { Wallet, TrendingUp, DollarSign, BarChart3, ArrowUpRight, ArrowDownRight, Gift, Clock, Crown, Bell } from "lucide-react";
import { useAuth } from "../context/AuthContext";
import Header from "../components/Header";
import Footer from "../components/Footer";
import PageTransition from "../components/PageTransition";

export default function Dashboard() {
  const { user } = useAuth();
  const profile = user?.profile || {};
  
  const [stats] = useState({
    balance: profile.balance || 0,
    dailyProfit: (profile.balance || 0) * 0.02,
    totalDeposited: profile.total_deposited || 0,
    totalProfit: profile.total_profit || 0,
  });

  return (
    <PageTransition>
      <div className="min-h-screen bg-[#0a0a0f] text-white">
        <Header />
        
        <main className="pt-28 pb-16 px-4">
          <div className="max-w-7xl mx-auto">
            {/* Welcome */}
            <motion.div 
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              className="flex items-center justify-between mb-8"
            >
              <div>
                <h1 className="text-3xl font-black">
                  مرحباً، <span className="bg-gradient-to-r from-yellow-400 to-yellow-200 bg-clip-text text-transparent">{profile.full_name || 'مستثمر'}</span> 👋
                </h1>
                <p className="text-gray-400">رصيدك يربح <span className="text-green-400 font-bold">2% يومياً</span></p>
              </div>
              <button className="relative p-3 rounded-xl bg-white/5 border border-white/10 hover:border-yellow-500/30 transition">
                <Bell className="w-5 h-5 text-gray-400" />
                <span className="absolute -top-1 -right-1 w-5 h-5 bg-red-500 rounded-full text-[10px] flex items-center justify-center font-bold">3</span>
              </button>
            </motion.div>

            {/* Stats */}
            <div className="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
              {[
                { icon: Wallet, label: "الرصيد الإجمالي", value: `$${stats.balance.toLocaleString()}`, color: "text-yellow-400", bg: "bg-yellow-500/10" },
                { icon: TrendingUp, label: "الربح اليومي", value: `$${stats.dailyProfit.toFixed(2)}`, color: "text-green-400", bg: "bg-green-500/10" },
                { icon: DollarSign, label: "إجمالي الإيداعات", value: `$${stats.totalDeposited.toLocaleString()}`, color: "text-blue-400", bg: "bg-blue-500/10" },
                { icon: BarChart3, label: "إجمالي الأرباح", value: `$${stats.totalProfit.toLocaleString()}`, color: "text-purple-400", bg: "bg-purple-500/10" },
              ].map((stat, i) => (
                <motion.div
                  key={i}
                  initial={{ opacity: 0, y: 20 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: i * 0.1 }}
                  whileHover={{ y: -5 }}
                  className="bg-white/5 backdrop-blur-xl border border-white/10 rounded-2xl p-6 hover:border-yellow-500/20 transition"
                >
                  <div className={`w-12 h-12 rounded-xl ${stat.bg} flex items-center justify-center mb-4`}>
                    <stat.icon className={`w-6 h-6 ${stat.color}`} />
                  </div>
                  <div className="text-2xl font-black">{stat.value}</div>
                  <div className="text-sm text-gray-500">{stat.label}</div>
                </motion.div>
              ))}
            </div>

            {/* Actions & Investments */}
            <div className="grid lg:grid-cols-2 gap-6">
              {/* Quick Actions */}
              <motion.div
                initial={{ opacity: 0, x: -20 }}
                animate={{ opacity: 1, x: 0 }}
                className="bg-white/5 backdrop-blur-xl border border-white/10 rounded-2xl p-6"
              >
                <h3 className="text-xl font-bold mb-6">إجراءات سريعة</h3>
                <div className="space-y-3">
                  <Link to="/deposit" className="flex items-center gap-3 p-4 rounded-xl bg-green-500/10 border border-green-500/20 text-green-400 font-semibold hover:bg-green-500/20 transition">
                    <ArrowDownRight className="w-5 h-5" /> إيداع أموال
                  </Link>
                  <button className="w-full flex items-center gap-3 p-4 rounded-xl bg-blue-500/10 border border-blue-500/20 text-blue-400 font-semibold hover:bg-blue-500/20 transition">
                    <ArrowUpRight className="w-5 h-5" /> سحب أرباح
                  </button>
                  <Link to="/invest" className="flex items-center gap-3 p-4 rounded-xl bg-yellow-500/10 border border-yellow-500/20 text-yellow-400 font-semibold hover:bg-yellow-500/20 transition">
                    <TrendingUp className="w-5 h-5" /> استثمار جديد
                  </Link>
                  <button className="w-full flex items-center gap-3 p-4 rounded-xl bg-purple-500/10 border border-purple-500/20 text-purple-400 font-semibold hover:bg-purple-500/20 transition">
                    <Gift className="w-5 h-5" /> دعوة صديق ({profile.referral_code || 'ZEN-XXXX'})
                  </button>
                </div>
              </motion.div>

              {/* Active Investments */}
              <motion.div
                initial={{ opacity: 0, x: 20 }}
                animate={{ opacity: 1, x: 0 }}
                className="bg-white/5 backdrop-blur-xl border border-white/10 rounded-2xl p-6"
              >
                <h3 className="text-xl font-bold mb-6 flex items-center gap-2">
                  <Crown className="w-5 h-5 text-yellow-400" /> استثماراتك
                </h3>
                
                {stats.totalDeposited > 0 ? (
                  <div className="space-y-4">
                    <div className="p-4 rounded-xl bg-yellow-500/5 border border-yellow-500/20">
                      <div className="flex justify-between mb-2">
                        <span className="font-bold">الخطة الذهبية</span>
                        <span className="text-green-400 text-sm flex items-center gap-1">
                          <div className="w-2 h-2 bg-green-500 rounded-full animate-pulse" /> نشط
                        </span>
                      </div>
                      <div className="flex justify-between text-sm text-gray-400 mb-3">
                        <span>${stats.totalDeposited.toLocaleString()}</span>
                        <span className="text-green-400">+${stats.totalProfit.toLocaleString()}</span>
                      </div>
                      <div className="h-2 rounded-full bg-white/10">
                        <div className="h-full w-[65%] rounded-full bg-gradient-to-r from-yellow-500 to-yellow-400"></div>
                      </div>
                    </div>
                  </div>
                ) : (
                  <div className="text-center py-12">
                    <div className="w-16 h-16 mx-auto mb-4 rounded-full bg-yellow-500/10 flex items-center justify-center">
                      <TrendingUp className="w-8 h-8 text-yellow-400" />
                    </div>
                    <p className="text-gray-400 mb-4">لا يوجد استثمارات حالياً</p>
                    <Link to="/invest" className="inline-block px-6 py-3 rounded-xl bg-gradient-to-r from-yellow-500 to-yellow-600 text-black font-bold">
                      ابدأ الاستثمار
                    </Link>
                  </div>
                )}
              </motion.div>
            </div>

            {/* Transactions */}
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.3 }}
              className="mt-6 bg-white/5 backdrop-blur-xl border border-white/10 rounded-2xl p-6"
            >
              <h3 className="text-xl font-bold mb-6 flex items-center gap-2">
                <Clock className="w-5 h-5 text-yellow-400" /> آخر المعاملات
              </h3>
              <div className="text-center py-8 text-gray-400">
                لا توجد معاملات حتى الآن
              </div>
            </motion.div>
          </div>
        </main>

        <Footer />
      </div>
    </PageTransition>
  );
}
EOF

# Deposit Page
cat > src/pages/Deposit.jsx << 'EOF'
import { useState } from "react";
import { motion } from "framer-motion";
import { Copy, CheckCircle, AlertCircle, ArrowLeft } from "lucide-react";
import { Link } from "react-router-dom";
import { WALLETS } from "../lib/wallets";
import Header from "../components/Header";
import Footer from "../components/Footer";
import PageTransition from "../components/PageTransition";
import toast from "react-hot-toast";

export default function Deposit() {
  const [selected, setSelected] = useState("USDT_TRC20");
  const [amount, setAmount] = useState("");
  const [txHash, setTxHash] = useState("");
  const [copied, setCopied] = useState(false);
  const [submitted, setSubmitted] = useState(false);

  const wallet = WALLETS[selected];

  const copyAddress = () => {
    navigator.clipboard.writeText(wallet.address);
    setCopied(true);
    toast.success("تم نسخ العنوان");
    setTimeout(() => setCopied(false), 2000);
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    if (!amount || !txHash) {
      toast.error("يرجى ملء جميع الحقول");
      return;
    }
    setSubmitted(true);
    toast.success("تم إرسال طلب الإيداع للمراجعة");
  };

  return (
    <PageTransition>
      <div className="min-h-screen bg-[#0a0a0f] text-white">
        <Header />
        
        <main className="pt-28 pb-16 px-4">
          <div className="max-w-2xl mx-auto">
            <Link to="/dashboard" className="inline-flex items-center gap-2 text-gray-400 hover:text-yellow-400 mb-6 transition">
              <ArrowLeft className="w-4 h-4" /> رجوع للوحة التحكم
            </Link>

            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              className="bg-white/5 backdrop-blur-xl border border-white/10 rounded-3xl p-8"
            >
              <h1 className="text-2xl font-bold mb-2">💰 إيداع أموال</h1>
              <p className="text-gray-400 text-sm mb-8">اختر العملة وأرسل المبلغ للعنوان التالي</p>

              {!submitted ? (
                <>
                  {/* Crypto Selection */}
                  <div className="grid grid-cols-2 gap-3 mb-8">
                    {Object.entries(WALLETS).map(([key, w]) => (
                      <button
                        key={key}
                        onClick={() => setSelected(key)}
                        className={`p-4 rounded-xl border text-right transition ${
                          selected === key 
                            ? "bg-yellow-500/10 border-yellow-500/50" 
                            : "bg-white/5 border-white/10 hover:border-white/20"
                        }`}
                      >
                        <span className="text-2xl">{w.icon}</span>
                        <div className="font-semibold mt-1">{w.name}</div>
                        <div className="text-xs text-gray-500">الحد الأدنى: ${w.minDeposit}</div>
                      </button>
                    ))}
                  </div>

                  {/* Wallet Address */}
                  <div className="mb-6">
                    <label className="text-sm text-gray-400 mb-2 block">عنوان المحفظة ({wallet.network})</label>
                    <div className="flex gap-2">
                      <input
                        type="text"
                        value={wallet.address}
                        readOnly
                        className="flex-1 bg-white/5 border border-white/10 rounded-xl py-3 px-4 text-sm text-gray-300 font-mono"
                        dir="ltr"
                      />
                      <button
                        onClick={copyAddress}
                        className={`px-4 rounded-xl transition ${copied ? "bg-green-500/20 text-green-400" : "bg-yellow-500/10 text-yellow-400 hover:bg-yellow-500/20"}`}
                      >
                        {copied ? <CheckCircle className="w-5 h-5" /> : <Copy className="w-5 h-5" />}
                      </button>
                    </div>
                  </div>

                  {/* Amount */}
                  <div className="mb-6">
                    <label className="text-sm text-gray-400 mb-2 block">المبلغ المُرسل ($)</label>
                    <input
                      type="number"
                      value={amount}
                      onChange={(e) => setAmount(e.target.value)}
                      className="w-full bg-white/5 border border-white/10 rounded-xl py-3 px-4 text-white focus:border-yellow-500/50 focus:outline-none"
                      placeholder={`الحد الأدنى: $${wallet.minDeposit}`}
                      min={wallet.minDeposit}
                    />
                  </div>

                  {/* TX Hash */}
                  <div className="mb-8">
                    <label className="text-sm text-gray-400 mb-2 block">رقم المعاملة (TX Hash)</label>
                    <input
                      type="text"
                      value={txHash}
                      onChange={(e) => setTxHash(e.target.value)}
                      className="w-full bg-white/5 border border-white/10 rounded-xl py-3 px-4 text-white font-mono text-sm focus:border-yellow-500/50 focus:outline-none"
                      placeholder="0x..."
                      dir="ltr"
                    />
                  </div>

                  {/* Warning */}
                  <div className="flex items-start gap-3 p-4 rounded-xl bg-yellow-500/10 border border-yellow-500/20 mb-6">
                    <AlertCircle className="w-5 h-5 text-yellow-400 flex-shrink-0 mt-0.5" />
                    <div className="text-sm text-yellow-400/80">
                      <strong>تنبيه:</strong> تأكد من إرسال العملة الصحيحة للشبكة الصحيحة ({wallet.network}). الإرسال الخاطئ قد يؤدي لفقدان الأموال.
                    </div>
                  </div>

                  <button
                    onClick={handleSubmit}
                    className="w-full py-4 rounded-xl bg-gradient-to-r from-yellow-500 to-yellow-600 text-black font-bold hover:shadow-lg hover:shadow-yellow-500/30 transition"
                  >
                    ✅ تأكيد الإيداع
                  </button>
                </>
              ) : (
                <div className="text-center py-12">
                  <div className="w-20 h-20 mx-auto mb-6 rounded-full bg-green-500/20 flex items-center justify-center">
                    <CheckCircle className="w-10 h-10 text-green-400" />
                  </div>
                  <h2 className="text-2xl font-bold mb-2">تم استلام طلبك!</h2>
                  <p className="text-gray-400 mb-6">سيتم مراجعة الإيداع وإضافته لحسابك خلال 10-30 دقيقة</p>
                  <Link to="/dashboard" className="inline-block px-8 py-3 rounded-xl bg-white/10 hover:bg-white/20 transition">
                    رجوع للوحة التحكم
                  </Link>
                </div>
              )}
            </motion.div>
          </div>
        </main>

        <Footer />
      </div>
    </PageTransition>
  );
}
EOF

# Invest Page
cat > src/pages/Invest.jsx << 'EOF'
import { Link } from "react-router-dom";
import { motion } from "framer-motion";
import { Star, Crown, Gem, Zap, Check, ArrowLeft } from "lucide-react";
import Header from "../components/Header";
import Footer from "../components/Footer";
import PageTransition from "../components/PageTransition";
import toast from "react-hot-toast";

const plans = [
  { id: "bronze", name: "البرونزية", icon: Star, daily: "0.8%", min: 100, max: 4999, color: "text-amber-400", features: ["عائد 0.8% يومياً", "سحب يومي", "دعم بريدي"] },
  { id: "gold", name: "الذهبية", icon: Crown, daily: "1.2%", min: 5000, max: 24999, color: "text-yellow-400", popular: true, features: ["عائد 1.2% يومياً", "سحب فوري", "دعم 24/7", "مدير حساب"] },
  { id: "diamond", name: "الماسية", icon: Gem, daily: "1.5%", min: 25000, max: 99999, color: "text-cyan-400", features: ["عائد 1.5% يومياً", "VIP سحب", "مستشار خاص"] },
  { id: "vip", name: "VIP", icon: Zap, daily: "2.0%", min: 50000, max: Infinity, color: "text-purple-400", features: ["عائد 2% يومياً", "كل المميزات", "أولوية قصوى"] },
];

export default function Invest() {
  const selectPlan = (plan) => {
    toast.success(`تم اختيار ${plan.name} - قم بالإيداع للبدء`);
  };

  return (
    <PageTransition>
      <div className="min-h-screen bg-[#0a0a0f] text-white">
        <Header />
        
        <main className="pt-28 pb-16 px-4">
          <div className="max-w-7xl mx-auto">
            <Link to="/dashboard" className="inline-flex items-center gap-2 text-gray-400 hover:text-yellow-400 mb-6 transition">
              <ArrowLeft className="w-4 h-4" /> رجوع
            </Link>

            <div className="text-center mb-12">
              <h1 className="text-4xl font-black mb-4">
                اختر <span className="bg-gradient-to-r from-yellow-400 to-yellow-200 bg-clip-text text-transparent">خطتك</span>
              </h1>
              <p className="text-gray-400">استثمر الآن واحصل على أرباح يومية مضمونة</p>
            </div>

            <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
              {plans.map((plan, i) => (
                <motion.div
                  key={plan.id}
                  initial={{ opacity: 0, y: 30 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: i * 0.1 }}
                  whileHover={{ y: -10 }}
                  className={`bg-white/5 backdrop-blur-xl border rounded-3xl p-6 relative ${plan.popular ? "border-yellow-500/50" : "border-white/10"}`}
                >
                  {plan.popular && (
                    <div className="absolute -top-3 left-1/2 -translate-x-1/2 bg-yellow-500 text-black px-4 py-1 rounded-full text-xs font-bold">
                      ⭐ الأكثر شعبية
                    </div>
                  )}
                  
                  <div className="text-center mb-6">
                    <plan.icon className={`w-14 h-14 mx-auto mb-3 ${plan.color}`} />
                    <h3 className="text-xl font-bold">{plan.name}</h3>
                    <p className="text-gray-500 text-sm">${plan.min.toLocaleString()} - ${plan.max === Infinity ? '∞' : '$' + plan.max.toLocaleString()}</p>
                  </div>

                  <div className="text-center p-5 rounded-2xl bg-white/5 mb-6">
                    <div className="text-4xl font-black bg-gradient-to-r from-yellow-400 to-yellow-200 bg-clip-text text-transparent">{plan.daily}</div>
                    <div className="text-gray-400 text-sm">عائد يومي</div>
                  </div>

                  <ul className="space-y-2 mb-6">
                    {plan.features.map((f, j) => (
                      <li key={j} className="flex items-center gap-2 text-sm text-gray-300">
                        <Check className="w-4 h-4 text-green-400 flex-shrink-0" /> {f}
                      </li>
                    ))}
                  </ul>

                  <Link
                    to="/deposit"
                    onClick={() => selectPlan(plan)}
                    className={`block w-full py-3 rounded-xl text-center font-bold transition ${
                      plan.popular 
                        ? "bg-gradient-to-r from-yellow-500 to-yellow-600 text-black" 
                        : "bg-white/5 hover:bg-white/10"
                    }`}
                  >
                    اختر الخطة
                  </Link>
                </motion.div>
              ))}
            </div>
          </div>
        </main>

        <Footer />
      </div>
    </PageTransition>
  );
}
EOF

# Environment file template
cat > .env.example << 'EOF'
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key-here
EOF

echo ""
echo "✅ تم إنشاء جميع الملفات!"
echo ""
echo "📝 الخطوة التالية: إعداد Supabase"
echo "   1. افتح https://supabase.com"
echo "   2. أنشئ مشروع جديد"
echo "   3. انسخ URL و anon key"
echo "   4. أنشئ ملف .env.local وأضف القيم"
