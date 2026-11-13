-- Qorgan MVP: one table that stores every record (tickets, vendors, clinic settings, test records)
create table if not exists public.docs (
  col text not null,
  id text not null,
  data jsonb not null,
  updated_at timestamptz not null default now(),
  primary key (col, id)
);
alter table public.docs replica identity full;
alter table public.docs enable row level security;
-- Demo policy: anyone with the public key can read and write. No patient data is ever stored.
create policy "demo read"   on public.docs for select to anon using (true);
create policy "demo insert" on public.docs for insert to anon with check (col in ('tickets','vendors','meta','tests'));
create policy "demo update" on public.docs for update to anon using (true) with check (col in ('tickets','vendors','meta','tests'));
create policy "demo delete" on public.docs for delete to anon using (true);
-- Live updates between devices
alter publication supabase_realtime add table public.docs;
