-- =============================================================
-- DB SUPABASE / POSTGRES - APP MÓVIL "IGO MANAGER"
-- Cliente: Dinámica del Oriente S.A.S.
-- Basado en DRF: Onboarding, Iniciativas, Motor IGO,
-- Cuadrantes, Planes de Acción, Alertas y Dashboard Admin.
-- =============================================================
-- EJECUCIÓN:
-- 1) Abrir Supabase > SQL Editor.
-- 2) Pegar TODO este script.
-- 3) Ejecutar.
--
-- NOTA IMPORTANTE:
-- Este script es para ambiente de desarrollo / demo.
-- Crea tablas, vistas, funciones, triggers, usuarios demo en public.app_users
-- y alimenta la base con datos de prueba.
-- No escribe sobre auth.users porque Supabase no permite que el SQL Editor
-- modifique esa tabla en proyectos normales.
-- =============================================================

-- -------------------------------------------------------------
-- 0. EXTENSIONES
-- -------------------------------------------------------------
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- -------------------------------------------------------------
-- 1. LIMPIEZA DE OBJETOS PÚBLICOS DEL PROYECTO
--    No elimina usuarios existentes de Supabase Auth.
-- -------------------------------------------------------------
DROP VIEW IF EXISTS public.v_admin_high_importance_keywords CASCADE;
DROP VIEW IF EXISTS public.v_admin_igo_matrix_aggregate CASCADE;
DROP VIEW IF EXISTS public.v_admin_quadrant_summary CASCADE;
DROP VIEW IF EXISTS public.v_admin_demographics_gender CASCADE;
DROP VIEW IF EXISTS public.v_admin_demographics_age CASCADE;
DROP VIEW IF EXISTS public.v_admin_demographics_company_size CASCADE;
DROP VIEW IF EXISTS public.v_admin_demographics_sector CASCADE;
DROP VIEW IF EXISTS public.v_admin_users_by_month CASCADE;
DROP VIEW IF EXISTS public.v_admin_kpis CASCADE;
DROP VIEW IF EXISTS public.v_admin_initiatives_anonymized CASCADE;
DROP VIEW IF EXISTS public.v_admin_action_plan_progress CASCADE;

DROP TABLE IF EXISTS public.notification_logs CASCADE;
DROP TABLE IF EXISTS public.notifications CASCADE;
DROP TABLE IF EXISTS public.notification_devices CASCADE;
DROP TABLE IF EXISTS public.action_plan_tasks CASCADE;
DROP TABLE IF EXISTS public.action_plans CASCADE;
DROP TABLE IF EXISTS public.initiative_events CASCADE;
DROP TABLE IF EXISTS public.initiatives CASCADE;
DROP TABLE IF EXISTS public.admin_users CASCADE;
DROP TABLE IF EXISTS public.profiles CASCADE;
DROP TABLE IF EXISTS public.app_users CASCADE;

DROP TYPE IF EXISTS public.notification_status CASCADE;
DROP TYPE IF EXISTS public.notification_type CASCADE;
DROP TYPE IF EXISTS public.device_platform CASCADE;
DROP TYPE IF EXISTS public.task_status CASCADE;
DROP TYPE IF EXISTS public.plan_status CASCADE;
DROP TYPE IF EXISTS public.initiative_status CASCADE;
DROP TYPE IF EXISTS public.igo_quadrant CASCADE;
DROP TYPE IF EXISTS public.auth_provider_type CASCADE;
DROP TYPE IF EXISTS public.admin_role CASCADE;
DROP TYPE IF EXISTS public.gender_type CASCADE;
DROP TYPE IF EXISTS public.age_range_type CASCADE;
DROP TYPE IF EXISTS public.company_size_type CASCADE;
DROP TYPE IF EXISTS public.economic_sector_type CASCADE;

-- -------------------------------------------------------------
-- 2. TIPOS ENUMERADOS SEGÚN EL DRF
-- -------------------------------------------------------------
CREATE TYPE public.economic_sector_type AS ENUM (
  'Agro',
  'Calzado/Moda',
  'Tecnología',
  'Servicios',
  'Comercio',
  'Salud',
  'Turismo',
  'Educación',
  'Otro'
);

CREATE TYPE public.company_size_type AS ENUM (
  'Idea',
  'Micro <10',
  'Pequeña <50',
  'Mediana <200',
  'Grande'
);

CREATE TYPE public.age_range_type AS ENUM (
  '18-25',
  '26-35',
  '36-45',
  '46-55',
  '+56'
);

CREATE TYPE public.gender_type AS ENUM (
  'Masculino',
  'Femenino',
  'Otro'
);

CREATE TYPE public.admin_role AS ENUM (
  'superadmin',
  'analista'
);

CREATE TYPE public.auth_provider_type AS ENUM (
  'email',
  'google',
  'apple'
);

CREATE TYPE public.igo_quadrant AS ENUM (
  'hacer_ya',
  'estrategico_aliados',
  'rutina',
  'descarte'
);

CREATE TYPE public.initiative_status AS ENUM (
  'activa',
  'archivada',
  'eliminada'
);

CREATE TYPE public.plan_status AS ENUM (
  'pendiente',
  'en_proceso',
  'terminado',
  'abortado'
);

CREATE TYPE public.task_status AS ENUM (
  'pendiente',
  'en_proceso',
  'terminado',
  'abortado'
);

CREATE TYPE public.device_platform AS ENUM (
  'android',
  'ios',
  'web'
);

CREATE TYPE public.notification_type AS ENUM (
  'deadline_24h',
  'deadline_1h',
  'inactivity_7d',
  'weekly_summary',
  'custom'
);

CREATE TYPE public.notification_status AS ENUM (
  'programada',
  'enviada',
  'fallida',
  'cancelada'
);

-- -------------------------------------------------------------
-- 3. FUNCIÓN GENERAL PARA updated_at
-- -------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

-- -------------------------------------------------------------
-- 4. TABLAS PRINCIPALES
-- -------------------------------------------------------------

-- 4.0 Usuarios demo de la aplicación
-- IMPORTANTE SUPABASE:
-- Esta tabla reemplaza la inserción directa en auth.users, porque el SQL Editor
-- no es dueño de auth.users y puede lanzar: must be owner of table users.
-- Para un MVP académico/demo, permite iniciar sesión con correo y contraseña
-- desde una autenticación personalizada en la app.
CREATE TABLE public.app_users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email text NOT NULL UNIQUE,
  password_plain_demo text NOT NULL,
  password_hash text NOT NULL,
  full_name text NOT NULL,
  user_type text NOT NULL DEFAULT 'emprendedor',
  email_confirmed boolean NOT NULL DEFAULT true,
  is_active boolean NOT NULL DEFAULT true,
  last_sign_in_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT app_users_email_format_chk CHECK (
    email ~* '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$'
  ),
  CONSTRAINT app_users_type_chk CHECK (
    user_type IN ('admin', 'emprendedor')
  )
);

CREATE INDEX idx_app_users_email ON public.app_users(email);
CREATE INDEX idx_app_users_type ON public.app_users(user_type);

CREATE TRIGGER trg_app_users_updated_at
BEFORE UPDATE ON public.app_users
FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- 4.1 Perfilamiento del emprendedor / usuario final
CREATE TABLE public.profiles (
  id uuid PRIMARY KEY REFERENCES public.app_users(id) ON DELETE CASCADE,
  full_name text NOT NULL,
  company_name text NOT NULL,
  email text NOT NULL UNIQUE,
  phone text NOT NULL,
  sector public.economic_sector_type NOT NULL,
  company_size public.company_size_type NOT NULL,
  age_range public.age_range_type NOT NULL,
  gender public.gender_type NOT NULL,
  auth_provider public.auth_provider_type NOT NULL DEFAULT 'email',
  terms_accepted boolean NOT NULL DEFAULT false,
  terms_accepted_at timestamptz,
  is_active boolean NOT NULL DEFAULT true,
  last_seen_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT profiles_email_format_chk CHECK (
    email ~* '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$'
  ),
  CONSTRAINT profiles_phone_format_chk CHECK (
    phone ~ '^[0-9+ ]{7,20}$'
  ),
  CONSTRAINT profiles_terms_chk CHECK (
    terms_accepted = true AND terms_accepted_at IS NOT NULL
  )
);

CREATE INDEX idx_profiles_sector ON public.profiles(sector);
CREATE INDEX idx_profiles_company_size ON public.profiles(company_size);
CREATE INDEX idx_profiles_created_at ON public.profiles(created_at);

CREATE TRIGGER trg_profiles_updated_at
BEFORE UPDATE ON public.profiles
FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- 4.2 Usuarios administradores para el panel web
CREATE TABLE public.admin_users (
  id uuid PRIMARY KEY REFERENCES public.app_users(id) ON DELETE CASCADE,
  full_name text NOT NULL,
  email text NOT NULL UNIQUE,
  role public.admin_role NOT NULL DEFAULT 'analista',
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT admin_users_email_format_chk CHECK (
    email ~* '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$'
  )
);

CREATE TRIGGER trg_admin_users_updated_at
BEFORE UPDATE ON public.admin_users
FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- 4.3 Iniciativas / ideas / tareas iniciales
-- Corte usado para "Alta" = 6 a 10.
-- Corte usado para "Baja" = 1 a 5.
CREATE TABLE public.initiatives (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  title varchar(160) NOT NULL,
  description text,
  audio_url text,
  transcription_text text,
  importance smallint NOT NULL DEFAULT 5,
  governability smallint NOT NULL DEFAULT 5,
  quadrant public.igo_quadrant GENERATED ALWAYS AS (
    CASE
      WHEN importance >= 6 AND governability >= 6 THEN 'hacer_ya'::public.igo_quadrant
      WHEN importance >= 6 AND governability <= 5 THEN 'estrategico_aliados'::public.igo_quadrant
      WHEN importance <= 5 AND governability >= 6 THEN 'rutina'::public.igo_quadrant
      ELSE 'descarte'::public.igo_quadrant
    END
  ) STORED,
  status public.initiative_status NOT NULL DEFAULT 'activa',
  classified_at timestamptz NOT NULL DEFAULT now(),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT initiatives_importance_chk CHECK (importance BETWEEN 1 AND 10),
  CONSTRAINT initiatives_governability_chk CHECK (governability BETWEEN 1 AND 10)
);

CREATE INDEX idx_initiatives_user_id ON public.initiatives(user_id);
CREATE INDEX idx_initiatives_quadrant ON public.initiatives(quadrant);
CREATE INDEX idx_initiatives_importance_governability ON public.initiatives(importance, governability);
CREATE INDEX idx_initiatives_created_at ON public.initiatives(created_at);
CREATE INDEX idx_initiatives_title_trgm_basic ON public.initiatives USING gin (to_tsvector('spanish', coalesce(title, '') || ' ' || coalesce(description, '')));

CREATE TRIGGER trg_initiatives_updated_at
BEFORE UPDATE ON public.initiatives
FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- 4.4 Historial simple de eventos de iniciativa
CREATE TABLE public.initiative_events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  initiative_id uuid NOT NULL REFERENCES public.initiatives(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  event_type text NOT NULL,
  event_payload jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_initiative_events_initiative_id ON public.initiative_events(initiative_id);
CREATE INDEX idx_initiative_events_user_id ON public.initiative_events(user_id);

-- 4.5 Planes de acción
CREATE TABLE public.action_plans (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  initiative_id uuid NOT NULL UNIQUE REFERENCES public.initiatives(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  deadline_at timestamptz NOT NULL,
  estimated_budget numeric(14,2),
  allies text[] NOT NULL DEFAULT '{}',
  responsible text,
  status public.plan_status NOT NULL DEFAULT 'pendiente',
  progress_percent smallint NOT NULL DEFAULT 0,
  completed_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT action_plans_budget_chk CHECK (estimated_budget IS NULL OR estimated_budget >= 0),
  CONSTRAINT action_plans_progress_chk CHECK (progress_percent BETWEEN 0 AND 100)
);

CREATE INDEX idx_action_plans_user_id ON public.action_plans(user_id);
CREATE INDEX idx_action_plans_deadline_at ON public.action_plans(deadline_at);
CREATE INDEX idx_action_plans_status ON public.action_plans(status);

CREATE TRIGGER trg_action_plans_updated_at
BEFORE UPDATE ON public.action_plans
FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- 4.6 Tareas internas de cada plan de acción
CREATE TABLE public.action_plan_tasks (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  plan_id uuid NOT NULL REFERENCES public.action_plans(id) ON DELETE CASCADE,
  title varchar(160) NOT NULL,
  description text,
  responsible text,
  due_date date,
  budget numeric(14,2),
  status public.task_status NOT NULL DEFAULT 'pendiente',
  sort_order int NOT NULL DEFAULT 1,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT action_plan_tasks_budget_chk CHECK (budget IS NULL OR budget >= 0)
);

CREATE INDEX idx_action_plan_tasks_plan_id ON public.action_plan_tasks(plan_id);
CREATE INDEX idx_action_plan_tasks_status ON public.action_plan_tasks(status);

CREATE TRIGGER trg_action_plan_tasks_updated_at
BEFORE UPDATE ON public.action_plan_tasks
FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- 4.7 Dispositivos para notificaciones push
CREATE TABLE public.notification_devices (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  platform public.device_platform NOT NULL,
  device_token text NOT NULL UNIQUE,
  is_active boolean NOT NULL DEFAULT true,
  last_seen_at timestamptz DEFAULT now(),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_notification_devices_user_id ON public.notification_devices(user_id);

CREATE TRIGGER trg_notification_devices_updated_at
BEFORE UPDATE ON public.notification_devices
FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- 4.8 Notificaciones programadas / enviadas
CREATE TABLE public.notifications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  plan_id uuid REFERENCES public.action_plans(id) ON DELETE CASCADE,
  initiative_id uuid REFERENCES public.initiatives(id) ON DELETE SET NULL,
  type public.notification_type NOT NULL,
  title varchar(160) NOT NULL,
  body text NOT NULL,
  scheduled_at timestamptz NOT NULL,
  sent_at timestamptz,
  status public.notification_status NOT NULL DEFAULT 'programada',
  idempotency_key text UNIQUE,
  metadata jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_notifications_user_id ON public.notifications(user_id);
CREATE INDEX idx_notifications_scheduled_at ON public.notifications(scheduled_at);
CREATE INDEX idx_notifications_status ON public.notifications(status);
CREATE INDEX idx_notifications_type ON public.notifications(type);

CREATE TRIGGER trg_notifications_updated_at
BEFORE UPDATE ON public.notifications
FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- 4.9 Logs de envío de notificaciones
CREATE TABLE public.notification_logs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  notification_id uuid NOT NULL REFERENCES public.notifications(id) ON DELETE CASCADE,
  device_id uuid REFERENCES public.notification_devices(id) ON DELETE SET NULL,
  provider_response jsonb NOT NULL DEFAULT '{}'::jsonb,
  success boolean NOT NULL DEFAULT false,
  error_message text,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_notification_logs_notification_id ON public.notification_logs(notification_id);

-- -------------------------------------------------------------
-- 5. FUNCIONES DE NEGOCIO
-- -------------------------------------------------------------

-- 5.1 Etiqueta visual del cuadrante
CREATE OR REPLACE FUNCTION public.get_igo_quadrant_label(p_quadrant public.igo_quadrant)
RETURNS text
LANGUAGE sql
IMMUTABLE
AS $$
  SELECT CASE p_quadrant
    WHEN 'hacer_ya' THEN '¡HACER YA!'
    WHEN 'estrategico_aliados' THEN 'ESTRATÉGICO/ALIADOS'
    WHEN 'rutina' THEN 'RUTINA'
    WHEN 'descarte' THEN 'DESCARTE'
  END;
$$;

-- 5.2 Acción sugerida según cuadrante
CREATE OR REPLACE FUNCTION public.get_igo_suggested_action(p_quadrant public.igo_quadrant)
RETURNS text
LANGUAGE sql
IMMUTABLE
AS $$
  SELECT CASE p_quadrant
    WHEN 'hacer_ya' THEN 'Crear plan de acción y ejecutar de inmediato.'
    WHEN 'estrategico_aliados' THEN 'Buscar aliados, recursos o capacidades externas antes de ejecutar.'
    WHEN 'rutina' THEN 'Delegar, automatizar o mantener como tarea operativa.'
    WHEN 'descarte' THEN 'Eliminar, archivar o revisar más adelante.'
  END;
$$;

-- 5.3 Recalcular progreso de un plan según sus tareas
CREATE OR REPLACE FUNCTION public.recalculate_action_plan_progress(p_plan_id uuid)
RETURNS void
LANGUAGE plpgsql
AS $$
DECLARE
  v_total int;
  v_done int;
  v_progress int;
BEGIN
  SELECT COUNT(*), COUNT(*) FILTER (WHERE status = 'terminado')
  INTO v_total, v_done
  FROM public.action_plan_tasks
  WHERE plan_id = p_plan_id
    AND status <> 'abortado';

  IF v_total = 0 THEN
    v_progress := 0;
  ELSE
    v_progress := ROUND((v_done::numeric / v_total::numeric) * 100)::int;
  END IF;

  UPDATE public.action_plans
  SET progress_percent = v_progress,
      status = CASE
        WHEN v_total > 0 AND v_progress = 100 THEN 'terminado'::public.plan_status
        WHEN status = 'terminado' AND v_progress < 100 THEN 'en_proceso'::public.plan_status
        ELSE status
      END,
      completed_at = CASE
        WHEN v_total > 0 AND v_progress = 100 THEN COALESCE(completed_at, now())
        WHEN v_progress < 100 THEN NULL
        ELSE completed_at
      END,
      updated_at = now()
  WHERE id = p_plan_id;
END;
$$;

CREATE OR REPLACE FUNCTION public.trg_recalculate_action_plan_progress()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  IF TG_OP = 'DELETE' THEN
    PERFORM public.recalculate_action_plan_progress(OLD.plan_id);
    RETURN OLD;
  ELSE
    PERFORM public.recalculate_action_plan_progress(NEW.plan_id);
    RETURN NEW;
  END IF;
END;
$$;

CREATE TRIGGER trg_action_plan_tasks_recalculate_progress
AFTER INSERT OR UPDATE OR DELETE ON public.action_plan_tasks
FOR EACH ROW EXECUTE FUNCTION public.trg_recalculate_action_plan_progress();

-- 5.4 Generar notificaciones de vencimiento 24h y 1h antes del deadline
CREATE OR REPLACE FUNCTION public.generate_deadline_notifications()
RETURNS void
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO public.notifications (
    user_id,
    plan_id,
    initiative_id,
    type,
    title,
    body,
    scheduled_at,
    status,
    idempotency_key,
    metadata
  )
  SELECT
    ap.user_id,
    ap.id,
    ap.initiative_id,
    'deadline_24h'::public.notification_type,
    'Tu plan vence mañana',
    'Faltan 24 horas para la fecha límite del plan: ' || i.title,
    ap.deadline_at - interval '24 hours',
    'programada'::public.notification_status,
    ap.id::text || ':deadline_24h',
    jsonb_build_object('initiative_title', i.title, 'deadline_at', ap.deadline_at)
  FROM public.action_plans ap
  JOIN public.initiatives i ON i.id = ap.initiative_id
  WHERE ap.status IN ('pendiente', 'en_proceso')
    AND ap.deadline_at > now()
  ON CONFLICT (idempotency_key) DO NOTHING;

  INSERT INTO public.notifications (
    user_id,
    plan_id,
    initiative_id,
    type,
    title,
    body,
    scheduled_at,
    status,
    idempotency_key,
    metadata
  )
  SELECT
    ap.user_id,
    ap.id,
    ap.initiative_id,
    'deadline_1h'::public.notification_type,
    'Tu plan vence pronto',
    'Falta 1 hora para la fecha límite del plan: ' || i.title,
    ap.deadline_at - interval '1 hour',
    'programada'::public.notification_status,
    ap.id::text || ':deadline_1h',
    jsonb_build_object('initiative_title', i.title, 'deadline_at', ap.deadline_at)
  FROM public.action_plans ap
  JOIN public.initiatives i ON i.id = ap.initiative_id
  WHERE ap.status IN ('pendiente', 'en_proceso')
    AND ap.deadline_at > now()
  ON CONFLICT (idempotency_key) DO NOTHING;
END;
$$;

-- 5.5 Generar alertas de inactividad de 7 días
CREATE OR REPLACE FUNCTION public.generate_inactivity_notifications()
RETURNS void
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO public.notifications (
    user_id,
    type,
    title,
    body,
    scheduled_at,
    status,
    idempotency_key,
    metadata
  )
  SELECT
    p.id,
    'inactivity_7d'::public.notification_type,
    'Revisa tus prioridades',
    'Hace 7 días no revisas tus prioridades. Entra y actualiza tus planes.',
    now(),
    'programada'::public.notification_status,
    p.id::text || ':inactivity_7d:' || to_char(now(), 'YYYY-MM-DD'),
    jsonb_build_object('last_seen_at', p.last_seen_at)
  FROM public.profiles p
  WHERE p.is_active = true
    AND COALESCE(p.last_seen_at, p.created_at) <= now() - interval '7 days'
  ON CONFLICT (idempotency_key) DO NOTHING;
END;
$$;

-- -------------------------------------------------------------
-- 6. VISTAS ADMINISTRATIVAS / DASHBOARD ANÓNIMO
-- -------------------------------------------------------------
CREATE OR REPLACE VIEW public.v_admin_kpis AS
SELECT
  (SELECT COUNT(*) FROM public.profiles WHERE is_active = true) AS total_registered_users,
  (SELECT COUNT(*) FROM public.profiles WHERE is_active = true AND created_at >= date_trunc('month', now())) AS users_current_month,
  (SELECT COUNT(*) FROM public.initiatives WHERE status = 'activa') AS active_initiatives,
  (SELECT COUNT(*) FROM public.action_plans WHERE status IN ('pendiente', 'en_proceso')) AS active_action_plans,
  (SELECT COUNT(*) FROM public.action_plans WHERE status = 'terminado') AS completed_action_plans,
  (SELECT COALESCE(ROUND(AVG(importance)::numeric, 2), 0) FROM public.initiatives WHERE status <> 'eliminada') AS avg_importance,
  (SELECT COALESCE(ROUND(AVG(governability)::numeric, 2), 0) FROM public.initiatives WHERE status <> 'eliminada') AS avg_governability;

CREATE OR REPLACE VIEW public.v_admin_users_by_month AS
SELECT
  date_trunc('month', created_at)::date AS month,
  COUNT(*) AS total_users
FROM public.profiles
WHERE is_active = true
GROUP BY 1
ORDER BY 1;

CREATE OR REPLACE VIEW public.v_admin_demographics_sector AS
SELECT sector, COUNT(*) AS total_users
FROM public.profiles
WHERE is_active = true
GROUP BY sector
ORDER BY total_users DESC, sector;

CREATE OR REPLACE VIEW public.v_admin_demographics_company_size AS
SELECT company_size, COUNT(*) AS total_users
FROM public.profiles
WHERE is_active = true
GROUP BY company_size
ORDER BY total_users DESC, company_size;

CREATE OR REPLACE VIEW public.v_admin_demographics_age AS
SELECT age_range, COUNT(*) AS total_users
FROM public.profiles
WHERE is_active = true
GROUP BY age_range
ORDER BY age_range;

CREATE OR REPLACE VIEW public.v_admin_demographics_gender AS
SELECT gender, COUNT(*) AS total_users
FROM public.profiles
WHERE is_active = true
GROUP BY gender
ORDER BY total_users DESC, gender;

CREATE OR REPLACE VIEW public.v_admin_quadrant_summary AS
SELECT
  i.quadrant,
  public.get_igo_quadrant_label(i.quadrant) AS quadrant_label,
  public.get_igo_suggested_action(i.quadrant) AS suggested_action,
  COUNT(*) AS total_initiatives,
  ROUND(AVG(i.importance)::numeric, 2) AS avg_importance,
  ROUND(AVG(i.governability)::numeric, 2) AS avg_governability
FROM public.initiatives i
WHERE i.status <> 'eliminada'
GROUP BY i.quadrant
ORDER BY total_initiatives DESC;

CREATE OR REPLACE VIEW public.v_admin_igo_matrix_aggregate AS
SELECT
  p.sector,
  p.company_size,
  i.quadrant,
  public.get_igo_quadrant_label(i.quadrant) AS quadrant_label,
  COUNT(*) AS total_initiatives,
  ROUND(AVG(i.importance)::numeric, 2) AS avg_importance,
  ROUND(AVG(i.governability)::numeric, 2) AS avg_governability
FROM public.initiatives i
JOIN public.profiles p ON p.id = i.user_id
WHERE i.status <> 'eliminada'
GROUP BY p.sector, p.company_size, i.quadrant
ORDER BY total_initiatives DESC;

-- Vista anónima: permite análisis sin exponer correo, celular ni nombre real.
CREATE OR REPLACE VIEW public.v_admin_initiatives_anonymized AS
SELECT
  md5(i.user_id::text) AS anonymous_user_key,
  p.sector,
  p.company_size,
  p.age_range,
  p.gender,
  i.title,
  i.importance,
  i.governability,
  i.quadrant,
  public.get_igo_quadrant_label(i.quadrant) AS quadrant_label,
  i.status,
  i.created_at
FROM public.initiatives i
JOIN public.profiles p ON p.id = i.user_id
WHERE i.status <> 'eliminada';

-- Mapa de calor / nube de palabras sobre títulos de alta importancia.
CREATE OR REPLACE VIEW public.v_admin_high_importance_keywords AS
WITH raw_words AS (
  SELECT
    regexp_replace(word, '[^a-záéíóúñü0-9]+', '', 'g') AS term
  FROM public.initiatives i
  CROSS JOIN LATERAL regexp_split_to_table(lower(i.title), '\s+') AS word
  WHERE i.status <> 'eliminada'
    AND i.importance >= 6
), filtered_words AS (
  SELECT term
  FROM raw_words
  WHERE length(term) >= 4
    AND term NOT IN (
      'para','como','este','esta','estos','estas','desde','hacia','sobre',
      'crear','hacer','abrir','nuevo','nueva','plan','acción','acciones',
      'empresa','emprendimiento','proyecto','proyectos','idea','ideas',
      'mejorar','implementar','desarrollar','gestionar','lanzar'
    )
)
SELECT
  term AS keyword,
  COUNT(*) AS occurrences
FROM filtered_words
GROUP BY term
ORDER BY occurrences DESC, keyword;

CREATE OR REPLACE VIEW public.v_admin_action_plan_progress AS
SELECT
  ap.id AS plan_id,
  md5(ap.user_id::text) AS anonymous_user_key,
  i.title AS initiative_title,
  i.quadrant,
  public.get_igo_quadrant_label(i.quadrant) AS quadrant_label,
  ap.deadline_at,
  ap.estimated_budget,
  ap.status,
  ap.progress_percent,
  COUNT(t.id) AS total_tasks,
  COUNT(t.id) FILTER (WHERE t.status = 'terminado') AS completed_tasks
FROM public.action_plans ap
JOIN public.initiatives i ON i.id = ap.initiative_id
LEFT JOIN public.action_plan_tasks t ON t.plan_id = ap.id
GROUP BY ap.id, i.title, i.quadrant, ap.deadline_at, ap.estimated_budget, ap.status, ap.progress_percent;

-- -------------------------------------------------------------
-- 7. CREACIÓN DE USUARIOS DEMO EN public.app_users
-- -------------------------------------------------------------
-- Credenciales demo:
-- Admin: admin@dinamicadeloriente.com / Admin12345*
-- Usuarios finales: password común Emprende123*
--
-- Nota: No se insertan usuarios en auth.users para evitar el error
-- "must be owner of table users" en Supabase SQL Editor.
-- -------------------------------------------------------------
INSERT INTO public.app_users (
  id,
  email,
  password_plain_demo,
  password_hash,
  full_name,
  user_type,
  email_confirmed,
  is_active,
  last_sign_in_at,
  created_at,
  updated_at
)
VALUES
  ('00000000-0000-0000-0000-000000000001', 'admin@dinamicadeloriente.com', 'Admin12345*', crypt('Admin12345*', gen_salt('bf')), 'Administrador Dinámica', 'admin', true, true, now(), now() - interval '30 days', now()),
  ('11111111-1111-1111-1111-111111111111', 'maria.gomez@demo.com', 'Emprende123*', crypt('Emprende123*', gen_salt('bf')), 'María Gómez', 'emprendedor', true, true, now() - interval '1 day', now() - interval '25 days', now()),
  ('22222222-2222-2222-2222-222222222222', 'carlos.ruiz@demo.com', 'Emprende123*', crypt('Emprende123*', gen_salt('bf')), 'Carlos Ruiz', 'emprendedor', true, true, now() - interval '2 days', now() - interval '20 days', now()),
  ('33333333-3333-3333-3333-333333333333', 'laura.martinez@demo.com', 'Emprende123*', crypt('Emprende123*', gen_salt('bf')), 'Laura Martínez', 'emprendedor', true, true, now() - interval '3 days', now() - interval '18 days', now()),
  ('44444444-4444-4444-4444-444444444444', 'andres.perez@demo.com', 'Emprende123*', crypt('Emprende123*', gen_salt('bf')), 'Andrés Pérez', 'emprendedor', true, true, now() - interval '4 days', now() - interval '12 days', now()),
  ('55555555-5555-5555-5555-555555555555', 'sofia.torres@demo.com', 'Emprende123*', crypt('Emprende123*', gen_salt('bf')), 'Sofía Torres', 'emprendedor', true, true, now() - interval '5 days', now() - interval '10 days', now())
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

-- -------------------------------------------------------------
-- 8. ALIMENTACIÓN DE DATOS DEMO
-- -------------------------------------------------------------

-- 8.1 Administrador del panel web
INSERT INTO public.admin_users (id, full_name, email, role, is_active, created_at, updated_at)
VALUES
  ('00000000-0000-0000-0000-000000000001', 'Administrador Dinámica', 'admin@dinamicadeloriente.com', 'superadmin', true, now() - interval '30 days', now())
ON CONFLICT (id) DO UPDATE SET
  full_name = EXCLUDED.full_name,
  email = EXCLUDED.email,
  role = EXCLUDED.role,
  is_active = EXCLUDED.is_active,
  updated_at = now();

-- 8.2 Perfiles de emprendedores
INSERT INTO public.profiles (
  id,
  full_name,
  company_name,
  email,
  phone,
  sector,
  company_size,
  age_range,
  gender,
  auth_provider,
  terms_accepted,
  terms_accepted_at,
  is_active,
  last_seen_at,
  created_at,
  updated_at
)
VALUES
  (
    '11111111-1111-1111-1111-111111111111',
    'María Gómez',
    'Café La Colina',
    'maria.gomez@demo.com',
    '3001112233',
    'Agro',
    'Micro <10',
    '26-35',
    'Femenino',
    'email',
    true,
    now() - interval '40 days',
    true,
    now() - interval '2 days',
    now() - interval '40 days',
    now()
  ),
  (
    '22222222-2222-2222-2222-222222222222',
    'Carlos Ruiz',
    'Calzado Norte',
    'carlos.ruiz@demo.com',
    '3012223344',
    'Calzado/Moda',
    'Pequeña <50',
    '36-45',
    'Masculino',
    'email',
    true,
    now() - interval '25 days',
    true,
    now() - interval '9 days',
    now() - interval '25 days',
    now()
  ),
  (
    '33333333-3333-3333-3333-333333333333',
    'Laura Martínez',
    'PagoSmart API',
    'laura.martinez@demo.com',
    '3023334455',
    'Tecnología',
    'Idea',
    '18-25',
    'Femenino',
    'email',
    true,
    now() - interval '18 days',
    true,
    now() - interval '1 day',
    now() - interval '18 days',
    now()
  ),
  (
    '44444444-4444-4444-4444-444444444444',
    'Andrés Pérez',
    'Consultoría Integral AP',
    'andres.perez@demo.com',
    '3034445566',
    'Servicios',
    'Micro <10',
    '46-55',
    'Masculino',
    'email',
    true,
    now() - interval '12 days',
    true,
    now() - interval '8 days',
    now() - interval '12 days',
    now()
  ),
  (
    '55555555-5555-5555-5555-555555555555',
    'Sofía Torres',
    'Aula Viva',
    'sofia.torres@demo.com',
    '3045556677',
    'Educación',
    'Mediana <200',
    '26-35',
    'Femenino',
    'email',
    true,
    now() - interval '5 days',
    true,
    now() - interval '3 hours',
    now() - interval '5 days',
    now()
  )
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

-- 8.3 Iniciativas de ejemplo en todos los cuadrantes IGO
INSERT INTO public.initiatives (
  user_id,
  title,
  description,
  audio_url,
  transcription_text,
  importance,
  governability,
  status,
  classified_at,
  created_at,
  updated_at
)
VALUES
  (
    '11111111-1111-1111-1111-111111111111',
    'Comprar empacadora al vacío para café especial',
    'Permite mejorar presentación, conservación del producto y preparación para venta en tiendas especializadas.',
    NULL,
    NULL,
    9,
    8,
    'activa',
    now() - interval '20 days',
    now() - interval '20 days',
    now()
  ),
  (
    '11111111-1111-1111-1111-111111111111',
    'Exportar café especial a clientes de Chile',
    'Iniciativa de alto impacto, pero requiere aliados logísticos, permisos y búsqueda de compradores internacionales.',
    NULL,
    NULL,
    10,
    4,
    'activa',
    now() - interval '18 days',
    now() - interval '18 days',
    now()
  ),
  (
    '11111111-1111-1111-1111-111111111111',
    'Publicar catálogo semanal en WhatsApp Business',
    'Actividad operativa para mantener contacto con clientes frecuentes.',
    NULL,
    NULL,
    5,
    9,
    'activa',
    now() - interval '12 days',
    now() - interval '12 days',
    now()
  ),
  (
    '11111111-1111-1111-1111-111111111111',
    'Cambiar etiquetas internas de inventario',
    'Mejora menor de orden interno, sin impacto fuerte en ventas o expansión.',
    NULL,
    NULL,
    3,
    4,
    'archivada',
    now() - interval '10 days',
    now() - interval '10 days',
    now()
  ),
  (
    '22222222-2222-2222-2222-222222222222',
    'Lanzar tienda online de calzado regional',
    'Vender referencias principales por internet y conectar pagos digitales con inventario.',
    NULL,
    NULL,
    9,
    7,
    'activa',
    now() - interval '15 days',
    now() - interval '15 days',
    now()
  ),
  (
    '22222222-2222-2222-2222-222222222222',
    'Abrir sucursal en Bogotá',
    'Puede aumentar ventas, pero necesita capital, estudio de mercado y equipo administrativo.',
    NULL,
    NULL,
    9,
    3,
    'activa',
    now() - interval '14 days',
    now() - interval '14 days',
    now()
  ),
  (
    '22222222-2222-2222-2222-222222222222',
    'Automatizar control de inventario',
    'Reducir errores de stock y mejorar reposición de materiales.',
    NULL,
    NULL,
    8,
    6,
    'activa',
    now() - interval '11 days',
    now() - interval '11 days',
    now()
  ),
  (
    '22222222-2222-2222-2222-222222222222',
    'Cambiar color de las cajas de empaque',
    'Actividad sencilla, con bajo impacto estratégico.',
    NULL,
    NULL,
    3,
    8,
    'activa',
    now() - interval '8 days',
    now() - interval '8 days',
    now()
  ),
  (
    '33333333-3333-3333-3333-333333333333',
    'Integrar pagos por API para comercios aliados',
    'Funcionalidad clave para validar el modelo de negocio y generar primeras ventas.',
    'storage/audio/laura-integrar-pagos-api.m4a',
    'Necesito integrar pagos por API para que los comercios aliados puedan cobrar fácil.',
    10,
    8,
    'activa',
    now() - interval '9 days',
    now() - interval '9 days',
    now()
  ),
  (
    '33333333-3333-3333-3333-333333333333',
    'Contratar desarrollador experto en inteligencia artificial',
    'Alto impacto para el producto, pero todavía no hay presupuesto suficiente ni candidato definido.',
    NULL,
    NULL,
    8,
    4,
    'activa',
    now() - interval '7 days',
    now() - interval '7 days',
    now()
  ),
  (
    '33333333-3333-3333-3333-333333333333',
    'Migrar landing page a dominio propio',
    'Tarea rápida para mejorar imagen digital, sin gran complejidad técnica.',
    NULL,
    NULL,
    4,
    8,
    'activa',
    now() - interval '6 days',
    now() - interval '6 days',
    now()
  ),
  (
    '33333333-3333-3333-3333-333333333333',
    'Crear app de realidad aumentada para demostraciones',
    'Idea interesante, pero de bajo impacto inmediato y alta complejidad para el MVP.',
    NULL,
    NULL,
    4,
    3,
    'archivada',
    now() - interval '5 days',
    now() - interval '5 days',
    now()
  ),
  (
    '44444444-4444-4444-4444-444444444444',
    'Diseñar paquete de consultoría express para pymes',
    'Servicio fácil de vender, con alto valor para empresas pequeñas que requieren diagnóstico rápido.',
    NULL,
    NULL,
    8,
    8,
    'activa',
    now() - interval '6 days',
    now() - interval '6 days',
    now()
  ),
  (
    '44444444-4444-4444-4444-444444444444',
    'Conseguir alianza con Cámara de Comercio',
    'Puede traer clientes y reputación, pero requiere relacionamiento institucional.',
    NULL,
    NULL,
    9,
    5,
    'activa',
    now() - interval '5 days',
    now() - interval '5 days',
    now()
  ),
  (
    '44444444-4444-4444-4444-444444444444',
    'Organizar carpetas digitales de clientes antiguos',
    'Trabajo operativo que ayuda al orden interno.',
    NULL,
    NULL,
    4,
    9,
    'activa',
    now() - interval '4 days',
    now() - interval '4 days',
    now()
  ),
  (
    '55555555-5555-5555-5555-555555555555',
    'Lanzar curso virtual de habilidades empresariales',
    'Producto escalable para emprendedores con buen potencial comercial.',
    NULL,
    NULL,
    9,
    8,
    'activa',
    now() - interval '4 days',
    now() - interval '4 days',
    now()
  ),
  (
    '55555555-5555-5555-5555-555555555555',
    'Vender licencias educativas a colegios privados',
    'Alto impacto, pero se necesitan contactos, validación comercial y ciclo de venta largo.',
    NULL,
    NULL,
    8,
    4,
    'activa',
    now() - interval '3 days',
    now() - interval '3 days',
    now()
  ),
  (
    '55555555-5555-5555-5555-555555555555',
    'Actualizar plantillas de certificados digitales',
    'Tarea de rutina, controlable y rápida.',
    NULL,
    NULL,
    5,
    8,
    'activa',
    now() - interval '2 days',
    now() - interval '2 days',
    now()
  )
ON CONFLICT DO NOTHING;

-- 8.4 Eventos iniciales de iniciativas
INSERT INTO public.initiative_events (initiative_id, user_id, event_type, event_payload, created_at)
SELECT
  i.id,
  i.user_id,
  'created_and_classified',
  jsonb_build_object(
    'importance', i.importance,
    'governability', i.governability,
    'quadrant', i.quadrant,
    'label', public.get_igo_quadrant_label(i.quadrant)
  ),
  i.created_at
FROM public.initiatives i;

-- 8.5 Planes de acción para iniciativas de cuadrante I y II
WITH plan_seed AS (
  SELECT * FROM (VALUES
    (
      'Comprar empacadora al vacío para café especial',
      now() + interval '15 days',
      12000000::numeric,
      ARRAY['SENA', 'Proveedor de maquinaria', 'Contador']::text[],
      'María Gómez',
      'en_proceso'::public.plan_status
    ),
    (
      'Exportar café especial a clientes de Chile',
      now() + interval '35 days',
      18000000::numeric,
      ARRAY['Agencia de aduanas', 'Cámara de Comercio', 'Operador logístico']::text[],
      'María Gómez',
      'pendiente'::public.plan_status
    ),
    (
      'Lanzar tienda online de calzado regional',
      now() + interval '21 days',
      9500000::numeric,
      ARRAY['Diseñador web', 'Pasarela de pagos', 'Community manager']::text[],
      'Carlos Ruiz',
      'en_proceso'::public.plan_status
    ),
    (
      'Automatizar control de inventario',
      now() + interval '18 days',
      4500000::numeric,
      ARRAY['Proveedor software POS', 'Auxiliar de bodega']::text[],
      'Carlos Ruiz',
      'en_proceso'::public.plan_status
    ),
    (
      'Abrir sucursal en Bogotá',
      now() + interval '60 days',
      75000000::numeric,
      ARRAY['Inversionista', 'Asesor inmobiliario', 'Contador']::text[],
      'Carlos Ruiz',
      'pendiente'::public.plan_status
    ),
    (
      'Integrar pagos por API para comercios aliados',
      now() + interval '10 days',
      7000000::numeric,
      ARRAY['Desarrollador backend', 'Proveedor pasarela de pagos']::text[],
      'Laura Martínez',
      'en_proceso'::public.plan_status
    ),
    (
      'Contratar desarrollador experto en inteligencia artificial',
      now() + interval '45 days',
      22000000::numeric,
      ARRAY['Universidad local', 'Bolsa de empleo', 'Mentor tecnológico']::text[],
      'Laura Martínez',
      'pendiente'::public.plan_status
    ),
    (
      'Diseñar paquete de consultoría express para pymes',
      now() + interval '12 days',
      1500000::numeric,
      ARRAY['Diseñador gráfico', 'Aliado comercial']::text[],
      'Andrés Pérez',
      'en_proceso'::public.plan_status
    ),
    (
      'Conseguir alianza con Cámara de Comercio',
      now() + interval '30 days',
      1000000::numeric,
      ARRAY['Cámara de Comercio', 'Red empresarial regional']::text[],
      'Andrés Pérez',
      'pendiente'::public.plan_status
    ),
    (
      'Lanzar curso virtual de habilidades empresariales',
      now() + interval '20 days',
      8500000::numeric,
      ARRAY['Diseñador instruccional', 'Plataforma LMS', 'Mentores invitados']::text[],
      'Sofía Torres',
      'en_proceso'::public.plan_status
    ),
    (
      'Vender licencias educativas a colegios privados',
      now() + interval '40 days',
      14000000::numeric,
      ARRAY['Asesor comercial', 'Directores académicos', 'Aliado jurídico']::text[],
      'Sofía Torres',
      'pendiente'::public.plan_status
    )
  ) AS t(initiative_title, deadline_at, estimated_budget, allies, responsible, status)
)
INSERT INTO public.action_plans (
  initiative_id,
  user_id,
  deadline_at,
  estimated_budget,
  allies,
  responsible,
  status,
  progress_percent,
  created_at,
  updated_at
)
SELECT
  i.id,
  i.user_id,
  ps.deadline_at,
  ps.estimated_budget,
  ps.allies,
  ps.responsible,
  ps.status,
  0,
  now() - interval '4 days',
  now()
FROM plan_seed ps
JOIN public.initiatives i ON i.title = ps.initiative_title
ON CONFLICT (initiative_id) DO UPDATE SET
  deadline_at = EXCLUDED.deadline_at,
  estimated_budget = EXCLUDED.estimated_budget,
  allies = EXCLUDED.allies,
  responsible = EXCLUDED.responsible,
  status = EXCLUDED.status,
  updated_at = now();

-- 8.6 Tareas por plan de acción
WITH task_seed AS (
  SELECT * FROM (VALUES
    ('Comprar empacadora al vacío para café especial', 'Cotizar tres proveedores', 'Solicitar cotizaciones comparables con garantía y soporte.', 'María Gómez', (current_date + 3), 'terminado'::public.task_status, 1),
    ('Comprar empacadora al vacío para café especial', 'Definir presupuesto final', 'Revisar flujo de caja y fuente de financiación.', 'María Gómez', (current_date + 5), 'en_proceso'::public.task_status, 2),
    ('Comprar empacadora al vacío para café especial', 'Comprar e instalar equipo', 'Coordinar compra, instalación y prueba de empaque.', 'Proveedor de maquinaria', (current_date + 14), 'pendiente'::public.task_status, 3),

    ('Exportar café especial a clientes de Chile', 'Validar requisitos de exportación', 'Revisar documentación requerida para exportar alimentos.', 'Agencia de aduanas', (current_date + 10), 'pendiente'::public.task_status, 1),
    ('Exportar café especial a clientes de Chile', 'Buscar compradores potenciales', 'Construir lista de contactos y enviar propuesta comercial.', 'María Gómez', (current_date + 20), 'pendiente'::public.task_status, 2),
    ('Exportar café especial a clientes de Chile', 'Calcular costos logísticos', 'Estimar transporte, seguros, empaque y margen.', 'Operador logístico', (current_date + 25), 'pendiente'::public.task_status, 3),

    ('Lanzar tienda online de calzado regional', 'Definir catálogo inicial', 'Seleccionar referencias, tallas, fotos y precios.', 'Carlos Ruiz', (current_date + 4), 'terminado'::public.task_status, 1),
    ('Lanzar tienda online de calzado regional', 'Configurar pasarela de pagos', 'Activar pagos digitales y pruebas de compra.', 'Pasarela de pagos', (current_date + 12), 'en_proceso'::public.task_status, 2),
    ('Lanzar tienda online de calzado regional', 'Publicar campaña de lanzamiento', 'Crear anuncios y piezas para redes sociales.', 'Community manager', (current_date + 20), 'pendiente'::public.task_status, 3),

    ('Automatizar control de inventario', 'Depurar base de productos', 'Limpiar referencias duplicadas y actualizar existencias.', 'Auxiliar de bodega', (current_date + 6), 'terminado'::public.task_status, 1),
    ('Automatizar control de inventario', 'Instalar software POS', 'Configurar usuarios, bodegas y categorías.', 'Proveedor software POS', (current_date + 12), 'en_proceso'::public.task_status, 2),
    ('Automatizar control de inventario', 'Capacitar equipo de ventas', 'Entrenar al personal en entradas y salidas de inventario.', 'Carlos Ruiz', (current_date + 17), 'pendiente'::public.task_status, 3),

    ('Abrir sucursal en Bogotá', 'Evaluar zonas comerciales', 'Comparar costos de arriendo, tráfico peatonal y competencia.', 'Asesor inmobiliario', (current_date + 20), 'pendiente'::public.task_status, 1),
    ('Abrir sucursal en Bogotá', 'Conseguir inversión', 'Preparar presupuesto y presentar propuesta a inversionista.', 'Carlos Ruiz', (current_date + 35), 'pendiente'::public.task_status, 2),
    ('Abrir sucursal en Bogotá', 'Diseñar plan operativo', 'Definir personal, inventario mínimo y punto de equilibrio.', 'Contador', (current_date + 50), 'pendiente'::public.task_status, 3),

    ('Integrar pagos por API para comercios aliados', 'Diseñar endpoints principales', 'Definir contratos de API para cobro, confirmación y reverso.', 'Desarrollador backend', (current_date + 3), 'terminado'::public.task_status, 1),
    ('Integrar pagos por API para comercios aliados', 'Crear ambiente sandbox', 'Configurar credenciales, llaves y ambiente de pruebas.', 'Proveedor pasarela de pagos', (current_date + 6), 'en_proceso'::public.task_status, 2),
    ('Integrar pagos por API para comercios aliados', 'Probar integración con comercio piloto', 'Ejecutar compras de prueba y validar confirmaciones.', 'Laura Martínez', (current_date + 9), 'pendiente'::public.task_status, 3),

    ('Contratar desarrollador experto en inteligencia artificial', 'Crear perfil del cargo', 'Definir habilidades técnicas, responsabilidades y rango salarial.', 'Laura Martínez', (current_date + 8), 'pendiente'::public.task_status, 1),
    ('Contratar desarrollador experto en inteligencia artificial', 'Publicar convocatoria', 'Difundir la vacante en universidades y bolsas de empleo.', 'Bolsa de empleo', (current_date + 15), 'pendiente'::public.task_status, 2),
    ('Contratar desarrollador experto en inteligencia artificial', 'Entrevistar candidatos', 'Evaluar portafolio, prueba técnica y disponibilidad.', 'Mentor tecnológico', (current_date + 30), 'pendiente'::public.task_status, 3),

    ('Diseñar paquete de consultoría express para pymes', 'Definir alcance del servicio', 'Precisar entregables, duración y precio.', 'Andrés Pérez', (current_date + 3), 'terminado'::public.task_status, 1),
    ('Diseñar paquete de consultoría express para pymes', 'Diseñar presentación comercial', 'Crear PDF y pieza de venta para redes.', 'Diseñador gráfico', (current_date + 8), 'en_proceso'::public.task_status, 2),
    ('Diseñar paquete de consultoría express para pymes', 'Contactar 10 prospectos', 'Enviar propuesta a empresarios priorizados.', 'Aliado comercial', (current_date + 12), 'pendiente'::public.task_status, 3),

    ('Conseguir alianza con Cámara de Comercio', 'Preparar propuesta institucional', 'Estructurar beneficios para empresarios afiliados.', 'Andrés Pérez', (current_date + 10), 'pendiente'::public.task_status, 1),
    ('Conseguir alianza con Cámara de Comercio', 'Solicitar reunión', 'Agendar espacio de presentación con directivos.', 'Red empresarial regional', (current_date + 15), 'pendiente'::public.task_status, 2),
    ('Conseguir alianza con Cámara de Comercio', 'Definir piloto conjunto', 'Diseñar una jornada inicial de consultoría.', 'Cámara de Comercio', (current_date + 28), 'pendiente'::public.task_status, 3),

    ('Lanzar curso virtual de habilidades empresariales', 'Estructurar módulos del curso', 'Definir objetivos, sesiones y materiales descargables.', 'Sofía Torres', (current_date + 5), 'terminado'::public.task_status, 1),
    ('Lanzar curso virtual de habilidades empresariales', 'Grabar primeras clases', 'Producir videos de los módulos iniciales.', 'Mentores invitados', (current_date + 12), 'en_proceso'::public.task_status, 2),
    ('Lanzar curso virtual de habilidades empresariales', 'Publicar en plataforma LMS', 'Subir contenidos, evaluaciones y certificados.', 'Plataforma LMS', (current_date + 18), 'pendiente'::public.task_status, 3),

    ('Vender licencias educativas a colegios privados', 'Construir base de colegios', 'Identificar decisores y datos de contacto.', 'Asesor comercial', (current_date + 8), 'pendiente'::public.task_status, 1),
    ('Vender licencias educativas a colegios privados', 'Diseñar demo comercial', 'Preparar presentación y prueba gratuita.', 'Sofía Torres', (current_date + 16), 'pendiente'::public.task_status, 2),
    ('Vender licencias educativas a colegios privados', 'Revisar condiciones jurídicas', 'Definir contrato, licenciamiento y tratamiento de datos.', 'Aliado jurídico', (current_date + 25), 'pendiente'::public.task_status, 3)
  ) AS t(initiative_title, task_title, description, responsible, due_date, status, sort_order)
)
INSERT INTO public.action_plan_tasks (
  plan_id,
  title,
  description,
  responsible,
  due_date,
  status,
  sort_order,
  created_at,
  updated_at
)
SELECT
  ap.id,
  ts.task_title,
  ts.description,
  ts.responsible,
  ts.due_date,
  ts.status,
  ts.sort_order,
  now() - interval '2 days',
  now()
FROM task_seed ts
JOIN public.initiatives i ON i.title = ts.initiative_title
JOIN public.action_plans ap ON ap.initiative_id = i.id;

-- 8.7 Dispositivos demo para notificaciones
INSERT INTO public.notification_devices (user_id, platform, device_token, is_active, last_seen_at, created_at, updated_at)
VALUES
  ('11111111-1111-1111-1111-111111111111', 'android', 'demo_android_token_maria_001', true, now() - interval '2 days', now() - interval '20 days', now()),
  ('22222222-2222-2222-2222-222222222222', 'android', 'demo_android_token_carlos_001', true, now() - interval '9 days', now() - interval '15 days', now()),
  ('33333333-3333-3333-3333-333333333333', 'ios', 'demo_ios_token_laura_001', true, now() - interval '1 day', now() - interval '9 days', now()),
  ('44444444-4444-4444-4444-444444444444', 'web', 'demo_web_token_andres_001', true, now() - interval '8 days', now() - interval '6 days', now()),
  ('55555555-5555-5555-5555-555555555555', 'ios', 'demo_ios_token_sofia_001', true, now() - interval '3 hours', now() - interval '5 days', now())
ON CONFLICT (device_token) DO UPDATE SET
  is_active = EXCLUDED.is_active,
  last_seen_at = EXCLUDED.last_seen_at,
  updated_at = now();

-- 8.8 Notificaciones automáticas según planes e inactividad
SELECT public.generate_deadline_notifications();
SELECT public.generate_inactivity_notifications();

-- 8.9 Resúmenes semanales demo
INSERT INTO public.notifications (
  user_id,
  type,
  title,
  body,
  scheduled_at,
  status,
  idempotency_key,
  metadata
)
VALUES
  (
    '11111111-1111-1111-1111-111111111111',
    'weekly_summary',
    'Resumen semanal IGO',
    'Esta semana completaste 1 tarea y tienes 2 iniciativas de alta importancia.',
    date_trunc('week', now()) + interval '6 days 9 hours',
    'programada',
    '11111111-1111-1111-1111-111111111111:weekly:' || to_char(now(), 'IYYY-IW'),
    '{"completed_tasks":1,"high_importance_initiatives":2}'::jsonb
  ),
  (
    '33333333-3333-3333-3333-333333333333',
    'weekly_summary',
    'Resumen semanal IGO',
    'Esta semana completaste 1 tarea y tienes 2 iniciativas estratégicas activas.',
    date_trunc('week', now()) + interval '6 days 9 hours',
    'programada',
    '33333333-3333-3333-3333-333333333333:weekly:' || to_char(now(), 'IYYY-IW'),
    '{"completed_tasks":1,"high_importance_initiatives":2}'::jsonb
  )
ON CONFLICT (idempotency_key) DO NOTHING;

-- -------------------------------------------------------------
-- 9. PERMISOS ABIERTOS PARA DESARROLLO / MVP
--    Para producción se recomienda activar RLS y políticas.
-- -------------------------------------------------------------
ALTER TABLE public.app_users DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.profiles DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.admin_users DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.initiatives DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.initiative_events DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.action_plans DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.action_plan_tasks DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.notification_devices DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.notification_logs DISABLE ROW LEVEL SECURITY;

GRANT USAGE ON SCHEMA public TO anon, authenticated;
GRANT ALL ON ALL TABLES IN SCHEMA public TO anon, authenticated;
GRANT ALL ON ALL ROUTINES IN SCHEMA public TO anon, authenticated;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO anon, authenticated;

-- -------------------------------------------------------------
-- 10. CONSULTAS RÁPIDAS DE VERIFICACIÓN
-- -------------------------------------------------------------
-- SELECT id, email, password_plain_demo, user_type FROM public.app_users ORDER BY user_type, email;
-- SELECT * FROM public.v_admin_kpis;
-- SELECT * FROM public.v_admin_quadrant_summary;
-- SELECT * FROM public.v_admin_demographics_sector;
-- SELECT * FROM public.v_admin_high_importance_keywords;
-- SELECT p.full_name, i.title, i.importance, i.governability, i.quadrant
-- FROM public.initiatives i JOIN public.profiles p ON p.id = i.user_id
-- ORDER BY p.full_name, i.created_at;

-- FIN DEL SCRIPT


---- ULTIMAS EJECUCIONES

INSERT INTO public.app_users (id, email, password_plain_demo, password_hash, full_name, user_type, email_confirmed, is_active, last_sign_in_at, created_at, updated_at)
VALUES
  ('00000000-0000-0000-0000-000000000001', 'admin@dinamicadeloriente.com', 'Admin12345*', crypt('Admin12345*', gen_salt('bf')), 'Administrador Dinámica', 'admin', true, true, now(), now() - interval '30 days', now())
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

INSERT INTO public.admin_users (id, full_name, email, role, is_active, created_at, updated_at)
VALUES
  ('00000000-0000-0000-0000-000000000001', 'Administrador Dinámica', 'admin@dinamicadeloriente.com', 'superadmin', true, now() - interval '30 days', now())
ON CONFLICT (id) DO UPDATE SET
  full_name = EXCLUDED.full_name,
  email = EXCLUDED.email,
  role = EXCLUDED.role,
  is_active = EXCLUDED.is_active,
  updated_at = now();