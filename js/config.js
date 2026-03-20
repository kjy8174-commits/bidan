// =============================================
// Supabase 설정 · 본인의 키로 교체하세요
// =============================================
// 1. https://supabase.com 접속 → 프로젝트 생성
// 2. Settings → API → 아래 두 값 복사

const SUPABASE_URL = 'https://fhizeuehljsbccszienn.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZoaXpldWVobGpzYmNjc3ppZW5uIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM4ODMzOTgsImV4cCI6MjA4OTQ1OTM5OH0.cybZryhxRRfWM6HptC70fjiDZtWKFMrAIRPldiQdkpE';

// 키가 설정된 경우에만 클라이언트 생성
let db = null;
try {
  if (typeof supabase !== 'undefined' &&
      SUPABASE_URL && !SUPABASE_URL.includes('YOUR_PROJECT_ID') &&
      SUPABASE_ANON_KEY && !SUPABASE_ANON_KEY.includes('YOUR_ANON_KEY')) {
    const { createClient } = supabase;
    db = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
  }
} catch(e) {
  console.warn('Supabase 초기화 실패:', e.message);
}
