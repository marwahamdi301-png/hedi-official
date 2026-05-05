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
