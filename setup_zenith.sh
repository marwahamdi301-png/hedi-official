#!/bin/bash
echo "🏆 ZENITH Africa - جاري الإنشاء..."

# إنشاء المجلدات
mkdir -p src/components src/constants src/utils public/images

# package.json
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
    "clsx": "^2.1.1",
    "lucide-react": "^0.468.0",
    "react": "^18.3.1",
    "react-dom": "^18.3.1",
    "tailwind-merge": "^2.6.0"
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

# vite.config.js
cat > vite.config.js << 'EOF'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
export default defineConfig({
  plugins: [react()],
})
EOF

# tailwind.config.js
cat > tailwind.config.js << 'EOF'
export default {
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  theme: {
    extend: {
      colors: {
        gold: { 400: '#ffd84d', 500: '#f5c518', 600: '#d4a810' },
        dark: { 800: '#111118', 900: '#0a0a0f' }
      },
      fontFamily: { cairo: ['Cairo', 'sans-serif'] }
    }
  },
  plugins: []
}
EOF

# postcss.config.js
cat > postcss.config.js << 'EOF'
export default {
  plugins: { tailwindcss: {}, autoprefixer: {} }
}
EOF

# index.html
cat > index.html << 'EOF'
<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>ZENITH Africa | منصة الاستثمار الرائدة</title>
  <link href="https://fonts.googleapis.com/css2?family=Cairo:wght@400;600;700;800;900&display=swap" rel="stylesheet">
</head>
<body>
  <div id="root"></div>
  <script type="module" src="/src/main.jsx"></script>
</body>
</html>
EOF

# src/index.css
cat > src/index.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;
* { margin: 0; padding: 0; box-sizing: border-box; }
body { font-family: 'Cairo', sans-serif; background: #0a0a0f; color: white; direction: rtl; }
.gold-text { background: linear-gradient(135deg, #f5c518, #ffe680); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
.gold-gradient { background: linear-gradient(135deg, #f5c518, #d4a810); }
.glass-card { background: rgba(255,255,255,0.03); backdrop-filter: blur(20px); border: 1px solid rgba(255,255,255,0.08); }
.btn-primary { background: linear-gradient(135deg, #f5c518, #d4a810); color: #0a0a0f; font-weight: 700; }
.btn-primary:hover { transform: translateY(-2px); box-shadow: 0 10px 30px rgba(245,197,24,0.4); }
EOF

# src/main.jsx
cat > src/main.jsx << 'EOF'
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App'
import './index.css'
ReactDOM.createRoot(document.getElementById('root')).render(<React.StrictMode><App /></React.StrictMode>)
EOF

# src/constants/links.js
cat > src/constants/links.js << 'EOF'
export const LINKS = {
  email: "marwahamdi301@gmail.com",
  github: "https://github.com/marwahamdi301/hedi-official",
  telegram: "https://wjslyrr.streamlit.app",
  site: "https://hedi-official.vercel.app"
};
export default LINKS;
EOF

# src/App.jsx - التطبيق الرئيسي
cat > src/App.jsx << 'APPEOF'
import { useState } from 'react';
import { Zap, TrendingUp, Shield, Users, Star, Crown, Gem, Check, Mail, MessageCircle, Code2, ArrowLeft, Wallet, BarChart3, Clock, Gift, ArrowUpRight, ArrowDownRight, Copy, CheckCircle, Bell, RefreshCcw, DollarSign, PieChart } from 'lucide-react';
import LINKS from './constants/links';

const plans = [
  { name: 'البرونزية', icon: Star, daily: '0.8%', min: '$100', max: '$4,999', duration: '30 يوم', total: '24%', color: 'amber', features: ['عائد يومي 0.8%', 'سحب يومي', 'دعم بريدي'] },
  { name: 'الذهبية', icon: Crown, daily: '1.2%', min: '$5,000', max: '$24,999', duration: '60 يوم', total: '72%', color: 'yellow', popular: true, features: ['عائد يومي 1.2%', 'سحب فوري', 'دعم 24/7', 'مدير حساب', 'عمولة 8%'] },
  { name: 'الماسية', icon: Gem, daily: '1.5%', min: '$25,000', max: 'غير محدود', duration: '90 يوم', total: '135%', color: 'cyan', features: ['عائد يومي 1.5%', 'VIP سحب', 'مستشار خاص', 'تحليلات AI', 'عمولة 10%'] },
];

const stats = [
  { value: '$5.2M+', label: 'أموال مُدارة' },
  { value: '25K+', label: 'مستثمر نشط' },
  { value: '99.9%', label: 'وقت التشغيل' },
  { value: '35+', label: 'دولة' },
];

export default function App() {
  const [page, setPage] = useState('home');
  const [loggedIn, setLoggedIn] = useState(false);

  const login = () => { setLoggedIn(true); setPage('dashboard'); };
  const logout = () => { setLoggedIn(false); setPage('home'); };

  return (
    <div className="min-h-screen bg-[#0a0a0f] text-white font-[Cairo]">
      {/* Header */}
      <header className="fixed top-0 left-0 right-0 z-50 bg-[#0a0a0f]/90 backdrop-blur-xl border-b border-white/5">
        <div className="max-w-7xl mx-auto px-4 h-20 flex items-center justify-between">
          <div className="flex items-center gap-3 cursor-pointer" onClick={() => setPage('home')}>
            <div className="w-12 h-12 rounded-xl gold-gradient flex items-center justify-center">
              <Zap className="w-7 h-7 text-[#0a0a0f]" />
            </div>
            <div>
              <span className="text-xl font-black gold-text">ZENITH</span>
              <span className="block text-[10px] text-yellow-500/60 tracking-[0.3em]">AFRICA</span>
            </div>
          </div>
          <nav className="hidden md:flex gap-2">
            {['home', 'plans', 'about'].map(p => (
              <button key={p} onClick={() => setPage(p)} className={`px-5 py-2 rounded-xl text-sm font-semibold transition ${page === p ? 'bg-yellow-500/15 text-yellow-400' : 'text-gray-400 hover:text-white'}`}>
                {p === 'home' ? 'الرئيسية' : p === 'plans' ? 'الخطط' : 'حول'}
              </button>
            ))}
          </nav>
          <div className="flex gap-3">
            {loggedIn ? (
              <>
                <button onClick={() => setPage('dashboard')} className="px-5 py-2 rounded-xl bg-yellow-500/10 text-yellow-400 text-sm font-semibold">لوحة التحكم</button>
                <button onClick={logout} className="px-5 py-2 rounded-xl text-red-400 text-sm font-semibold">خروج</button>
              </>
            ) : (
              <button onClick={login} className="btn-primary px-6 py-2 rounded-xl text-sm font-bold transition">ابدأ الاستثمار</button>
            )}
          </div>
        </div>
      </header>

      <main className="pt-20">
        {/* HOME PAGE */}
        {page === 'home' && (
          <>
            {/* Hero */}
            <section className="min-h-screen flex items-center justify-center relative overflow-hidden">
              <div className="absolute top-1/4 right-1/4 w-[500px] h-[500px] bg-yellow-500/5 rounded-full blur-[150px]" />
              <div className="relative z-10 text-center px-4 max-w-4xl mx-auto">
                <div className="inline-flex items-center gap-2 px-5 py-2 rounded-full bg-yellow-500/10 border border-yellow-500/20 mb-8">
                  <span className="text-yellow-400 text-sm font-semibold">المنصة الاستثمارية #1 في أفريقيا</span>
                  <div className="w-2 h-2 bg-green-500 rounded-full animate-pulse" />
                </div>
                <h1 className="text-5xl md:text-7xl font-black mb-6">
                  <span className="text-white">استثمر بذكاء مع</span><br />
                  <span className="gold-text text-6xl md:text-8xl">ZENITH</span>
                </h1>
                <p className="text-xl text-gray-400 mb-8 max-w-2xl mx-auto">
                  منصة استثمارية موثوقة مدعومة بعملة <span className="text-yellow-400 font-bold">ZEN</span> الرقمية.
                  حقق عوائد تصل إلى <span className="text-green-400 font-bold">1.5% يومياً</span>
                </p>
                <div className="flex flex-col sm:flex-row gap-4 justify-center mb-12">
                  <button onClick={login} className="btn-primary px-10 py-4 rounded-2xl text-lg font-bold flex items-center gap-3 justify-center transition">
                    ابدأ الاستثمار الآن <ArrowLeft className="w-5 h-5" />
                  </button>
                  <button onClick={() => setPage('plans')} className="px-10 py-4 rounded-2xl border border-white/10 text-gray-300 hover:border-yellow-500/30 transition">
                    استعرض الخطط
                  </button>
                </div>
                <div className="grid grid-cols-2 md:grid-cols-4 gap-4 max-w-3xl mx-auto">
                  {stats.map((s, i) => (
                    <div key={i} className="glass-card rounded-2xl p-4">
                      <div className="text-2xl font-black gold-text">{s.value}</div>
                      <div className="text-sm text-gray-500">{s.label}</div>
                    </div>
                  ))}
                </div>
              </div>
            </section>

            {/* Features */}
            <section className="py-24 px-4">
              <div className="max-w-7xl mx-auto">
                <h2 className="text-4xl font-black text-center mb-16">
                  <span className="text-white">لماذا </span><span className="gold-text">ZENITH؟</span>
                </h2>
                <div className="grid md:grid-cols-3 gap-6">
                  {[
                    { icon: Shield, title: 'أمان بنكي', desc: 'تشفير 256-bit مع حماية متعددة الطبقات' },
                    { icon: TrendingUp, title: 'عوائد مضمونة', desc: 'احصل على عوائد تصل إلى 1.5% يومياً' },
                    { icon: Users, title: 'برنامج إحالة', desc: 'اكسب حتى 10% من استثمارات المُحالين' },
                  ].map((f, i) => (
                    <div key={i} className="glass-card rounded-2xl p-8 hover:border-yellow-500/30 transition group">
                      <div className="w-14 h-14 rounded-2xl bg-yellow-500/10 flex items-center justify-center mb-5 group-hover:bg-yellow-500/20 transition">
                        <f.icon className="w-7 h-7 text-yellow-400" />
                      </div>
                      <h3 className="text-xl font-bold mb-3 group-hover:text-yellow-400 transition">{f.title}</h3>
                      <p className="text-gray-400">{f.desc}</p>
                    </div>
                  ))}
                </div>
              </div>
            </section>

            {/* Plans Preview */}
            <section className="py-24 px-4 bg-gradient-to-b from-transparent via-yellow-500/5 to-transparent">
              <div className="max-w-7xl mx-auto">
                <h2 className="text-4xl font-black text-center mb-16">
                  <span className="text-white">خطط </span><span className="gold-text">الاستثمار</span>
                </h2>
                <div className="grid md:grid-cols-3 gap-8">
                  {plans.map((plan, i) => (
                    <div key={i} className={`glass-card rounded-3xl p-8 relative ${plan.popular ? 'border-yellow-500/40 scale-105' : ''}`}>
                      {plan.popular && (
                        <div className="absolute -top-4 left-1/2 -translate-x-1/2 bg-yellow-500 text-black px-4 py-1 rounded-full text-sm font-bold">
                          ⭐ الأكثر شعبية
                        </div>
                      )}
                      <div className="text-center mb-6">
                        <plan.icon className={`w-12 h-12 mx-auto mb-4 text-${plan.color}-400`} />
                        <h3 className="text-2xl font-bold">{plan.name}</h3>
                      </div>
                      <div className="text-center p-6 rounded-2xl bg-white/3 mb-6">
                        <div className="text-5xl font-black gold-text">{plan.daily}</div>
                        <div className="text-gray-400">عائد يومي</div>
                        <div className="mt-2 text-green-400 font-bold">إجمالي: {plan.total}</div>
                      </div>
                      <div className="grid grid-cols-2 gap-3 mb-6 text-center text-sm">
                        <div className="p-3 rounded-xl bg-white/3"><div className="text-gray-500">الحد الأدنى</div><div className="font-bold">{plan.min}</div></div>
                        <div className="p-3 rounded-xl bg-white/3"><div className="text-gray-500">الحد الأقصى</div><div className="font-bold">{plan.max}</div></div>
                      </div>
                      <ul className="space-y-2 mb-6">
                        {plan.features.map((f, j) => (
                          <li key={j} className="flex items-center gap-2 text-sm text-gray-300">
                            <Check className="w-4 h-4 text-green-400" /> {f}
                          </li>
                        ))}
                      </ul>
                      <button onClick={login} className={`w-full py-4 rounded-2xl font-bold transition ${plan.popular ? 'btn-primary' : 'bg-white/5 hover:bg-white/10'}`}>
                        ابدأ الاستثمار
                      </button>
                    </div>
                  ))}
                </div>
              </div>
            </section>
          </>
        )}

        {/* PLANS PAGE */}
        {page === 'plans' && (
          <section className="py-32 px-4">
            <div className="max-w-7xl mx-auto">
              <h1 className="text-5xl font-black text-center mb-16">
                <span className="text-white">خطط </span><span className="gold-text">الاستثمار</span>
              </h1>
              <div className="grid md:grid-cols-3 gap-8">
                {plans.map((plan, i) => (
                  <div key={i} className={`glass-card rounded-3xl p-8 ${plan.popular ? 'border-yellow-500/40' : ''}`}>
                    <div className="text-center mb-6">
                      <plan.icon className={`w-16 h-16 mx-auto mb-4 text-${plan.color}-400`} />
                      <h3 className="text-2xl font-bold">{plan.name}</h3>
                      <p className="text-gray-500">{plan.duration}</p>
                    </div>
                    <div className="text-center p-6 rounded-2xl bg-white/3 mb-6">
                      <div className="text-5xl font-black gold-text">{plan.daily}</div>
                      <div className="text-gray-400">عائد يومي</div>
                    </div>
                    <button onClick={login} className="w-full btn-primary py-4 rounded-2xl font-bold">استثمر الآن</button>
                  </div>
                ))}
              </div>
            </div>
          </section>
        )}

        {/* ABOUT PAGE */}
        {page === 'about' && (
          <section className="py-32 px-4">
            <div className="max-w-4xl mx-auto text-center">
              <h1 className="text-5xl font-black mb-8"><span className="gold-text">ZENITH</span> Africa</h1>
              <p className="text-xl text-gray-400 mb-12">المنصة الاستثمارية الرائدة في أفريقيا منذ 2020</p>
              <div className="grid md:grid-cols-4 gap-6 mb-12">
                {stats.map((s, i) => (
                  <div key={i} className="glass-card rounded-2xl p-6">
                    <div className="text-3xl font-black gold-text">{s.value}</div>
                    <div className="text-gray-500">{s.label}</div>
                  </div>
                ))}
              </div>
              <div className="glass-card rounded-2xl p-8">
                <h3 className="text-2xl font-bold mb-6">تواصل معنا</h3>
                <div className="flex flex-wrap justify-center gap-4">
                  <a href={`mailto:${LINKS.email}`} className="flex items-center gap-2 px-6 py-3 rounded-xl bg-red-500/10 text-red-400 hover:bg-red-500/20 transition">
                    <Mail className="w-5 h-5" /> {LINKS.email}
                  </a>
                  <a href={LINKS.telegram} target="_blank" className="flex items-center gap-2 px-6 py-3 rounded-xl bg-blue-500/10 text-blue-400 hover:bg-blue-500/20 transition">
                    <MessageCircle className="w-5 h-5" /> Telegram
                  </a>
                  <a href={LINKS.github} target="_blank" className="flex items-center gap-2 px-6 py-3 rounded-xl bg-gray-500/10 text-gray-400 hover:bg-gray-500/20 transition">
                    <Code2 className="w-5 h-5" /> GitHub
                  </a>
                </div>
              </div>
            </div>
          </section>
        )}

        {/* DASHBOARD */}
        {page === 'dashboard' && (
          <section className="py-32 px-4">
            <div className="max-w-7xl mx-auto">
              <div className="flex items-center justify-between mb-8">
                <div>
                  <h1 className="text-3xl font-black"><span className="text-white">مرحباً، </span><span className="gold-text">أحمد</span> 👋</h1>
                  <p className="text-gray-400">آخر دخول: اليوم 10:30 ص</p>
                </div>
                <button className="relative p-3 rounded-xl glass-card"><Bell className="w-5 h-5" /><span className="absolute -top-1 -right-1 w-5 h-5 bg-red-500 rounded-full text-xs flex items-center justify-center">3</span></button>
              </div>

              <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
                {[
                  { icon: Wallet, label: 'الرصيد', value: '$18,600', color: 'yellow' },
                  { icon: TrendingUp, label: 'الأرباح اليومية', value: '$160', color: 'green' },
                  { icon: DollarSign, label: 'المُستثمر', value: '$15,000', color: 'blue' },
                  { icon: BarChart3, label: 'إجمالي الأرباح', value: '$3,600', color: 'purple' },
                ].map((s, i) => (
                  <div key={i} className="glass-card rounded-2xl p-6">
                    <s.icon className={`w-8 h-8 text-${s.color}-400 mb-3`} />
                    <div className="text-2xl font-black">{s.value}</div>
                    <div className="text-sm text-gray-500">{s.label}</div>
                  </div>
                ))}
              </div>

              <div className="grid md:grid-cols-2 gap-6">
                <div className="glass-card rounded-2xl p-8">
                  <h3 className="text-xl font-bold mb-6 flex items-center gap-2"><Crown className="w-5 h-5 text-yellow-400" /> استثماراتك النشطة</h3>
                  <div className="space-y-4">
                    <div className="p-4 rounded-xl bg-white/3 border border-yellow-500/20">
                      <div className="flex justify-between mb-2">
                        <span className="font-bold">الخطة الذهبية</span>
                        <span className="text-green-400">نشط</span>
                      </div>
                      <div className="flex justify-between text-sm text-gray-400">
                        <span>$10,000</span>
                        <span>+$2,160 أرباح</span>
                      </div>
                      <div className="mt-3 h-2 rounded-full bg-white/10"><div className="h-full w-[60%] rounded-full gold-gradient"></div></div>
                    </div>
                    <div className="p-4 rounded-xl bg-white/3 border border-amber-500/20">
                      <div className="flex justify-between mb-2">
                        <span className="font-bold">الخطة البرونزية</span>
                        <span className="text-green-400">نشط</span>
                      </div>
                      <div className="flex justify-between text-sm text-gray-400">
                        <span>$5,000</span>
                        <span>+$600 أرباح</span>
                      </div>
                      <div className="mt-3 h-2 rounded-full bg-white/10"><div className="h-full w-[75%] rounded-full bg-amber-500"></div></div>
                    </div>
                  </div>
                </div>

                <div className="glass-card rounded-2xl p-8">
                  <h3 className="text-xl font-bold mb-6">إجراءات سريعة</h3>
                  <div className="space-y-3">
                    <button className="w-full flex items-center gap-3 p-4 rounded-xl bg-green-500/10 border border-green-500/20 text-green-400 font-semibold hover:bg-green-500/20 transition">
                      <ArrowDownRight className="w-5 h-5" /> إيداع أموال
                    </button>
                    <button className="w-full flex items-center gap-3 p-4 rounded-xl bg-blue-500/10 border border-blue-500/20 text-blue-400 font-semibold hover:bg-blue-500/20 transition">
                      <ArrowUpRight className="w-5 h-5" /> سحب أرباح
                    </button>
                    <button onClick={() => setPage('plans')} className="w-full flex items-center gap-3 p-4 rounded-xl bg-yellow-500/10 border border-yellow-500/20 text-yellow-400 font-semibold hover:bg-yellow-500/20 transition">
                      <TrendingUp className="w-5 h-5" /> استثمار جديد
                    </button>
                    <button className="w-full flex items-center gap-3 p-4 rounded-xl bg-purple-500/10 border border-purple-500/20 text-purple-400 font-semibold hover:bg-purple-500/20 transition">
                      <Gift className="w-5 h-5" /> دعوة أصدقاء (كود: ZENITH-AHM)
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </section>
        )}
      </main>

      {/* Footer */}
      <footer className="border-t border-white/5 py-12 px-4">
        <div className="max-w-7xl mx-auto">
          <div className="flex flex-col md:flex-row items-center justify-between gap-6 mb-8">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-xl gold-gradient flex items-center justify-center">
                <Zap className="w-6 h-6 text-[#0a0a0f]" />
              </div>
              <span className="text-xl font-black gold-text">ZENITH</span>
            </div>
            <div className="flex flex-wrap gap-4">
              <a href={`mailto:${LINKS.email}`} className="flex items-center gap-2 text-gray-400 hover:text-yellow-400 transition">
                <Mail className="w-4 h-4" /> {LINKS.email}
              </a>
              <a href={LINKS.telegram} target="_blank" className="flex items-center gap-2 text-gray-400 hover:text-yellow-400 transition">
                <MessageCircle className="w-4 h-4" /> Telegram
              </a>
              <a href={LINKS.github} target="_blank" className="flex items-center gap-2 text-gray-400 hover:text-yellow-400 transition">
                <Code2 className="w-4 h-4" /> GitHub
              </a>
            </div>
          </div>
          <div className="text-center text-gray-500 text-sm">
            © 2024 ZENITH Africa. جميع الحقوق محفوظة. صُنع بـ ❤️ من أجل أفريقيا
          </div>
        </div>
      </footer>
    </div>
  );
}
APPEOF

echo "✅ تم إنشاء جميع الملفات!"
echo ""
echo "📦 جاري تثبيت المكتبات..."
npm install

echo ""
echo "🎉 تم الإعداد بنجاح!"
echo ""
echo "🚀 لتشغيل المشروع: npm run dev"
echo "📦 للبناء: npm run build"
