export interface AdminKpis {
  total_registered_users: number;
  users_current_month: number;
  active_initiatives: number;
  active_action_plans: number;
  completed_action_plans: number;
  avg_importance: number;
  avg_governability: number;
}

export interface UsersByMonth {
  month: string;
  total_users: number;
}

export interface DemographicsSector {
  sector: string;
  total_users: number;
}

export interface DemographicsCompanySize {
  company_size: string;
  total_users: number;
}

export interface DemographicsAge {
  age_range: string;
  total_users: number;
}

export interface DemographicsGender {
  gender: string;
  total_users: number;
}

export interface QuadrantSummary {
  quadrant: string;
  quadrant_label: string;
  suggested_action: string;
  total_initiatives: number;
  avg_importance: number;
  avg_governability: number;
}

export interface IgoMatrixAggregate {
  sector: string;
  company_size: string;
  quadrant: string;
  quadrant_label: string;
  total_initiatives: number;
  avg_importance: number;
  avg_governability: number;
}

export interface AnonymizedInitiative {
  anonymous_user_key: string;
  sector: string;
  company_size: string;
  age_range: string;
  gender: string;
  title: string;
  importance: number;
  governability: number;
  quadrant: string;
  quadrant_label: string;
  status: string;
  created_at: string;
  company_name?: string;
  owner_name?: string;
}

export interface HighImportanceKeyword {
  keyword: string;
  occurrences: number;
}

export interface ActionPlanProgress {
  plan_id: string;
  anonymous_user_key: string;
  initiative_title: string;
  quadrant: string;
  quadrant_label: string;
  deadline_at: string;
  estimated_budget: number | null;
  status: string;
  progress_percent: number;
  total_tasks: number;
  completed_tasks: number;
}

export interface AuthUser {
  id: string;
  email: string;
  full_name: string;
  role: 'superadmin' | 'analista';
}

export interface AdminUser {
  id: string;
  full_name: string;
  email: string;
  role: 'superadmin' | 'analista';
  is_active: boolean;
}


