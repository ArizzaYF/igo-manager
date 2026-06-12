import { supabase } from '../config/supabase';
import type {
  AdminKpis,
  UsersByMonth,
  QuadrantSummary,
  HighImportanceKeyword,
  IgoMatrixAggregate,
  ActionPlanProgress,
} from '../types';

export async function fetchKpis(): Promise<AdminKpis> {
  const { data, error } = await supabase.from('v_admin_kpis').select('*').limit(1).single();
  if (error) throw new Error(`Error fetching KPIs: ${error.message}`);
  return data as AdminKpis;
}

export async function fetchUsersByMonth(): Promise<UsersByMonth[]> {
  const { data, error } = await supabase
    .from('v_admin_users_by_month')
    .select('*')
    .order('month', { ascending: true });
  if (error) throw new Error(`Error fetching users by month: ${error.message}`);
  return (data ?? []) as UsersByMonth[];
}

export async function fetchQuadrantSummary(): Promise<QuadrantSummary[]> {
  const { data, error } = await supabase.from('v_admin_quadrant_summary').select('*');
  if (error) throw new Error(`Error fetching quadrant summary: ${error.message}`);
  return (data ?? []) as QuadrantSummary[];
}

export async function fetchHighImportanceKeywords(): Promise<HighImportanceKeyword[]> {
  const { data, error } = await supabase
    .from('v_admin_high_importance_keywords')
    .select('*')
    .order('occurrences', { ascending: false })
    .limit(100);
  if (error) throw new Error(`Error fetching keywords: ${error.message}`);
  return (data ?? []) as HighImportanceKeyword[];
}

export async function fetchIGOMatrixAggregate(): Promise<IgoMatrixAggregate[]> {
  const { data, error } = await supabase.from('v_admin_igo_matrix_aggregate').select('*');
  if (error) throw new Error(`Error fetching IGO matrix: ${error.message}`);
  return (data ?? []) as IgoMatrixAggregate[];
}

export async function fetchActionPlanProgress(): Promise<ActionPlanProgress[]> {
  const { data, error } = await supabase.from('v_admin_action_plan_progress').select('*');
  if (error) throw new Error(`Error fetching action plans: ${error.message}`);
  return (data ?? []) as ActionPlanProgress[];
}

export async function fetchKeywordInitiatives(): Promise<{ keyword: string; occurrences: number; quadrant: string; initiative_title: string; sector: string; company_size: string }[]> {
  const { data, error } = await supabase
    .from('v_admin_high_importance_keywords')
    .select('*')
    .order('occurrences', { ascending: false })
    .limit(100);
  if (error) throw new Error(`Error fetching keyword initiatives: ${error.message}`);
  return (data ?? []) as any;
}

export async function fetchDistinctSectors(): Promise<string[]> {
  const { data, error } = await supabase
    .from('v_admin_igo_matrix_aggregate')
    .select('sector')
    .order('sector', { ascending: true });
  if (error) throw new Error(`Error fetching sectors: ${error.message}`);
  const sectors = [...new Set((data ?? []).map((r: { sector: string }) => r.sector))];
  return sectors;
}

export async function fetchDistinctCompanySizes(): Promise<string[]> {
  const { data, error } = await supabase
    .from('v_admin_igo_matrix_aggregate')
    .select('company_size')
    .order('company_size', { ascending: true });
  if (error) throw new Error(`Error fetching company sizes: ${error.message}`);
  const sizes = [...new Set((data ?? []).map((r: { company_size: string }) => r.company_size))];
  return sizes;
}
