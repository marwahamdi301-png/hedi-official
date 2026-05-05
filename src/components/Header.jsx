import { Link, useNavigate } from "react-router-dom";
import { motion } from "framer-motion";
import { Zap, LogOut, LayoutDashboard, Menu, X } from "lucide-react";
import { useState } from "react";
import { useAuth } from "../context/AuthContext";
import { signOut } from "../lib/supabase";
import toast from "react-hot-toast";

export default function Header() {
  const { user } = useAuth();
  const navigate = useNavigate();
  const [menuOpen, setMenuOpen] = useState(false);

  const handleLogout = async () => {
    await signOut();
    toast.success("تم تسجيل الخروج");
    navigate("/");
  };

  return (
    <header className="fixed top-0 left-0 right-0 z-50 bg-[#0a0a0f]/90 backdrop-blur-xl border-b border-white/5">
      <div className="max-w-7xl mx-auto px-4 h-20 flex items-center justify-between">
        <Link to="/" className="flex items-center gap-3">
          <motion.div 
            whileHover={{ scale: 1.05, rotate: 5 }}
            className="w-12 h-12 rounded-xl bg-gradient-to-br from-yellow-400 to-yellow-600 flex items-center justify-center"
          >
            <Zap className="w-7 h-7 text-black" />
          </motion.div>
          <div>
            <span className="text-xl font-black bg-gradient-to-r from-yellow-400 to-yellow-200 bg-clip-text text-transparent">ZENITH</span>
            <span className="block text-[10px] text-yellow-500/60 tracking-widest">AFRICA</span>
          </div>
        </Link>

        {/* Desktop Nav */}
        <nav className="hidden md:flex items-center gap-4">
          {user ? (
            <>
              <Link to="/dashboard" className="flex items-center gap-2 px-5 py-2 rounded-xl bg-yellow-500/10 text-yellow-400 font-semibold hover:bg-yellow-500/20 transition">
                <LayoutDashboard className="w-4 h-4" /> لوحة التحكم
              </Link>
              <button onClick={handleLogout} className="flex items-center gap-2 px-5 py-2 rounded-xl text-red-400 hover:bg-red-500/10 transition">
                <LogOut className="w-4 h-4" /> خروج
              </button>
            </>
          ) : (
            <>
              <Link to="/login" className="px-5 py-2 text-gray-400 hover:text-white transition">دخول</Link>
              <Link to="/register" className="px-6 py-2 rounded-xl bg-gradient-to-r from-yellow-500 to-yellow-600 text-black font-bold hover:shadow-lg hover:shadow-yellow-500/30 transition">
                ابدأ الآن
              </Link>
            </>
          )}
        </nav>

        {/* Mobile Menu Button */}
        <button onClick={() => setMenuOpen(!menuOpen)} className="md:hidden p-2 text-gray-400">
          {menuOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
        </button>
      </div>

      {/* Mobile Menu */}
      {menuOpen && (
        <motion.div 
          initial={{ opacity: 0, y: -10 }}
          animate={{ opacity: 1, y: 0 }}
          className="md:hidden bg-[#0a0a0f] border-t border-white/5 px-4 py-4"
        >
          {user ? (
            <div className="space-y-2">
              <Link to="/dashboard" onClick={() => setMenuOpen(false)} className="block w-full text-center py-3 rounded-xl bg-yellow-500/10 text-yellow-400 font-semibold">
                لوحة التحكم
              </Link>
              <button onClick={() => { handleLogout(); setMenuOpen(false); }} className="block w-full text-center py-3 rounded-xl text-red-400">
                خروج
              </button>
            </div>
          ) : (
            <div className="space-y-2">
              <Link to="/login" onClick={() => setMenuOpen(false)} className="block w-full text-center py-3 text-gray-400">دخول</Link>
              <Link to="/register" onClick={() => setMenuOpen(false)} className="block w-full text-center py-3 rounded-xl bg-yellow-500 text-black font-bold">ابدأ الآن</Link>
            </div>
          )}
        </motion.div>
      )}
    </header>
  );
}
