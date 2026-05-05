'use client';

import Link from 'next/link';
import { useState, useEffect } from 'react';
import { TrendingUp, Lock, Zap, Award, BarChart3, Users, ArrowRight, CheckCircle2, Wallet, BarChart, PieChart, LineChart } from 'lucide-react';

export default function Home() {
  const [zenPrice, setZenPrice] = useState(2.45);
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  const investmentPlans = [
    {
      name: 'بدء العمل',
      minAmount: 100,
      dailyReturn: 0.8,
      monthlyReturn: 24,
      annualReturn: 288,
      features: ['الحد الأدنى $100', 'عائد يومي 0.8%', 'دعم أساسي 24/7', 'تقارير شهرية'],
    },
    {
      name: 'احترافي',
      minAmount: 1000,
      dailyReturn: 1.2,
      monthlyReturn: 36,
      annualReturn: 432,
      featured: true,
      features: ['الحد الأدنى $1,000', 'عائد يومي 1.2%', 'دعم أولويات', 'تقارير أسبوعية', 'استشارات مجانية'],
    },
    {
      name: 'إلايت',
      minAmount: 10000,
      dailyReturn: 1.5,
      monthlyReturn: 45,
      annualReturn: 540,
      features: ['الحد الأدنى $10,000', 'عائد يومي 1.5%', 'دعم VIP 24/7', 'تقارير يومية', 'مدير حساب شخصي'],
    },
  ];

  if (!mounted) return null;

  return (
    <main className="min-h-screen overflow-hidden pt-20 pb-20">
      {/* ═══════════════════════════════════════════════════════════
          HERO SECTION
          ═══════════════════════════════════════════════════════════ */}
      <section className="relative min-h-screen flex items-center justify-center px-4 sm:px-6 lg:px-8">
        <div className="relative z-10 max-w-6xl mx-auto text-center animate-slide-down">
          {/* Badge */}
          <div className="inline-block mb-6 px-4 py-2 rounded-full border border-amber-500/40 bg-amber-500/10 backdrop-blur">
            <p className="text-sm font-semibold text-amber-300">🚀 أضخم منصة استثمارية في أفريقيا</p>
          </div>

          {/* Main Heading */}
          <h1 className="text-5xl sm:text-6xl lg:text-7xl font-black mb-6 leading-tight">
            <span className="block text-white">اجعل أموالك</span>
            <span className="block text-gradient text-5xl sm:text-6xl lg:text-7xl mt-2">
              تعمل من أجلك
            </span>
          </h1>

          {/* Subheading */}
          <p className="text-lg sm:text-xl text-gray-300 max-w-3xl mx-auto mb-12">
            منصة استثمارية عالمية توفر عوائد حقيقية شهرية بأمان كامل وشفافية تامة برعاية عملة ZEN
          </p>

          {/* CTA Buttons */}
          <div className="flex flex-col sm:flex-row gap-4 justify-center mb-16">
            <Link href="/dashboard">
              <button className="luxury-button flex items-center justify-center gap-2 w-full sm:w-auto">
                ابدأ الآن <ArrowRight className="w-5 h-5" />
              </button>
            </Link>
            <button className="luxury-button-outline w-full sm:w-auto">
              تعرف أكثر على ZEN
            </button>
          </div>

          {/* Stats Grid */}
          <div className="grid grid-cols-2 lg:grid-cols-4 gap-3 sm:gap-4">
            {[
              { label: 'مستثمرين نشط', value: '25,432', icon: Users },
              { label: 'أموال مدارة', value: '$5.2M', icon: Wallet },
              { label: 'متوسط العائد', value: '24%', icon: TrendingUp },
              { label: 'دول مشاركة', value: '156', icon: BarChart },
            ].map((stat, idx) => {
              const Icon = stat.icon;
              return (
                <div key={idx} className="luxury-card group">
                  <div className="flex items-center justify-between gap-3">
                    <div>
                      <div className="text-2xl sm:text-3xl font-black text-amber-400 group-hover:text-amber-300">
                        {stat.value}
                      </div>
                      <p className="text-xs sm:text-sm text-gray-400 mt-1">{stat.label}</p>
                    </div>
                    <Icon className="w-8 h-8 sm:w-10 sm:h-10 text-amber-500/30 group-hover:text-amber-500/60" />
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      </section>

      {/* ═══════════════════════════════════════════════════════════
          ZEN TOKEN LUXURY CARD SECTION
          ═══════════════════════════════════════════════════════════ */}
      <section className="py-16 sm:py-20 px-4 sm:px-6 lg:px-8">
        <div className="max-w-5xl mx-auto">
          <div className="luxury-card border-2 border-amber-400/50 shadow-2xl shadow-amber-500/30">
            <div className="grid md:grid-cols-2 gap-8 items-center">
              {/* Left Content */}
              <div className="text-center md:text-right">
                <div className="inline-block mb-4 px-4 py-2 rounded-full bg-amber-500/20 border border-amber-500/40">
                  <span className="text-sm font-bold text-amber-300">💎 عملة الدرجة الأولى</span>
                </div>
                <h2 className="text-4xl sm:text-5xl font-black mb-4">
                  <span className="text-gradient">عملة ZEN</span>
                </h2>
                <p className="text-gray-300 mb-8 leading-relaxed">
                  العملة الأصلية لمنصة ZENITH Africa المدعومة بتكنولوجيا البلوكتشين والمسجلة في 156 دولة
                </p>
                
                {/* Price Cards */}
                <div className="grid grid-cols-2 gap-4 mb-8">
                  <div className="bg-slate-900/80 rounded-xl p-4 border border-amber-500/20 hover:border-amber-500/50 transition-all">
                    <p className="text-gray-400 text-xs mb-1">السعر الحالي</p>
                    <p className="text-3xl font-black text-amber-400">${zenPrice}</p>
                    <p className="text-xs text-amber-300 mt-1">USD</p>
                  </div>
                  <div className="bg-slate-900/80 rounded-xl p-4 border border-green-500/20 hover:border-green-500/50 transition-all">
                    <p className="text-gray-400 text-xs mb-1">التغيير (24h)</p>
                    <p className="text-3xl font-black text-green-400">+12.5%</p>
                    <p className="text-xs text-green-300 mt-1">📈 صعود</p>
                  </div>
                </div>

                {/* Action Button */}
                <button className="w-full luxury-button">
                  اشتري ZEN الآن
                </button>
              </div>

              {/* Right Visual */}
              <div className="flex flex-col items-center justify-center">
                <div className="relative w-40 h-40 sm:w-56 sm:h-56">
                  {/* Outer Circle */}
                  <div className="absolute inset-0 bg-gradient-to-br from-amber-500 to-yellow-600 rounded-full blur-2xl opacity-30 animate-pulse" />
                  
                  {/* Main Circle */}
                  <div className="absolute inset-8 bg-gradient-to-br from-amber-400 to-yellow-500 rounded-full flex items-center justify-center shadow-2xl shadow-amber-500/50 animate-float">
                    <div className="text-7xl sm:text-8xl">💰</div>
                  </div>
                  
                  {/* Inner Circle */}
                  <div className="absolute inset-12 bg-gradient-to-t from-amber-600 to-amber-400 rounded-full opacity-30 blur-xl" />
                </div>
                
                {/* Stats Below */}
                <div className="mt-12 space-y-2 text-center">
                  <p className="text-sm text-gray-400">رأس المال السوقي</p>
                  <p className="text-2xl font-black text-amber-400">$125.6M</p>
                  <p className="text-xs text-gray-500">متزايد بنسبة 15% شهرياً</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* ═══════════════════════════════════════════════════════════
          FEATURES SECTION
          ═══════════════════════════════════════════════════════════ */}
      <section className="py-16 sm:py-20 px-4 sm:px-6 lg:px-8">
        <div className="max-w-6xl mx-auto">
          <h2 className="text-4xl sm:text-5xl font-black mb-12 text-center">
            <span className="text-white">لماذا تختار</span>
            <br />
            <span className="text-gradient">ZENITH Africa؟</span>
          </h2>

          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
            {[
              { icon: Lock, title: 'أمان بلا مثيل', desc: 'تشفير عسكري وحماية كاملة للبيانات والمحفظة' },
              { icon: TrendingUp, title: 'عوائد عالية', desc: 'من 24% إلى 540% سنوياً مع ضمان أرباح يومية' },
              { icon: Zap, title: 'سحب فوري', desc: 'أرباحك بين يديك خلال دقائق بدون رسوم إضافية' },
              { icon: Award, title: 'معترف به دولياً', desc: 'مسجل ومرخص في 156 دولة بجميع المعايير الدولية' },
              { icon: Users, title: 'برنامج إحالة', desc: 'اربح 10% من كل استثمار لصديقك دون حد أقصى' },
              { icon: BarChart3, title: 'تحليلات حية', desc: 'لوحة تحكم متقدمة وتقارير فورية وفصلية مفصلة' },
            ].map((feature, idx) => {
              const Icon = feature.icon;
              return (
                <div key={idx} className="luxury-card hover:scale-105 transform">
                  <div className="w-14 h-14 rounded-xl bg-gradient-to-br from-amber-500 to-yellow-500 flex items-center justify-center mb-4 shadow-lg shadow-amber-500/30">
                    <Icon className="w-7 h-7 text-white" />
                  </div>
                  <h3 className="text-xl font-bold text-white mb-2">{feature.title}</h3>
                  <p className="text-gray-400 text-sm leading-relaxed">{feature.desc}</p>
                </div>
              );
            })}
          </div>
        </div>
      </section>

      {/* ═══════════════════════════════════════════════════════════
          INVESTMENT PLANS SECTION
          ═══════════════════════════════════════════════════════════ */}
      <section className="py-16 sm:py-20 px-4 sm:px-6 lg:px-8">
        <div className="max-w-6xl mx-auto">
          <h2 className="text-4xl sm:text-5xl font-black mb-12 text-center">
            <span className="text-white">خطط</span>
            <br />
            <span className="text-gradient">الاستثمار الذكية</span>
          </h2>

          <div className="grid md:grid-cols-3 gap-6 lg:gap-8">
            {investmentPlans.map((plan, idx) => (
              <div
                key={idx}
                className={`relative group ${plan.featured ? 'md:scale-105 md:col-start-2' : ''}`}
              >
                {plan.featured && (
                  <div className="absolute -top-4 left-1/2 transform -translate-x-1/2 z-20">
                    <div className="px-6 py-1.5 bg-gradient-to-r from-amber-500 to-yellow-500 rounded-full shadow-lg shadow-amber-500/50">
                      <p className="text-xs sm:text-sm font-bold text-white">⭐ الخطة الأكثر رواجاً</p>
                    </div>
                  </div>
                )}

                <div className={`luxury-card h-full transition-all ${
                  plan.featured ? 'border-2 border-amber-400 shadow-2xl shadow-amber-500/40' : 'border-2 border-amber-500/30'
                }`}>
                  <h3 className="text-2xl sm:text-3xl font-black text-white mb-4">{plan.name}</h3>

                  <div className="mb-6 pb-6 border-b border-amber-500/20">
                    <div className="text-5xl font-black bg-gradient-to-r from-amber-400 to-yellow-400 bg-clip-text text-transparent mb-4">
                      ${plan.minAmount}
                    </div>
                    <div className="space-y-3">
                      <div className="flex justify-between items-center bg-slate-800/50 rounded-lg p-3">
                        <span className="text-gray-400 text-sm">عائد يومي</span>
                        <span className="text-amber-400 font-black text-lg">{plan.dailyReturn}%</span>
                      </div>
                      <div className="flex justify-between items-center bg-slate-800/50 rounded-lg p-3">
                        <span className="text-gray-400 text-sm">عائد شهري</span>
                        <span className="text-amber-400 font-black text-lg">{plan.monthlyReturn}%</span>
                      </div>
                      <div className="flex justify-between items-center bg-slate-800/50 rounded-lg p-3">
                        <span className="text-gray-400 text-sm">عائد سنوي</span>
                        <span className="text-amber-400 font-black text-lg">{plan.annualReturn}%</span>
                      </div>
                    </div>
                  </div>

                  <div className="mb-8 space-y-3">
                    {plan.features.map((feature, fidx) => (
                      <div key={fidx} className="flex items-start gap-3">
                        <CheckCircle2 className="w-5 h-5 text-amber-400 flex-shrink-0 mt-0.5" />
                        <span className="text-gray-300 text-sm">{feature}</span>
                      </div>
                    ))}
                  </div>

                  <button className={`w-full py-3 px-6 font-bold rounded-lg transition-all transform hover:scale-105 ${
                    plan.featured
                      ? 'bg-gradient-to-r from-amber-500 to-yellow-500 text-white hover:shadow-lg hover:shadow-amber-500/50'
                      : 'border-2 border-amber-500/50 text-amber-400 hover:bg-amber-500/10'
                  }`}>
                    اختر هذه الخطة الآن
                  </button>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ═══════════════════════════════════════════════════════════
          TESTIMONIALS SECTION
          ═══════════════════════════════════════════════════════════ */}
      <section className="py-16 sm:py-20 px-4 sm:px-6 lg:px-8">
        <div className="max-w-6xl mx-auto">
          <h2 className="text-4xl sm:text-5xl font-black mb-12 text-center">
            <span className="text-white">قصص نجاح</span>
            <br />
            <span className="text-gradient">مستثمرينا</span>
          </h2>

          <div className="grid md:grid-cols-3 gap-6">
            {[
              { name: 'أحمد محمد', country: 'مصر', profit: '+$2,400', text: 'استثمرت $5,000 وحصلت على أرباح تفاقت التوقعات' },
              { name: 'فاطمة علي', country: 'السودان', profit: '+$1,850', text: 'أفضل استثمار قمت به! الفريق احترافي جداً' },
              { name: 'محمود خالد', country: 'الجزائر', profit: '+$3,120', text: 'الشفافية والأمان جعلت الاستثمار أكثر راحة' },
            ].map((testimonial, idx) => (
              <div key={idx} className="luxury-card">
                <div className="flex items-start justify-between mb-4">
                  <div>
                    <h4 className="text-lg font-bold text-white">{testimonial.name}</h4>
                    <p className="text-sm text-gray-400">{testimonial.country}</p>
                  </div>
                  <div className="text-4xl">😊</div>
                </div>
                <p className="text-gray-300 text-sm mb-4">{testimonial.text}</p>
                <p className="text-green-400 font-bold pt-4 border-t border-amber-500/20">
                  الأرباح: {testimonial.profit}
                </p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ═══════════════════════════════════════════════════════════
          FINAL CTA SECTION
          ═══════════════════════════════════════════════════════════ */}
      <section className="py-16 sm:py-20 px-4 sm:px-6 lg:px-8">
        <div className="max-w-4xl mx-auto luxury-card border-2 border-amber-400/50">
          <h2 className="text-4xl sm:text-5xl font-black mb-6 text-center">
            <span className="text-white">جاهز لتحقيق</span>
            <br />
            <span className="text-gradient">أحلامك المالية؟</span>
          </h2>
          <p className="text-lg text-gray-300 mb-8 text-center max-w-2xl mx-auto">
            انضم إلى 25,432 مستثمراً حقق أهدافهم المالية مع ZENITH Africa اليوم
          </p>
          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <Link href="/dashboard">
              <button className="luxury-button">
                افتح حسابك الآن - مجاني 100%
              </button>
            </Link>
            <button className="luxury-button-outline">
              اطلب استشارة مجانية
            </button>
          </div>
          <p className="text-gray-500 text-sm mt-8 text-center border-t border-amber-500/20 pt-6">
            ⚠️ تذكير: الاستثمار ينطوي على مخاطر. يرجى قراءة شروط الخدمة والإفصاحات قبل الاستثمار
          </p>
        </div>
      </section>
    </main>
  );
}
