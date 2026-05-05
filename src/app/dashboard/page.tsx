'use client';

import { TrendingUp, Wallet, DollarSign, Eye, EyeOff, BarChart3, PieChart, ArrowUpRight } from 'lucide-react';
import { useState } from 'react';
import Link from 'next/link';

export default function Dashboard() {
  const [showBalance, setShowBalance] = useState(true);

  // بيانات المستخدم من Prisma
  const userData = {
    name: 'أحمد محمد',
    email: 'ahmed@zenith.com',
    zenBalance: 1500,
    totalInvested: 15000,
    totalProfit: 3600,
    currentBalance: 18600,
    roi: 24,
    dailyProfit: 160,
    investmentTier: 'PROFESSIONAL',
  };

  const investments = [
    { id: 1, tier: 'احترافي', amount: 10000, dailyReturn: 120, totalReturn: 2400, status: 'ACTIVE' },
    { id: 2, tier: 'بدء العمل', amount: 5000, dailyReturn: 40, totalReturn: 1200, status: 'ACTIVE' },
  ];

  return (
    <main className="min-h-screen pt-20 pb-20 px-4 sm:px-6 lg:px-8 bg-gradient-to-br from-slate-950 via-slate-900 to-black">
      <div className="max-w-7xl mx-auto">
        {/* Header */}
        <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 mb-8">
          <div>
            <h1 className="text-5xl font-black mb-2">
              مرحباً، <span className="text-gradient">{userData.name}</span>
            </h1>
            <p className="text-gray-400">لوحة تحكم المستثمرين - متابعة استثماراتك بسهولة</p>
          </div>
          <Link href="/">
            <button className="px-6 py-2 text-amber-400 border border-amber-500/50 rounded-lg hover:bg-amber-500/10 transition-all">
              العودة للرئيسية
            </button>
          </Link>
        </div>

        {/* Main Stats */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
          {/* Total Balance */}
          <div className="luxury-card">
            <div className="flex justify-between items-start mb-4">
              <div>
                <p className="text-gray-400 text-sm mb-2">الرصيد الكلي</p>
                <button onClick={() => setShowBalance(!showBalance)} className="text-3xl font-black hover:opacity-80">
                  {showBalance ? `$${userData.currentBalance}` : '••••••'}
                </button>
              </div>
              <button onClick={() => setShowBalance(!showBalance)}>
                {showBalance ? <Eye className="w-5 h-5 text-amber-400" /> : <EyeOff className="w-5 h-5 text-amber-400" />}
              </button>
            </div>
            <p className="text-amber-400 text-sm">+${userData.totalProfit} أرباح</p>
          </div>

          {/* Daily Profit */}
          <div className="luxury-card">
            <div className="flex justify-between items-start mb-4">
              <div>
                <p className="text-gray-400 text-sm mb-2">الأرباح اليومية</p>
                <p className="text-3xl font-black text-green-400">${userData.dailyProfit}</p>
              </div>
              <TrendingUp className="w-8 h-8 text-green-400 opacity-50" />
            </div>
            <p className="text-gray-400 text-xs">متوسط يومي مستقر</p>
          </div>

          {/* Total Invested */}
          <div className="luxury-card">
            <div className="flex justify-between items-start mb-4">
              <div>
                <p className="text-gray-400 text-sm mb-2">إجمالي الاستثمار</p>
                <p className="text-3xl font-black">${userData.totalInvested}</p>
              </div>
              <DollarSign className="w-8 h-8 text-amber-400 opacity-50" />
            </div>
            <p className="text-amber-400 text-sm">عبر {investments.length} استثمار نشط</p>
          </div>

          {/* ROI */}
          <div className="luxury-card">
            <div className="flex justify-between items-start mb-4">
              <div>
                <p className="text-gray-400 text-sm mb-2">معدل العائد</p>
                <p className="text-3xl font-black text-amber-400">{userData.roi}%</p>
              </div>
              <ArrowUpRight className="w-8 h-8 text-amber-400 opacity-50" />
            </div>
            <p className="text-gray-400 text-xs">معدل النمو السنوي</p>
          </div>
        </div>

        <div className="grid lg:grid-cols-3 gap-8 mb-8">
          {/* Investments */}
          <div className="lg:col-span-2">
            <div className="luxury-card">
              <h2 className="text-2xl font-bold mb-6">الاستثمارات النشطة</h2>
              <div className="space-y-4">
                {investments.map((inv) => (
                  <div key={inv.id} className="p-4 rounded-lg bg-slate-800/50 border border-amber-500/10 hover:border-amber-500/30 transition-all">
                    <div className="flex justify-between items-start mb-3">
                      <div>
                        <h3 className="font-bold text-lg">{inv.tier}</h3>
                        <p className="text-gray-400 text-sm">استثمار نشط</p>
                      </div>
                      <span className="px-3 py-1 rounded-full bg-green-500/20 text-green-400 text-xs font-bold">نشط</span>
                    </div>
                    <div className="grid grid-cols-3 gap-4">
                      <div>
                        <p className="text-gray-400 text-xs mb-1">المبلغ</p>
                        <p className="font-bold">${inv.amount}</p>
                      </div>
                      <div>
                        <p className="text-gray-400 text-xs mb-1">العائد اليومي</p>
                        <p className="font-bold text-amber-400">${inv.dailyReturn}</p>
                      </div>
                      <div>
                        <p className="text-gray-400 text-xs mb-1">الإجمالي</p>
                        <p className="font-bold text-green-400">${inv.totalReturn}</p>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>

          {/* ZEN Token */}
          <div className="space-y-8">
            <div className="luxury-card">
              <h3 className="text-xl font-bold mb-4">عملات ZEN</h3>
              <div className="space-y-3">
                <div className="flex justify-between">
                  <span className="text-gray-400">الرصيد</span>
                  <span className="font-bold text-amber-400">{userData.zenBalance} ZEN</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-400">السعر الحالي</span>
                  <span className="font-bold text-amber-400">$2.45</span>
                </div>
                <div className="flex justify-between pt-4 border-t border-amber-500/20">
                  <span className="text-gray-400">القيمة الكلية</span>
                  <span className="font-bold text-amber-400">${(userData.zenBalance * 2.45).toFixed(2)}</span>
                </div>
              </div>
              <button className="w-full mt-4 luxury-button text-sm py-2">
                أرسل ZEN
              </button>
            </div>
          </div>
        </div>
      </div>
    </main>
  );
}
