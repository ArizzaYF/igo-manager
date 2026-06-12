import { NavLink } from 'react-router-dom';
import {
  LayoutDashboard,
  Users,
  Grid3X3,
  Cloud,
  LogOut,
  BarChart3,
} from 'lucide-react';
import { useAuth } from '../contexts/AuthContext';

const navItems = [
  { to: '/dashboard', label: 'Dashboard', icon: LayoutDashboard },
  { to: '/demografia', label: 'Demografía', icon: Users },
  { to: '/matriz-agregada', label: 'Matriz IGO', icon: Grid3X3 },
  { to: '/nube-palabras', label: 'Nube de Palabras', icon: Cloud },
];

export default function Sidebar() {
  const { user, logout } = useAuth();

  return (
    <aside className="w-64 bg-primary-500 text-white flex flex-col h-screen fixed left-0 top-0 z-30">
      <div className="p-5 border-b border-primary-400">
        <div className="flex items-center gap-2">
          <BarChart3 className="w-7 h-7 text-accent-400" />
          <div>
            <h1 className="text-lg font-bold leading-tight">IGO Manager</h1>
            <p className="text-xs text-primary-200">Panel Administrativo</p>
          </div>
        </div>
      </div>

      <nav className="flex-1 p-3 space-y-1">
        {navItems.map((item) => (
          <NavLink
            key={item.to}
            to={item.to}
            className={({ isActive }) =>
              `flex items-center gap-3 px-4 py-2.5 rounded-lg text-sm font-medium transition-colors ${
                isActive
                  ? 'bg-white/20 text-white shadow-sm'
                  : 'text-primary-100 hover:bg-white/10 hover:text-white'
              }`
            }
          >
            <item.icon className="w-5 h-5" />
            {item.label}
          </NavLink>
        ))}
      </nav>

      <div className="p-4 border-t border-primary-400">
        <div className="flex items-center gap-3 mb-3">
          <div className="w-8 h-8 rounded-full bg-accent-400 flex items-center justify-center text-primary-900 font-bold text-sm">
            {user?.full_name?.charAt(0) ?? 'A'}
          </div>
          <div className="flex-1 min-w-0">
            <p className="text-sm font-medium truncate">{user?.full_name ?? 'Admin'}</p>
            <p className="text-xs text-primary-200 capitalize">{user?.role ?? 'usuario'}</p>
          </div>
        </div>
        <button
          onClick={logout}
          className="flex items-center gap-2 w-full px-4 py-2 text-sm text-primary-200 hover:text-white hover:bg-white/10 rounded-lg transition-colors"
        >
          <LogOut className="w-4 h-4" />
          Cerrar Sesión
        </button>
      </div>
    </aside>
  );
}
