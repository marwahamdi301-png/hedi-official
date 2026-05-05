import { supabase } from './supabase'

// Investment Plans with daily returns
export const PLANS = {
  bronze: { name: 'البرونزية', dailyReturn: 0.008, minDeposit: 100, maxDeposit: 4999 },
  gold: { name: 'الذهبية', dailyReturn: 0.012, minDeposit: 5000, maxDeposit: 24999 },
  diamond: { name: 'الماسية', dailyReturn: 0.015, minDeposit: 25000, maxDeposit: Infinity },
  vip: { name: 'VIP', dailyReturn: 0.02, minDeposit: 50000, maxDeposit: Infinity }
}

// Calculate daily profit based on plan
export const calculateDailyProfit = (amount, planType) => {
  const plan = PLANS[planType] || PLANS.bronze
  return amount * plan.dailyReturn
}

// Process daily profits for all users (run via cron/edge function)
export const processDailyProfits = async () => {
  const { data: investments } = await supabase
    .from('investments')
    .select('*')
    .eq('status', 'active')

  for (const inv of investments || []) {
    const profit = calculateDailyProfit(inv.amount, inv.plan_type)
    
    // Add profit transaction
    await supabase.from('transactions').insert({
      user_id: inv.user_id,
      type: 'profit',
      amount: profit,
      description: `ربح يومي - ${PLANS[inv.plan_type]?.name || 'استثمار'}`,
      status: 'completed'
    })

    // Update user balance
    await supabase.rpc('increment_balance', { 
      user_id: inv.user_id, 
      amount: profit 
    })

    // Update investment total earned
    await supabase
      .from('investments')
      .update({ total_earned: inv.total_earned + profit })
      .eq('id', inv.id)
  }
}

// Get user investments
export const getUserInvestments = async (userId) => {
  const { data } = await supabase
    .from('investments')
    .select('*')
    .eq('user_id', userId)
    .order('created_at', { ascending: false })
  return data || []
}

// Get user transactions
export const getUserTransactions = async (userId) => {
  const { data } = await supabase
    .from('transactions')
    .select('*')
    .eq('user_id', userId)
    .order('created_at', { ascending: false })
    .limit(20)
  return data || []
}
