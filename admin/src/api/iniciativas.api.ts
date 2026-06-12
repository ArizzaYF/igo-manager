import { supabase } from '../config/supabase';
import type { AnonymizedInitiative } from '../types';

export async function fetchAnonymizedInitiatives(): Promise<AnonymizedInitiative[]> {
  const { data, error } = await supabase
    .from('v_admin_initiatives_anonymized')
    .select('*')
    .order('created_at', { ascending: false });
  if (error) throw new Error(`Error fetching initiatives: ${error.message}`);
  return (data ?? []) as AnonymizedInitiative[];
}
