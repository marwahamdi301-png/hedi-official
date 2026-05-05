import { create } from 'zustand'

export const useStore = create((set) => ({
  balance: 0,
  dailyProfit: 0,
  totalDeposited: 0,
  investments: [],
  transactions: [],
  
  setBalance: (balance) => set({ balance }),
  setDailyProfit: (dailyProfit) => set({ dailyProfit }),
  setTotalDeposited: (totalDeposited) => set({ totalDeposited }),
  setInvestments: (investments) => set({ investments }),
  setTransactions: (transactions) => set({ transactions }),
  
  addTransaction: (tx) => set((state) => ({ 
    transactions: [tx, ...state.transactions] 
  })),
}))
