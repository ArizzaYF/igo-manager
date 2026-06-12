import { createContext, useContext, useState, useEffect, type ReactNode } from 'react';
import { supabase } from '../config/supabase';

interface AuthContextType {
  user: { id: string; email: string; full_name: string; role: string } | null;
  loading: boolean;
  login: (email: string, password: string) => Promise<{ id: string; email: string; full_name: string; role: string }>;
  logout: () => void;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

const AUTH_KEY = 'igo_user';

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<{ id: string; email: string; full_name: string; role: string } | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const stored = localStorage.getItem(AUTH_KEY);
    if (stored) {
      try {
        setUser(JSON.parse(stored));
      } catch {
        localStorage.removeItem(AUTH_KEY);
      }
    }
    setLoading(false);
  }, []);

  const login = async (email: string, password: string) => {
    const { data, error } = await supabase.rpc('login_app_user', {
      p_email: email,
      p_password: password,
    });

    if (error || !data || data.length === 0) {
      throw new Error('Credenciales inválidas');
    }

    const rpcUser = data[0] as { id: string; email: string; full_name: string; role: string };

    localStorage.setItem(AUTH_KEY, JSON.stringify(rpcUser));

    setUser(rpcUser);

    return rpcUser;
  };

  const logout = () => {
    localStorage.removeItem(AUTH_KEY);
    setUser(null);
  };

  return (
    <AuthContext.Provider value={{ user, loading, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error('useAuth must be used within AuthProvider');
  return ctx;
}
