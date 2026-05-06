import{createClient}from'@supabase/supabase-js';
const url='https://qvwcpljqbvaylwvdrryw.supabase.co',key='eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF2d2NwbGpxYnZheWx3dmRycnl3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzgwMTEzODEsImV4cCI6MjA5MzU4NzM4MX0.g9q69rbGpWyh6Q-4lv-XNAV2nKZqBsQMAwmfofbL_dw';
export const supabase=createClient(url,key);
export const signUp=async(e,p,n)=>{const{data,error}=await supabase.auth.signUp({email:e,password:p,options:{data:{full_name:n}}});if(!error&&data.user)await supabase.from('users').insert({id:data.user.id,email:e,full_name:n,balance:0,zen_balance:1000,referral_code:'ZEN-'+Math.random().toString(36).substr(2,8).toUpperCase()});return{data,error}};
export const signIn=async(e,p)=>supabase.auth.signInWithPassword({email:e,password:p});
export const signOut=()=>supabase.auth.signOut();
export const getProfile=async(id)=>{const{data}=await supabase.from('users').select('*').eq('id',id).single();return data};
