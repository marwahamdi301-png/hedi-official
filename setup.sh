#!/bin/bash
echo "🏆 ZENITH Africa - جاري الإنشاء..."

mkdir -p src/constants

cat > package.json << 'EOF'
{
  "name": "zenith-africa",
  "private": true,
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "lucide-react": "^0.468.0",
    "react": "^18.3.1",
    "react-dom": "^18.3.1"
  },
  "devDependencies": {
    "@vitejs/plugin-react": "^4.3.4",
    "autoprefixer": "^10.4.20",
    "postcss": "^8.4.49",
    "tailwindcss": "^3.4.17",
    "vite": "^6.0.5"
  }
}
EOF

cat > vite.config.js << 'EOF'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
export default defineConfig({ plugins: [react()] })
EOF

cat > tailwind.config.js << 'EOF'
export default {
  content: ["./index.html", "./src/**/*.{js,jsx}"],
  theme: { extend: { colors: { gold: { 400: '#ffd84d', 500: '#f5c518', 600: '#d4a810' }, dark: { 900: '#0a0a0f' } } } },
  plugins: []
}
EOF

cat > postcss.config.js << 'EOF'
export default { plugins: { tailwindcss: {}, autoprefixer: {} } }
EOF

cat > index.html << 'EOF'
<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>ZENITH Africa | منصة الاستثمار</title>
  <link href="https://fonts.googleapis.com/css2?family=Cairo:wght@400;600;700;900&display=swap" rel="stylesheet">
</head>
<body><div id="root"></div><script type="module" src="/src/main.jsx"></script></body>
</html>
EOF

cat > src/index.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;
body { font-family: 'Cairo', sans-serif; background: #0a0a0f; color: white; }
.gold-text { background: linear-gradient(135deg, #f5c518, #ffe680); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
.gold-gradient { background: linear-gradient(135deg, #f5c518, #d4a810); }
.glass-card { background: rgba(255,255,255,0.03); backdrop-filter: blur(20px); border: 1px solid rgba(255,255,255,0.08); }
.btn-gold { background: linear-gradient(135deg, #f5c518, #d4a810); color: #0a0a0f; font-weight: 700; }
.btn-gold:hover { transform: translateY(-2px); box-shadow: 0 10px 30px rgba(245,197,24,0.4); }
EOF

cat > src/main.jsx << 'EOF'
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App'
import './index.css'
ReactDOM.createRoot(document.getElementById('root')).render(<React.StrictMode><App /></React.StrictMode>)
EOF

cat > src/constants/links.js << 'EOF'
export const LINKS = {
  email: "marwahamdi301@gmail.com",
  github: "https://github.com/marwahamdi301/hedi-official",
  telegram: "https://wjslyrr.streamlit.app",
  site: "https://hedi-official.vercel.app"
};
EOF

cat > src/App.jsx << 'EOF'
import { useState } from "react";
import { Zap, TrendingUp, Shield, Users, Star, Crown, Gem, Check, Mail, MessageCircle, Code2, ArrowLeft, Wallet, BarChart3, Gift, ArrowUpRight, ArrowDownRight, Bell, DollarSign } from "lucide-react";
import { LINKS } from "./constants/links";

const plans = [
  { name: "البرونزية", icon: Star, daily: "0.8%", min: "$100", max: "$4,999", total: "24%", color: "text-amber-400", features: ["عائد يومي 0.8%", "سحب يومي", "دعم بريدي"] },
  { name: "الذهبية", icon: Crown, daily: "1.2%", min: "$5,000", max: "$24,999", total: "72%", color: "text-yellow-400", popular: true, features: ["عائد يومي 1.2%", "سحب فوري", "دعم 24/7", "مدير حساب"] },
  { name: "الماسية", icon: Gem, daily: "1.5%", min: "$25,000", max: "∞", total: "135%", color: "text-cyan-400", features: ["عائد يومي 1.5%", "VIP سحب", "مستشار خاص", "تحليلات AI"] },
];

const stats = [{ v: "$5.2M+", l: "أموال مُدارة" }, { v: "25K+", l: "مستثمر" }, { v: "99.9%", l: "وقت التشغيل" }, { v: "35+", l: "دولة" }];

export default function App() {
  const [page, setPage] = useState("home");
  const [logged, setLogged] = useState(false);
  const login = () => { setLogged(true); setPage("dash"); };

  return (
    <div className="min-h-screen bg-[#0a0a0f] text-white">
      <header className="fixed top-0 left-0 right-0 z-50 bg-[#0a0a0f]/90 backdrop-blur-xl border-b border-white/5">
        <div className="max-w-7xl mx-auto px-4 h-20 flex items-center justify-between">
          <div className="flex items-center gap-3 cursor-pointer" onClick={() => setPage("home")}>
            <div className="w-12 h-12 rounded-xl gold-gradient flex items-center justify-center"><Zap className="w-7 h-7 text-black" /></div>
            <div><span className="text-xl font-black gold-text">ZENITH</span><span className="block text-[10px] text-yellow-500/60 tracking-widest">AFRICA</span></div>
          </div>
          <nav className="hidden md:flex gap-2">
            {[["home", "الرئيسية"], ["plans", "الخطط"], ["about", "حول"]].map(([p, n]) => (
              <button key={p} onClick={() => setPage(p)} className={`px-5 py-2 rounded-xl text-sm font-semibold ${page === p ? "bg-yellow-500/15 text-yellow-400" : "text-gray-400 hover:text-white"}`}>{n}</button>
            ))}
          </nav>
          {logged ? (
            <div className="flex gap-2">
              <button onClick={() => setPage("dash")} className="px-4 py-2 rounded-xl bg-yellow-500/10 text-yellow-400 text-sm font-semibold">لوحة التحكم</button>
              <button onClick={() => { setLogged(false); setPage("home"); }} className="px-4 py-2 rounded-xl text-red-400 text-sm">خروج</button>
            </div>
          ) : (
            <button onClick={login} className="btn-gold px-6 py-2 rounded-xl text-sm font-bold">ابدأ الاستثمار</button>
          )}
        </div>
      </header>

      <main className="pt-20">
        {page === "home" && (
          <>
            <section className="min-h-screen flex items-center justify-center relative">
              <div className="absolute top-1/4 right-1/4 w-96 h-96 bg-yellow-500/10 rounded-full blur-[150px]" />
              <div className="relative z-10 text-center px-4 max-w-4xl mx-auto">
                <div className="inline-flex items-center gap-2 px-5 py-2 rounded-full bg-yellow-500/10 border border-yellow-500/20 mb-8">
                  <span className="text-yellow-400 text-sm font-semibold">المنصة #1 في أفريقيا</span>
                  <div className="w-2 h-2 bg-green-500 rounded-full animate-pulse" />
                </div>
                <h1 className="text-5xl md:text-7xl font-black mb-6">استثمر بذكاء مع<br /><span className="gold-text text-6xl md:text-8xl">ZENITH</span></h1>
                <p className="text-xl text-gray-400 mb-8">منصة موثوقة مدعومة بعملة <span className="text-yellow-400 font-bold">ZEN</span>. عوائد تصل <span className="text-green-400 font-bold">1.5% يومياً</span></p>
                <div className="flex flex-col sm:flex-row gap-4 justify-center mb-12">
                  <button onClick={login} className="btn-gold px-10 py-4 rounded-2xl text-lg font-bold flex items-center gap-3 justify-center">ابدأ الآن <ArrowLeft className="w-5 h-5" /></button>
                  <button onClick={() => setPage("plans")} className="px-10 py-4 rounded-2xl border border-white/10 text-gray-300 hover:border-yellow-500/30">الخطط</button>
                </div>
                <div className="grid grid-cols-2 md:grid-cols-4 gap-4 max-w-3xl mx-auto">
                  {stats.map((s, i) => (<div key={i} className="glass-card rounded-2xl p-4"><div className="text-2xl font-black gold-text">{s.v}</div><div className="text-sm text-gray-500">{s.l}</div></div>))}
                </div>
              </div>
            </section>
            <section className="py-24 px-4">
              <div className="max-w-7xl mx-auto">
                <h2 className="text-4xl font-black text-center mb-16">لماذا <span className="gold-text">ZENITH؟</span></h2>
                <div className="grid md:grid-cols-3 gap-6">
                  {[[Shield, "أمان بنكي", "تشفير 256-bit"], [TrendingUp, "عوائد مضمونة", "حتى 1.5% يومياً"], [Users, "برنامج إحالة", "حتى 10% عمولة"]].map(([I, t, d], i) => (
                    <div key={i} className="glass-card rounded-2xl p-8 hover:border-yellow-500/30 transition group">
                      <div className="w-14 h-14 rounded-2xl bg-yellow-500/10 flex items-center justify-center mb-5"><I className="w-7 h-7 text-yellow-400" /></div>
                      <h3 className="text-xl font-bold mb-3 group-hover:text-yellow-400">{t}</h3>
                      <p className="text-gray-400">{d}</p>
                    </div>
                  ))}
                </div>
              </div>
            </section>
            <section className="py-24 px-4">
              <div className="max-w-7xl mx-auto">
                <h2 className="text-4xl font-black text-center mb-16">خطط <span className="gold-text">الاستثمار</span></h2>
                <div className="grid md:grid-cols-3 gap-8">
                  {plans.map((p, i) => (
                    <div key={i} className={`glass-card rounded-3xl p-8 relative ${p.popular ? "border-yellow-500/40 md:scale-105" : ""}`}>
                      {p.popular && <div className="absolute -top-4 left-1/2 -translate-x-1/2 bg-yellow-500 text-black px-4 py-1 rounded-full text-sm font-bold">⭐ الأكثر شعبية</div>}
                      <div className="text-center mb-6"><p.icon className={`w-12 h-12 mx-auto mb-4 ${p.color}`} /><h3 className="text-2xl font-bold">{p.name}</h3></div>
                      <div className="text-center p-6 rounded-2xl bg-white/5 mb-6"><div className="text-5xl font-black gold-text">{p.daily}</div><div className="text-gray-400">يومياً</div><div className="mt-2 text-green-400 font-bold">إجمالي: {p.total}</div></div>
                      <div className="grid grid-cols-2 gap-3 mb-6 text-sm text-center"><div className="p-3 rounded-xl bg-white/5"><div className="text-gray-500">الأدنى</div><div className="font-bold">{p.min}</div></div><div className="p-3 rounded-xl bg-white/5"><div className="text-gray-500">الأقصى</div><div className="font-bold">{p.max}</div></div></div>
                      <ul className="space-y-2 mb-6">{p.features.map((f, j) => (<li key={j} className="flex items-center gap-2 text-sm text-gray-300"><Check className="w-4 h-4 text-green-400" />{f}</li>))}</ul>
                      <button onClick={login} className={`w-full py-4 rounded-2xl font-bold ${p.popular ? "btn-gold" : "bg-white/5 hover:bg-white/10"}`}>استثمر</button>
                    </div>
                  ))}
                </div>
              </div>
            </section>
          </>
        )}

        {page === "plans" && (
          <section className="py-32 px-4">
            <div className="max-w-7xl mx-auto">
              <h1 className="text-5xl font-black text-center mb-16">خطط <span className="gold-text">الاستثمار</span></h1>
              <div className="grid md:grid-cols-3 gap-8">
                {plans.map((p, i) => (
                  <div key={i} className="glass-card rounded-3xl p-8 text-center">
                    <p.icon className={`w-16 h-16 mx-auto mb-4 ${p.color}`} />
                    <h3 className="text-2xl font-bold mb-4">{p.name}</h3>
                    <div className="text-5xl font-black gold-text mb-2">{p.daily}</div>
                    <div className="text-gray-400 mb-6">عائد يومي</div>
                    <button onClick={login} className="w-full btn-gold py-4 rounded-2xl font-bold">استثمر الآن</button>
                  </div>
                ))}
              </div>
            </div>
          </section>
        )}

        {page === "about" && (
          <section className="py-32 px-4">
            <div className="max-w-4xl mx-auto text-center">
              <h1 className="text-5xl font-black mb-8"><span className="gold-text">ZENITH</span> Africa</h1>
              <p className="text-xl text-gray-400 mb-12">المنصة الاستثمارية الرائدة في أفريقيا</p>
              <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-12">
                {stats.map((s, i) => (<div key={i} className="glass-card rounded-2xl p-6"><div className="text-3xl font-black gold-text">{s.v}</div><div className="text-gray-500">{s.l}</div></div>))}
              </div>
              <div className="glass-card rounded-2xl p-8">
                <h3 className="text-2xl font-bold mb-6">تواصل معنا</h3>
                <div className="flex flex-wrap justify-center gap-4">
                  <a href={`mailto:${LINKS.email}`} className="flex items-center gap-2 px-6 py-3 rounded-xl bg-red-500/10 text-red-400"><Mail className="w-5 h-5" />{LINKS.email}</a>
                  <a href={LINKS.telegram} target="_blank" rel="noreferrer" className="flex items-center gap-2 px-6 py-3 rounded-xl bg-blue-500/10 text-blue-400"><MessageCircle className="w-5 h-5" />Telegram</a>
                  <a href={LINKS.github} target="_blank" rel="noreferrer" className="flex items-center gap-2 px-6 py-3 rounded-xl bg-gray-500/10 text-gray-400"><Code2 className="w-5 h-5" />GitHub</a>
                </div>
              </div>
            </div>
          </section>
        )}

        {page === "dash" && (
          <section className="py-32 px-4">
            <div className="max-w-7xl mx-auto">
              <div className="flex items-center justify-between mb-8">
                <div><h1 className="text-3xl font-black">مرحباً، <span className="gold-text">أحمد</span> 👋</h1><p className="text-gray-400">آخر دخول: اليوم</p></div>
                <button className="relative p-3 rounded-xl glass-card"><Bell className="w-5 h-5" /><span className="absolute -top-1 -right-1 w-5 h-5 bg-red-500 rounded-full text-xs flex items-center justify-center">3</span></button>
              </div>
              <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
                {[[Wallet, "الرصيد", "$18,600", "text-yellow-400"], [TrendingUp, "أرباح يومية", "$160", "text-green-400"], [DollarSign, "المُستثمر", "$15,000", "text-blue-400"], [BarChart3, "إجمالي الأرباح", "$3,600", "text-purple-400"]].map(([I, l, v, c], i) => (
                  <div key={i} className="glass-card rounded-2xl p-6"><I className={`w-8 h-8 ${c} mb-3`} /><div className="text-2xl font-black">{v}</div><div className="text-sm text-gray-500">{l}</div></div>
                ))}
              </div>
              <div className="grid md:grid-cols-2 gap-6">
                <div className="glass-card rounded-2xl p-8">
                  <h3 className="text-xl font-bold mb-6 flex items-center gap-2"><Crown className="w-5 h-5 text-yellow-400" />استثماراتك</h3>
                  {[["الذهبية", "$10,000", "+$2,160", "60%", "border-yellow-500/30"], ["البرونزية", "$5,000", "+$600", "75%", "border-amber-500/30"]].map(([n, a, p, w, b], i) => (
                    <div key={i} className={`p-4 rounded-xl bg-white/3 border ${b} mb-3`}>
                      <div className="flex justify-between mb-2"><span className="font-bold">{n}</span><span className="text-green-400 text-sm">نشط</span></div>
                      <div className="flex justify-between text-sm text-gray-400"><span>{a}</span><span>{p}</span></div>
                      <div className="mt-3 h-2 rounded-full bg-white/10"><div className="h-full rounded-full gold-gradient" style={{width: w}}></div></div>
                    </div>
                  ))}
                </div>
                <div className="glass-card rounded-2xl p-8">
                  <h3 className="text-xl font-bold mb-6">إجراءات</h3>
                  {[[ArrowDownRight, "إيداع", "bg-green-500/10 border-green-500/20 text-green-400"], [ArrowUpRight, "سحب", "bg-blue-500/10 border-blue-500/20 text-blue-400"], [TrendingUp, "استثمار جديد", "bg-yellow-500/10 border-yellow-500/20 text-yellow-400"], [Gift, "دعوة صديق", "bg-purple-500/10 border-purple-500/20 text-purple-400"]].map(([I, t, c], i) => (
                    <button key={i} className={`w-full flex items-center gap-3 p-4 rounded-xl border ${c} font-semibold mb-3 hover:opacity-80`}><I className="w-5 h-5" />{t}</button>
                  ))}
                </div>
              </div>
            </div>
          </section>
        )}
      </main>

      <footer className="border-t border-white/5 py-12 px-4">
        <div className="max-w-7xl mx-auto flex flex-col md:flex-row items-center justify-between gap-6">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl gold-gradient flex items-center justify-center"><Zap className="w-6 h-6 text-black" /></div>
            <span className="text-xl font-black gold-text">ZENITH</span>
          </div>
          <div className="flex gap-4">
            <a href={`mailto:${LINKS.email}`} className="text-gray-400 hover:text-yellow-400"><Mail className="w-5 h-5" /></a>
            <a href={LINKS.telegram} target="_blank" rel="noreferrer" className="text-gray-400 hover:text-yellow-400"><MessageCircle className="w-5 h-5" /></a>
            <a href={LINKS.github} target="_blank" rel="noreferrer" className="text-gray-400 hover:text-yellow-400"><Code2 className="w-5 h-5" /></a>
          </div>
        </div>
        <div className="text-center text-gray-500 text-sm mt-6">© 2024 ZENITH Africa ❤️</div>
      </footer>
    </div>
  );
}
EOF

echo "✅ تم إنشاء الملفات!"
echo "📦 جاري التثبيت..."
npm install
echo ""
echo "🎉 تم! شغّل: npm run dev"
