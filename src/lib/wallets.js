export const WALLETS = {
  USDT_TRC20: {
    address: 'TYourUSDTWalletAddressHere123456789',
    network: 'TRC20',
    icon: '💵',
    name: 'USDT (TRC20)',
    minDeposit: 50
  },
  USDT_ERC20: {
    address: '0xYourERC20WalletAddressHere123456789',
    network: 'ERC20', 
    icon: '💵',
    name: 'USDT (ERC20)',
    minDeposit: 100
  },
  BTC: {
    address: 'bc1YourBitcoinWalletAddressHere123456789',
    network: 'Bitcoin',
    icon: '₿',
    name: 'Bitcoin',
    minDeposit: 0.001
  },
  ZEN: {
    address: 'ZENYourZenithWalletAddressHere123456789',
    network: 'ZENITH',
    icon: '⚡',
    name: 'ZEN Token',
    minDeposit: 100
  }
}

export const createDepositRequest = async (supabase, userId, crypto, amount, txHash) => {
  return await supabase.from('deposits').insert({
    user_id: userId,
    crypto_type: crypto,
    amount,
    tx_hash: txHash,
    wallet_address: WALLETS[crypto].address,
    status: 'pending'
  })
}
