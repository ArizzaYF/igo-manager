import { useState, useMemo } from 'react';

interface WordCloudItem {
  keyword: string;
  occurrences: number;
  quadrant?: string;
  initiatives?: { title: string; sector?: string; company_size?: string }[];
}

interface WordCloudProps {
  data: WordCloudItem[];
}

const quadrantColors: Record<string, { bg: string; text: string; hover: string }> = {
  hacer_ya: { bg: 'bg-emerald-100', text: 'text-emerald-800', hover: 'bg-emerald-500' },
  estrategico_aliados: { bg: 'bg-amber-100', text: 'text-amber-800', hover: 'bg-amber-500' },
  rutina: { bg: 'bg-blue-100', text: 'text-blue-800', hover: 'bg-blue-500' },
  descarte: { bg: 'bg-gray-100', text: 'text-gray-600', hover: 'bg-gray-400' },
};

export default function WordCloudComponent({ data }: WordCloudProps) {
  const [hovered, setHovered] = useState<string | null>(null);
  const [tooltip, setTooltip] = useState<{ x: number; y: number; item: WordCloudItem } | null>(null);

  const maxOccurrences = useMemo(
    () => (data.length > 0 ? Math.max(...data.map((d) => d.occurrences)) : 1),
    [data]
  );

  if (!data || data.length === 0) {
    return (
      <div className="h-80 flex items-center justify-center text-gray-400 text-sm">
        Sin palabras clave disponibles
      </div>
    );
  }

  const getFontSize = (occurrences: number) => {
    const ratio = occurrences / maxOccurrences;
    return Math.max(0.7, ratio) * 2.5 + 0.6;
  };

  return (
    <div className="bg-white rounded-xl border border-gray-200 p-6 relative">
      <div className="flex flex-wrap justify-center items-center gap-3 min-h-[300px] content-center">
        {data.map((item) => {
          const fontSize = getFontSize(item.occurrences);
          const isHovered = hovered === item.keyword;
          const qColor = item.quadrant
            ? quadrantColors[item.quadrant]
            : { bg: 'bg-gray-50', text: 'text-gray-700', hover: 'bg-primary-500' };

          return (
            <span
              key={item.keyword}
              onMouseEnter={(e) => {
                setHovered(item.keyword);
                const rect = (e.target as HTMLElement).getBoundingClientRect();
                setTooltip({ x: rect.left, y: rect.bottom + 8, item });
              }}
              onMouseLeave={() => {
                setHovered(null);
                setTooltip(null);
              }}
              className={`inline-block cursor-default transition-all duration-200 rounded px-1.5 py-0.5 ${
                isHovered
                  ? `${qColor.hover} text-white shadow-md scale-110`
                  : `${qColor.bg} ${qColor.text} hover:opacity-80`
              }`}
              style={{
                fontSize: `${fontSize}rem`,
              }}
            >
              {item.keyword}
              {isHovered && (
                <span className="ml-1.5 text-xs font-normal opacity-80">
                  ({item.occurrences})
                </span>
              )}
            </span>
          );
        })}
      </div>

      {tooltip && (
        <div
          className="fixed z-50 bg-white rounded-lg border border-gray-200 shadow-lg p-4 max-w-xs text-sm space-y-1.5 pointer-events-none"
          style={{ left: tooltip.x, top: tooltip.y }}
        >
          <p className="font-semibold text-gray-900">{tooltip.item.keyword}</p>
          <p className="text-xs text-gray-400">{tooltip.item.occurrences} ocurrencia(s)</p>
          {tooltip.item.initiatives && tooltip.item.initiatives.length > 0 && (
            <div className="pt-1 border-t border-gray-100 space-y-1">
              {tooltip.item.initiatives.slice(0, 3).map((ini, i) => (
                <p key={i} className="text-xs text-gray-600 leading-tight">
                  {ini.title}
                </p>
              ))}
              {tooltip.item.initiatives.length > 3 && (
                <p className="text-xs text-gray-400">+{tooltip.item.initiatives.length - 3} más</p>
              )}
            </div>
          )}
        </div>
      )}
    </div>
  );
}