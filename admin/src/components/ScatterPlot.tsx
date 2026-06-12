import { useState, useCallback, useRef } from 'react';
import {
  ScatterChart,
  Scatter,
  XAxis,
  YAxis,
  CartesianGrid,
  ResponsiveContainer,
  ReferenceLine,
  Legend,
} from 'recharts';

interface ClusterItem {
  title: string;
  sector?: string;
  company_size?: string;
  company_name?: string;
  owner_name?: string;
}

interface ScatterDataPoint {
  title: string;
  importance: number;
  governability: number;
  quadrant: string;
  sector?: string;
  company_size?: string;
  company_name?: string;
  owner_name?: string;
}

interface ClusterPoint {
  importancia_5: number;
  gobernabilidad_5: number;
  quadrant: string;
  count: number;
  items: ClusterItem[];
}

interface ScatterPlotProps {
  data: ScatterDataPoint[];
}

const quadrantColors: Record<string, { fill: string; bg: string; border: string }> = {
  hacer_ya: { fill: '#22c55e', bg: 'bg-emerald-500', border: 'border-emerald-600' },
  estrategico_aliados: { fill: '#f59e0b', bg: 'bg-amber-500', border: 'border-amber-600' },
  rutina: { fill: '#3b82f6', bg: 'bg-blue-500', border: 'border-blue-600' },
  descarte: { fill: '#6b7280', bg: 'bg-gray-400', border: 'border-gray-500' },
};

const quadrantLabels: Record<string, string> = {
  hacer_ya: 'HACER YA',
  estrategico_aliados: 'ESTRATÉGICO',
  rutina: 'RUTINA',
  descarte: 'DESCARTE',
};

export default function ScatterPlotComponent({ data }: ScatterPlotProps) {
  const [modalData, setModalData] = useState<{ x: number; y: number; items: ClusterItem[] } | null>(null);
  const [hoveredPoint, setHoveredPoint] = useState<ClusterPoint | null>(null);
  const [tooltipPos, setTooltipPos] = useState({ x: 0, y: 0 });
  const hideTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null);

  const clusters = groupIntoClusters(data);

  const clearHideTimer = useCallback(() => {
    if (hideTimerRef.current) {
      clearTimeout(hideTimerRef.current);
      hideTimerRef.current = null;
    }
  }, []);

  const scheduleHide = useCallback(() => {
    hideTimerRef.current = setTimeout(() => {
      setHoveredPoint(null);
    }, 300);
  }, []);

  const handleShapeEnter = useCallback(
    (point: ClusterPoint, e: React.MouseEvent<SVGGElement>) => {
      clearHideTimer();
      setHoveredPoint(point);
      setTooltipPos({ x: e.clientX, y: e.clientY - 10 });
    },
    [clearHideTimer],
  );

  const handleShapeLeave = useCallback(() => {
    scheduleHide();
  }, [scheduleHide]);

  const handleTooltipEnter = useCallback(() => {
    clearHideTimer();
  }, [clearHideTimer]);

  const handleTooltipLeave = useCallback(() => {
    setHoveredPoint(null);
  }, []);

  if (!data || data.length === 0) {
    return (
      <div className="h-80 flex items-center justify-center text-gray-400 text-sm">
        Sin datos disponibles
      </div>
    );
  }

  return (
    <>
      <div className="relative">
        <ResponsiveContainer width="100%" height={400}>
          <ScatterChart margin={{ top: 20, right: 20, bottom: 20, left: 20 }}>
            <CartesianGrid strokeDasharray="3 3" stroke="#e5e7eb" />
            <XAxis
              type="number"
              dataKey="gobernabilidad_5"
              name="Gobernabilidad"
              domain={[0, 6]}
              ticks={[1, 2, 3, 4, 5]}
              label={{
                value: 'Gobernabilidad',
                position: 'insideBottomRight',
                offset: -10,
                style: { fontSize: 13, fill: '#6b7280' },
              }}
            />
            <YAxis
              type="number"
              dataKey="importancia_5"
              name="Importancia"
              domain={[0, 6]}
              ticks={[1, 2, 3, 4, 5]}
              label={{
                value: 'Importancia',
                angle: -90,
                position: 'insideLeft',
                offset: 0,
                style: { fontSize: 13, fill: '#6b7280' },
              }}
            />
            <ReferenceLine x={3.5} stroke="#9ca3af" strokeDasharray="5 5" strokeWidth={1.5} />
            <ReferenceLine y={3.5} stroke="#9ca3af" strokeDasharray="5 5" strokeWidth={1.5} />
            <Legend
              verticalAlign="top"
              height={36}
              formatter={(value: string) => (
                <span className="text-xs text-gray-600">{value}</span>
              )}
            />
            {Object.entries(quadrantLabels).map(([quadrant, label]) => {
              const filtered = clusters.filter((d) => d.quadrant === quadrant);
              return (
                <Scatter
                  key={quadrant}
                  name={label}
                  data={filtered}
                  fill={quadrantColors[quadrant].fill}
                  shape={(props: any) => {
                    const { cx, cy, fill, payload } = props;
                    const point = payload as ClusterPoint;
                    const count = point?.count ?? 1;
                    const r = count > 1 ? Math.min(18, 8 + count * 2) : 6;
                    return (
                      <g
                        onMouseEnter={(e: React.MouseEvent<SVGGElement>) => handleShapeEnter(point, e)}
                        onMouseLeave={handleShapeLeave}
                        style={{ cursor: 'pointer' }}
                      >
                        <circle cx={cx} cy={cy} r={r} fill={fill} opacity={0.85} stroke={fill} strokeWidth={1.5} />
                        {count > 1 && (
                          <text x={cx} y={cy} textAnchor="middle" dominantBaseline="central" fill="#fff" fontSize={11} fontWeight="bold">
                            {count}
                          </text>
                        )}
                      </g>
                    );
                  }}
                />
              );
            })}
          </ScatterChart>
        </ResponsiveContainer>

        {hoveredPoint && (
          <div
            onMouseEnter={handleTooltipEnter}
            onMouseLeave={handleTooltipLeave}
            style={{
              position: 'fixed',
              left: Math.min(tooltipPos.x + 15, window.innerWidth - 280),
              top: Math.max(tooltipPos.y - 10, 10),
              pointerEvents: 'auto',
              zIndex: 1000,
            }}
            className="bg-white rounded-lg border border-gray-200 shadow-lg p-4 max-w-xs text-sm space-y-1.5"
          >
            <p className="font-semibold text-gray-900">
              {hoveredPoint.count > 1
                ? `${hoveredPoint.count} iniciativas en este punto`
                : hoveredPoint.items?.[0]?.title || 'Iniciativa'}
            </p>
            {hoveredPoint.count === 1 && hoveredPoint.items?.[0] && (
              <div className="text-gray-500 text-xs space-y-0.5">
                <p>Empresa: {hoveredPoint.items[0].company_name || hoveredPoint.items[0].sector || '—'}</p>
                <p>Dueño: {hoveredPoint.items[0].owner_name || 'Anónimo'}</p>
              </div>
            )}
            <div className="flex gap-4 pt-1 text-xs text-gray-600">
              <span>I: {hoveredPoint.importancia_5}</span>
              <span>G: {hoveredPoint.gobernabilidad_5}</span>
            </div>
            {hoveredPoint.count > 1 && (
              <button
                onClick={() => setModalData({ x: hoveredPoint.importancia_5, y: hoveredPoint.gobernabilidad_5, items: hoveredPoint.items })}
                className="w-full mt-1 text-xs text-primary-600 hover:text-primary-800 font-medium"
              >
                Ver todas →
              </button>
            )}
          </div>
        )}
      </div>

      {modalData && (
        <ClusterModal
          data={modalData}
          onClose={() => setModalData(null)}
        />
      )}
    </>
  );
}

function groupIntoClusters(data: ScatterDataPoint[]): ClusterPoint[] {
  const map = new Map<string, { count: number; items: ClusterItem[]; quadrant: string; importance: number; governability: number }>();
  for (const d of data) {
    const imp5 = Math.round(d.importance / 2);
    const gov5 = Math.round(d.governability / 2);
    const key = `${imp5}-${gov5}`;
    if (map.has(key)) {
      const entry = map.get(key)!;
      entry.count++;
      entry.items.push({ title: d.title, sector: d.sector, company_size: d.company_size, company_name: d.company_name, owner_name: d.owner_name });
    } else {
      map.set(key, {
        count: 1,
        items: [{ title: d.title, sector: d.sector, company_size: d.company_size, company_name: d.company_name, owner_name: d.owner_name }],
        quadrant: d.quadrant,
        importance: imp5,
        governability: gov5,
      });
    }
  }
  return Array.from(map.values()).map((entry) => ({
    importancia_5: entry.importance,
    gobernabilidad_5: entry.governability,
    quadrant: entry.quadrant,
    count: entry.count,
    items: entry.items,
  }));
}

function ClusterModal({ data, onClose }: { data: { x: number; y: number; items: ClusterItem[] }; onClose: () => void }) {
  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40" onClick={onClose}>
      <div className="bg-white rounded-xl shadow-2xl max-w-lg w-full mx-4 max-h-[70vh] flex flex-col" onClick={(e) => e.stopPropagation()}>
        <div className="flex items-center justify-between p-4 border-b border-gray-200">
          <h3 className="font-semibold text-gray-900">
            Iniciativas en ({data.x}, {data.y})
          </h3>
          <button onClick={onClose} className="text-gray-400 hover:text-gray-600 text-xl leading-none">&times;</button>
        </div>
        <div className="overflow-y-auto p-4 space-y-2">
          {data.items.map((item, i) => (
            <div key={i} className="p-3 rounded-lg border border-gray-100 bg-gray-50">
              <p className="font-medium text-gray-800 text-sm">{item.title}</p>
              <p className="text-xs text-gray-500 mt-0.5">{item.company_name || item.sector || 'Anónimo'} · {item.owner_name || 'Sin dueño'}</p>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
