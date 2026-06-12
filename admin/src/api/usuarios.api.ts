import { supabase } from '../config/supabase';
import type {
  DemographicsSector,
  DemographicsCompanySize,
  DemographicsAge,
  DemographicsGender,
} from '../types';

export async function fetchDemographicsSector(): Promise<DemographicsSector[]> {
  const { data, error } = await supabase.from('v_admin_demographics_sector').select('*');
  if (error) throw new Error(`Error fetching sector demographics: ${error.message}`);
  return (data ?? []) as DemographicsSector[];
}

export async function fetchDemographicsCompanySize(): Promise<DemographicsCompanySize[]> {
  const { data, error } = await supabase.from('v_admin_demographics_company_size').select('*');
  if (error) throw new Error(`Error fetching company size demographics: ${error.message}`);
  return (data ?? []) as DemographicsCompanySize[];
}

export async function fetchDemographicsAge(): Promise<DemographicsAge[]> {
  const { data, error } = await supabase.from('v_admin_demographics_age').select('*');
  if (error) throw new Error(`Error fetching age demographics: ${error.message}`);
  return (data ?? []) as DemographicsAge[];
}

export async function fetchDemographicsGender(): Promise<DemographicsGender[]> {
  const { data, error } = await supabase.from('v_admin_demographics_gender').select('*');
  if (error) throw new Error(`Error fetching gender demographics: ${error.message}`);
  return (data ?? []) as DemographicsGender[];
}
