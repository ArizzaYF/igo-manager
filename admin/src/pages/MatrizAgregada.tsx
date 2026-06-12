import { useState, useEffect } from 'react';
import ScatterPlotComponent from '../components/ScatterPlot';
import { fetchAnonymizedInitiatives } from '../api/iniciativas.api';
import {
  fetchDistinctSectors,
  fetchDistinctCompanySizes,
} from '../api/metricas.api';
import type { AnonymizedInitiative } from '../types';
import { Filter } from 'lucide-react';

export default function MatrizAgregada() {
  const [allInitiatives, setAllInitiatives] = useState<AnonymizedInitiative[]>([]);
  const [sectors, setSectors] = useState<string[]>([]);
  const [companySizes, setCompanySizes] = useState<string[]>([]);
  const [selectedSector, setSelectedSector] = useState<string>('');
  const [selectedCompanySize, setSelectedCompanySize] = useState<string>('');
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    const loadData = async () => {
      try {
        const [initiatives, sectors, sizes] = await Promise.all([
          fetchAnonymizedInitiatives(),
          fetchDistinctSectors(),
          fetchDistinctCompanySizes(),
        ]);
        setAllInitiatives(initiatives);
        setSectors(sectors);
        setCompanySizes(sizes);
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

  const filteredInitiatives = allInitiatives.filter((i) => {
    if (selectedSector && i.sector !== selectedSector) return false;
    if (selectedCompanySize && i.company_size !== selectedCompanySize) return false;
    return true;
  });

  const scatterData = filteredInitiatives.map((i) => ({
    title: i.title,
    importance: i.importance,
    governability: i.governability,
    quadrant: i.quadrant,
    sector: i.sector,
    company_size: i.company_size,
    company_name: i.company_name,
    owner_name: i.owner_name,
  }));

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

  const quadrantCounts = {
    hacer_ya: filteredInitiatives.filter((i) => i.quadrant === 'hacer_ya').length,
    estrategico_aliados: filteredInitiatives.filter(
      (i) => i.quadrant === 'estrategico_aliados'
    ).length,
    rutina: filteredInitiatives.filter((i) => i.quadrant === 'rutina').length,
    descarte: filteredInitiatives.filter((i) => i.quadrant === 'descarte').length,
  };

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-gray-900">Matriz IGO Agregada</h1>
        <p className="text-sm text-gray-500 mt-1">
          Visualización de todas las iniciativas en la matriz Importancia vs Gobernabilidad.
          Datos anonimizados.
        </p>
      </div>

      <div className="bg-white rounded-xl border border-gray-200 p-5">
        <div className="flex items-center gap-2 mb-4">
          <Filter className="w-4 h-4 text-gray-500" />
          <span className="text-sm font-medium text-gray-700">Filtros</span>
        </div>
        <div className="flex flex-wrap gap-4">
          <div className="flex-1 min-w-[200px]">
            <label className="block text-xs font-medium text-gray-500 mb-1">
              Sector Económico
            </label>
            <select
              value={selectedSector}
              onChange={(e) => setSelectedSector(e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-primary-500 focus:border-primary-500 outline-none"
            >
              <option value="">Todos los sectores</option>
              {sectors.map((s) => (
                <option key={s} value={s}>
                  {s}
                </option>
              ))}
            </select>
          </div>
          <div className="flex-1 min-w-[200px]">
            <label className="block text-xs font-medium text-gray-500 mb-1">
              Tamaño de Empresa
            </label>
            <select
              value={selectedCompanySize}
              onChange={(e) => setSelectedCompanySize(e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-primary-500 focus:border-primary-500 outline-none"
            >
              <option value="">Todos los tamaños</option>
              {companySizes.map((s) => (
                <option key={s} value={s}>
                  {s}
                </option>
              ))}
            </select>
          </div>
        </div>
      </div>

      <div className="bg-white rounded-xl border border-gray-200 p-5">
        <h3 className="text-sm font-semibold text-gray-700 mb-2">
          Matriz Importancia vs Gobernabilidad
        </h3>
        <p className="text-xs text-gray-400 mb-4">
          {filteredInitiatives.length} iniciativas mostradas
        </p>
        <ScatterPlotComponent data={scatterData} />
      </div>

      <div className="grid grid-cols-4 gap-4">
        {[
          { label: 'HACER YA', key: 'hacer_ya', color: 'bg-emerald-500' },
          { label: 'ESTRATÉGICO', key: 'estrategico_aliados', color: 'bg-amber-500' },
          { label: 'RUTINA', key: 'rutina', color: 'bg-blue-500' },
          { label: 'DESCARTE', key: 'descarte', color: 'bg-gray-400' },
        ].map((q) => (
          <div
            key={q.key}
            className="bg-white rounded-xl border border-gray-200 p-4 text-center"
          >
            <div className={`w-3 h-3 rounded-full ${q.color} mx-auto mb-2`} />
            <p className="text-xs font-medium text-gray-500">{q.label}</p>
            <p className="text-2xl font-bold text-gray-900">
              {quadrantCounts[q.key as keyof typeof quadrantCounts]}
            </p>
          </div>
        ))}
      </div>
    </div>
  );
}
