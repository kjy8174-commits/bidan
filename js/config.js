// =============================================
// Supabase 설정 · 본인의 키로 교체하세요
// =============================================
// 1. https://supabase.com 접속 → 프로젝트 생성
// 2. Settings → API → 아래 두 값 복사

const SUPABASE_URL = 'https://fhizeuehljsbccszienn.supabase.co';
const SUPABASE_ANON_KEY = 'sb_publishable_g09ueTJiNs9dOdMde4qxIg_fzUoKsVB';

const { createClient } = supabase;
const db = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

