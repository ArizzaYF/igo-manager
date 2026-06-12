-- =============================================================
-- ALIMENTACIÓN EXTRA - IGO MANAGER
-- Datos demo adicionales para poblar el Panel Admin
-- =============================================================
-- EJECUCIÓN:
-- 1) Abrir Supabase > SQL Editor.
-- 2) Pegar TODO este script.
-- 3) Ejecutar.
--
-- NOTA: No modifica db_reconstruida.sql.
-- Solo INSERT con ON CONFLICT para evitar duplicados.
-- =============================================================

-- =============================================================
-- 1. USUARIOS ADICIONALES (12 nuevos)
-- =============================================================
INSERT INTO public.app_users (id, email, password_plain_demo, password_hash, full_name, user_type, email_confirmed, is_active, last_sign_in_at, created_at, updated_at)
VALUES
  ('a0000000-0000-0000-0000-000000000001', 'pedro.ramirez@demo.com',    'Emprende123*', crypt('Emprende123*', gen_salt('bf')), 'Pedro Ramírez',    'emprendedor', true, true, now() - interval '3 days',  now() - interval '150 days', now()),
  ('a0000000-0000-0000-0000-000000000002', 'ana.rodriguez@demo.com',   'Emprende123*', crypt('Emprende123*', gen_salt('bf')), 'Ana Rodríguez',    'emprendedor', true, true, now() - interval '1 day',  now() - interval '135 days', now()),
  ('a0000000-0000-0000-0000-000000000003', 'jorge.medina@demo.com',    'Emprende123*', crypt('Emprende123*', gen_salt('bf')), 'Jorge Medina',     'emprendedor', true, true, now() - interval '7 days',  now() - interval '120 days', now()),
  ('a0000000-0000-0000-0000-000000000004', 'carmen.lopez@demo.com',    'Emprende123*', crypt('Emprende123*', gen_salt('bf')), 'Carmen López',     'emprendedor', true, true, now() - interval '2 days',  now() - interval '100 days', now()),
  ('a0000000-0000-0000-0000-000000000005', 'diego.arias@demo.com',     'Emprende123*', crypt('Emprende123*', gen_salt('bf')), 'Diego Arias',      'emprendedor', true, true, now() - interval '10 days', now() - interval '85 days',  now()),
  ('a0000000-0000-0000-0000-000000000006', 'valentina.moreno@demo.com','Emprende123*', crypt('Emprende123*', gen_salt('bf')), 'Valentina Moreno', 'emprendedor', true, true, now() - interval '5 days',  now() - interval '70 days',  now()),
  ('a0000000-0000-0000-0000-000000000007', 'fernando.rivas@demo.com',  'Emprende123*', crypt('Emprende123*', gen_salt('bf')), 'Fernando Rivas',   'emprendedor', true, true, now() - interval '15 days', now() - interval '55 days',  now()),
  ('a0000000-0000-0000-0000-000000000008', 'patricia.duce@demo.com',   'Emprende123*', crypt('Emprende123*', gen_salt('bf')), 'Patricia Duce',    'emprendedor', true, true, now() - interval '8 days',  now() - interval '40 days',  now()),
  ('a0000000-0000-0000-0000-000000000009', 'roberto.salas@demo.com',   'Emprende123*', crypt('Emprende123*', gen_salt('bf')), 'Roberto Salas',    'emprendedor', true, true, now() - interval '20 days', now() - interval '30 days',  now()),
  ('a0000000-0000-0000-0000-00000000000a', 'lucia.velez@demo.com',     'Emprende123*', crypt('Emprende123*', gen_salt('bf')), 'Lucía Vélez',      'emprendedor', true, true, now() - interval '4 days',  now() - interval '20 days',  now()),
  ('a0000000-0000-0000-0000-00000000000b', 'mario.gil@demo.com',       'Emprende123*', crypt('Emprende123*', gen_salt('bf')), 'Mario Gil',        'emprendedor', true, true, now() - interval '12 days', now() - interval '10 days',  now()),
  ('a0000000-0000-0000-0000-00000000000c', 'elena.castro@demo.com',    'Emprende123*', crypt('Emprende123*', gen_salt('bf')), 'Elena Castro',     'emprendedor', true, true, now() - interval '6 days',  now() - interval '5 days',   now())
ON CONFLICT (id) DO UPDATE SET
  email = EXCLUDED.email,
  password_plain_demo = EXCLUDED.password_plain_demo,
  password_hash = EXCLUDED.password_hash,
  full_name = EXCLUDED.full_name,
  user_type = EXCLUDED.user_type,
  email_confirmed = EXCLUDED.email_confirmed,
  is_active = EXCLUDED.is_active,
  last_sign_in_at = EXCLUDED.last_sign_in_at,
  updated_at = now();

-- =============================================================
-- 2. PERFILES ADICIONALES (variedad demográfica)
-- =============================================================
INSERT INTO public.profiles (id, full_name, company_name, email, phone, sector, company_size, age_range, gender, auth_provider, terms_accepted, terms_accepted_at, is_active, last_seen_at, created_at, updated_at)
VALUES
  ('a0000000-0000-0000-0000-000000000001', 'Pedro Ramírez',    'BioAgro Colombia',        'pedro.ramirez@demo.com',    '3101000001', 'Agro',          'Mediana <200', '46-55', 'Masculino', 'email', true, now() - interval '150 days', true, now() - interval '3 days',  now() - interval '150 days', now()),
  ('a0000000-0000-0000-0000-000000000002', 'Ana Rodríguez',    'DataSmart SAS',           'ana.rodriguez@demo.com',   '3101000002', 'Tecnología',    'Pequeña <50',  '26-35', 'Femenino',  'email', true, now() - interval '135 days', true, now() - interval '1 day',  now() - interval '135 days', now()),
  ('a0000000-0000-0000-0000-000000000003', 'Jorge Medina',     'Medina Consultores',       'jorge.medina@demo.com',    '3101000003', 'Servicios',     'Micro <10',    '+56',   'Masculino', 'email', true, now() - interval '120 days', true, now() - interval '7 days',  now() - interval '120 days', now()),
  ('a0000000-0000-0000-0000-000000000004', 'Carmen López',     'Distribuciones López',     'carmen.lopez@demo.com',    '3101000004', 'Comercio',      'Grande',       '36-45', 'Femenino',  'email', true, now() - interval '100 days', true, now() - interval '2 days',  now() - interval '100 days', now()),
  ('a0000000-0000-0000-0000-000000000005', 'Diego Arias',      'Clínica Vital',            'diego.arias@demo.com',     '3101000005', 'Salud',         'Mediana <200', '36-45', 'Masculino', 'email', true, now() - interval '85 days',  true, now() - interval '10 days', now() - interval '85 days',  now()),
  ('a0000000-0000-0000-0000-000000000006', 'Valentina Moreno', 'EcoTurismo Colombia',      'valentina.moreno@demo.com','3101000006', 'Turismo',       'Pequeña <50',  '18-25', 'Femenino',  'email', true, now() - interval '70 days',  true, now() - interval '5 days',  now() - interval '70 days',  now()),
  ('a0000000-0000-0000-0000-000000000007', 'Fernando Rivas',   'AprendeLab',               'fernando.rivas@demo.com',  '3101000007', 'Educación',     'Idea',         '26-35', 'Masculino', 'email', true, now() - interval '55 days',  true, now() - interval '15 days', now() - interval '55 days',  now()),
  ('a0000000-0000-0000-0000-000000000008', 'Patricia Duce',    'Moda Circular',            'patricia.duce@demo.com',   '3101000008', 'Calzado/Moda',  'Micro <10',    '46-55', 'Femenino',  'email', true, now() - interval '40 days',  true, now() - interval '8 days',  now() - interval '40 days',  now()),
  ('a0000000-0000-0000-0000-000000000009', 'Roberto Salas',    'Soluciones Empresariales', 'roberto.salas@demo.com',   '3101000009', 'Servicios',     'Grande',       '+56',   'Masculino', 'email', true, now() - interval '30 days',  true, now() - interval '20 days', now() - interval '30 days',  now()),
  ('a0000000-0000-0000-0000-00000000000a', 'Lucía Vélez',      'Salud en Casa',            'lucia.velez@demo.com',     '3101000010', 'Salud',         'Idea',         '18-25', 'Femenino',  'email', true, now() - interval '20 days',  true, now() - interval '4 days',  now() - interval '20 days',  now()),
  ('a0000000-0000-0000-0000-00000000000b', 'Mario Gil',        'Turismo Raíz',             'mario.gil@demo.com',       '3101000011', 'Turismo',       'Micro <10',    '36-45', 'Masculino', 'email', true, now() - interval '10 days',  true, now() - interval '12 days', now() - interval '10 days',  now()),
  ('a0000000-0000-0000-0000-00000000000c', 'Elena Castro',     'InnovaTech',               'elena.castro@demo.com',    '3101000012', 'Tecnología',    'Pequeña <50',  '26-35', 'Otro',      'email', true, now() - interval '5 days',   true, now() - interval '6 days',  now() - interval '5 days',   now())
ON CONFLICT (id) DO UPDATE SET
  full_name = EXCLUDED.full_name,
  company_name = EXCLUDED.company_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  sector = EXCLUDED.sector,
  company_size = EXCLUDED.company_size,
  age_range = EXCLUDED.age_range,
  gender = EXCLUDED.gender,
  auth_provider = EXCLUDED.auth_provider,
  terms_accepted = EXCLUDED.terms_accepted,
  terms_accepted_at = EXCLUDED.terms_accepted_at,
  is_active = EXCLUDED.is_active,
  last_seen_at = EXCLUDED.last_seen_at,
  updated_at = now();

-- =============================================================
-- 3. INICIATIVAS ADICIONALES (24 nuevas, 2 por usuario)
--    Distribuidas en todos los cuadrantes IGO
-- =============================================================
INSERT INTO public.initiatives (user_id, title, description, importance, governability, status, classified_at, created_at, updated_at)
VALUES
  -- Pedro Ramírez (Agro)
  ('a0000000-0000-0000-0000-000000000001', 'Implementar sistema de riego inteligente',          'Automatizar el riego con sensores de humedad para optimizar agua y aumentar rendimiento.',                8, 7, 'activa',    now() - interval '140 days', now() - interval '140 days', now()),
  ('a0000000-0000-0000-0000-000000000001', 'Exportar café orgánico a mercado europeo',          'Alta oportunidad de venta, pero requiere certificaciones y contactos internacionales.',                   9, 3, 'activa',    now() - interval '130 days', now() - interval '130 days', now()),

  -- Ana Rodríguez (Tecnología)
  ('a0000000-0000-0000-0000-000000000002', 'Desarrollar plataforma SaaS de facturación',        'Producto escalable para pymes con alto potencial de recurrencia mensual.',                               9, 8, 'activa',    now() - interval '125 days', now() - interval '125 days', now()),
  ('a0000000-0000-0000-0000-000000000002', 'Integrar inteligencia artificial para predicción',  'Requiere inversión en talento especializado y datos de entrenamiento.',                                 7, 4, 'activa',    now() - interval '115 days', now() - interval '115 days', now()),

  -- Jorge Medina (Servicios)
  ('a0000000-0000-0000-0000-000000000003', 'Lanzar programa de mentoría empresarial',           'Servicio de alto valor con bajo costo operativo, fácil de escalar.',                                   7, 9, 'activa',    now() - interval '110 days', now() - interval '110 days', now()),
  ('a0000000-0000-0000-0000-000000000003', 'Crear alianza con gremios para consultoría masiva', 'Puede multiplicar clientes pero requiere acuerdos institucionales complejos.',                           9, 5, 'activa',    now() - interval '105 days', now() - interval '105 days', now()),

  -- Carmen López (Comercio)
  ('a0000000-0000-0000-0000-000000000004', 'Abrir tienda física en centro comercial',            'Alto tráfico de clientes potenciales con inversión controlada.',                                       8, 8, 'archivada',  now() - interval '95 days',  now() - interval '95 days',  now()),
  ('a0000000-0000-0000-0000-000000000004', 'Implementar sistema de fidelización omnicanal',     'Integrar canales digitales y físicos para retener clientes.',                                          8, 6, 'activa',    now() - interval '90 days',  now() - interval '90 days',  now()),

  -- Diego Arias (Salud)
  ('a0000000-0000-0000-0000-000000000005', 'Implementar telemedicina para consultas externas',   'Alta demanda post-pandemia, requiere plataforma y capacitación médica.',                               9, 7, 'activa',    now() - interval '80 days',  now() - interval '80 days',  now()),
  ('a0000000-0000-0000-0000-000000000005', 'Adquirir equipo de resonancia magnética',           'Mejora capacidad diagnóstica pero requiere inversión millonaria y personal especializado.',             6, 2, 'activa',    now() - interval '75 days',  now() - interval '75 days',  now()),

  -- Valentina Moreno (Turismo)
  ('a0000000-0000-0000-0000-000000000006', 'Crear paquetes de turismo comunitario',              'Diferenciación en mercado local con alto impacto social.',                                             7, 8, 'activa',    now() - interval '65 days',  now() - interval '65 days',  now()),
  ('a0000000-0000-0000-0000-000000000006', 'Desarrollar plataforma de reservas directas',        'Evitar comisiones de OTAs y captar clientes directos.',                                               8, 5, 'activa',    now() - interval '60 days',  now() - interval '60 days',  now()),

  -- Fernando Rivas (Educación)
  ('a0000000-0000-0000-0000-000000000007', 'Crear curso virtual de inglés técnico',               'Alta demanda laboral, contenido escalable y bajo costo de distribución.',                             8, 9, 'activa',    now() - interval '50 days',  now() - interval '50 days',  now()),
  ('a0000000-0000-0000-0000-000000000007', 'Desarrollar app de realidad aumentada educativa',    'Innovador pero requiere inversión en desarrollo 3D y prueba pedagógica.',                             6, 3, 'eliminada', now() - interval '45 days',  now() - interval '45 days',  now()),

  -- Patricia Duce (Calzado/Moda)
  ('a0000000-0000-0000-0000-000000000008', 'Lanzar línea de calzado con materiales reciclados',  'Diferenciación sostenible con creciente demanda de consumidores conscientes.',                         9, 7, 'activa',    now() - interval '35 days',  now() - interval '35 days',  now()),
  ('a0000000-0000-0000-0000-000000000008', 'Crear tienda online con probador virtual',           'Tecnología atractiva pero requiere desarrollo y prueba de experiencia de usuario.',                    7, 4, 'activa',    now() - interval '30 days',  now() - interval '30 days',  now()),

  -- Roberto Salas (Servicios - Grande)
  ('a0000000-0000-0000-0000-000000000009', 'Digitalizar procesos de gestión documental',          'Reducir costos operativos y mejorar eficiencia interna.',                                             6, 9, 'activa',    now() - interval '25 days',  now() - interval '25 days',  now()),
  ('a0000000-0000-0000-0000-000000000009', 'Expandir operaciones a mercado centroamericano',     'Alto crecimiento potencial pero implica riesgos cambiarios y legales.',                              9, 4, 'activa',    now() - interval '20 days',  now() - interval '20 days',  now()),

  -- Lucía Vélez (Salud - Idea)
  ('a0000000-0000-0000-0000-00000000000a', 'Crear app de acompañamiento para adultos mayores',   'Necesidad social creciente con modelo freemium viable.',                                             7, 7, 'activa',    now() - interval '15 days',  now() - interval '15 days',  now()),
  ('a0000000-0000-0000-0000-00000000000a', 'Conseguir aliados farmacéuticos para distribución',  'Clave para escalar pero requiere negociaciones y validación regulatoria.',                            8, 5, 'activa',    now() - interval '12 days',  now() - interval '12 days',  now()),

  -- Mario Gil (Turismo - Micro)
  ('a0000000-0000-0000-0000-00000000000b', 'Crear ruta turística gastronómica local',             'Atractivo para turistas extranjeros con bajo presupuesto de implementación.',                         6, 8, 'activa',    now() - interval '8 days',   now() - interval '8 days',   now()),
  ('a0000000-0000-0000-0000-00000000000b', 'Diseñar sitio web multilingüe para reservas',        'Esencial para captar turistas internacionales, requiere traducción y mantenimiento.',                 7, 5, 'archivada', now() - interval '6 days',   now() - interval '6 days',   now()),

  -- Elena Castro (Tecnología)
  ('a0000000-0000-0000-0000-00000000000c', 'Crear microservicios de pago para apps terceros',    'Producto SaaS con alto margen y mercado en expansión.',                                              9, 7, 'activa',    now() - interval '3 days',   now() - interval '3 days',   now()),
  ('a0000000-0000-0000-0000-00000000000c', 'Desarrollar herramienta de análisis de datos',        'Complemento estratégico para clientes existentes, requiere equipo data science.',                     8, 6, 'activa',    now() - interval '2 days',   now() - interval '2 days',   now())
ON CONFLICT DO NOTHING;

-- =============================================================
-- 4. EVENTOS DE INICIATIVAS
-- =============================================================
INSERT INTO public.initiative_events (initiative_id, user_id, event_type, event_payload, created_at)
SELECT i.id, i.user_id, 'created_and_classified',
  jsonb_build_object('importance', i.importance, 'governability', i.governability, 'quadrant', i.quadrant, 'label', public.get_igo_quadrant_label(i.quadrant)),
  i.created_at
FROM public.initiatives i
WHERE i.created_at >= now() - interval '150 days'
  AND i.id NOT IN (SELECT ie.initiative_id FROM public.initiative_events ie)
ON CONFLICT DO NOTHING;

-- =============================================================
-- 5. PLANES DE ACCIÓN (iniciativas de cuadrante I y II)
-- =============================================================
WITH plan_data AS (
  SELECT * FROM (VALUES
    ('Implementar sistema de riego inteligente',        now() + interval '20 days',  25000000::numeric,  ARRAY['Proveedor de tecnología', 'Ingeniero agrónomo', 'SENA']::text[],                               'Pedro Ramírez',    'en_proceso'::public.plan_status),
    ('Desarrollar plataforma SaaS de facturación',      now() + interval '45 days',  60000000::numeric,  ARRAY['Desarrollador full-stack', 'Diseñador UI/UX', 'Contador']::text[],                        'Ana Rodríguez',    'en_proceso'::public.plan_status),
    ('Lanzar programa de mentoría empresarial',         now() + interval '15 days',  5000000::numeric,   ARRAY['Mentores invitados', 'Cámara de Comercio', 'Diseñador gráfico']::text[],                'Jorge Medina',     'en_proceso'::public.plan_status),
    ('Implementar telemedicina para consultas externas',now() + interval '60 days',  45000000::numeric,  ARRAY['Proveedor plataforma telesalud', 'Médicos especialistas', 'Área jurídica']::text[],           'Diego Arias',      'pendiente'::public.plan_status),
    ('Crear paquetes de turismo comunitario',           now() + interval '25 days',  8000000::numeric,   ARRAY['Comunidades locales', 'Operador turístico', 'Fotógrafo']::text[],                          'Valentina Moreno', 'en_proceso'::public.plan_status),
    ('Crear curso virtual de inglés técnico',           now() + interval '30 days',  15000000::numeric,  ARRAY['Docente inglés técnico', 'Plataforma LMS', 'Diseñador instruccional']::text[],             'Fernando Rivas',   'en_proceso'::public.plan_status),
    ('Lanzar línea de calzado con materiales reciclados',now() + interval '40 days', 35000000::numeric,  ARRAY['Proveedor materiales reciclados', 'Diseñador calzado', 'Community manager']::text[],         'Patricia Duce',    'pendiente'::public.plan_status),
    ('Crear app de acompañamiento para adultos mayores',now() + interval '50 days',  22000000::numeric,  ARRAY['Desarrollador móvil', 'Geriatra', 'Trabajador social']::text[],                             'Lucía Vélez',      'pendiente'::public.plan_status),
    ('Crear microservicios de pago para apps terceros', now() + interval '35 days',  55000000::numeric,  ARRAY['Desarrollador backend', 'Proveedor pasarela pagos', 'Abogado']::text[],                     'Elena Castro',     'en_proceso'::public.plan_status)
  ) AS t(initiative_title, deadline_at, estimated_budget, allies, responsible, status)
)
INSERT INTO public.action_plans (initiative_id, user_id, deadline_at, estimated_budget, allies, responsible, status, progress_percent, created_at, updated_at)
SELECT i.id, i.user_id, pd.deadline_at, pd.estimated_budget, pd.allies, pd.responsible, pd.status, 0, now() - interval '2 days', now()
FROM plan_data pd
JOIN public.initiatives i ON i.title = pd.initiative_title
ON CONFLICT (initiative_id) DO UPDATE SET
  deadline_at = EXCLUDED.deadline_at,
  estimated_budget = EXCLUDED.estimated_budget,
  allies = EXCLUDED.allies,
  responsible = EXCLUDED.responsible,
  status = EXCLUDED.status,
  updated_at = now();

-- =============================================================
-- 6. TAREAS POR PLAN DE ACCIÓN
-- =============================================================
WITH task_data AS (
  SELECT * FROM (VALUES
    ('Implementar sistema de riego inteligente', 'Seleccionar sensores y proveedores', 'Comparar opciones de sensores de humedad, caudal y automatización.', 'Proveedor de tecnología', (current_date + 5),  'terminado'::public.task_status, 1),
    ('Implementar sistema de riego inteligente', 'Diseñar plano de instalación',      'Mapear zonas de cultivo y puntos de riego.',                          'Ingeniero agrónomo',     (current_date + 10), 'en_proceso'::public.task_status, 2),
    ('Implementar sistema de riego inteligente', 'Instalar y probar sistema piloto',  'Implementar en una hectárea y medir resultados.',                     'Pedro Ramírez',          (current_date + 18), 'pendiente'::public.task_status, 3),

    ('Desarrollar plataforma SaaS de facturación', 'Definir MVP y user stories', 'Especificar funcionalidades críticas del primer release.',         'Ana Rodríguez',          (current_date + 7),  'terminado'::public.task_status, 1),
    ('Desarrollar plataforma SaaS de facturación', 'Crear prototipo UI',        'Diseñar pantallas principales y flujo de usuario.',                 'Diseñador UI/UX',        (current_date + 15), 'en_proceso'::public.task_status, 2),
    ('Desarrollar plataforma SaaS de facturación', 'Desarrollar backend',       'Construir API REST con autenticación y módulo de facturación.',      'Desarrollador full-stack',(current_date + 35), 'pendiente'::public.task_status, 3),

    ('Lanzar programa de mentoría empresarial', 'Reclutar 5 mentores',      'Identificar empresarios dispuestos a mentorizar.',                    'Jorge Medina',           (current_date + 4),  'terminado'::public.task_status, 1),
    ('Lanzar programa de mentoría empresarial', 'Diseñar estructura del programa', 'Definir duración, sesiones y entregables.',                            'Mentores invitados',     (current_date + 10), 'en_proceso'::public.task_status, 2),
    ('Lanzar programa de mentoría empresarial', 'Lanzar convocatoria piloto', 'Difundir entre 20 empresarios locales.',                              'Cámara de Comercio',     (current_date + 14), 'pendiente'::public.task_status, 3),

    ('Implementar telemedicina para consultas externas', 'Evaluar plataformas disponibles', 'Comparar opciones del mercado y seleccionar proveedor.',              'Proveedor plataforma telesalud', (current_date + 15), 'pendiente'::public.task_status, 1),
    ('Implementar telemedicina para consultas externas', 'Adecuar instalaciones',          'Habilitar consultorios con equipos de videoconferencia.',            'Diego Arias',            (current_date + 35), 'pendiente'::public.task_status, 2),
    ('Implementar telemedicina para consultas externas', 'Capacitar personal médico',      'Entrenar en uso de plataforma y protocolos.',                        'Médicos especialistas',  (current_date + 50), 'pendiente'::public.task_status, 3),

    ('Crear paquetes de turismo comunitario', 'Identificar comunidades participantes', 'Visitar y seleccionar 3 comunidades.',                                'Valentina Moreno',       (current_date + 5),  'terminado'::public.task_status, 1),
    ('Crear paquetes de turismo comunitario', 'Diseñar itinerarios',               'Crear recorridos de 1 y 2 días con actividades locales.',            'Operador turístico',     (current_date + 15), 'en_proceso'::public.task_status, 2),
    ('Crear paquetes de turismo comunitario', 'Producir material promocional',     'Fotos, videos y contenido para redes.',                              'Fotógrafo',              (current_date + 23), 'pendiente'::public.task_status, 3),

    ('Crear curso virtual de inglés técnico', 'Estructurar 5 módulos del curso', 'Definir objetivos, vocabulario técnico y evaluaciones.',              'Docente inglés técnico', (current_date + 8),  'terminado'::public.task_status, 1),
    ('Crear curso virtual de inglés técnico', 'Grabar video lecciones',          'Producir contenido multimedia profesional.',                         'Fernando Rivas',         (current_date + 20), 'en_proceso'::public.task_status, 2),
    ('Crear curso virtual de inglés técnico', 'Publicar en plataforma LMS',      'Configurar evaluaciones, certificados y precios.',                    'Plataforma LMS',         (current_date + 28), 'pendiente'::public.task_status, 3),

    ('Lanzar línea de calzado con materiales reciclados', 'Contactar proveedores de materiales', 'Buscar y evaluar 3 proveedores de caucho reciclado y textiles.',      'Proveedor materiales reciclados', (current_date + 10), 'pendiente'::public.task_status, 1),
    ('Lanzar línea de calzado con materiales reciclados', 'Crear prototipos',                   'Diseñar 3 modelos y producir muestras.',                              'Diseñador calzado',      (current_date + 25), 'pendiente'::public.task_status, 2),
    ('Lanzar línea de calzado con materiales reciclados', 'Planear lanzamiento campaña',        'Preparar anuncios, influencers y contenido sostenible.',              'Community manager',      (current_date + 38), 'pendiente'::public.task_status, 3),

    ('Crear app de acompañamiento para adultos mayores', 'Validar necesidad con 10 familias', 'Entrevistar cuidadores y adultos mayores.',                            'Lucía Vélez',            (current_date + 7),  'pendiente'::public.task_status, 1),
    ('Crear app de acompañamiento para adultos mayores', 'Diseñar MVP de la app',             'Pantallas: registro, perfil, agenda, alertas.',                        'Desarrollador móvil',    (current_date + 25), 'pendiente'::public.task_status, 2),
    ('Crear app de acompañamiento para adultos mayores', 'Configurar alertas y notificaciones','Integrar recordatorios y contactos de emergencia.',                     'Desarrollador móvil',    (current_date + 40), 'pendiente'::public.task_status, 3),

    ('Crear microservicios de pago para apps terceros', 'Diseñar arquitectura de APIs',    'Definir endpoints, autenticación y manejo de errores.',               'Desarrollador backend',  (current_date + 5),  'terminado'::public.task_status, 1),
    ('Crear microservicios de pago para apps terceros', 'Implementar sandbox de pruebas',  'Crear ambiente con datos simulados para onboarding.',                  'Desarrollador backend',  (current_date + 18), 'en_proceso'::public.task_status, 2),
    ('Crear microservicios de pago para apps terceros', 'Documentar API pública',          'Escribir documentación técnica con ejemplos de integración.',          'Elena Castro',           (current_date + 30), 'pendiente'::public.task_status, 3)
  ) AS t(initiative_title, task_title, description, responsible, due_date, status, sort_order)
)
INSERT INTO public.action_plan_tasks (plan_id, title, description, responsible, due_date, status, sort_order, created_at, updated_at)
SELECT ap.id, td.task_title, td.description, td.responsible, td.due_date, td.status, td.sort_order, now() - interval '1 day', now()
FROM task_data td
JOIN public.initiatives i ON i.title = td.initiative_title
JOIN public.action_plans ap ON ap.initiative_id = i.id
ON CONFLICT DO NOTHING;

-- =============================================================
-- 7. RECALCULAR PROGRESO DE PLANES AFECTADOS
-- =============================================================
SELECT public.recalculate_action_plan_progress(ap.id)
FROM public.action_plans ap
WHERE ap.created_at >= now() - interval '10 days';

-- =============================================================
-- 8. DISPOSITIVOS DEMO ADICIONALES
-- =============================================================
INSERT INTO public.notification_devices (user_id, platform, device_token, is_active, last_seen_at, created_at, updated_at)
VALUES
  ('a0000000-0000-0000-0000-000000000001', 'android', 'demo_android_token_pedro_001',  true, now() - interval '3 days',  now() - interval '20 days', now()),
  ('a0000000-0000-0000-0000-000000000002', 'ios',     'demo_ios_token_ana_001',        true, now() - interval '1 day',   now() - interval '15 days', now()),
  ('a0000000-0000-0000-0000-000000000004', 'web',     'demo_web_token_carmen_001',     true, now() - interval '2 days',  now() - interval '10 days', now()),
  ('a0000000-0000-0000-0000-000000000006', 'android', 'demo_android_token_valentina_001', true, now() - interval '5 days', now() - interval '8 days',  now()),
  ('a0000000-0000-0000-0000-00000000000c', 'ios',     'demo_ios_token_elena_001',      true, now() - interval '6 days',  now() - interval '3 days',  now())
ON CONFLICT (device_token) DO UPDATE SET
  is_active = EXCLUDED.is_active,
  last_seen_at = EXCLUDED.last_seen_at,
  updated_at = now();

-- =============================================================
-- 9. NOTIFICACIONES PROGRAMADAS
-- =============================================================
SELECT public.generate_deadline_notifications();
SELECT public.generate_inactivity_notifications();

-- =============================================================
-- FIN
-- =============================================================






-- =============================================================
-- 6. CAMBIO DE CONTRASEÑA
-- =============================================================
CREATE OR REPLACE FUNCTION public.change_password_app_user(
  p_user_id uuid,
  p_current_password text,
  p_new_password text
) RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_stored_hash text;
  v_now timestamptz := now();
  v_result jsonb;
BEGIN
  SELECT password_hash INTO v_stored_hash
  FROM public.app_users
  WHERE id = p_user_id AND is_active = true;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Usuario no encontrado o inactivo';
  END IF;

  IF v_stored_hash IS NULL OR crypt(p_current_password, v_stored_hash) <> v_stored_hash THEN
    RAISE EXCEPTION 'La contraseña actual no es correcta';
  END IF;

  IF length(p_new_password) < 8 THEN
    RAISE EXCEPTION 'La nueva contraseña debe tener al menos 8 caracteres';
  END IF;

  UPDATE public.app_users
  SET
    password_hash = crypt(p_new_password, gen_salt('bf')),
    password_plain_demo = p_new_password,
    updated_at = v_now
  WHERE id = p_user_id;

  SELECT jsonb_build_object(
    'success', true,
    'message', 'Contraseña actualizada exitosamente'
  ) INTO v_result;

  RETURN v_result;
END;
$$;

CREATE OR REPLACE FUNCTION public.register_app_user(
  p_id uuid,
  p_email text,
  p_password text,
  p_full_name text,
  p_phone text,
  p_company_name text,
  p_sector text,
  p_company_size text,
  p_age_range text,
  p_gender text
) RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_now timestamptz := now();
  v_user jsonb;
BEGIN
  INSERT INTO public.app_users (id, email, password_plain_demo, password_hash, full_name, user_type, email_confirmed, is_active, created_at, updated_at)
  VALUES (p_id, p_email, p_password, crypt(p_password, gen_salt('bf')), p_full_name, 'emprendedor', true, true, v_now, v_now);

  INSERT INTO public.profiles (id, full_name, company_name, email, phone, sector, company_size, age_range, gender, auth_provider, terms_accepted, terms_accepted_at, is_active, created_at, updated_at)
  VALUES (p_id, p_full_name, p_company_name, p_email, p_phone, p_sector::public.economic_sector_type, p_company_size::public.company_size_type, p_age_range::public.age_range_type, p_gender::public.gender_type, 'email', true, v_now, true, v_now, v_now);

  SELECT jsonb_build_object(
    'id', p_id, 'email', p_email, 'full_name', p_full_name, 'phone', p_phone,
    'company_name', p_company_name, 'sector', p_sector, 'company_size', p_company_size,
    'age_range', p_age_range, 'gender', p_gender, 'user_type', 'emprendedor',
    'is_active', true, 'created_at', v_now, 'updated_at', v_now
  ) INTO v_user;

  RETURN v_user;
END;
$$;