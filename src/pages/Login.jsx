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
