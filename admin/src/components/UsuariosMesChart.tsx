import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
} from 'recharts';
import { format, parseISO } from 'date-fns';
import { es } from 'date-fns/locale';

interface UsersByMonth {
  month: string;
  total_users: number;
}

interface UsuariosMesChartProps {
  data: UsersByMonth[];
}

export default function UsuariosMesChart({ data }: UsuariosMesChartProps) {
  if (!data || data.length === 0) {
    return (
      <div className="bg-white rounded-xl border border-gray-200 p-5">
        <h3 className="text-sm font-semibold text-gray-700 mb-4">
          Usuarios Registrados por Mes
        </h3>
        <div className="h-64 flex items-center justify-center text-gray-400 text-sm">
          Sin datos disponibles
        </div>
      </div>
    );
  }

  const chartData = data.map((d) => {
    let label = d.month;
    try {
      label = format(parseISO(d.month), 'MMM yyyy', { locale: es });
    } catch {
      try {
        label = format(new Date(d.month), 'MMM yyyy', { locale: es });
      } catch {
        label = d.month;
      }
    }
    return {
      ...d,
      label: label.charAt(0).toUpperCase() + label.slice(1),
    };
  });

  return (
    <div className="bg-white rounded-xl border border-gray-200 p-5">
      <h3 className="text-sm font-semibold text-gray-700 mb-4">
        Usuarios Registrados por Mes
      </h3>
      <ResponsiveContainer width="100%" height={280}>
        <LineChart data={chartData}>
          <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
          <XAxis
            dataKey="label"
            tick={{ fontSize: 11, fill: '#6b7280' }}
            axisLine={false}
            tickLine={false}
          />
          <YAxis
            allowDecimals={false}
            tick={{ fontSize: 11, fill: '#6b7280' }}
            axisLine={false}
            tickLine={false}
          />
          <Tooltip
            contentStyle={{
              borderRadius: '8px',
              border: '1px solid #e5e7eb',
              fontSize: '13px',
            }}
            formatter={(value: number) => [value, 'Usuarios']}
          />
          <Line
            type="monotone"
            dataKey="total_users"
            stroke="#1e3a5f"
            strokeWidth={2.5}
            dot={{ fill: '#1e3a5f', strokeWidth: 2, r: 4 }}
            activeDot={{ r: 6, fill: '#1e3a5f' }}
          />
        </LineChart>
      </ResponsiveContainer>
    </div>
  );
}
