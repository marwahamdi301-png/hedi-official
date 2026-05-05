import type { Metadata } from 'next';
import './globals.css';

export const metadata: Metadata = {
  title: 'ZENITH Africa - منصة الاستثمار الأفريقية المتقدمة',
  description: 'منصة استثمارية عالمية توفر عوائد حقيقية وأمان كامل برعاية عملة ZEN',
  keywords: 'استثمار، أفريقيا، عملات رقمية، ZEN، ZENITH',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="ar" dir="rtl" suppressHydrationWarning>
      <head>
        <link 
          href="https://fonts.googleapis.com/css2?family=Cairo:wght@400;600;700;900&display=swap" 
          rel="stylesheet" 
        />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
      </head>
      <body className="bg-slate-950 text-white font-cairo overflow-x-hidden">
        {/* Animated Background */}
        <div className="fixed inset-0 z-0 pointer-events-none overflow-hidden">
          <div className="absolute inset-0 bg-gradient-to-br from-slate-950 via-slate-900 to-black" />
          <div className="absolute top-0 right-0 w-96 h-96 bg-amber-600 rounded-full blur-3xl opacity-20 animate-pulse" />
          <div className="absolute bottom-0 left-0 w-96 h-96 bg-amber-700 rounded-full blur-3xl opacity-10 animate-pulse" style={{animationDelay: '1s'}} />
        </div>

        {/* Content */}
        <div className="relative z-10 min-h-screen">
          {children}
        </div>

        {/* Grid Pattern Overlay */}
        <div className="fixed inset-0 z-0 pointer-events-none opacity-5">
          <svg className="w-full h-full" xmlns="http://www.w3.org/2000/svg">
            <defs>
              <pattern id="grid" width="50" height="50" patternUnits="userSpaceOnUse">
                <path d="M 50 0 L 0 0 0 50" fill="none" stroke="white" strokeWidth="0.5"/>
              </pattern>
            </defs>
            <rect width="100%" height="100%" fill="url(#grid)" />
          </svg>
        </div>
      </body>
    </html>
  );
}
