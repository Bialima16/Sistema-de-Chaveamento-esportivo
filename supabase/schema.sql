-- JUSA — estrutura inicial do Supabase
-- Execute este arquivo no SQL Editor de um projeto Supabase vazio.

create extension if not exists pgcrypto;

create type public.user_role as enum ('admin', 'referee');
create type public.match_status as enum ('Pendente', 'Em andamento', 'Finalizada', 'W.O.', 'Cancelada');

create table public.competitions (
  id text primary key,
  name text not null check (char_length(trim(name)) > 0),
  short_name text not null,
  format text not null,
  advance_rule text not null,
  status text not null default 'Fase de grupos',
  sort_order integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.groups (
  id text primary key,
  competition_id text not null references public.competitions(id) on delete cascade,
  name text not null check (char_length(trim(name)) > 0),
  sort_order integer not null default 0,
  unique (competition_id, name)
);

create table public.teams (
  id text primary key,
  competition_id text not null references public.competitions(id) on delete cascade,
  group_id text references public.groups(id) on delete set null,
  name text not null check (char_length(trim(name)) > 0),
  university text not null default '',
  sort_order integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.athletes (
  id uuid primary key default gen_random_uuid(),
  team_id text not null references public.teams(id) on delete cascade,
  competition_id text not null references public.competitions(id) on delete cascade,
  name text not null check (char_length(trim(name)) > 0),
  sort_order integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.matches (
  id text primary key,
  competition_id text not null references public.competitions(id) on delete cascade,
  group_id text references public.groups(id) on delete set null,
  phase text not null default 'Grupos',
  match_order integer not null default 0,
  team_a_id text not null references public.teams(id),
  team_b_id text not null references public.teams(id),
  score_a integer check (score_a is null or score_a >= 0),
  score_b integer check (score_b is null or score_b >= 0),
  sets jsonb not null default '[]'::jsonb,
  winner_id text references public.teams(id),
  status public.match_status not null default 'Pendente',
  match_date date,
  match_time time,
  court text not null default 'Quadra principal',
  notes text not null default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (team_a_id <> team_b_id),
  check (winner_id is null or winner_id in (team_a_id, team_b_id)),
  unique (competition_id, phase, match_order)
);

create table public.knockout_matches (
  id text not null,
  competition_id text not null references public.competitions(id) on delete cascade,
  phase text not null,
  match_order integer not null,
  team_a_id text references public.teams(id),
  team_b_id text references public.teams(id),
  score_a integer check (score_a is null or score_a >= 0),
  score_b integer check (score_b is null or score_b >= 0),
  winner_id text references public.teams(id),
  status public.match_status not null default 'Pendente',
  updated_at timestamptz not null default now(),
  primary key (competition_id, id),
  check (team_a_id is null or team_b_id is null or team_a_id <> team_b_id),
  check (winner_id is null or winner_id in (team_a_id, team_b_id))
);

create table public.checkins (
  athlete_id uuid primary key references public.athletes(id) on delete cascade,
  competition_id text not null references public.competitions(id) on delete cascade,
  arrived boolean not null default false,
  notes text not null default '',
  updated_at timestamptz not null default now()
);

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null default '',
  role public.user_role not null default 'referee',
  competition_id text references public.competitions(id) on delete restrict,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check ((role = 'admin' and competition_id is null) or (role = 'referee' and competition_id is not null))
);

create index groups_competition_idx on public.groups(competition_id);
create index teams_competition_idx on public.teams(competition_id);
create index teams_group_idx on public.teams(group_id);
create index athletes_team_idx on public.athletes(team_id);
create index athletes_competition_idx on public.athletes(competition_id);
create index matches_competition_idx on public.matches(competition_id);
create index matches_status_idx on public.matches(status);
create index knockout_competition_idx on public.knockout_matches(competition_id);
create index checkins_competition_idx on public.checkins(competition_id);

create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger competitions_updated_at before update on public.competitions for each row execute function public.set_updated_at();
create trigger teams_updated_at before update on public.teams for each row execute function public.set_updated_at();
create trigger athletes_updated_at before update on public.athletes for each row execute function public.set_updated_at();
create trigger matches_updated_at before update on public.matches for each row execute function public.set_updated_at();
create trigger knockout_updated_at before update on public.knockout_matches for each row execute function public.set_updated_at();
create trigger checkins_updated_at before update on public.checkins for each row execute function public.set_updated_at();
create trigger profiles_updated_at before update on public.profiles for each row execute function public.set_updated_at();

-- Funções auxiliares de autorização. SECURITY DEFINER evita recursão nas políticas de profiles.
create or replace function public.current_user_role()
returns public.user_role language sql stable security definer set search_path = public as $$
  select role from public.profiles where id = auth.uid();
$$;

create or replace function public.current_user_competition()
returns text language sql stable security definer set search_path = public as $$
  select competition_id from public.profiles where id = auth.uid();
$$;

create or replace function public.is_admin()
returns boolean language sql stable security definer set search_path = public as $$
  select coalesce(public.current_user_role() = 'admin', false);
$$;

revoke all on function public.current_user_role() from public;
revoke all on function public.current_user_competition() from public;
revoke all on function public.is_admin() from public;
grant execute on function public.current_user_role() to authenticated;
grant execute on function public.current_user_competition() to authenticated;
grant execute on function public.is_admin() to authenticated;

alter table public.competitions enable row level security;
alter table public.groups enable row level security;
alter table public.teams enable row level security;
alter table public.athletes enable row level security;
alter table public.matches enable row level security;
alter table public.knockout_matches enable row level security;
alter table public.checkins enable row level security;
alter table public.profiles enable row level security;

-- Resultados e cadastros esportivos podem ser consultados publicamente.
create policy "public reads competitions" on public.competitions for select using (true);
create policy "public reads groups" on public.groups for select using (true);
create policy "public reads teams" on public.teams for select using (true);
create policy "public reads athletes" on public.athletes for select using (true);
create policy "public reads matches" on public.matches for select using (true);
create policy "public reads knockout" on public.knockout_matches for select using (true);

-- Somente o administrador altera cadastros estruturais.
create policy "admin manages competitions" on public.competitions for all to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "admin manages groups" on public.groups for all to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "admin manages teams" on public.teams for all to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "admin manages athletes" on public.athletes for all to authenticated using (public.is_admin()) with check (public.is_admin());

-- Árbitros alteram apenas partidas da modalidade vinculada ao perfil.
create policy "authorized users insert matches" on public.matches for insert to authenticated
  with check (public.is_admin() or competition_id = public.current_user_competition());
create policy "authorized users update matches" on public.matches for update to authenticated
  using (public.is_admin() or competition_id = public.current_user_competition())
  with check (public.is_admin() or competition_id = public.current_user_competition());
create policy "admin deletes matches" on public.matches for delete to authenticated using (public.is_admin());

create policy "authorized users insert knockout" on public.knockout_matches for insert to authenticated
  with check (public.is_admin() or competition_id = public.current_user_competition());
create policy "authorized users update knockout" on public.knockout_matches for update to authenticated
  using (public.is_admin() or competition_id = public.current_user_competition())
  with check (public.is_admin() or competition_id = public.current_user_competition());
create policy "admin deletes knockout" on public.knockout_matches for delete to authenticated using (public.is_admin());

-- Check-in: árbitro consulta sua modalidade; apenas administrador altera.
create policy "authorized users read checkins" on public.checkins for select to authenticated
  using (public.is_admin() or competition_id = public.current_user_competition());
create policy "admin manages checkins" on public.checkins for all to authenticated
  using (public.is_admin()) with check (public.is_admin());

-- Cada usuário consulta o próprio perfil; administrador consulta e gerencia todos.
create policy "users read own profile" on public.profiles for select to authenticated using (id = auth.uid() or public.is_admin());
create policy "admin manages profiles" on public.profiles for all to authenticated using (public.is_admin()) with check (public.is_admin());

-- Realtime para placares, mata-mata e check-in.
alter publication supabase_realtime add table public.matches;
alter publication supabase_realtime add table public.knockout_matches;
alter publication supabase_realtime add table public.checkins;

-- Dados básicos das quatro modalidades. As demais tabelas serão populadas na próxima migração.
insert into public.competitions (id,name,short_name,format,advance_rule,sort_order) values
('v2m','Vôlei 2x2 Masculino','Vôlei 2x2 Masc.','15 duplas · 4 grupos','2 melhores de cada grupo avançam',1),
('v4x','Vôlei 4x4 Misto','Vôlei 4x4 Misto','8 equipes · 2 grupos','2 melhores de cada grupo avançam',2),
('v2f','Vôlei 2x2 Feminino','Vôlei 2x2 Fem.','5 duplas · grupo único','4 melhores avançam',3),
('fvm','Futvôlei 2x2 Masculino','Futvôlei 2x2','4 duplas · grupo único','4 avançam',4);

-- Verificação rápida após executar:
select id, name from public.competitions order by sort_order;
