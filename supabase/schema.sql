-- =============================================
-- 비단결고운길 필라테스 · Supabase Schema
-- =============================================

-- 회원 테이블
create table members (
  id uuid default gen_random_uuid() primary key,
  name text not null,
  phone text not null unique,
  email text,
  birth_date date,
  memo text,
  created_at timestamptz default now()
);

-- 수강권 종류
create table pass_types (
  id uuid default gen_random_uuid() primary key,
  name text not null,
  total_count int not null,
  price int not null,
  valid_days int not null default 90,
  created_at timestamptz default now()
);

-- 회원 수강권
create table member_passes (
  id uuid default gen_random_uuid() primary key,
  member_id uuid references members(id) on delete cascade,
  pass_type_id uuid references pass_types(id),
  pass_name text not null,
  total_count int not null,
  used_count int not null default 0,
  start_date date not null default current_date,
  expire_date date not null,
  status text not null default 'active' check (status in ('active','expired','paused')),
  created_at timestamptz default now()
);

-- 수업 일정 (반복 수업 템플릿)
create table class_schedules (
  id uuid default gen_random_uuid() primary key,
  title text not null,
  day_of_week int not null check (day_of_week between 0 and 6), -- 0=일, 1=월...
  start_time time not null,
  duration_min int not null default 50,
  capacity int not null default 1,
  is_active boolean default true,
  created_at timestamptz default now()
);

-- 예약
create table reservations (
  id uuid default gen_random_uuid() primary key,
  member_id uuid references members(id) on delete cascade,
  member_pass_id uuid references member_passes(id),
  class_schedule_id uuid references class_schedules(id),
  reserved_date date not null,
  start_time time not null,
  class_title text not null,
  status text not null default 'confirmed' check (status in ('confirmed','cancelled','completed','noshow')),
  memo text,
  created_at timestamptz default now()
);

-- 공지사항
create table notices (
  id uuid default gen_random_uuid() primary key,
  title text not null,
  content text not null,
  is_pinned boolean default false,
  created_at timestamptz default now()
);

-- ─── 기본 수강권 데이터 ───
insert into pass_types (name, total_count, price, valid_days) values
  ('1:1 레슨 10회', 10, 600000, 90),
  ('1:1 레슨 20회', 20, 1100000, 180),
  ('1:1 레슨 30회', 30, 1500000, 270),
  ('듀엣 레슨 10회', 10, 400000, 90),
  ('월정액 (주 2회)', 8, 300000, 35);

-- ─── RLS (Row Level Security) ───
alter table members enable row level security;
alter table member_passes enable row level security;
alter table class_schedules enable row level security;
alter table reservations enable row level security;
alter table notices enable row level security;
alter table pass_types enable row level security;

-- 공지사항은 누구나 읽기 가능
create policy "notices_public_read" on notices for select using (true);

-- 나머지는 authenticated(관리자)만
create policy "members_admin" on members for all using (auth.role() = 'authenticated');
create policy "passes_admin" on member_passes for all using (auth.role() = 'authenticated');
create policy "schedules_admin" on class_schedules for all using (auth.role() = 'authenticated');
create policy "reservations_admin" on reservations for all using (auth.role() = 'authenticated');
create policy "notices_admin" on notices for all using (auth.role() = 'authenticated');
create policy "pass_types_read" on pass_types for select using (true);
create policy "pass_types_admin" on pass_types for all using (auth.role() = 'authenticated');
