#!/bin/bash
echo "🚀 ZENITH PRO - Professional Trading Platform..."

mkdir -p src/pages src/components

# Advanced Copy Trading with Supabase
cat > src/pages/CopyTrading.jsx << 'COPYTRADING'
import{useState,useEffect,useRef}from'react';import{motion,AnimatePresence}from'framer-motion';import{Users,TrendingUp,DollarSign,Copy,Star,Shield,Zap,CheckCircle,Play,Pause,Settings,Crown,Award,Target,BarChart3,Clock,ArrowUpRight,ArrowDownRight,Percent,Eye,Filter,Search,ChevronDown,Flame,Medal}from'lucide-react';
import{supabase}from'../lib/supabase';

const ELITE_TRADERS=[
{id:1,name:'CryptoMaster',avatar:'🏆',country:'🇳🇬',profit:1247.5,profitPercent:847,winRate:96.2,followers:28450,aum:4250000,trades:1847,drawdown:3.2,risk:'low',badge:'legend',verified:true,pnl7d:12.4,pnl30d:45.8,copiers:3420,minCopy:100},
{id:2,name:'ZEN Whale',avatar:'🐋',country:'🇰🇪',profit:892.3,profitPercent:623,winRate:94.1,followers:19200,aum:2800000,trades:1245,drawdown:4.8,risk:'low',badge:'elite',verified:true,pnl7d:8.7,pnl30d:32.4,copiers:2180,minCopy:500},
{id:3,name:'African Bull',avatar:'🦁',country:'🇬🇭',profit:654.2,profitPercent:445,winRate:91.5,followers:12800,aum:1650000,trades:956,drawdown:6.1,risk:'medium',badge:'pro',verified:true,pnl7d:15.2,pnl30d:28.9,copiers:1540,minCopy:200},
{id:4,name:'Diamond Hands',avatar:'💎',country:'🇪🇬',profit:523.8,profitPercent:312,winRate:88.7,followers:8900,aum:920000,trades:724,drawdown:7.5,risk:'medium',badge:'pro',verified:true,pnl7d:6.3,pnl30d:21.5,copiers:890,minCopy:100},
{id:5,name:'Moon Hunter',avatar:'🌙',country:'🇹🇿',profit:412.4,profitPercent:287,winRate:85.3,followers:6200,aum:580000,trades:512,drawdown:9.2,risk:'high',badge:'rising',verified:false,pnl7d:18.9,pnl30d:35.2,copiers:420,minCopy:50},
{id:6,name:'Sigma Trader',avatar:'⚡',country:'🇲🇦',profit:387.1,profitPercent:245,winRate:83.8,followers:4800,aum:420000,trades:438,drawdown:11.4,risk:'high',badge:'rising',verified:false,pnl7d:9.8,pnl30d:18.7,copiers:310,minCopy:50},
];

const LIVE_TRADES=[
{pair:'ZEN/USDT',type:'LONG',entry:1.2456,current:1.2892,pnl:'+3.5%',time:'2m ago'},
{pair:'BTC/USDT',type:'LONG',entry:67542,current:68120,pnl:'+0.86%',time:'5m ago'},
{pair:'ETH/USDT',type:'SHORT',entry:3520,current:3485,pnl:'+0.99%',time:'12m ago'},
];

export default function CopyTrading({go}){
const[traders,setTraders]=useState(ELITE_TRADERS);
const[copied,setCopied]=useState([]);
const[balance,setBalance]=useState(5000);
const[totalProfit,setTotalProfit]=useState(0);
const[liveProfit,setLiveProfit]=useState(0);
const[filter,setFilter]=useState('all');
const[sort,setSort]=useState('profit');
const[search,setSearch]=useState('');
const[showModal,setShowModal]=useState(null);
const[copyAmount,setCopyAmount]=useState(500);
const[activeTrades,setActiveTrades]=useState(LIVE_TRADES);

// Live profit simulation
useEffect(()=>{
if(copied.length===0)return;
const i=setInterval(()=>{
const profit=copied.reduce((acc,id)=>{
const t=traders.find(t=>t.id===id);
return acc+(copyAmount*0.0008*(t?.winRate||80)/100);
},0);
setLiveProfit(prev=>prev+profit);
setTotalProfit(prev=>prev+profit);
setBalance(prev=>prev+profit);
},1000);
return()=>clearInterval(i);
},[copied,copyAmount]);

// Live trades update
useEffect(()=>{
const i=setInterval(()=>{
setActiveTrades(prev=>prev.map(t=>({
...t,
current:t.current*(1+(Math.random()-0.48)*0.001),
pnl:`${Math.random()>0.3?'+':'-'}${(Math.random()*5).toFixed(2)}%`
})));
},2000);
return()=>clearInterval(i);
},[]);

const toggleCopy=(trader)=>{
if(copied.includes(trader.id)){
setCopied(prev=>prev.filter(i=>i!==trader.id));
}else{
setShowModal(trader);
}
};

const confirmCopy=(trader)=>{
setCopied(prev=>[...prev,trader.id]);
setShowModal(null);
// Save to Supabase
supabase.from('copy_trades').insert({
trader_id:trader.id,
trader_name:trader.name,
amount:copyAmount,
status:'active'
}).then(()=>console.log('Saved to Supabase'));
};

const filteredTraders=traders
.filter(t=>filter==='all'||t.risk===filter)
.filter(t=>t.name.toLowerCase().includes(search.toLowerCase()))
.sort((a,b)=>sort==='profit'?b.profitPercent-a.profitPercent:sort==='winrate'?b.winRate-a.winRate:b.followers-a.followers);

return<div className="min-h-screen bg-[#0a0a0f] text-white pt-20 pb-8">
{/* Header Stats Bar */}
<div className="bg-gradient-to-r from-green-500/10 via-yellow-500/5 to-green-500/10 border-b border-white/5">
<div className="max-w-7xl mx-auto px-4 py-4">
<div className="flex flex-wrap items-center justify-between gap-4">
<div className="flex items-center gap-6">
<div><div className="text-xs text-gray-500">رصيدك</div><div className="text-xl font-black">${balance.toFixed(2)}</div></div>
<div className="h-8 w-px bg-white/10"/>
<div><div className="text-xs text-gray-500">الأرباح الكلية</div><div className="text-xl font-black text-green-400">+${totalProfit.toFixed(2)}</div></div>
<div className="h-8 w-px bg-white/10"/>
<div><div className="text-xs text-gray-500">تنسخ من</div><div className="text-xl font-black text-yellow-400">{copied.length} متداول</div></div>
</div>
{copied.length>0&&<motion.div animate={{scale:[1,1.05,1]}} transition={{duration:0.5,repeat:Infinity}} className="flex items-center gap-2 px-4 py-2 rounded-xl bg-green-500/20 border border-green-500/30">
<div className="w-2 h-2 bg-green-500 rounded-full animate-pulse"/>
<span className="text-green-400 font-bold">+${liveProfit.toFixed(4)}/ثانية</span>
</motion.div>}
</div>
</div>
</div>

<div className="max-w-7xl mx-auto px-4 py-6">
{/* Live Trades Ticker */}
{copied.length>0&&<motion.div initial={{opacity:0,y:-20}} animate={{opacity:1,y:0}} className="mb-6 p-4 rounded-2xl bg-gradient-to-r from-green-500/10 to-blue-500/10 border border-green-500/20">
<div className="flex items-center justify-between mb-3">
<h3 className="font-bold flex items-center gap-2"><Flame className="w-5 h-5 text-orange-400"/>صفقات حية الآن</h3>
<span className="text-xs text-gray-400">{activeTrades.length} صفقات نشطة</span>
</div>
<div className="grid grid-cols-3 gap-3">
{activeTrades.map((t,i)=><motion.div key={i} animate={{borderColor:['rgba(34,197,94,0.2)','rgba(34,197,94,0.5)','rgba(34,197,94,0.2)']}} transition={{duration:2,repeat:Infinity}} className="p-3 rounded-xl bg-black/30 border">
<div className="flex items-center justify-between mb-1"><span className="font-bold text-sm">{t.pair}</span><span className={`text-xs px-2 py-0.5 rounded ${t.type==='LONG'?'bg-green-500/20 text-green-400':'bg-red-500/20 text-red-400'}`}>{t.type}</span></div>
<div className="flex items-center justify-between"><span className="text-gray-400 text-xs">{t.time}</span><span className={`font-bold ${t.pnl.startsWith('+')?'text-green-400':'text-red-400'}`}>{t.pnl}</span></div>
</motion.div>)}
</div>
</motion.div>}

{/* Filters */}
<div className="flex flex-wrap items-center gap-4 mb-6">
<div className="flex-1 relative">
<Search className="absolute right-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-500"/>
<input value={search} onChange={e=>setSearch(e.target.value)} className="w-full bg-white/5 border border-white/10 rounded-xl py-3 pr-12 pl-4 text-white focus:border-yellow-500/50 focus:outline-none" placeholder="ابحث عن متداول..."/>
</div>
<div className="flex gap-2">
{[['all','الكل'],['low','منخفض'],['medium','متوسط'],['high','عالي']].map(([k,v])=><button key={k} onClick={()=>setFilter(k)} className={`px-4 py-2 rounded-xl text-sm font-semibold transition ${filter===k?'bg-yellow-500/20 text-yellow-400 border border-yellow-500/30':'bg-white/5 text-gray-400 hover:bg-white/10'}`}>{v}</button>)}
</div>
<select value={sort} onChange={e=>setSort(e.target.value)} className="bg-white/5 border border-white/10 rounded-xl px-4 py-2 text-white focus:outline-none">
<option value="profit">الأرباح</option>
<option value="winrate">نسبة النجاح</option>
<option value="followers">المتابعين</option>
</select>
</div>

{/* Traders Grid */}
<div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
{filteredTraders.map((t,i)=><motion.div key={t.id} initial={{opacity:0,y:30}} animate={{opacity:1,y:0}} transition={{delay:i*0.05}} whileHover={{y:-5,borderColor:'rgba(245,197,24,0.3)'}} className={`relative bg-gradient-to-br from-white/5 to-white/[0.02] backdrop-blur-xl border rounded-2xl overflow-hidden transition-all ${copied.includes(t.id)?'border-green-500/50 shadow-lg shadow-green-500/10':'border-white/10'}`}>
{/* Badge */}
{t.badge==='legend'&&<div className="absolute top-0 right-0 bg-gradient-to-br from-yellow-400 via-yellow-500 to-orange-500 text-black px-4 py-1 text-xs font-black rounded-bl-xl flex items-center gap-1"><Crown className="w-3 h-3"/>LEGEND</div>}
{t.badge==='elite'&&<div className="absolute top-0 right-0 bg-gradient-to-br from-purple-400 to-purple-600 text-white px-4 py-1 text-xs font-bold rounded-bl-xl flex items-center gap-1"><Award className="w-3 h-3"/>ELITE</div>}
{t.badge==='pro'&&<div className="absolute top-0 right-0 bg-gradient-to-br from-blue-400 to-blue-600 text-white px-4 py-1 text-xs font-bold rounded-bl-xl">PRO</div>}
{t.badge==='rising'&&<div className="absolute top-0 right-0 bg-gradient-to-br from-green-400 to-green-600 text-white px-4 py-1 text-xs font-bold rounded-bl-xl flex items-center gap-1"><TrendingUp className="w-3 h-3"/>RISING</div>}

{/* Active indicator */}
{copied.includes(t.id)&&<motion.div animate={{opacity:[0.5,1,0.5]}} transition={{duration:1,repeat:Infinity}} className="absolute inset-0 border-2 border-green-500 rounded-2xl pointer-events-none"/>}

<div className="p-6">
{/* Header */}
<div className="flex items-start gap-4 mb-4">
<div className="relative">
<div className="w-16 h-16 rounded-2xl bg-gradient-to-br from-yellow-400/20 to-purple-500/20 flex items-center justify-center text-3xl">{t.avatar}</div>
{t.verified&&<div className="absolute -bottom-1 -right-1 w-6 h-6 bg-blue-500 rounded-full flex items-center justify-center"><CheckCircle className="w-4 h-4 text-white"/></div>}
</div>
<div className="flex-1">
<div className="flex items-center gap-2">
<h3 className="text-lg font-black">{t.name}</h3>
<span className="text-sm">{t.country}</span>
</div>
<div className="flex items-center gap-3 mt-1">
<div className="flex items-center gap-1">{[...Array(5)].map((_,i)=><Star key={i} className={`w-3 h-3 ${i<Math.floor(t.winRate/20)?'text-yellow-400 fill-yellow-400':'text-gray-600'}`}/>)}</div>
<span className="text-xs text-gray-400">{t.followers.toLocaleString()} متابع</span>
</div>
<div className="flex items-center gap-2 mt-2">
<span className={`text-xs px-2 py-0.5 rounded-full ${t.risk==='low'?'bg-green-500/20 text-green-400':t.risk==='medium'?'bg-yellow-500/20 text-yellow-400':'bg-red-500/20 text-red-400'}`}>{t.risk==='low'?'مخاطر منخفضة':t.risk==='medium'?'مخاطر متوسطة':'مخاطر عالية'}</span>
<span className="text-xs text-gray-500">{t.copiers} ينسخون</span>
</div>
</div>
</div>

{/* Stats Grid */}
<div className="grid grid-cols-4 gap-2 mb-4">
<div className="text-center p-2 rounded-xl bg-black/30">
<div className="text-green-400 font-black text-lg">+{t.profitPercent}%</div>
<div className="text-[10px] text-gray-500">ROI</div>
</div>
<div className="text-center p-2 rounded-xl bg-black/30">
<div className="text-yellow-400 font-black text-lg">{t.winRate}%</div>
<div className="text-[10px] text-gray-500">نجاح</div>
</div>
<div className="text-center p-2 rounded-xl bg-black/30">
<div className="text-blue-400 font-bold text-sm">${(t.aum/1000000).toFixed(1)}M</div>
<div className="text-[10px] text-gray-500">AUM</div>
</div>
<div className="text-center p-2 rounded-xl bg-black/30">
<div className="text-red-400 font-bold text-sm">-{t.drawdown}%</div>
<div className="text-[10px] text-gray-500">DD</div>
</div>
</div>

{/* PnL Timeline */}
<div className="flex gap-2 mb-4">
<div className="flex-1 p-2 rounded-xl bg-white/5"><div className="flex items-center justify-between"><span className="text-xs text-gray-500">7 أيام</span><span className="text-green-400 font-bold text-sm">+{t.pnl7d}%</span></div></div>
<div className="flex-1 p-2 rounded-xl bg-white/5"><div className="flex items-center justify-between"><span className="text-xs text-gray-500">30 يوم</span><span className="text-green-400 font-bold text-sm">+{t.pnl30d}%</span></div></div>
</div>

{/* Mini Chart */}
<div className="h-12 flex items-end gap-0.5 mb-4">
{Array.from({length:20},(_,i)=>20+Math.sin(i*0.5)*15+Math.random()*20).map((h,i)=><div key={i} className="flex-1 rounded-t bg-gradient-to-t from-green-500/30 to-green-400" style={{height:`${h}%`}}/>)}
</div>

{/* Action Button */}
<button onClick={()=>toggleCopy(t)} className={`w-full py-3 rounded-xl font-bold flex items-center justify-center gap-2 transition ${copied.includes(t.id)?'bg-red-500/20 text-red-400 border border-red-500/30 hover:bg-red-500/30':'bg-gradient-to-r from-green-500 to-green-600 text-white hover:shadow-lg hover:shadow-green-500/30'}`}>
{copied.includes(t.id)?<><Pause className="w-5 h-5"/>إيقاف النسخ</>:<><Play className="w-5 h-5"/>نسخ بـ ${t.minCopy}+</>}
</button>
</div>
</motion.div>)}
</div>
</div>

{/* Copy Modal */}
<AnimatePresence>
{showModal&&<motion.div initial={{opacity:0}} animate={{opacity:1}} exit={{opacity:0}} className="fixed inset-0 bg-black/80 backdrop-blur-sm z-50 flex items-center justify-center p-4" onClick={()=>setShowModal(null)}>
<motion.div initial={{scale:0.9,opacity:0}} animate={{scale:1,opacity:1}} exit={{scale:0.9,opacity:0}} onClick={e=>e.stopPropagation()} className="bg-[#1a1a24] border border-white/10 rounded-3xl p-8 max-w-md w-full">
<div className="flex items-center gap-4 mb-6">
<div className="w-16 h-16 rounded-2xl bg-gradient-to-br from-yellow-400/20 to-purple-500/20 flex items-center justify-center text-3xl">{showModal.avatar}</div>
<div><h3 className="text-xl font-black">{showModal.name}</h3><p className="text-gray-400">نسبة النجاح: <span className="text-green-400">{showModal.winRate}%</span></p></div>
</div>
<div className="mb-6">
<label className="text-sm text-gray-400 mb-2 block">مبلغ النسخ (USDT)</label>
<div className="grid grid-cols-4 gap-2 mb-3">
{[100,500,1000,2000].map(a=><button key={a} onClick={()=>setCopyAmount(a)} className={`py-2 rounded-xl text-sm font-bold transition ${copyAmount===a?'bg-yellow-500 text-black':'bg-white/5 text-gray-400 hover:bg-white/10'}`}>${a}</button>)}
</div>
<input type="number" value={copyAmount} onChange={e=>setCopyAmount(Number(e.target.value))} className="w-full bg-white/5 border border-white/10 rounded-xl py-3 px-4 text-white text-xl font-bold text-center focus:border-yellow-500/50 focus:outline-none"/>
<p className="text-xs text-gray-500 mt-2 text-center">الحد الأدنى: ${showModal.minCopy}</p>
</div>
<div className="bg-white/5 rounded-xl p-4 mb-6">
<div className="flex justify-between mb-2"><span className="text-gray-400">العائد المتوقع (30 يوم)</span><span className="text-green-400 font-bold">+${(copyAmount*showModal.pnl30d/100).toFixed(2)}</span></div>
<div className="flex justify-between"><span className="text-gray-400">أقصى خسارة متوقعة</span><span className="text-red-400 font-bold">-${(copyAmount*showModal.drawdown/100).toFixed(2)}</span></div>
</div>
<button onClick={()=>confirmCopy(showModal)} className="w-full py-4 rounded-xl bg-gradient-to-r from-green-500 to-green-600 text-white font-bold text-lg hover:shadow-lg hover:shadow-green-500/30 transition">✓ تأكيد النسخ</button>
</motion.div>
</motion.div>}
</AnimatePresence>
</div>;
}
COPYTRADING

# Rewards Center Page
cat > src/pages/RewardsCenter.jsx << 'REWARDS'
import{useState,useEffect}from'react';import{motion,AnimatePresence}from'framer-motion';import{Gift,Zap,Star,Trophy,Target,Users,TrendingUp,CheckCircle,Lock,Clock,Sparkles,Crown,Medal,Award,Flame,Heart,Share2,MessageCircle,DollarSign,Eye,Play}from'lucide-react';
import{supabase}from'../lib/supabase';

const DAILY_TASKS=[
{id:1,title:'تسجيل الدخول اليومي',desc:'سجل دخولك كل يوم',reward:10,icon:CheckCircle,progress:1,total:1,completed:true},
{id:2,title:'شاهد فيديو تعليمي',desc:'شاهد فيديو واحد على الأقل',reward:25,icon:Play,progress:0,total:1,completed:false},
{id:3,title:'نفذ صفقة واحدة',desc:'اشترِ أو بِع أي عملة',reward:50,icon:TrendingUp,progress:0,total:1,completed:false},
{id:4,title:'شارك في الدردشة',desc:'أرسل 5 رسائل في الدردشة',reward:15,icon:MessageCircle,progress:2,total:5,completed:false},
];

const WEEKLY_TASKS=[
{id:5,title:'متداول نشط',desc:'نفذ 10 صفقات هذا الأسبوع',reward:200,icon:Flame,progress:3,total:10,completed:false},
{id:6,title:'ربح متتالي',desc:'حقق ربح 5 أيام متتالية',reward:500,icon:Trophy,progress:2,total:5,completed:false},
{id:7,title:'مستكشف',desc:'جرب جميع ميزات المنصة',reward:150,icon:Star,progress:4,total:6,completed:false},
];

const ACHIEVEMENTS=[
{id:1,title:'أول استثمار',desc:'أودع أول $100',reward:100,icon:DollarSign,unlocked:true,rarity:'common'},
{id:2,title:'متداول محترف',desc:'نفذ 100 صفقة',reward:500,icon:Target,unlocked:true,rarity:'rare'},
{id:3,title:'مليونير ZEN',desc:'اجمع 10,000 ZEN',reward:1000,icon:Zap,unlocked:false,rarity:'epic'},
{id:4,title:'أسطورة أفريقيا',desc:'حقق $10,000 أرباح',reward:5000,icon:Crown,unlocked:false,rarity:'legendary'},
{id:5,title:'قائد المجتمع',desc:'أحِل 50 صديق',reward:2500,icon:Users,unlocked:false,rarity:'epic'},
{id:6,title:'الناسخ الذهبي',desc:'انسخ 10 متداولين',reward:300,icon:Copy,unlocked:false,rarity:'rare'},
];

const LUCKY_WHEEL=[100,25,50,500,10,75,1000,5];

export default function RewardsCenter({go}){
const[zenBalance,setZenBalance]=useState(1847);
const[dailyStreak,setDailyStreak]=useState(7);
const[totalEarned,setTotalEarned]=useState(4520);
const[spinning,setSpinning]=useState(false);
const[wheelResult,setWheelResult]=useState(null);
const[rotation,setRotation]=useState(0);
const[tasks,setTasks]=useState([...DAILY_TASKS,...WEEKLY_TASKS]);
const[showClaim,setShowClaim]=useState(null);
const[tab,setTab]=useState('tasks');

const claimTask=(task)=>{
if(task.progress<task.total)return;
setZenBalance(prev=>prev+task.reward);
setTotalEarned(prev=>prev+task.reward);
setTasks(prev=>prev.map(t=>t.id===task.id?{...t,claimed:true}:t));
setShowClaim(task.reward);
setTimeout(()=>setShowClaim(null),2000);
// Save to Supabase
supabase.from('rewards').insert({task_id:task.id,reward:task.reward,type:'task'});
};

const spinWheel=()=>{
if(spinning)return;
setSpinning(true);
const result=LUCKY_WHEEL[Math.floor(Math.random()*LUCKY_WHEEL.length)];
const newRotation=rotation+1440+Math.floor(Math.random()*360);
setRotation(newRotation);
setTimeout(()=>{
setSpinning(false);
setWheelResult(result);
setZenBalance(prev=>prev+result);
setTotalEarned(prev=>prev+result);
supabase.from('rewards').insert({reward:result,type:'wheel'});
},4000);
};

return<div className="min-h-screen bg-[#0a0a0f] text-white pt-20 pb-8">
{/* Header */}
<div className="bg-gradient-to-r from-purple-500/20 via-yellow-500/10 to-purple-500/20 border-b border-white/5">
<div className="max-w-7xl mx-auto px-4 py-6">
<div className="flex flex-wrap items-center justify-between gap-4">
<div>
<h1 className="text-3xl font-black flex items-center gap-3"><Gift className="w-8 h-8 text-yellow-400"/>مركز <span className="gold-text">المكافآت</span></h1>
<p className="text-gray-400">اجمع ZEN من خلال إتمام المهام والتحديات</p>
</div>
<div className="flex items-center gap-6">
<div className="text-center px-6 py-3 rounded-2xl bg-yellow-500/10 border border-yellow-500/20">
<div className="text-3xl font-black gold-text">{zenBalance.toLocaleString()}</div>
<div className="text-xs text-yellow-400/60">رصيد ZEN</div>
</div>
<div className="text-center px-6 py-3 rounded-2xl bg-purple-500/10 border border-purple-500/20">
<div className="text-2xl font-black text-purple-400">{dailyStreak} 🔥</div>
<div className="text-xs text-purple-400/60">يوم متتالي</div>
</div>
</div>
</div>
</div>
</div>

<div className="max-w-7xl mx-auto px-4 py-6">
{/* Tabs */}
<div className="flex gap-2 mb-6 overflow-x-auto pb-2">
{[['tasks','📋 المهام'],['achievements','🏆 الإنجازات'],['wheel','🎡 عجلة الحظ'],['leaderboard','👑 المتصدرين']].map(([id,label])=><button key={id} onClick={()=>setTab(id)} className={`px-6 py-3 rounded-xl font-semibold whitespace-nowrap transition ${tab===id?'bg-yellow-500/20 text-yellow-400 border border-yellow-500/30':'bg-white/5 text-gray-400 hover:bg-white/10'}`}>{label}</button>)}
</div>

{/* Tasks Tab */}
{tab==='tasks'&&<div className="grid lg:grid-cols-2 gap-6">
{/* Daily Tasks */}
<div className="glass rounded-2xl p-6">
<h3 className="text-xl font-bold mb-4 flex items-center gap-2"><Clock className="w-5 h-5 text-blue-400"/>المهام اليومية<span className="text-xs bg-blue-500/20 text-blue-400 px-2 py-1 rounded-lg mr-auto">يتبقى 18:42:35</span></h3>
<div className="space-y-4">
{DAILY_TASKS.map((task,i)=><motion.div key={task.id} initial={{opacity:0,x:-20}} animate={{opacity:1,x:0}} transition={{delay:i*0.1}} className={`p-4 rounded-xl border transition ${task.completed?'bg-green-500/10 border-green-500/30':'bg-white/5 border-white/10'}`}>
<div className="flex items-center gap-4">
<div className={`w-12 h-12 rounded-xl flex items-center justify-center ${task.completed?'bg-green-500/20':'bg-white/10'}`}>
<task.icon className={`w-6 h-6 ${task.completed?'text-green-400':'text-gray-400'}`}/>
</div>
<div className="flex-1">
<div className="flex items-center justify-between">
<h4 className="font-bold">{task.title}</h4>
<span className="flex items-center gap-1 text-yellow-400 font-bold"><Zap className="w-4 h-4"/>+{task.reward}</span>
</div>
<p className="text-sm text-gray-400">{task.desc}</p>
<div className="mt-2 h-2 rounded-full bg-white/10 overflow-hidden">
<motion.div initial={{width:0}} animate={{width:`${(task.progress/task.total)*100}%`}} className={`h-full rounded-full ${task.completed?'bg-green-500':'bg-yellow-500'}`}/>
</div>
<span className="text-xs text-gray-500">{task.progress}/{task.total}</span>
</div>
{task.completed&&!task.claimed&&<button onClick={()=>claimTask(task)} className="px-4 py-2 rounded-xl bg-green-500 text-white font-bold text-sm hover:bg-green-600 transition">استلم</button>}
{task.claimed&&<CheckCircle className="w-6 h-6 text-green-400"/>}
</div>
</motion.div>)}
</div>
</div>

{/* Weekly Tasks */}
<div className="glass rounded-2xl p-6">
<h3 className="text-xl font-bold mb-4 flex items-center gap-2"><Trophy className="w-5 h-5 text-purple-400"/>التحديات الأسبوعية<span className="text-xs bg-purple-500/20 text-purple-400 px-2 py-1 rounded-lg mr-auto">5 أيام متبقية</span></h3>
<div className="space-y-4">
{WEEKLY_TASKS.map((task,i)=><motion.div key={task.id} initial={{opacity:0,x:20}} animate={{opacity:1,x:0}} transition={{delay:i*0.1}} className="p-4 rounded-xl bg-white/5 border border-white/10">
<div className="flex items-center gap-4">
<div className="w-12 h-12 rounded-xl bg-purple-500/20 flex items-center justify-center">
<task.icon className="w-6 h-6 text-purple-400"/>
</div>
<div className="flex-1">
<div className="flex items-center justify-between">
<h4 className="font-bold">{task.title}</h4>
<span className="flex items-center gap-1 text-yellow-400 font-bold"><Zap className="w-4 h-4"/>+{task.reward}</span>
</div>
<p className="text-sm text-gray-400">{task.desc}</p>
<div className="mt-2 h-2 rounded-full bg-white/10 overflow-hidden">
<motion.div animate={{width:`${(task.progress/task.total)*100}%`}} className="h-full rounded-full bg-gradient-to-r from-purple-500 to-pink-500"/>
</div>
<span className="text-xs text-gray-500">{task.progress}/{task.total}</span>
</div>
</div>
</motion.div>)}
</div>
</div>
</div>}

{/* Achievements Tab */}
{tab==='achievements'&&<div className="grid md:grid-cols-2 lg:grid-cols-3 gap-4">
{ACHIEVEMENTS.map((a,i)=><motion.div key={a.id} initial={{opacity:0,scale:0.9}} animate={{opacity:1,scale:1}} transition={{delay:i*0.05}} className={`p-6 rounded-2xl border relative overflow-hidden ${a.unlocked?'bg-gradient-to-br from-yellow-500/10 to-purple-500/10 border-yellow-500/30':'bg-white/5 border-white/10 opacity-60'}`}>
{!a.unlocked&&<div className="absolute inset-0 bg-black/50 flex items-center justify-center"><Lock className="w-8 h-8 text-gray-500"/></div>}
<div className={`absolute top-2 left-2 px-2 py-1 rounded-lg text-xs font-bold ${a.rarity==='legendary'?'bg-gradient-to-r from-yellow-400 to-orange-500 text-black':a.rarity==='epic'?'bg-purple-500 text-white':a.rarity==='rare'?'bg-blue-500 text-white':'bg-gray-500 text-white'}`}>{a.rarity==='legendary'?'أسطوري':a.rarity==='epic'?'ملحمي':a.rarity==='rare'?'نادر':'عادي'}</div>
<div className="flex items-center gap-4 mt-4">
<div className={`w-16 h-16 rounded-2xl flex items-center justify-center ${a.unlocked?'bg-yellow-500/20':'bg-white/10'}`}>
<a.icon className={`w-8 h-8 ${a.unlocked?'text-yellow-400':'text-gray-500'}`}/>
</div>
<div>
<h4 className="font-bold text-lg">{a.title}</h4>
<p className="text-sm text-gray-400">{a.desc}</p>
<div className="flex items-center gap-1 mt-1 text-yellow-400 font-bold"><Zap className="w-4 h-4"/>+{a.reward} ZEN</div>
</div>
</div>
</motion.div>)}
</div>}

{/* Lucky Wheel Tab */}
{tab==='wheel'&&<div className="flex flex-col items-center justify-center py-12">
<div className="relative w-80 h-80 mb-8">
{/* Wheel */}
<motion.div animate={{rotate:rotation}} transition={{duration:4,ease:'easeOut'}} className="w-full h-full rounded-full border-8 border-yellow-500 relative" style={{background:'conic-gradient(from 0deg, #22c55e 0deg 45deg, #f59e0b 45deg 90deg, #3b82f6 90deg 135deg, #8b5cf6 135deg 180deg, #ec4899 180deg 225deg, #06b6d4 225deg 270deg, #f97316 270deg 315deg, #10b981 315deg 360deg)'}}>
{LUCKY_WHEEL.map((prize,i)=><div key={i} className="absolute text-white font-bold text-sm" style={{top:'50%',left:'50%',transform:`rotate(${i*45+22.5}deg) translateY(-120px) rotate(-${i*45+22.5}deg)`}}>{prize}</div>)}
</motion.div>
{/* Pointer */}
<div className="absolute top-0 left-1/2 -translate-x-1/2 -translate-y-2 w-0 h-0 border-l-[15px] border-r-[15px] border-t-[30px] border-l-transparent border-r-transparent border-t-yellow-400"/>
{/* Center */}
<button onClick={spinWheel} disabled={spinning} className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-24 h-24 rounded-full bg-gradient-to-br from-yellow-400 to-yellow-600 text-black font-black text-lg hover:scale-105 transition disabled:opacity-50">{spinning?'🎰':'دور!'}</button>
</div>
{wheelResult&&<motion.div initial={{scale:0}} animate={{scale:1}} className="text-center"><div className="text-5xl font-black gold-text mb-2">+{wheelResult} ZEN!</div><p className="text-gray-400">مبروك! تمت إضافة المكافأة لرصيدك</p></motion.div>}
<p className="text-gray-500 text-sm mt-4">يمكنك الدوران مرة واحدة يومياً مجاناً</p>
</div>}

{/* Leaderboard Tab */}
{tab==='leaderboard'&&<div className="glass rounded-2xl p-6">
<h3 className="text-xl font-bold mb-6 flex items-center gap-2"><Crown className="w-5 h-5 text-yellow-400"/>أكثر جامعي ZEN</h3>
<div className="space-y-3">
{[
{rank:1,name:'CryptoKing',zen:125000,badge:'🥇'},
{rank:2,name:'ZenMaster',zen:98500,badge:'🥈'},
{rank:3,name:'AfricanBull',zen:87200,badge:'🥉'},
{rank:4,name:'DiamondHands',zen:72400,badge:'4'},
{rank:5,name:'MoonHunter',zen:65800,badge:'5'},
{rank:24,name:'أنت',zen:zenBalance,badge:'24',isMe:true},
].map((user,i)=><motion.div key={i} initial={{opacity:0,x:-20}} animate={{opacity:1,x:0}} transition={{delay:i*0.1}} className={`flex items-center gap-4 p-4 rounded-xl ${user.isMe?'bg-yellow-500/20 border border-yellow-500/30':'bg-white/5'}`}>
<div className={`w-10 h-10 rounded-xl flex items-center justify-center font-black ${user.rank<=3?'bg-gradient-to-br from-yellow-400 to-yellow-600 text-black':'bg-white/10 text-gray-400'}`}>{user.badge}</div>
<div className="flex-1"><div className="font-bold">{user.name}</div></div>
<div className="flex items-center gap-1 text-yellow-400 font-bold"><Zap className="w-4 h-4"/>{user.zen.toLocaleString()}</div>
</motion.div>)}
</div>
</div>}
</div>

{/* Claim Animation */}
<AnimatePresence>
{showClaim&&<motion.div initial={{opacity:0,scale:0.5,y:50}} animate={{opacity:1,scale:1,y:0}} exit={{opacity:0,scale:0.5,y:-50}} className="fixed top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 z-50 text-center">
<div className="text-6xl font-black gold-text">+{showClaim} ZEN!</div>
<Sparkles className="w-12 h-12 text-yellow-400 mx-auto mt-4 animate-spin"/>
</motion.div>}
</AnimatePresence>
</div>;
}
REWARDS

# Update main App with new pages
cat > src/App.jsx << 'APPEOF'
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
APPEOF

echo "📦 Installing & Building..."
npm install
npm run build

if [ $? -eq 0 ]; then
    echo "🚀 Deploying..."
    vercel --prod --yes
    echo ""
    echo "🎉🎉🎉 ZENITH PRO READY! 🎉🎉🎉"
    echo "🌐 https://zenith-africa.vercel.app"
fi
