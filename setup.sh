#!/bin/bash
echo "🚀 ZENITH Africa - Full Setup..."
rm -rf src && mkdir -p src/lib

cat > package.json << 'PKGJSON'
{"name":"zenith-africa","private":true,"version":"1.0.0","type":"module","scripts":{"dev":"vite","build":"vite build","preview":"vite preview"},"dependencies":{"@supabase/supabase-js":"^2.39.0","framer-motion":"^10.16.0","lucide-react":"^0.468.0","react":"^18.3.1","react-dom":"^18.3.1","react-hot-toast":"^2.4.1"},"devDependencies":{"@vitejs/plugin-react":"^4.3.4","autoprefixer":"^10.4.20","postcss":"^8.4.49","tailwindcss":"^3.4.17","vite":"^6.0.5"}}
PKGJSON

cat > vite.config.js << 'VITE'
import{defineConfig}from'vite';import react from'@vitejs/plugin-react';export default defineConfig({plugins:[react()]})
VITE

cat > tailwind.config.js << 'TW'
export default{content:["./index.html","./src/**/*.{js,jsx}"],theme:{extend:{colors:{gold:{400:'#ffd84d',500:'#f5c518',600:'#d4a810'},dark:{900:'#0a0a0f'}}}},plugins:[]}
TW

cat > postcss.config.js << 'PC'
export default{plugins:{tailwindcss:{},autoprefixer:{}}}
PC

cat > index.html << 'HTML'
<!DOCTYPE html><html lang="ar" dir="rtl"><head><meta charset="UTF-8"/><meta name="viewport" content="width=device-width,initial-scale=1.0"/><title>ZENITH Africa | منصة الاستثمار</title><link href="https://fonts.googleapis.com/css2?family=Cairo:wght@400;600;700;900&display=swap" rel="stylesheet"></head><body><div id="root"></div><script type="module" src="/src/main.jsx"></script></body></html>
HTML

cat > src/main.jsx << 'MAIN'
import React from'react';import ReactDOM from'react-dom/client';import App from'./App';import'./index.css';ReactDOM.createRoot(document.getElementById('root')).render(<React.StrictMode><App/></React.StrictMode>)
MAIN

cat > src/index.css << 'CSS'
@tailwind base;@tailwind components;@tailwind utilities;
*{margin:0;padding:0;box-sizing:border-box}body{font-family:'Cairo',sans-serif;background:#0a0a0f;color:#fff;direction:rtl}
.gold-text{background:linear-gradient(135deg,#f5c518,#ffe680);-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text}
.gold-gradient{background:linear-gradient(135deg,#f5c518,#d4a810)}.glass{background:rgba(255,255,255,0.03);backdrop-filter:blur(20px);border:1px solid rgba(255,255,255,0.08)}
.btn-gold{background:linear-gradient(135deg,#f5c518,#d4a810);color:#0a0a0f;font-weight:700;transition:all 0.3s}.btn-gold:hover{transform:translateY(-2px);box-shadow:0 10px 30px rgba(245,197,24,0.4)}
CSS

cat > src/lib/supabase.js << 'SUPA'
import{createClient}from'@supabase/supabase-js';
const url='https://qvwcpljqbvaylwvdrryw.supabase.co',key='eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF2d2NwbGpxYnZheWx3dmRycnl3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzgwMTEzODEsImV4cCI6MjA5MzU4NzM4MX0.g9q69rbGpWyh6Q-4lv-XNAV2nKZqBsQMAwmfofbL_dw';
export const supabase=createClient(url,key);
export const signUp=async(e,p,n)=>{const{data,error}=await supabase.auth.signUp({email:e,password:p,options:{data:{full_name:n}}});if(!error&&data.user)await supabase.from('users').insert({id:data.user.id,email:e,full_name:n,balance:0,zen_balance:1000,referral_code:'ZEN-'+Math.random().toString(36).substr(2,8).toUpperCase()});return{data,error}};
export const signIn=async(e,p)=>supabase.auth.signInWithPassword({email:e,password:p});
export const signOut=()=>supabase.auth.signOut();
export const getProfile=async(id)=>{const{data}=await supabase.from('users').select('*').eq('id',id).single();return data};
SUPA

cat > src/lib/config.js << 'CFG'
export const LINKS={email:'marwahamdi301@gmail.com',telegram:'https://wjslyrr.streamlit.app',github:'https://github.com/marwahamdi301-png/hedi-official',site:'https://zenith-africa.vercel.app'};
export const PLANS=[{id:'bronze',name:'البرونزية',daily:'0.8%',min:'$100',max:'$4,999',total:'24%',icon:'⭐',features:['عائد 0.8% يومياً','سحب يومي','دعم بريدي']},{id:'gold',name:'الذهبية',daily:'1.2%',min:'$5,000',max:'$24,999',total:'72%',icon:'👑',popular:true,features:['عائد 1.2% يومياً','سحب فوري','دعم 24/7','مدير حساب']},{id:'diamond',name:'الماسية',daily:'1.5%',min:'$25,000',max:'$99,999',total:'135%',icon:'💎',features:['عائد 1.5% يومياً','VIP سحب','مستشار خاص']},{id:'vip',name:'VIP',daily:'2.0%',min:'$50,000',max:'∞',total:'180%',icon:'⚡',features:['عائد 2% يومياً','كل المميزات','أولوية قصوى']}];
export const WALLETS={USDT_TRC20:{address:'TYourWalletTRC20Here',network:'TRC20',icon:'💵',name:'USDT (TRC20)',min:50},BTC:{address:'bc1YourBitcoinHere',network:'Bitcoin',icon:'₿',name:'Bitcoin',min:50},ZEN:{address:'ZENYourAddressHere',network:'ZENITH',icon:'⚡',name:'ZEN Token',min:100}};
CFG

cat > src/App.jsx << 'APPEOF'
import{useState,useEffect,createContext,useContext}from'react';import{motion,AnimatePresence}from'framer-motion';import{Toaster,toast}from'react-hot-toast';import{Zap,TrendingUp,Shield,Users,ArrowLeft,Mail,MessageCircle,Code2,Check,Wallet,BarChart3,ArrowUpRight,ArrowDownRight,Bell,DollarSign,Gift,Lock,Eye,EyeOff,User,LogOut,LayoutDashboard,Menu,Copy,CheckCircle,AlertCircle,RefreshCcw,Send,QrCode,Crown,ExternalLink}from'lucide-react';import{supabase,signUp,signIn,signOut,getProfile}from'./lib/supabase';import{LINKS,PLANS,WALLETS}from'./lib/config';

const AuthContext=createContext({});const useAuth=()=>useContext(AuthContext);
function AuthProvider({children}){const[user,setUser]=useState(null);const[profile,setProfile]=useState(null);const[loading,setLoading]=useState(true);
useEffect(()=>{supabase.auth.getUser().then(({data:{user:u}})=>{setUser(u);if(u)getProfile(u.id).then(setProfile);setLoading(false)});
const{data:{subscription}}=supabase.auth.onAuthStateChange((_,session)=>{setUser(session?.user||null);if(session?.user)getProfile(session.user.id).then(setProfile);else setProfile(null)});
return()=>subscription.unsubscribe()},[]);
return <AuthContext.Provider value={{user,profile,loading}}>{children}</AuthContext.Provider>}

const PageWrap=({children})=><motion.div initial={{opacity:0,y:20}} animate={{opacity:1,y:0}} exit={{opacity:0,y:-20}} transition={{duration:0.3}}>{children}</motion.div>;

function Header({page,go}){const{user}=useAuth();const[open,setOpen]=useState(false);
const logout=async()=>{await signOut();toast.success('تم الخروج');go('home')};
return<header className="fixed top-0 left-0 right-0 z-50 bg-[#0a0a0f]/90 backdrop-blur-xl border-b border-white/5">
<div className="max-w-7xl mx-auto px-4 h-20 flex items-center justify-between">
<button onClick={()=>go('home')} className="flex items-center gap-3"><div className="w-12 h-12 rounded-xl gold-gradient flex items-center justify-center"><Zap className="w-7 h-7 text-black"/></div><div><span className="text-xl font-black gold-text">ZENITH</span><span className="block text-[10px] text-yellow-500/60 tracking-widest">AFRICA</span></div></button>
<nav className="hidden md:flex gap-2">{[['home','الرئيسية'],['plans','الخطط'],['about','حول']].map(([k,v])=><button key={k} onClick={()=>go(k)} className={`px-5 py-2 rounded-xl text-sm font-semibold transition ${page===k?'bg-yellow-500/15 text-yellow-400':'text-gray-400 hover:text-white'}`}>{v}</button>)}</nav>
<div className="hidden md:flex gap-3">{user?<><button onClick={()=>go('dashboard')} className="flex items-center gap-2 px-4 py-2 rounded-xl bg-yellow-500/10 text-yellow-400 text-sm font-semibold"><LayoutDashboard className="w-4 h-4"/>لوحة التحكم</button><button onClick={logout} className="px-4 py-2 rounded-xl text-red-400 text-sm"><LogOut className="w-4 h-4"/></button></>:<><button onClick={()=>go('login')} className="px-5 py-2 text-gray-400 text-sm">دخول</button><button onClick={()=>go('register')} className="btn-gold px-6 py-2 rounded-xl text-sm font-bold">ابدأ الآن</button></>}</div>
<button onClick={()=>setOpen(!open)} className="md:hidden p-2 text-gray-400"><Menu className="w-6 h-6"/></button></div>
{open&&<motion.div initial={{opacity:0,y:-10}} animate={{opacity:1,y:0}} className="md:hidden bg-[#0a0a0f] border-t border-white/5 p-4">{user?<><button onClick={()=>{go('dashboard');setOpen(false)}} className="block w-full py-3 rounded-xl bg-yellow-500/10 text-yellow-400 font-semibold mb-2">لوحة التحكم</button><button onClick={()=>{logout();setOpen(false)}} className="block w-full py-3 text-red-400">خروج</button></>:<button onClick={()=>{go('register');setOpen(false)}} className="block w-full py-3 rounded-xl btn-gold font-bold">ابدأ الآن</button>}</motion.div>}
</header>}

function Footer(){return<footer className="border-t border-white/5 bg-[#0a0a0f]/80 py-12 px-4">
<div className="max-w-7xl mx-auto"><div className="grid md:grid-cols-4 gap-8 mb-8">
<div><div className="flex items-center gap-3 mb-4"><div className="w-10 h-10 rounded-xl gold-gradient flex items-center justify-center"><Zap className="w-6 h-6 text-black"/></div><span className="text-xl font-black gold-text">ZENITH</span></div><p className="text-gray-400 text-sm">المنصة الاستثمارية الرائدة في أفريقيا</p></div>
<div><h4 className="font-bold mb-4">روابط</h4><ul className="space-y-2 text-sm text-gray-400"><li><a href="/" className="hover:text-yellow-400">الرئيسية</a></li><li><a href="#" className="hover:text-yellow-400">الخطط</a></li></ul></div>
<div><h4 className="font-bold mb-4">تواصل</h4><ul className="space-y-2"><li><a href={`mailto:${LINKS.email}`} className="flex items-center gap-2 text-gray-400 hover:text-yellow-400 text-sm"><Mail className="w-4 h-4"/>{LINKS.email}</a></li><li><a href={LINKS.telegram} target="_blank" className="flex items-center gap-2 text-gray-400 hover:text-yellow-400 text-sm"><MessageCircle className="w-4 h-4"/>Telegram</a></li><li><a href={LINKS.github} target="_blank" className="flex items-center gap-2 text-gray-400 hover:text-yellow-400 text-sm"><Code2 className="w-4 h-4"/>GitHub</a></li></ul></div>
<div><h4 className="font-bold mb-4">إحصائيات</h4><div className="space-y-2 text-sm">{[['المستثمرين','25,000+'],['الإيداعات','$5.2M+'],['الأرباح','$1.8M+']].map(([k,v],i)=><div key={i} className="flex justify-between"><span className="text-gray-400">{k}</span><span className="text-yellow-400 font-bold">{v}</span></div>)}</div></div>
</div><div className="border-t border-white/5 pt-8 text-center text-gray-500 text-sm">© 2024 ZENITH Africa ❤️</div></div></footer>}

function HomePage({go}){const stats=[{v:'$5.2M+',l:'أموال مُدارة'},{v:'25K+',l:'مستثمر'},{v:'2%',l:'ربح يومي'},{v:'35+',l:'دولة'}];
return<PageWrap><section className="min-h-screen flex items-center justify-center relative pt-20 overflow-hidden">
<div className="absolute top-1/4 right-1/4 w-[500px] h-[500px] bg-yellow-500/10 rounded-full blur-[150px]"/>
<div className="relative z-10 text-center px-4 max-w-4xl mx-auto">
<motion.div initial={{opacity:0,y:20}} animate={{opacity:1,y:0}} className="inline-flex items-center gap-2 px-5 py-2 rounded-full bg-yellow-500/10 border border-yellow-500/20 mb-8"><span className="text-yellow-400 text-sm font-semibold">🏆 المنصة #1 في أفريقيا</span><div className="w-2 h-2 bg-green-500 rounded-full animate-pulse"/></motion.div>
<motion.h1 initial={{opacity:0,y:30}} animate={{opacity:1,y:0}} transition={{delay:0.1}} className="text-5xl md:text-7xl font-black mb-6">استثمر بذكاء مع<br/><span className="gold-text text-6xl md:text-8xl">ZENITH</span></motion.h1>
<motion.p initial={{opacity:0}} animate={{opacity:1}} transition={{delay:0.2}} className="text-xl text-gray-400 mb-10">منصة موثوقة بعملة <span className="text-yellow-400 font-bold">ZEN</span> الرقمية. <span className="text-green-400 font-bold">2% أرباح يومية</span></motion.p>
<motion.div initial={{opacity:0}} animate={{opacity:1}} transition={{delay:0.3}} className="flex flex-col sm:flex-row gap-4 justify-center mb-12">
<button onClick={()=>go('register')} className="btn-gold px-10 py-4 rounded-2xl text-lg font-bold flex items-center gap-3 justify-center group">ابدأ الآن <ArrowLeft className="w-5 h-5 group-hover:-translate-x-1 transition"/></button>
<button onClick={()=>go('login')} className="px-10 py-4 rounded-2xl border border-white/10 text-gray-300 hover:border-yellow-500/30 transition">تسجيل الدخول</button>
</motion.div>
<div className="grid grid-cols-2 md:grid-cols-4 gap-4">{stats.map((s,i)=><motion.div key={i} initial={{opacity:0,y:20}} animate={{opacity:1,y:0}} transition={{delay:0.4+i*0.1}} className="glass rounded-2xl p-5"><div className="text-2xl font-black gold-text">{s.v}</div><div className="text-sm text-gray-500">{s.l}</div></motion.div>)}</div>
</div></section>
<section className="py-24 px-4"><div className="max-w-7xl mx-auto">
<h2 className="text-4xl font-black text-center mb-16">لماذا <span className="gold-text">ZENITH؟</span></h2>
<div className="grid md:grid-cols-3 gap-6">{[[Shield,'أمان بنكي','تشفير 256-bit'],[TrendingUp,'أرباح 2% يومياً','أرباحك تُضاف تلقائياً'],[Users,'برنامج إحالة','اكسب 10% عمولة']].map(([Icon,t,d],i)=><motion.div key={i} initial={{opacity:0,y:30}} whileInView={{opacity:1,y:0}} className="glass rounded-2xl p-8 hover:border-yellow-500/30 transition group"><div className="w-14 h-14 rounded-2xl bg-yellow-500/10 flex items-center justify-center mb-5"><Icon className="w-7 h-7 text-yellow-400"/></div><h3 className="text-xl font-bold mb-3 group-hover:text-yellow-400">{t}</h3><p className="text-gray-400">{d}</p></motion.div>)}</div>
</div></section>
<section className="py-24 px-4"><div className="max-w-7xl mx-auto">
<h2 className="text-4xl font-black text-center mb-16">خطط <span className="gold-text">الاستثمار</span></h2>
<div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">{PLANS.map((p,i)=><motion.div key={i} initial={{opacity:0,y:30}} whileInView={{opacity:1,y:0}} transition={{delay:i*0.1}} className={`glass rounded-3xl p-6 relative ${p.popular?'border-yellow-500/50':''}`}>
{p.popular&&<div className="absolute -top-3 left-1/2 -translate-x-1/2 bg-yellow-500 text-black px-4 py-1 rounded-full text-xs font-bold">⭐ الأكثر شعبية</div>}
<div className="text-center mb-6"><div className="text-4xl mb-3">{p.icon}</div><h3 className="text-xl font-bold">{p.name}</h3><p className="text-gray-500 text-sm">{p.min}</p></div>
<div className="text-center p-4 rounded-2xl bg-white/5 mb-6"><div className="text-4xl font-black gold-text">{p.daily}</div><div className="text-gray-400 text-sm">يومياً</div><div className="text-green-400 font-bold mt-1">إجمالي: {p.total}</div></div>
<ul className="space-y-2 mb-6">{p.features.map((f,j)=><li key={j} className="flex items-center gap-2 text-sm text-gray-300"><Check className="w-4 h-4 text-green-400"/>{f}</li>)}</ul>
<button onClick={()=>go('register')} className={`w-full py-3 rounded-xl font-bold transition ${p.popular?'btn-gold':'bg-white/5 hover:bg-white/10'}`}>ابدأ الآن</button>
</motion.div>)}</div>
</div></section></PageWrap>}

function LoginPage({go}){const[email,setEmail]=useState('');const[pass,setPass]=useState('');const[show,setShow]=useState(false);const[loading,setLoading]=useState(false);
const submit=async e=>{e.preventDefault();setLoading(true);const{error}=await signIn(email,pass);if(error)toast.error(error.message||'فشل الدخول');else{toast.success('تم الدخول!');go('dashboard')}setLoading(false)};
return<PageWrap><div className="min-h-screen flex items-center justify-center px-4 py-12">
<motion.div initial={{opacity:0,y:20}} animate={{opacity:1,y:0}} className="w-full max-w-md">
<button onClick={()=>go('home')} className="flex items-center justify-center gap-3 mb-8 mx-auto"><div className="w-12 h-12 rounded-xl gold-gradient flex items-center justify-center"><Zap className="w-7 h-7 text-black"/></div><span className="text-2xl font-black gold-text">ZENITH</span></button>
<div className="glass rounded-3xl p-8"><h1 className="text-2xl font-bold text-center mb-8">تسجيل الدخول</h1>
<form onSubmit={submit} className="space-y-5">
<div><label className="text-sm text-gray-400 mb-2 block">البريد</label><div className="relative"><Mail className="absolute right-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-500"/><input type="email" value={email} onChange={e=>setEmail(e.target.value)} className="w-full bg-white/5 border border-white/10 rounded-xl py-3 pr-12 pl-4 text-white focus:border-yellow-500/50 focus:outline-none" required/></div></div>
<div><label className="text-sm text-gray-400 mb-2 block">كلمة المرور</label><div className="relative"><Lock className="absolute right-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-500"/><input type={show?'text':'password'} value={pass} onChange={e=>setPass(e.target.value)} className="w-full bg-white/5 border border-white/10 rounded-xl py-3 pr-12 pl-12 text-white focus:border-yellow-500/50 focus:outline-none" required/><button type="button" onClick={()=>setShow(!show)} className="absolute left-4 top-1/2 -translate-y-1/2 text-gray-500">{show?<EyeOff className="w-5 h-5"/>:<Eye className="w-5 h-5"/>}</button></div></div>
<button type="submit" disabled={loading} className="w-full py-4 rounded-xl btn-gold font-bold flex items-center justify-center gap-2">{loading?<div className="w-5 h-5 border-2 border-black border-t-transparent rounded-full animate-spin"/>:<>دخول <ArrowLeft className="w-5 h-5"/></>}</button>
</form>
<p className="text-center text-gray-400 text-sm mt-6">ليس لديك حساب؟ <button onClick={()=>go('register')} className="text-yellow-400 hover:underline">سجل الآن</button></p>
</div></motion.div></div></PageWrap>}

function RegisterPage({go}){const[name,setName]=useState('');const[email,setEmail]=useState('');const[pass,setPass]=useState('');const[show,setShow]=useState(false);const[loading,setLoading]=useState(false);
const submit=async e=>{e.preventDefault();if(pass.length<6){toast.error('كلمة المرور 6 أحرف على الأقل');return}setLoading(true);const{error}=await signUp(email,pass,name);if(error)toast.error(error.message||'فشل التسجيل');else{toast.success('تم إنشاء الحساب!');go('dashboard')}setLoading(false)};
return<PageWrap><div className="min-h-screen flex items-center justify-center px-4 py-12">
<motion.div initial={{opacity:0,y:20}} animate={{opacity:1,y:0}} className="w-full max-w-md">
<button onClick={()=>go('home')} className="flex items-center justify-center gap-3 mb-8 mx-auto"><div className="w-12 h-12 rounded-xl gold-gradient flex items-center justify-center"><Zap className="w-7 h-7 text-black"/></div><span className="text-2xl font-black gold-text">ZENITH</span></button>
<div className="glass rounded-3xl p-8"><h1 className="text-2xl font-bold text-center mb-8">إنشاء حساب</h1>
<form onSubmit={submit} className="space-y-5">
<div><label className="text-sm text-gray-400 mb-2 block">الاسم</label><div className="relative"><User className="absolute right-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-500"/><input type="text" value={name} onChange={e=>setName(e.target.value)} className="w-full bg-white/5 border border-white/10 rounded-xl py-3 pr-12 pl-4 text-white focus:border-yellow-500/50 focus:outline-none" required/></div></div>
<div><label className="text-sm text-gray-400 mb-2 block">البريد</label><div className="relative"><Mail className="absolute right-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-500"/><input type="email" value={email} onChange={e=>setEmail(e.target.value)} className="w-full bg-white/5 border border-white/10 rounded-xl py-3 pr-12 pl-4 text-white focus:border-yellow-500/50 focus:outline-none" required/></div></div>
<div><label className="text-sm text-gray-400 mb-2 block">كلمة المرور</label><div className="relative"><Lock className="absolute right-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-500"/><input type={show?'text':'password'} value={pass} onChange={e=>setPass(e.target.value)} className="w-full bg-white/5 border border-white/10 rounded-xl py-3 pr-12 pl-12 text-white focus:border-yellow-500/50 focus:outline-none" required minLength={6}/><button type="button" onClick={()=>setShow(!show)} className="absolute left-4 top-1/2 -translate-y-1/2 text-gray-500">{show?<EyeOff className="w-5 h-5"/>:<Eye className="w-5 h-5"/>}</button></div></div>
<button type="submit" disabled={loading} className="w-full py-4 rounded-xl btn-gold font-bold flex items-center justify-center gap-2">{loading?<div className="w-5 h-5 border-2 border-black border-t-transparent rounded-full animate-spin"/>:<>إنشاء حساب <ArrowLeft className="w-5 h-5"/></>}</button>
</form>
<p className="text-center text-gray-400 text-sm mt-6">لديك حساب؟ <button onClick={()=>go('login')} className="text-yellow-400 hover:underline">دخول</button></p>
</div></motion.div></div></PageWrap>}

function DashboardPage({go}){const{profile:p}=useAuth();const balance=p?.balance||0;const daily=balance*0.02;const deposited=p?.total_deposited||0;const profit=p?.total_profit||0;const zen=p?.zen_balance||1000;
return<PageWrap><main className="pt-28 pb-16 px-4"><div className="max-w-7xl mx-auto">
<motion.div initial={{opacity:0,y:20}} animate={{opacity:1,y:0}} className="flex items-center justify-between mb-8"><div><h1 className="text-3xl font-black">مرحباً، <span className="gold-text">{p?.full_name||'مستثمر'}</span> 👋</h1><p className="text-gray-400">رصيدك يربح <span className="text-green-400 font-bold">2% يومياً</span></p></div><button className="relative p-3 rounded-xl glass"><Bell className="w-5 h-5 text-gray-400"/><span className="absolute -top-1 -right-1 w-5 h-5 bg-red-500 rounded-full text-[10px] flex items-center justify-center">3</span></button></motion.div>
<div className="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-8">{[[Wallet,'الرصيد',`$${balance}`,'text-yellow-400','bg-yellow-500/10'],[TrendingUp,'الربح اليومي',`$${daily.toFixed(2)}`,'text-green-400','bg-green-500/10'],[DollarSign,'الإيداعات',`$${deposited}`,'text-blue-400','bg-blue-500/10'],[Zap,'رصيد ZEN',`${zen} ZEN`,'text-purple-400','bg-purple-500/10']].map(([Icon,l,v,c,bg],i)=><motion.div key={i} initial={{opacity:0,y:20}} animate={{opacity:1,y:0}} transition={{delay:i*0.1}} className="glass rounded-2xl p-6"><div className={`w-12 h-12 rounded-xl ${bg} flex items-center justify-center mb-4`}><Icon className={`w-6 h-6 ${c}`}/></div><div className="text-2xl font-black">{v}</div><div className="text-sm text-gray-500">{l}</div></motion.div>)}</div>
<div className="grid lg:grid-cols-2 gap-6">
<motion.div initial={{opacity:0,x:-20}} animate={{opacity:1,x:0}} className="glass rounded-2xl p-6"><h3 className="text-xl font-bold mb-6">إجراءات سريعة</h3><div className="space-y-3">
<button onClick={()=>go('deposit')} className="w-full flex items-center gap-3 p-4 rounded-xl bg-green-500/10 border border-green-500/20 text-green-400 font-semibold"><ArrowDownRight className="w-5 h-5"/>إيداع أموال</button>
<button className="w-full flex items-center gap-3 p-4 rounded-xl bg-blue-500/10 border border-blue-500/20 text-blue-400 font-semibold"><ArrowUpRight className="w-5 h-5"/>سحب أرباح</button>
<button onClick={()=>go('invest')} className="w-full flex items-center gap-3 p-4 rounded-xl bg-yellow-500/10 border border-yellow-500/20 text-yellow-400 font-semibold"><TrendingUp className="w-5 h-5"/>استثمار جديد</button>
<button onClick={()=>go('zen')} className="w-full flex items-center gap-3 p-4 rounded-xl bg-purple-500/10 border border-purple-500/20 text-purple-400 font-semibold"><Zap className="w-5 h-5"/>محفظة ZEN</button>
<button className="w-full flex items-center gap-3 p-4 rounded-xl bg-pink-500/10 border border-pink-500/20 text-pink-400 font-semibold"><Gift className="w-5 h-5"/>دعوة ({p?.referral_code||'ZEN-XXXX'})</button>
</div></motion.div>
<motion.div initial={{opacity:0,x:20}} animate={{opacity:1,x:0}} className="glass rounded-2xl p-6"><h3 className="text-xl font-bold mb-6 flex items-center gap-2"><Crown className="w-5 h-5 text-yellow-400"/>استثماراتك</h3>
{deposited>0?<div className="p-4 rounded-xl bg-yellow-500/5 border border-yellow-500/20"><div className="flex justify-between mb-2"><span className="font-bold">خطة نشطة</span><span className="text-green-400 text-sm flex items-center gap-1"><div className="w-2 h-2 bg-green-500 rounded-full animate-pulse"/>نشط</span></div><div className="flex justify-between text-sm text-gray-400 mb-3"><span>${deposited}</span><span className="text-green-400">+${profit}</span></div><div className="h-2 rounded-full bg-white/10"><div className="h-full w-[65%] rounded-full gold-gradient"/></div></div>
:<div className="text-center py-12"><div className="w-16 h-16 mx-auto mb-4 rounded-full bg-yellow-500/10 flex items-center justify-center"><TrendingUp className="w-8 h-8 text-yellow-400"/></div><p className="text-gray-400 mb-4">لا يوجد استثمارات</p><button onClick={()=>go('invest')} className="btn-gold px-6 py-3 rounded-xl font-bold">ابدأ الاستثمار</button></div>}
</motion.div></div>
</div></main></PageWrap>}

function DepositPage({go}){const[sel,setSel]=useState('USDT_TRC20');const[amount,setAmount]=useState('');const[txHash,setTxHash]=useState('');const[copied,setCopied]=useState(false);const[done,setDone]=useState(false);const w=WALLETS[sel];
const copy=()=>{navigator.clipboard.writeText(w.address);setCopied(true);toast.success('تم النسخ');setTimeout(()=>setCopied(false),2000)};
const submit=()=>{if(!amount||!txHash){toast.error('املأ جميع الحقول');return}setDone(true);toast.success('تم إرسال الطلب!')};
return<PageWrap><main className="pt-28 pb-16 px-4"><div className="max-w-2xl mx-auto">
<button onClick={()=>go('dashboard')} className="flex items-center gap-2 text-gray-400 hover:text-yellow-400 mb-6"><ArrowLeft className="w-4 h-4"/>رجوع</button>
<motion.div initial={{opacity:0,y:20}} animate={{opacity:1,y:0}} className="glass rounded-3xl p-8">
<h1 className="text-2xl font-bold mb-2">💰 إيداع</h1><p className="text-gray-400 text-sm mb-8">اختر العملة وأرسل المبلغ</p>
{!done?<><div className="grid grid-cols-3 gap-3 mb-8">{Object.entries(WALLETS).map(([k,v])=><button key={k} onClick={()=>setSel(k)} className={`p-4 rounded-xl border text-center transition ${sel===k?'bg-yellow-500/10 border-yellow-500/50':'bg-white/5 border-white/10'}`}><span className="text-2xl">{v.icon}</span><div className="font-semibold mt-1 text-sm">{v.name}</div></button>)}</div>
<div className="mb-6"><label className="text-sm text-gray-400 mb-2 block">عنوان المحفظة ({w.network})</label><div className="flex gap-2"><input value={w.address} readOnly className="flex-1 bg-white/5 border border-white/10 rounded-xl py-3 px-4 text-sm font-mono" dir="ltr"/><button onClick={copy} className={`px-4 rounded-xl ${copied?'bg-green-500/20 text-green-400':'bg-yellow-500/10 text-yellow-400'}`}>{copied?<CheckCircle className="w-5 h-5"/>:<Copy className="w-5 h-5"/>}</button></div></div>
<div className="mb-6"><label className="text-sm text-gray-400 mb-2 block">المبلغ ($)</label><input type="number" value={amount} onChange={e=>setAmount(e.target.value)} className="w-full bg-white/5 border border-white/10 rounded-xl py-3 px-4 focus:border-yellow-500/50 focus:outline-none" placeholder={`الحد الأدنى: $${w.min}`}/></div>
<div className="mb-8"><label className="text-sm text-gray-400 mb-2 block">TX Hash</label><input value={txHash} onChange={e=>setTxHash(e.target.value)} className="w-full bg-white/5 border border-white/10 rounded-xl py-3 px-4 font-mono text-sm focus:border-yellow-500/50 focus:outline-none" dir="ltr" placeholder="0x..."/></div>
<div className="flex items-start gap-3 p-4 rounded-xl bg-yellow-500/10 border border-yellow-500/20 mb-6"><AlertCircle className="w-5 h-5 text-yellow-400 mt-0.5"/><p className="text-sm text-yellow-400/80">تأكد من الشبكة الصحيحة ({w.network})</p></div>
<button onClick={submit} className="w-full py-4 rounded-xl btn-gold font-bold">✅ تأكيد الإيداع</button></>
:<div className="text-center py-12"><div className="w-20 h-20 mx-auto mb-6 rounded-full bg-green-500/20 flex items-center justify-center"><CheckCircle className="w-10 h-10 text-green-400"/></div><h2 className="text-2xl font-bold mb-2">تم!</h2><p className="text-gray-400 mb-6">المراجعة خلال 10-30 دقيقة</p><button onClick={()=>go('dashboard')} className="px-8 py-3 rounded-xl bg-white/10">رجوع</button></div>}
</motion.div></div></main></PageWrap>}

function InvestPage({go}){return<PageWrap><main className="pt-28 pb-16 px-4"><div className="max-w-7xl mx-auto">
<button onClick={()=>go('dashboard')} className="flex items-center gap-2 text-gray-400 hover:text-yellow-400 mb-6"><ArrowLeft className="w-4 h-4"/>رجوع</button>
<h1 className="text-4xl font-black text-center mb-12">اختر <span className="gold-text">خطتك</span></h1>
<div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">{PLANS.map((p,i)=><motion.div key={i} initial={{opacity:0,y:30}} animate={{opacity:1,y:0}} transition={{delay:i*0.1}} className={`glass rounded-3xl p-6 relative ${p.popular?'border-yellow-500/50':''}`}>
{p.popular&&<div className="absolute -top-3 left-1/2 -translate-x-1/2 bg-yellow-500 text-black px-4 py-1 rounded-full text-xs font-bold">⭐ الأكثر شعبية</div>}
<div className="text-center mb-6"><div className="text-4xl mb-3">{p.icon}</div><h3 className="text-xl font-bold">{p.name}</h3><p className="text-gray-500 text-sm">{p.min} - {p.max}</p></div>
<div className="text-center p-5 rounded-2xl bg-white/5 mb-6"><div className="text-4xl font-black gold-text">{p.daily}</div><div className="text-gray-400 text-sm">يومياً</div></div>
<ul className="space-y-2 mb-6">{p.features.map((f,j)=><li key={j} className="flex items-center gap-2 text-sm text-gray-300"><Check className="w-4 h-4 text-green-400"/>{f}</li>)}</ul>
<button onClick={()=>{toast.success(`تم اختيار ${p.name}`);go('deposit')}} className={`w-full py-3 rounded-xl font-bold ${p.popular?'btn-gold':'bg-white/5 hover:bg-white/10'}`}>اختر</button>
</motion.div>)}</div>
</div></main></PageWrap>}

function ZenPage({go}){const{profile:p}=useAuth();const[price,setPrice]=useState(1.24);const zen=p?.zen_balance||1000;const[tab,setTab]=useState('main');const[copied,setCopied]=useState(false);const addr='ZEN'+Math.random().toString(36).substr(2,12).toUpperCase();
useEffect(()=>{const i=setInterval(()=>setPrice(1.24+(Math.random()-0.5)*0.1),5000);return()=>clearInterval(i)},[]);
const copy=()=>{navigator.clipboard.writeText(addr);setCopied(true);toast.success('تم النسخ');setTimeout(()=>setCopied(false),2000)};
return<PageWrap><main className="pt-28 pb-16 px-4"><div className="max-w-7xl mx-auto">
<button onClick={()=>go('dashboard')} className="flex items-center gap-2 text-gray-400 hover:text-yellow-400 mb-6"><ArrowLeft className="w-4 h-4"/>رجوع</button>
<motion.div initial={{opacity:0,y:20}} animate={{opacity:1,y:0}} className="bg-gradient-to-br from-yellow-500/20 via-yellow-600/10 to-purple-500/10 border border-yellow-500/20 rounded-3xl p-8 mb-8">
<div className="flex flex-col lg:flex-row items-start lg:items-center justify-between gap-6">
<div className="flex items-center gap-4"><div className="w-20 h-20 rounded-2xl gold-gradient flex items-center justify-center shadow-lg shadow-yellow-500/30"><Zap className="w-10 h-10 text-black"/></div><div><h1 className="text-3xl font-black">ZEN Token</h1><p className="text-gray-400">العملة الرسمية لـ ZENITH</p></div></div>
<div className="flex flex-wrap gap-4">
<div className="bg-black/30 rounded-2xl px-6 py-4 text-center"><div className="text-3xl font-black text-yellow-400">${price.toFixed(4)}</div><div className="text-sm text-green-400 flex items-center justify-center gap-1"><TrendingUp className="w-3 h-3"/>+3.2%</div></div>
<div className="bg-black/30 rounded-2xl px-6 py-4 text-center"><div className="text-3xl font-black">{zen.toLocaleString()}</div><div className="text-sm text-gray-400">ZEN</div></div>
<div className="bg-black/30 rounded-2xl px-6 py-4 text-center"><div className="text-3xl font-black text-green-400">${(zen*price).toFixed(2)}</div><div className="text-sm text-gray-400">بالدولار</div></div>
</div></div></motion.div>
<div className="flex gap-2 mb-8">{[['main','نظرة عامة',Zap],['send','إرسال',Send],['receive','استلام',ArrowDownRight],['swap','تبديل',RefreshCcw]].map(([id,l,Icon])=><button key={id} onClick={()=>setTab(id)} className={`flex items-center gap-2 px-5 py-3 rounded-xl font-semibold transition ${tab===id?'bg-yellow-500/20 text-yellow-400 border border-yellow-500/30':'bg-white/5 text-gray-400'}`}><Icon className="w-4 h-4"/>{l}</button>)}</div>
<div className="grid lg:grid-cols-3 gap-6"><div className="lg:col-span-2">
{tab==='main'&&<motion.div initial={{opacity:0}} animate={{opacity:1}} className="glass rounded-2xl p-6"><h3 className="text-xl font-bold mb-6">مخطط السعر</h3><div className="h-48 flex items-end gap-1">{Array.from({length:30},(_,i)=>40+Math.sin(i*0.5)*20+Math.random()*15).map((h,i)=><div key={i} className="flex-1"><div className="w-full rounded-t bg-gradient-to-t from-yellow-500/30 to-yellow-400/80 hover:to-yellow-400 transition" style={{height:`${h}%`}}/></div>)}</div></motion.div>}
{tab==='send'&&<motion.div initial={{opacity:0}} animate={{opacity:1}} className="glass rounded-2xl p-6"><h3 className="text-xl font-bold mb-6">إرسال ZEN</h3><div className="space-y-4"><input placeholder="عنوان المستلم ZEN..." className="w-full bg-white/5 border border-white/10 rounded-xl py-3 px-4 focus:border-yellow-500/50 focus:outline-none"/><input type="number" placeholder="الكمية" className="w-full bg-white/5 border border-white/10 rounded-xl py-3 px-4 focus:border-yellow-500/50 focus:outline-none"/><p className="text-xs text-gray-500">المتاح: {zen} ZEN</p><button className="w-full py-4 rounded-xl btn-gold font-bold">إرسال</button></div></motion.div>}
{tab==='receive'&&<motion.div initial={{opacity:0}} animate={{opacity:1}} className="glass rounded-2xl p-6 text-center"><h3 className="text-xl font-bold mb-6">استلام ZEN</h3><div className="w-48 h-48 mx-auto mb-6 bg-white rounded-2xl flex items-center justify-center"><QrCode className="w-32 h-32 text-black"/></div><p className="text-sm text-gray-400 mb-4">عنوانك</p><div className="flex items-center justify-center gap-2"><code className="bg-white/5 px-4 py-2 rounded-xl text-sm font-mono text-yellow-400">{addr}</code><button onClick={copy} className={`p-2 rounded-lg ${copied?'bg-green-500/20 text-green-400':'bg-yellow-500/20 text-yellow-400'}`}>{copied?<CheckCircle className="w-5 h-5"/>:<Copy className="w-5 h-5"/>}</button></div></motion.div>}
{tab==='swap'&&<motion.div initial={{opacity:0}} animate={{opacity:1}} className="glass rounded-2xl p-6"><h3 className="text-xl font-bold mb-6">تبديل</h3><div className="bg-white/5 rounded-xl p-4 mb-4"><div className="flex justify-between text-sm text-gray-400 mb-2"><span>من</span><span>{zen} ZEN</span></div><div className="flex items-center gap-4"><input type="number" placeholder="0.00" className="flex-1 bg-transparent text-2xl font-bold focus:outline-none"/><div className="flex items-center gap-2 bg-yellow-500/20 px-4 py-2 rounded-xl"><Zap className="w-5 h-5 text-yellow-400"/><span className="font-bold">ZEN</span></div></div></div><div className="flex justify-center my-4"><div className="w-10 h-10 rounded-full bg-white/10 flex items-center justify-center"><RefreshCcw className="w-5 h-5"/></div></div><div className="bg-white/5 rounded-xl p-4 mb-6"><div className="flex justify-between text-sm text-gray-400 mb-2"><span>إلى</span><span>${price.toFixed(4)}/ZEN</span></div><div className="flex items-center gap-4"><input placeholder="0.00" readOnly className="flex-1 bg-transparent text-2xl font-bold focus:outline-none"/><div className="flex items-center gap-2 bg-green-500/20 px-4 py-2 rounded-xl"><span>💵</span><span className="font-bold">USDT</span></div></div></div><button className="w-full py-4 rounded-xl bg-gradient-to-r from-purple-500 to-purple-600 font-bold">تبديل</button></motion.div>}
</div>
<div className="space-y-6"><div className="glass rounded-2xl p-6"><h3 className="font-bold mb-4">إجراءات</h3><div className="space-y-3"><button onClick={()=>go('deposit')} className="w-full flex items-center gap-3 p-3 rounded-xl bg-green-500/10 border border-green-500/20 text-green-400"><ArrowDownRight className="w-5 h-5"/>شراء ZEN</button><button className="w-full flex items-center gap-3 p-3 rounded-xl bg-blue-500/10 border border-blue-500/20 text-blue-400"><ArrowUpRight className="w-5 h-5"/>بيع ZEN</button><button className="w-full flex items-center gap-3 p-3 rounded-xl bg-purple-500/10 border border-purple-500/20 text-purple-400"><Gift className="w-5 h-5"/>إهداء</button></div></div></div></div>
</div></main></PageWrap>}

function AboutPage(){return<PageWrap><section className="pt-32 pb-16 px-4"><div className="max-w-4xl mx-auto text-center">
<h1 className="text-5xl font-black mb-8"><span className="gold-text">ZENITH</span> Africa</h1>
<p className="text-xl text-gray-400 mb-12">المنصة الاستثمارية الرائدة</p>
<div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-12">{[['$5.2M+','أموال'],['25K+','مستثمر'],['99.9%','التشغيل'],['35+','دولة']].map(([v,l],i)=><motion.div key={i} initial={{opacity:0,y:20}} whileInView={{opacity:1,y:0}} className="glass rounded-2xl p-6"><div className="text-3xl font-black gold-text">{v}</div><div className="text-gray-500">{l}</div></motion.div>)}</div>
<div className="glass rounded-2xl p-8"><h3 className="text-2xl font-bold mb-6">تواصل</h3><div className="flex flex-wrap justify-center gap-4"><a href={`mailto:${LINKS.email}`} className="flex items-center gap-2 px-6 py-3 rounded-xl bg-red-500/10 text-red-400"><Mail className="w-5 h-5"/>{LINKS.email}</a><a href={LINKS.telegram} target="_blank" className="flex items-center gap-2 px-6 py-3 rounded-xl bg-blue-500/10 text-blue-400"><MessageCircle className="w-5 h-5"/>Telegram</a><a href={LINKS.github} target="_blank" className="flex items-center gap-2 px-6 py-3 rounded-xl bg-gray-500/10 text-gray-400"><Code2 className="w-5 h-5"/>GitHub</a></div></div>
</div></section></PageWrap>}

export default function App(){const[page,setPage]=useState('home');const go=p=>{setPage(p);window.scrollTo({top:0,behavior:'smooth'})};
return<AuthProvider><div className="min-h-screen bg-[#0a0a0f] text-white">
<Toaster position="top-center" toastOptions={{style:{background:'#1a1a24',color:'#fff',border:'1px solid rgba(245,197,24,0.2)'}}}/>
<Header page={page} go={go}/>
<AnimatePresence mode="wait">
{page==='home'&&<HomePage key="h" go={go}/>}
{page==='plans'&&<div key="p" className="pt-28"><HomePage go={go}/></div>}
{page==='about'&&<><AboutPage key="a"/><Footer/></>}
{page==='login'&&<LoginPage key="l" go={go}/>}
{page==='register'&&<RegisterPage key="r" go={go}/>}
{page==='dashboard'&&<><DashboardPage key="d" go={go}/><Footer/></>}
{page==='deposit'&&<><DepositPage key="dp" go={go}/><Footer/></>}
{page==='invest'&&<><InvestPage key="i" go={go}/><Footer/></>}
{page==='zen'&&<><ZenPage key="z" go={go}/><Footer/></>}
</AnimatePresence>
{page==='home'&&<Footer/>}
</div></AuthProvider>}
APPEOF

echo "📦 Installing..."
npm install

echo "🔨 Building..."
npm run build

echo "✅ Done! Run: vercel --prod --yes"
