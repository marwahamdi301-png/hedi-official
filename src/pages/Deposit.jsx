import { useState } from "react";
import { motion } from "framer-motion";
import { Copy, CheckCircle, AlertCircle, ArrowLeft } from "lucide-react";
import { Link } from "react-router-dom";
import { WALLETS } from "../lib/wallets";
import Header from "../components/Header";
import Footer from "../components/Footer";
import PageTransition from "../components/PageTransition";
import toast from "react-hot-toast";

export default function Deposit() {
  const [selected, setSelected] = useState("USDT_TRC20");
  const [amount, setAmount] = useState("");
  const [txHash, setTxHash] = useState("");
  const [copied, setCopied] = useState(false);
  const [submitted, setSubmitted] = useState(false);

  const wallet = WALLETS[selected];

  const copyAddress = () => {
    navigator.clipboard.writeText(wallet.address);
    setCopied(true);
    toast.success("تم نسخ العنوان");
    setTimeout(() => setCopied(false), 2000);
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    if (!amount || !txHash) {
      toast.error("يرجى ملء جميع الحقول");
      return;
    }
    setSubmitted(true);
    toast.success("تم إرسال طلب الإيداع للمراجعة");
  };

  return (
    <PageTransition>
      <div className="min-h-screen bg-[#0a0a0f] text-white">
        <Header />
        
        <main className="pt-28 pb-16 px-4">
          <div className="max-w-2xl mx-auto">
            <Link to="/dashboard" className="inline-flex items-center gap-2 text-gray-400 hover:text-yellow-400 mb-6 transition">
              <ArrowLeft className="w-4 h-4" /> رجوع للوحة التحكم
            </Link>

            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              className="bg-white/5 backdrop-blur-xl border border-white/10 rounded-3xl p-8"
            >
              <h1 className="text-2xl font-bold mb-2">💰 إيداع أموال</h1>
              <p className="text-gray-400 text-sm mb-8">اختر العملة وأرسل المبلغ للعنوان التالي</p>

              {!submitted ? (
                <>
                  {/* Crypto Selection */}
                  <div className="grid grid-cols-2 gap-3 mb-8">
                    {Object.entries(WALLETS).map(([key, w]) => (
                      <button
                        key={key}
                        onClick={() => setSelected(key)}
                        className={`p-4 rounded-xl border text-right transition ${
                          selected === key 
                            ? "bg-yellow-500/10 border-yellow-500/50" 
                            : "bg-white/5 border-white/10 hover:border-white/20"
                        }`}
                      >
                        <span className="text-2xl">{w.icon}</span>
                        <div className="font-semibold mt-1">{w.name}</div>
                        <div className="text-xs text-gray-500">الحد الأدنى: ${w.minDeposit}</div>
                      </button>
                    ))}
                  </div>

                  {/* Wallet Address */}
                  <div className="mb-6">
                    <label className="text-sm text-gray-400 mb-2 block">عنوان المحفظة ({wallet.network})</label>
                    <div className="flex gap-2">
                      <input
                        type="text"
                        value={wallet.address}
                        readOnly
                        className="flex-1 bg-white/5 border border-white/10 rounded-xl py-3 px-4 text-sm text-gray-300 font-mono"
                        dir="ltr"
                      />
                      <button
                        onClick={copyAddress}
                        className={`px-4 rounded-xl transition ${copied ? "bg-green-500/20 text-green-400" : "bg-yellow-500/10 text-yellow-400 hover:bg-yellow-500/20"}`}
                      >
                        {copied ? <CheckCircle className="w-5 h-5" /> : <Copy className="w-5 h-5" />}
                      </button>
                    </div>
                  </div>

                  {/* Amount */}
                  <div className="mb-6">
                    <label className="text-sm text-gray-400 mb-2 block">المبلغ المُرسل ($)</label>
                    <input
                      type="number"
                      value={amount}
                      onChange={(e) => setAmount(e.target.value)}
                      className="w-full bg-white/5 border border-white/10 rounded-xl py-3 px-4 text-white focus:border-yellow-500/50 focus:outline-none"
                      placeholder={`الحد الأدنى: $${wallet.minDeposit}`}
                      min={wallet.minDeposit}
                    />
                  </div>

                  {/* TX Hash */}
                  <div className="mb-8">
                    <label className="text-sm text-gray-400 mb-2 block">رقم المعاملة (TX Hash)</label>
                    <input
                      type="text"
                      value={txHash}
                      onChange={(e) => setTxHash(e.target.value)}
                      className="w-full bg-white/5 border border-white/10 rounded-xl py-3 px-4 text-white font-mono text-sm focus:border-yellow-500/50 focus:outline-none"
                      placeholder="0x..."
                      dir="ltr"
                    />
                  </div>

                  {/* Warning */}
                  <div className="flex items-start gap-3 p-4 rounded-xl bg-yellow-500/10 border border-yellow-500/20 mb-6">
                    <AlertCircle className="w-5 h-5 text-yellow-400 flex-shrink-0 mt-0.5" />
                    <div className="text-sm text-yellow-400/80">
                      <strong>تنبيه:</strong> تأكد من إرسال العملة الصحيحة للشبكة الصحيحة ({wallet.network}). الإرسال الخاطئ قد يؤدي لفقدان الأموال.
                    </div>
                  </div>

                  <button
                    onClick={handleSubmit}
                    className="w-full py-4 rounded-xl bg-gradient-to-r from-yellow-500 to-yellow-600 text-black font-bold hover:shadow-lg hover:shadow-yellow-500/30 transition"
                  >
                    ✅ تأكيد الإيداع
                  </button>
                </>
              ) : (
                <div className="text-center py-12">
                  <div className="w-20 h-20 mx-auto mb-6 rounded-full bg-green-500/20 flex items-center justify-center">
                    <CheckCircle className="w-10 h-10 text-green-400" />
                  </div>
                  <h2 className="text-2xl font-bold mb-2">تم استلام طلبك!</h2>
                  <p className="text-gray-400 mb-6">سيتم مراجعة الإيداع وإضافته لحسابك خلال 10-30 دقيقة</p>
                  <Link to="/dashboard" className="inline-block px-8 py-3 rounded-xl bg-white/10 hover:bg-white/20 transition">
                    رجوع للوحة التحكم
                  </Link>
                </div>
              )}
            </motion.div>
          </div>
        </main>

        <Footer />
      </div>
    </PageTransition>
  );
}
