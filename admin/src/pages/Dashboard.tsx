import { useState, useEffect } from 'react';
import {
  Users,
  Lightbulb,
  ClipboardCheck,
  CheckCircle2,
  TrendingUp,
  Target,
  Navigation,
  Activity,
  Sparkles,
} from 'lucide-react';
import KpiCard from '../components/KpiCard';
import UsuariosMesChart from '../components/UsuariosMesChart';
import { fetchKpis, fetchUsersByMonth, fetchQuadrantSummary } from '../api/metricas.api';
import type { AdminKpis, UsersByMonth, QuadrantSummary } from '../types';

const quadrantColors: Record<string, string> = {
  hacer_ya: '#22c55e',
  estrategico_aliados: '#f59e0b',
  rutina: '#3b82f6',
  descarte: '#6b7280',
};

function toSliderScale(v: number) { return Math.round(v / 2); }

export default function Dashboard() {
  const [kpis, setKpis] = useState<AdminKpis | null>(null);
  const [usersByMonth, setUsersByMonth] = useState<UsersByMonth[]>([]);
  const [quadrantSummary, setQuadrantSummary] = useState<QuadrantSummary[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    const loadData = async () => {
      try {
        const [kpisData, usersData, quadrants] = await Promise.all([
          fetchKpis(),
          fetchUsersByMonth(),
          fetchQuadrantSummary(),
        ]);
        setKpis(kpisData);
        setUsersByMonth(usersData);
        setQuadrantSummary(quadrants);
      } catch (err) {
        setError(err instanceof Error ? err.message : 'Error al cargar datos');
      } finally {
        setLoading(false);
      }
    };
    loadData();
    const interval = setInterval(loadData, 30000);
    return () => clearInterval(interval);
  }, []);

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary-500" />
      </div>
    );
  }

  if (error) {
    return (
      <div className="bg-red-50 border border-red-200 text-red-700 rounded-lg p-4 text-sm">
        {error}
      </div>
    );
  }

  const totalInitiatives = (kpis?.active_initiatives ?? 0) +
    (quadrantSummary?.reduce((sum, q) => sum + q.total_initiatives, 0) ?? 0);

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Dashboard</h1>
          <p className="text-sm text-gray-500 mt-1">
            Resumen general de métricas de la plataforma IGO Manager
          </p>
        </div>
        <div className="flex items-center gap-2 px-4 py-2 bg-primary-50 text-primary-700 rounded-lg text-sm font-medium">
          <Sparkles className="w-4 h-4" />
          <span>Actualizado en tiempo real</span>
        </div>
      </div>

      {/* KPI Cards Grid */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <KpiCard
          title="Usuarios Registrados"
          value={kpis?.total_registered_users ?? 0}
          subtitle="Total acumulado"
          icon={Users}
          colorClass="blue"
        />
        <KpiCard
          title="Usuarios este Mes"
          value={kpis?.users_current_month ?? 0}
          subtitle="Nuevos registros"
          icon={TrendingUp}
          colorClass="green"
        />
        <KpiCard
          title="Iniciativas Activas"
          value={kpis?.active_initiatives ?? 0}
          subtitle="En seguimiento"
          icon={Lightbulb}
          colorClass="amber"
        />
        <KpiCard
          title="Planes Activos"
          value={kpis?.active_action_plans ?? 0}
          subtitle="En ejecución"
          icon={ClipboardCheck}
          colorClass="purple"
        />
      </div>

      {/* Secondary KPI Row */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <div className="bg-white rounded-xl border border-gray-200 p-5 shadow-sm">
          <p className="text-sm font-medium text-gray-500">Planes Completados</p>
          <p className="text-2xl font-bold text-gray-900 mt-1">{kpis?.completed_action_plans ?? 0}</p>
          <div className="mt-3 w-full bg-gray-100 rounded-full h-2">
            <div
              className="bg-emerald-500 h-2 rounded-full transition-all duration-500"
              style={{ width: `${Math.min(100, ((kpis?.completed_action_plans ?? 0) / Math.max(1, (kpis?.active_action_plans ?? 0) + (kpis?.completed_action_plans ?? 0))) * 100)}%` }}
            />
          </div>
          <p className="text-xs text-gray-400 mt-1">
            {((kpis?.completed_action_plans ?? 0) / Math.max(1, (kpis?.active_action_plans ?? 0) + (kpis?.completed_action_plans ?? 0)) * 100).toFixed(0)}% completado
          </p>
        </div>

        <div className="bg-white rounded-xl border border-gray-200 p-5 shadow-sm">
          <p className="text-sm font-medium text-gray-500">Importancia Promedio</p>
          <p className="text-2xl font-bold text-gray-900 mt-1">{toSliderScale(kpis?.avg_importance ?? 0)} / 5</p>
          <div className="flex items-center gap-1 mt-2">
            {[1,2,3,4,5].map((star) => (
              <div
                key={star}
                className={`w-3 h-3 rounded-full ${star <= toSliderScale(kpis?.avg_importance ?? 0) ? 'bg-rose-500' : 'bg-gray-200'}`}
              />
            ))}
          </div>
          <p className="text-xs text-gray-400 mt-1">Valor DB: {kpis?.avg_importance?.toFixed(1) ?? '—'}</p>
        </div>

        <div className="bg-white rounded-xl border border-gray-200 p-5 shadow-sm">
          <p className="text-sm font-medium text-gray-500">Gobernabilidad Promedio</p>
          <p className="text-2xl font-bold text-gray-900 mt-1">{toSliderScale(kpis?.avg_governability ?? 0)} / 5</p>
          <div className="flex items-center gap-1 mt-2">
            {[1,2,3,4,5].map((star) => (
              <div
                key={star}
                className={`w-3 h-3 rounded-full ${star <= toSliderScale(kpis?.avg_governability ?? 0) ? 'bg-cyan-500' : 'bg-gray-200'}`}
              />
            ))}
          </div>
          <p className="text-xs text-gray-400 mt-1">Valor DB: {kpis?.avg_governability?.toFixed(1) ?? '—'}</p>
        </div>

        <div className="bg-gradient-to-br from-primary-500 to-primary-700 rounded-xl p-5 shadow-sm text-white">
          <p className="text-sm font-medium text-white/80">Total Iniciativas</p>
          <p className="text-2xl font-bold mt-1">{totalInitiatives}</p>
          <div className="flex items-center gap-2 mt-2">
            <Activity className="w-4 h-4 text-accent-400" />
            <span className="text-xs text-white/70">En todos los cuadrantes</span>
          </div>
        </div>
      </div>

      {/* Charts Row */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div className="lg:col-span-2">
          <UsuariosMesChart data={usersByMonth} />
        </div>

        {/* Quadrant Distribution */}
        <div className="bg-white rounded-xl border border-gray-200 p-5 shadow-sm">
          <h3 className="text-sm font-semibold text-gray-700 mb-4">Distribución por Cuadrante</h3>
          <div className="space-y-4">
            {quadrantSummary.length === 0 ? (
              <p className="text-sm text-gray-400">Sin datos</p>
            ) : (
              quadrantSummary.map((q) => {
                const total = quadrantSummary.reduce((s, qq) => s + qq.total_initiatives, 0);
                const pct = total > 0 ? (q.total_initiatives / total) * 100 : 0;
                return (
                  <div key={q.quadrant}>
                    <div className="flex items-center justify-between text-sm mb-1">
                      <div className="flex items-center gap-2">
                        <div
                          className="w-3 h-3 rounded-full"
                          style={{ backgroundColor: quadrantColors[q.quadrant] || '#6b7280' }}
                        />
                        <span className="font-medium text-gray-700">{q.quadrant_label}</span>
                      </div>
                      <span className="text-gray-500">{q.total_initiatives} ({pct.toFixed(0)}%)</span>
                    </div>
                    <div className="w-full bg-gray-100 rounded-full h-2">
                      <div
                        className="h-2 rounded-full transition-all duration-500"
                        style={{ width: `${pct}%`, backgroundColor: quadrantColors[q.quadrant] || '#6b7280' }}
                      />
                    </div>
                    <div className="flex justify-between text-xs text-gray-400 mt-0.5">
                      <span>I: {toSliderScale(q.avg_importance)}</span>
                      <span>G: {toSliderScale(q.avg_governability)}</span>
                    </div>
                  </div>
                );
              })
            )}
          </div>
        </div>
      </div>

      {/* Last updated indicator */}
      <p className="text-xs text-gray-400 text-right">
        Los datos se actualizan automáticamente cada 30 segundos
      </p>
    </div>
  );
}
