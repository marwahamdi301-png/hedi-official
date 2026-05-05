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
