import { type LucideIcon } from 'lucide-react';

interface KpiCardProps {
  title: string;
  value: string | number;
  subtitle?: string;
  icon: LucideIcon;
  colorClass?: string;
}

const colorMap: Record<string, string> = {
  blue: 'bg-blue-50 text-blue-600 border-blue-200',
  green: 'bg-emerald-50 text-emerald-600 border-emerald-200',
  amber: 'bg-amber-50 text-amber-600 border-amber-200',
  purple: 'bg-purple-50 text-purple-600 border-purple-200',
  rose: 'bg-rose-50 text-rose-600 border-rose-200',
  cyan: 'bg-cyan-50 text-cyan-600 border-cyan-200',
};

export default function KpiCard({
  title,
  value,
  subtitle,
  icon: Icon,
  colorClass = 'blue',
}: KpiCardProps) {
  const bgColor = colorMap[colorClass] ?? colorMap.blue;

  return (
    <div className="bg-white rounded-xl border border-gray-200 p-5 shadow-sm hover:shadow-md transition-shadow">
      <div className="flex items-start justify-between">
        <div className="flex-1 min-w-0">
          <p className="text-sm font-medium text-gray-500 truncate">{title}</p>
          <p className="text-3xl font-bold text-gray-900 mt-1">{value}</p>
          {subtitle && (
            <p className="text-xs text-gray-400 mt-1">{subtitle}</p>
          )}
        </div>
        <div className={`p-3 rounded-lg border ${bgColor} shrink-0`}>
          <Icon className="w-6 h-6" />
        </div>
      </div>
    </div>
  );
}
