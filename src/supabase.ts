import { createClient } from '@supabase/supabase-js'

// Vamos buscar as variáveis de ambiente que o Vite lê
const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY

if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error('Faltam as variáveis de ambiente do Supabase no ficheiro .env')
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey)