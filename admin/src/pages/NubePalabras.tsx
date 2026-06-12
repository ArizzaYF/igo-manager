import { useState, useEffect, useMemo } from 'react';
import WordCloudComponent from '../components/WordCloud';
import { supabase } from '../config/supabase';

const SPANISH_STOP_WORDS = new Set([
  'de', 'la', 'el', 'los', 'las', 'un', 'una', 'unos', 'unas', 'y', 'e', 'o', 'u',
  'a', 'ante', 'bajo', 'cabe', 'con', 'contra', 'de', 'desde', 'durante', 'en',
  'entre', 'hacia', 'hasta', 'mediante', 'para', 'por', 'según', 'sin', 'so',
  'sobre', 'tras', 'que', 'como', 'del', 'lo', 'le', 'se', 'no', 'su', 'sus',
  'es', 'son', 'fue', 'era', 'han', 'has', 'ha', 'hemos', 'habían', 'había',
  'hay', 'hubo', 'sea', 'sean', 'ser', 'sido', 'está', 'están', 'estaba',
  'estado', 'tiene', 'tienen', 'tuvo', 'tenía', 'tenido', 'hace', 'hacen',
  'hacer', 'hecho', 'más', 'menos', 'muy', 'tan', 'tanto', 'todo', 'toda',
  'todos', 'todas', 'cada', 'mismo', 'misma', 'mismos', 'mismas', 'otro',
  'otra', 'otros', 'otras', 'algo', 'nada', 'alguien', 'nadie', 'este',
  'esta', 'estos', 'estas', 'ese', 'esa', 'esos', 'esas', 'aquel', 'aquella',
  'aquellos', 'aquellas', 'mi', 'tu', 'su', 'nuestro', 'vuestro', 'me', 'te',
  'nos', 'os', 'yo', 'tú', 'él', 'ella', 'ellos', 'ellas', 'nosotros',
  'vosotros', 'qué', 'quién', 'quiénes', 'cómo', 'cuándo', 'dónde', 'por qué',
  'para qué', 'cuál', 'cuáles', 'si', 'sí', 'no', 'también', 'pero', 'aunque',
  'sino', 'además', 'incluso', 'entonces', 'pues', 'bien', 'mal', 'casi',
  'solo', 'sólo', 'siempre', 'nunca', 'jamás', 'ya', 'aún', 'todavía',
  'después', 'luego', 'antes', 'ahora', 'aquí', 'allí', 'allá', 'acá',
  'arriba', 'abajo', 'dentro', 'fuera', 'cerca', 'lejos', 'así', 'quizás',
  'quizá', 'tal', 'vez', 'veces', 'ser', 'estar', 'haber', 'tener', 'hacer',
  'poder', 'poner', 'decir', 'dar', 'ver', 'saber', 'querer', 'llegar',
  'pasar', 'deber', 'crear', 'creo', 'cree', 'creen', 'buscar', 'encontrar',
  'llevar', 'dejar', 'abrir', 'cerrar', 'subir', 'bajar', 'entrar', 'salir',
  'volver', 'empezar', 'comenzar', 'terminar', 'acabar', 'quedar', 'llegar',
  'pensar', 'considerar', 'necesitar', 'utilizar', 'usar', 'través',
  'partir', 'base', 'cuenta', 'forma', 'parte', 'tipo', 'medio', 'tanto',
  'tan', 'gran', 'mayor', 'menor', 'mejor', 'peor', 'primero', 'último',
  'nuevo', 'nueva', 'nuevos', 'nuevas', 'buen', 'buena', 'buenos', 'buenas',
  'malo', 'mala', 'malos', 'malas', 'cualquier', 'cualquiera', 'demás',
  'ambos', 'ambas', 'propio', 'propia', 'propios', 'propias',
]);

interface RawInitiative {
  title: string;
  description?: string;
  quadrant: string;
}

export default function NubePalabras() {
  const [initiatives, setInitiatives] = useState<RawInitiative[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [minOccurrences, setMinOccurrences] = useState(1);

  useEffect(() => {
    const loadData = async () => {
      try {
        const { data, error: err } = await supabase
          .from('initiatives')
          .select('title, description, quadrant')
          .in('status', ['activa', 'archivada'])
          .limit(2000);
        if (err) throw err;
        setInitiatives(data ?? []);
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

  const wordCloudData = useMemo(() => {
    const freq = new Map<string, { count: number; related: RawInitiative[] }>();
    for (const ini of initiatives) {
      const title = ini.title || '';
      const desc = ini.description || '';
      if (!title && !desc) continue;
      const text = `${title} ${desc}`.toLowerCase();
      const cleaned = text.replace(/[^a-záéíóúüñ0-9\s]/g, ' ');
      const words = cleaned.split(/\s+/).filter(Boolean);
      const seen = new Set<string>();
      for (const word of words) {
        if (word.length < 3) continue;
        if (SPANISH_STOP_WORDS.has(word)) continue;
        if (seen.has(word)) continue;
        seen.add(word);
        if (freq.has(word)) {
          const entry = freq.get(word)!;
          entry.count++;
          if (entry.related.length < 50) entry.related.push(ini);
        } else {
          freq.set(word, { count: 1, related: [ini] });
        }
      }
    }
    const entries = Array.from(freq.entries())
      .filter(([_, v]) => v.count >= minOccurrences)
      .sort((a, b) => b[1].count - a[1].count)
      .slice(0, 100);

    return entries.map(([keyword, data]) => {
      const quadrantCounts: Record<string, number> = {};
      data.related.forEach((i) => {
        const q = i.quadrant || 'descarte';
        quadrantCounts[q] = (quadrantCounts[q] || 0) + 1;
      });
      const dominant = Object.entries(quadrantCounts).sort((a, b) => b[1] - a[1])[0]?.[0];
      return {
        keyword,
        occurrences: data.count,
        quadrant: dominant,
        initiatives: data.related.slice(0, 20).map((i) => ({
          title: i.title,
        })),
      };
    });
  }, [initiatives, minOccurrences]);

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

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-gray-900">Nube de Palabras</h1>
        <p className="text-sm text-gray-500 mt-1">
          Términos más frecuentes extraídos dinámicamente de los títulos y descripciones de las iniciativas.
          Se actualiza automáticamente cada 30 segundos.
        </p>
      </div>

      <div className="bg-white rounded-xl border border-gray-200 p-4 flex items-center gap-4">
        <label className="text-sm font-medium text-gray-700">
          Frecuencia mínima:
        </label>
        <div className="flex gap-2">
          {[1, 2, 3, 4, 5].map((n) => (
            <button
              key={n}
              onClick={() => setMinOccurrences(n)}
              className={`px-3 py-1.5 text-sm rounded-lg border transition-colors ${
                minOccurrences === n
                  ? 'bg-primary-500 text-white border-primary-500'
                  : 'bg-white text-gray-600 border-gray-300 hover:border-primary-300'
              }`}
            >
              {n === 1 ? 'Todas' : `≥ ${n}`}
            </button>
          ))}
        </div>
        <span className="text-xs text-gray-400 ml-auto">
          {wordCloudData.length} palabras mostradas de {initiatives.length} iniciativas
        </span>
      </div>

      {wordCloudData.length === 0 ? (
        <div className="h-80 flex items-center justify-center text-gray-400 text-sm">
          No hay suficientes palabras clave aún
        </div>
      ) : (
        <WordCloudComponent data={wordCloudData} />
      )}

      <div className="bg-white rounded-xl border border-gray-200 p-5">
        <h3 className="text-sm font-semibold text-gray-700 mb-4">
          Listado de Términos por Frecuencia ({wordCloudData.length})
        </h3>
        {wordCloudData.length === 0 ? (
          <p className="text-sm text-gray-400">No hay suficientes palabras clave aún</p>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead>
                <tr className="border-b border-gray-200">
                  <th className="text-left py-2 px-3 font-medium text-gray-500">
                    #
                  </th>
                  <th className="text-left py-2 px-3 font-medium text-gray-500">
                    Palabra Clave
                  </th>
                  <th className="text-center py-2 px-3 font-medium text-gray-500">
                    Cuadrante
                  </th>
                  <th className="text-right py-2 px-3 font-medium text-gray-500">
                    Ocurrencias
                  </th>
                </tr>
              </thead>
              <tbody>
                {wordCloudData.map((item, index) => (
                  <tr
                    key={item.keyword}
                    className="border-b border-gray-50 hover:bg-gray-50 transition-colors"
                  >
                    <td className="py-2 px-3 text-gray-400">{index + 1}</td>
                    <td className="py-2 px-3 font-medium text-gray-800">
                      {item.keyword}
                    </td>
                    <td className="py-2 px-3 text-center">
                      {item.quadrant && (
                        <span className={`inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium ${
                          item.quadrant === 'hacer_ya' ? 'bg-emerald-100 text-emerald-700' :
                          item.quadrant === 'estrategico_aliados' ? 'bg-amber-100 text-amber-700' :
                          item.quadrant === 'rutina' ? 'bg-blue-100 text-blue-700' :
                          'bg-gray-100 text-gray-500'
                        }`}>
                          {item.quadrant === 'hacer_ya' ? 'HACER YA' :
                           item.quadrant === 'estrategico_aliados' ? 'ESTRATÉGICO' :
                           item.quadrant === 'rutina' ? 'RUTINA' : 'DESCARTE'}
                        </span>
                      )}
                    </td>
                    <td className="py-2 px-3 text-right">
                      <span className="inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium bg-primary-50 text-primary-700">
                        {item.occurrences}
                      </span>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
}
