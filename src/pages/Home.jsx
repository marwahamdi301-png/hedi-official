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
