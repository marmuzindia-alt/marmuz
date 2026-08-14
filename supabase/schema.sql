-- MARMUZ SUPABASE DATABASE
-- Run this whole file in Supabase SQL Editor.
-- First create the admin Auth user in Supabase Dashboard > Authentication > Users.

create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text,
  role text not null default 'student' check (role in ('student','admin')),
  created_at timestamptz not null default now()
);

create table if not exists public.lectures (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  subject text,
  topic text,
  youtube_url text not null,
  published boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.resources (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  subject text,
  type text,
  url text not null,
  published boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.announcements (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  body text,
  published boolean not null default false,
  created_at timestamptz not null default now()
);

create index if not exists lectures_created_at_idx on public.lectures(created_at desc);
create index if not exists resources_created_at_idx on public.resources(created_at desc);

create or replace function public.is_admin()
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select exists (
    select 1 from public.profiles
    where id = auth.uid() and role = 'admin'
  );
$$;

alter table public.profiles enable row level security;
alter table public.lectures enable row level security;
alter table public.resources enable row level security;
alter table public.announcements enable row level security;

drop policy if exists "profiles own read" on public.profiles;
create policy "profiles own read" on public.profiles for select to authenticated using (id = auth.uid() or public.is_admin());

drop policy if exists "public read published lectures" on public.lectures;
create policy "public read published lectures" on public.lectures for select to anon, authenticated using (published = true or public.is_admin());
drop policy if exists "admin insert lectures" on public.lectures;
create policy "admin insert lectures" on public.lectures for insert to authenticated with check (public.is_admin());
drop policy if exists "admin update lectures" on public.lectures;
create policy "admin update lectures" on public.lectures for update to authenticated using (public.is_admin()) with check (public.is_admin());
drop policy if exists "admin delete lectures" on public.lectures;
create policy "admin delete lectures" on public.lectures for delete to authenticated using (public.is_admin());

drop policy if exists "public read published resources" on public.resources;
create policy "public read published resources" on public.resources for select to anon, authenticated using (published = true or public.is_admin());
drop policy if exists "admin insert resources" on public.resources;
create policy "admin insert resources" on public.resources for insert to authenticated with check (public.is_admin());
drop policy if exists "admin update resources" on public.resources;
create policy "admin update resources" on public.resources for update to authenticated using (public.is_admin()) with check (public.is_admin());
drop policy if exists "admin delete resources" on public.resources;
create policy "admin delete resources" on public.resources for delete to authenticated using (public.is_admin());

drop policy if exists "public read published announcements" on public.announcements;
create policy "public read published announcements" on public.announcements for select to anon, authenticated using (published = true or public.is_admin());
drop policy if exists "admin manage announcements" on public.announcements;
create policy "admin manage announcements" on public.announcements for all to authenticated using (public.is_admin()) with check (public.is_admin());

-- AFTER creating your Auth user, replace the email below and run:
-- insert into public.profiles (id,email,role)
-- select id,email,'admin' from auth.users where email='YOUR_ADMIN_EMAIL';
