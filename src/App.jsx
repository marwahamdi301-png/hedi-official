import{useState,useEffect,createContext,useContext}from'react';import{motion,AnimatePresence}from'framer-motion';import{Toaster,toast}from'react-hot-toast';import{Zap,TrendingUp,Shield,Users,ArrowLeft,Mail,MessageCircle,Code2,Check,Wallet,BarChart3,ArrowUpRight,ArrowDownRight,Bell,DollarSign,Gift,Lock,Eye,EyeOff,User,LogOut,LayoutDashboard,Menu,Copy,CheckCircle,RefreshCcw,Crown,Brain,Activity,Target,Sparkles}from'lucide-react';
import{supabase,signUp,signIn,signOut,getProfile}from'./lib/supabase';
import{LINKS,PLANS}from'./lib/config';
import CopyTrading from'./pages/CopyTrading';
import RewardsCenter from'./pages/RewardsCenter';

const AuthContext=createContext({});const useAuth=()=>useContext(AuthContext);
function AuthProvider({children}){const[user,setUser]=useState(null);const[profile,setProfile]=useState(null);const[loading,setLoading]=useState(true);
useEffect(()=>{supabase.auth.getUser().then(({data:{user:u}})=>{setUser(u);if(u)getProfile(u.id).then(setProfile);setLoading(false)});
const{data:{subscription}}=supabase.auth.onAuthStateChange((_,session)=>{setUser(session?.user||null);if(session?.user)getProfile(session.user.id).then(setProfile);else setProfile(null)});
return()=>subscription.unsubscribe()},[]);
return<AuthContext.Provider value={{user,profile,loading}}>{children}</AuthContext.Provider>}

function Header({page,go}){const{user}=useAuth();const[open,setOpen]=useState(false);
const logout=async()=>{await signOut();toast.success('تم الخروج');go('home')};
return<header className="fixed top-0 left-0 right-0 z-50 bg-[#0a0a0f]/95 backdrop-blur-xl border-b border-white/5">
<div className="max-w-7xl mx-auto px-4 h-16 flex items-center justify-between">
<button onClick={()=>go('home')} className="flex items-center gap-2"><div className="w-10 h-10 rounded-xl gold-gradient flex items-center justify-center"><Zap className="w-6 h-6 text-black"/></div><div><span className="text-lg font-black gold-text">ZENITH</span><span className="block text-[8px] text-yellow-500/60 tracking-widest -mt-1">PRO</span></div></button>
<nav className="hidden lg:flex gap-1">{[['home','الرئيسية'],['copy','نسخ التداول'],['rewards','المكافآت'],['trading','التداول']].map(([k,v])=><button key={k} onClick={()=>go(k)} className={`px-4 py-2 rounded-lg text-sm font-semibold transition ${page===k?'bg-yellow-500/15 text-yellow-400':'text-gray-400 hover:text-white'}`}>{v}</button>)}</nav>
<div className="hidden md:flex gap-2">{user?<><button onClick={()=>go('dashboard')} className="flex items-center gap-2 px-4 py-2 rounded-lg bg-yellow-500/10 text-yellow-400 text-sm font-semibold"><LayoutDashboard className="w-4 h-4"/>لوحة التحكم</button><button onClick={logout} className="p-2 rounded-lg text-red-400"><LogOut className="w-4 h-4"/></button></>:<><button onClick={()=>go('login')} className="px-4 py-2 text-gray-400 text-sm">دخول</button><button onClick={()=>go('register')} className="btn-gold px-5 py-2 rounded-lg text-sm font-bold">ابدأ</button></>}</div>
<button onClick={()=>setOpen(!open)} className="lg:hidden p-2 text-gray-400"><Menu className="w-6 h-6"/></button></div>
{open&&<motion.div initial={{opacity:0,y:-10}} animate={{opacity:1,y:0}} className="lg:hidden bg-[#0a0a0f] border-t border-white/5 p-4 space-y-2">{[['copy','📋 نسخ التداول'],['rewards','🎁 المكافآت'],['trading','📈 التداول']].map(([k,v])=><button key={k} onClick={()=>{go(k);setOpen(false)}} className="block w-full text-right px-4 py-3 rounded-lg text-gray-400 hover:bg-white/5">{v}</button>)}{user?<button onClick={()=>{go('dashboard');setOpen(false)}} className="block w-full py-3 rounded-lg bg-yellow-500/10 text-yellow-400 font-semibold">لوحة التحكم</button>:<button onClick={()=>{go('register');setOpen(false)}} className="block w-full py-3 rounded-lg btn-gold font-bold">ابدأ الآن</button>}</motion.div>}
</header>}

function Footer(){return<footer className="border-t border-white/5 bg-[#0a0a0f]/80 py-8 px-4"><div className="max-w-7xl mx-auto flex flex-col md:flex-row items-center justify-between gap-4"><div className="flex items-center gap-2"><div className="w-8 h-8 rounded-lg gold-gradient flex items-center justify-center"><Zap className="w-5 h-5 text-black"/></div><span className="font-black gold-text">ZENITH PRO</span></div><div className="flex gap-4 text-sm text-gray-400"><a href={`mailto:${LINKS.email}`} className="hover:text-yellow-400">البريد</a><a href={LINKS.telegram} target="_blank" className="hover:text-yellow-400">Telegram</a><a href={LINKS.github} target="_blank" className="hover:text-yellow-400">GitHub</a></div><div className="text-gray-500 text-sm">© 2024 ZENITH PRO</div></div></footer>}

function HomePage({go}){
const[liveStats,setLiveStats]=useState({volume:12847520,traders:25847,profit:847520});
useEffect(()=>{const i=setInterval(()=>{setLiveStats(p=>({volume:p.volume+Math.floor(Math.random()*1000),traders:p.traders+Math.floor(Math.random()*3),profit:p.profit+Math.floor(Math.random()*500)}))},2000);return()=>clearInterval(i)},[]);
return<div>
{/* Live Stats Bar */}
<div className="fixed top-16 left-0 right-0 z-40 bg-black/80 backdrop-blur border-b border-white/5 py-2 overflow-hidden">
<motion.div animate={{x:['0%','-50%']}} transition={{duration:30,repeat:Infinity,ease:'linear'}} className="flex gap-8 whitespace-nowrap">
{[...Array(2)].map((_,j)=><div key={j} className="flex gap-8 text-sm">
<span className="text-gray-400">📊 حجم التداول: <span className="text-green-400 font-bold">${(liveStats.volume/1000000).toFixed(2)}M</span></span>
<span className="text-gray-400">👥 المتداولين: <span className="text-yellow-400 font-bold">{liveStats.traders.toLocaleString()}</span></span>
<span className="text-gray-400">💰 الأرباح اليوم: <span className="text-green-400 font-bold">${(liveStats.profit/1000).toFixed(0)}K</span></span>
<span className="text-gray-400">🔥 ZEN: <span className="text-yellow-400 font-bold">$1.2847 (+3.24%)</span></span>
</div>)}
</motion.div>
</div>

<section className="min-h-screen flex items-center justify-center relative pt-32 overflow-hidden">
<div className="absolute inset-0"><div className="absolute top-1/4 right-1/4 w-[500px] h-[500px] bg-yellow-500/10 rounded-full blur-[150px]"/><div className="absolute bottom-1/4 left-1/4 w-[400px] h-[400px] bg-purple-500/10 rounded-full blur-[120px]"/></div>
<div className="relative z-10 text-center px-4 max-w-5xl mx-auto">
<motion.div initial={{opacity:0,y:20}} animate={{opacity:1,y:0}} className="inline-flex items-center gap-2 px-5 py-2 rounded-full bg-green-500/10 border border-green-500/20 mb-8"><div className="w-2 h-2 bg-green-500 rounded-full animate-pulse"/><span className="text-green-400 text-sm font-semibold">🔴 LIVE - الأسواق مفتوحة</span></motion.div>
<motion.h1 initial={{opacity:0,y:30}} animate={{opacity:1,y:0}} className="text-5xl md:text-7xl font-black mb-6">تداول مثل<br/><span className="gold-text text-6xl md:text-8xl">المحترفين</span></motion.h1>
<motion.p initial={{opacity:0}} animate={{opacity:1}} transition={{delay:0.2}} className="text-xl text-gray-400 mb-10">انسخ أفضل المتداولين • اجمع مكافآت ZEN • <span className="text-green-400 font-bold">أرباح تصل 2% يومياً</span></motion.p>
<motion.div initial={{opacity:0}} animate={{opacity:1}} transition={{delay:0.3}} className="flex flex-col sm:flex-row gap-4 justify-center mb-12">
<button onClick={()=>go('copy')} className="btn-gold px-10 py-4 rounded-2xl text-lg font-bold flex items-center gap-3 justify-center group">📋 نسخ التداول <ArrowLeft className="w-5 h-5 group-hover:-translate-x-1 transition"/></button>
<button onClick={()=>go('rewards')} className="px-10 py-4 rounded-2xl border border-purple-500/30 bg-purple-500/10 text-purple-400 font-bold flex items-center gap-3 justify-center"><Gift className="w-5 h-5"/>مركز المكافآت</button>
</motion.div>
{/* Features */}
<div className="grid grid-cols-2 md:grid-cols-4 gap-4 mt-16">{[[Copy,'نسخ التداول','اتبع الأفضل','copy'],[Gift,'مكافآت ZEN','اجمع يومياً','rewards'],[Brain,'AI توصيات','دقة 94%','trading'],[Shield,'آمن 100%','مشفر','about']].map(([Icon,t,d,p],i)=><motion.div key={i} initial={{opacity:0,y:20}} animate={{opacity:1,y:0}} transition={{delay:0.5+i*0.1}} onClick={()=>go(p)} className="glass rounded-2xl p-6 cursor-pointer hover:border-yellow-500/30 transition group"><Icon className="w-8 h-8 text-yellow-400 mb-3 mx-auto"/><h3 className="font-bold group-hover:text-yellow-400">{t}</h3><p className="text-sm text-gray-400">{d}</p></motion.div>)}</div>
</div>
</section>
</div>}

function LoginPage({go}){const[email,setEmail]=useState('');const[pass,setPass]=useState('');const[show,setShow]=useState(false);const[loading,setLoading]=useState(false);
const submit=async e=>{e.preventDefault();setLoading(true);const{error}=await signIn(email,pass);if(error)toast.error(error.message);else{toast.success('مرحباً!');go('dashboard')}setLoading(false)};
return<div className="min-h-screen flex items-center justify-center px-4 pt-24"><motion.div initial={{opacity:0,y:20}} animate={{opacity:1,y:0}} className="w-full max-w-md"><div className="text-center mb-8"><div className="w-16 h-16 rounded-2xl gold-gradient flex items-center justify-center mx-auto mb-4"><Zap className="w-10 h-10 text-black"/></div><h1 className="text-2xl font-black">تسجيل الدخول</h1></div><div className="glass rounded-3xl p-8"><form onSubmit={submit} className="space-y-5"><div><input type="email" value={email} onChange={e=>setEmail(e.target.value)} className="w-full bg-white/5 border border-white/10 rounded-xl py-3 px-4 text-white focus:border-yellow-500/50 focus:outline-none" placeholder="البريد الإلكتروني" required/></div><div className="relative"><input type={show?'text':'password'} value={pass} onChange={e=>setPass(e.target.value)} className="w-full bg-white/5 border border-white/10 rounded-xl py-3 px-4 pr-12 text-white focus:border-yellow-500/50 focus:outline-none" placeholder="كلمة المرور" required/><button type="button" onClick={()=>setShow(!show)} className="absolute left-4 top-1/2 -translate-y-1/2 text-gray-500">{show?<EyeOff className="w-5 h-5"/>:<Eye className="w-5 h-5"/>}</button></div><button type="submit" disabled={loading} className="w-full py-4 rounded-xl btn-gold font-bold">{loading?'جاري...':'دخول'}</button></form><p className="text-center text-gray-400 text-sm mt-6">جديد؟ <button onClick={()=>go('register')} className="text-yellow-400">سجل الآن</button></p></div></motion.div></div>}

function RegisterPage({go}){const[name,setName]=useState('');const[email,setEmail]=useState('');const[pass,setPass]=useState('');const[loading,setLoading]=useState(false);
const submit=async e=>{e.preventDefault();if(pass.length<6){toast.error('6 أحرف على الأقل');return}setLoading(true);const{error}=await signUp(email,pass,name);if(error)toast.error(error.message);else{toast.success('تم إنشاء حسابك!');go('dashboard')}setLoading(false)};
return<div className="min-h-screen flex items-center justify-center px-4 pt-24"><motion.div initial={{opacity:0,y:20}} animate={{opacity:1,y:0}} className="w-full max-w-md"><div className="text-center mb-8"><div className="w-16 h-16 rounded-2xl gold-gradient flex items-center justify-center mx-auto mb-4"><Zap className="w-10 h-10 text-black"/></div><h1 className="text-2xl font-black">إنشاء حساب</h1></div><div className="glass rounded-3xl p-8"><form onSubmit={submit} className="space-y-5"><input type="text" value={name} onChange={e=>setName(e.target.value)} className="w-full bg-white/5 border border-white/10 rounded-xl py-3 px-4 text-white focus:border-yellow-500/50 focus:outline-none" placeholder="الاسم" required/><input type="email" value={email} onChange={e=>setEmail(e.target.value)} className="w-full bg-white/5 border border-white/10 rounded-xl py-3 px-4 text-white focus:border-yellow-500/50 focus:outline-none" placeholder="البريد" required/><input type="password" value={pass} onChange={e=>setPass(e.target.value)} className="w-full bg-white/5 border border-white/10 rounded-xl py-3 px-4 text-white focus:border-yellow-500/50 focus:outline-none" placeholder="كلمة المرور" required minLength={6}/><button type="submit" disabled={loading} className="w-full py-4 rounded-xl btn-gold font-bold">{loading?'جاري...':'إنشاء حساب'}</button></form><p className="text-center text-gray-400 text-sm mt-6">لديك حساب؟ <button onClick={()=>go('login')} className="text-yellow-400">دخول</button></p></div></motion.div></div>}

function DashboardPage({go}){const{profile:p}=useAuth();const[liveProfit,setLiveProfit]=useState(0);const balance=p?.balance||1000;const zen=p?.zen_balance||1847;
useEffect(()=>{const i=setInterval(()=>setLiveProfit(prev=>prev+(Math.random()*0.3)),1500);return()=>clearInterval(i)},[]);
return<main className="pt-24 pb-8 px-4"><div className="max-w-7xl mx-auto">
<div className="flex items-center justify-between mb-6"><div><h1 className="text-2xl font-black">مرحباً <span className="gold-text">{p?.full_name||'متداول'}</span></h1><p className="text-gray-400 text-sm">الأرباح تتراكم <motion.span animate={{opacity:[0.5,1,0.5]}} transition={{duration:1,repeat:Infinity}} className="text-green-400">ثانية بثانية</motion.span></p></div><motion.div animate={{scale:[1,1.02,1]}} transition={{duration:0.5,repeat:Infinity}} className="text-left"><div className="text-xs text-gray-500">الربح الحي</div><div className="text-xl font-black text-green-400">+${liveProfit.toFixed(4)}</div></motion.div></div>
<div className="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-6">{[[Wallet,'الرصيد',`$${(balance+liveProfit).toFixed(2)}`,'yellow'],[Zap,'ZEN',`${zen.toLocaleString()}`,'purple'],[TrendingUp,'اليوم',`+$${(balance*0.02).toFixed(2)}`,'green'],[Users,'تنسخ من','3 متداولين','blue']].map(([Icon,l,v,c],i)=><motion.div key={i} initial={{opacity:0,y:20}} animate={{opacity:1,y:0}} transition={{delay:i*0.1}} className="glass rounded-xl p-4"><Icon className={`w-6 h-6 text-${c}-400 mb-2`}/><div className="text-lg font-black">{v}</div><div className="text-xs text-gray-500">{l}</div></motion.div>)}</div>
<div className="grid md:grid-cols-2 gap-4">{[[Copy,'نسخ التداول','اتبع المحترفين','copy','green'],[Gift,'المكافآت','اجمع ZEN','rewards','purple'],[Target,'التداول','تداول مباشر','trading','blue'],[Activity,'الإحصائيات','تحليل أدائك','dashboard','yellow']].map(([Icon,t,d,p,c],i)=><motion.button key={i} onClick={()=>go(p)} initial={{opacity:0,y:20}} animate={{opacity:1,y:0}} transition={{delay:0.2+i*0.1}} className={`flex items-center gap-4 p-4 rounded-xl bg-${c}-500/10 border border-${c}-500/20 text-${c}-400 hover:bg-${c}-500/20 transition text-right`}><Icon className="w-8 h-8"/><div><div className="font-bold">{t}</div><div className="text-xs opacity-60">{d}</div></div></motion.button>)}</div>
</div></main>}

function TradingPage({go}){
return<div className="min-h-screen pt-24 pb-8 px-4"><div className="max-w-7xl mx-auto text-center py-20">
<h1 className="text-4xl font-black mb-4">قريباً - <span className="gold-text">التداول المباشر</span></h1>
<p className="text-gray-400 mb-8">صفحة التداول الاحترافية قيد التطوير</p>
<button onClick={()=>go('copy')} className="btn-gold px-8 py-4 rounded-xl font-bold">جرب نسخ التداول الآن</button>
</div></div>}

export default function App(){const[page,setPage]=useState('home');const go=p=>{setPage(p);window.scrollTo({top:0,behavior:'smooth'})};
return<AuthProvider><div className="min-h-screen bg-[#0a0a0f] text-white">
<Toaster position="top-center" toastOptions={{style:{background:'#1a1a24',color:'#fff',border:'1px solid rgba(245,197,24,0.2)'}}}/>
<Header page={page} go={go}/>
<AnimatePresence mode="wait">
{page==='home'&&<><HomePage key="h" go={go}/><Footer/></>}
{page==='copy'&&<CopyTrading key="c" go={go}/>}
{page==='rewards'&&<RewardsCenter key="r" go={go}/>}
{page==='trading'&&<TradingPage key="t" go={go}/>}
{page==='login'&&<LoginPage key="l" go={go}/>}
{page==='register'&&<RegisterPage key="rg" go={go}/>}
{page==='dashboard'&&<><DashboardPage key="d" go={go}/><Footer/></>}
</AnimatePresence>
</div></AuthProvider>}
