-- Pegá esto en Supabase > SQL Editor > New query > Run
create table if not exists public.cvs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  title text not null default 'Mi CV',
  data jsonb not null,
  created_at timestamptz not null default now()
);

alter table public.cvs enable row level security;

-- Cada usuario ve y modifica únicamente sus propios CVs
create policy "ver mis cvs" on public.cvs for select using (auth.uid() = user_id);
create policy "crear mis cvs" on public.cvs for insert with check (auth.uid() = user_id);
create policy "editar mis cvs" on public.cvs for update using (auth.uid() = user_id);
create policy "borrar mis cvs" on public.cvs for delete using (auth.uid() = user_id);
