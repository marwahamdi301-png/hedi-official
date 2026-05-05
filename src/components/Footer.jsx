import { Zap, Mail, MessageCircle, Code2, ExternalLink } from "lucide-react";
import { motion } from "framer-motion";

const LINKS = {
  email: "marwahamdi301@gmail.com",
  telegram: "https://wjslyrr.streamlit.app",
  github: "https://github.com/marwahamdi301-png/hedi-official",
  site: "https://zenith-africa.vercel.app"
};

export default function Footer() {
  return (
    <footer className="border-t border-white/5 py-16 px-4 bg-[#0a0a0f]">
      <div className="max-w-7xl mx-auto">
        <div className="grid md:grid-cols-4 gap-12 mb-12">
          {/* Brand */}
          <div>
            <div className="flex items-center gap-3 mb-4">
              <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-yellow-400 to-yellow-600 flex items-center justify-center">
                <Zap className="w-6 h-6 text-black" />
              </div>
              <span className="text-xl font-black bg-gradient-to-r from-yellow-400 to-yellow-200 bg-clip-text text-transparent">ZENITH</span>
            </div>
            <p className="text-gray-400 text-sm">المنصة الاستثمارية الرائدة في أفريقيا مع عوائد يومية مضمونة</p>
          </div>

          {/* Quick Links */}
          <div>
            <h4 className="text-white font-bold mb-4">روابط سريعة</h4>
            <ul className="space-y-2 text-gray-400 text-sm">
              <li><a href="/" className="hover:text-yellow-400 transition">الرئيسية</a></li>
              <li><a href="/dashboard" className="hover:text-yellow-400 transition">لوحة التحكم</a></li>
              <li><a href="/invest" className="hover:text-yellow-400 transition">خطط الاستثمار</a></li>
              <li><a href="/deposit" className="hover:text-yellow-400 transition">إيداع</a></li>
            </ul>
          </div>

          {/* Contact */}
          <div>
            <h4 className="text-white font-bold mb-4">تواصل معنا</h4>
            <ul className="space-y-3">
              <li>
                <motion.a 
                  href={"mailto:" + LINKS.email}
                  whileHover={{ x: 5 }}
                  className="flex items-center gap-2 text-gray-400 hover:text-yellow-400 transition text-sm"
                >
                  <Mail className="w-4 h-4" /> {LINKS.email}
                </motion.a>
              </li>
              <li>
                <motion.a 
                  href={LINKS.telegram}
                  target="_blank"
                  rel="noreferrer"
                  whileHover={{ x: 5 }}
                  className="flex items-center gap-2 text-gray-400 hover:text-yellow-400 transition text-sm"
                >
                  <MessageCircle className="w-4 h-4" /> Telegram <ExternalLink className="w-3 h-3" />
                </motion.a>
              </li>
              <li>
                <motion.a 
                  href={LINKS.github}
                  target="_blank"
                  rel="noreferrer"
                  whileHover={{ x: 5 }}
                  className="flex items-center gap-2 text-gray-400 hover:text-yellow-400 transition text-sm"
                >
                  <Code2 className="w-4 h-4" /> GitHub <ExternalLink className="w-3 h-3" />
                </motion.a>
              </li>
            </ul>
          </div>

          {/* Stats */}
          <div>
            <h4 className="text-white font-bold mb-4">إحصائيات</h4>
            <div className="space-y-2 text-sm">
              <div className="flex justify-between"><span className="text-gray-400">المستثمرين</span><span className="text-yellow-400 font-bold">25,000+</span></div>
              <div className="flex justify-between"><span className="text-gray-400">إجمالي الإيداعات</span><span className="text-yellow-400 font-bold">$5.2M+</span></div>
              <div className="flex justify-between"><span className="text-gray-400">الأرباح الموزعة</span><span className="text-green-400 font-bold">$1.8M+</span></div>
              <div className="flex justify-between"><span className="text-gray-400">الدول</span><span className="text-yellow-400 font-bold">35+</span></div>
            </div>
          </div>
        </div>

        <div className="border-t border-white/5 pt-8 flex flex-col md:flex-row items-center justify-between gap-4">
          <p className="text-gray-500 text-sm">© 2024 ZENITH Africa. جميع الحقوق محفوظة ❤️</p>
          <div className="flex gap-4">
            <a href={"mailto:" + LINKS.email} className="w-10 h-10 rounded-xl bg-white/5 flex items-center justify-center text-gray-400 hover:text-yellow-400 hover:bg-yellow-500/10 transition">
              <Mail className="w-5 h-5" />
            </a>
            <a href={LINKS.telegram} target="_blank" rel="noreferrer" className="w-10 h-10 rounded-xl bg-white/5 flex items-center justify-center text-gray-400 hover:text-yellow-400 hover:bg-yellow-500/10 transition">
              <MessageCircle className="w-5 h-5" />
            </a>
            <a href={LINKS.github} target="_blank" rel="noreferrer" className="w-10 h-10 rounded-xl bg-white/5 flex items-center justify-center text-gray-400 hover:text-yellow-400 hover:bg-yellow-500/10 transition">
              <Code2 className="w-5 h-5" />
            </a>
          </div>
        </div>
      </div>
    </footer>
  );
}
