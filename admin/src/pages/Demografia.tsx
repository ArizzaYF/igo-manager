import { useState, useEffect } from 'react';
import PieChartComponent from '../components/PieChart';
import {
  fetchDemographicsSector,
  fetchDemographicsCompanySize,
  fetchDemographicsAge,
  fetchDemographicsGender,
} from '../api/usuarios.api';
import type {
  DemographicsSector,
  DemographicsCompanySize,
  DemographicsAge,
  DemographicsGender,
} from '../types';

export default function Demografia() {
  const [sector, setSector] = useState<DemographicsSector[]>([]);
  const [companySize, setCompanySize] = useState<DemographicsCompanySize[]>([]);
  const [age, setAge] = useState<DemographicsAge[]>([]);
  const [gender, setGender] = useState<DemographicsGender[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    const loadData = async () => {
      try {
        const [s, c, a, g] = await Promise.all([
          fetchDemographicsSector(),
          fetchDemographicsCompanySize(),
          fetchDemographicsAge(),
          fetchDemographicsGender(),
        ]);
        setSector(s);
        setCompanySize(c);
        setAge(a);
        setGender(g);
      } catch (err) {
        setError(err instanceof Error ? err.message : 'Error al cargar datos');
      } finally {
        setLoading(false);
      }
    };
    loadData();
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

  const sectorData = sector.map((s) => ({ name: s.sector, value: s.total_users }));
  const companySizeData = companySize.map((c) => ({
    name: c.company_size,
    value: c.total_users,
  }));
  const ageData = age.map((a) => ({ name: a.age_range, value: a.total_users }));
  const genderData = gender.map((g) => ({ name: g.gender, value: g.total_users }));

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-gray-900">Demografía</h1>
        <p className="text-sm text-gray-500 mt-1">
          Distribución demográfica de los usuarios registrados.
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <PieChartComponent data={sectorData} title="Sector Económico" />
        <PieChartComponent data={companySizeData} title="Tamaño de Empresa" />
        <PieChartComponent data={ageData} title="Rango de Edad" />
        <PieChartComponent data={genderData} title="Género" />
      </div>
    </div>
  );
}
