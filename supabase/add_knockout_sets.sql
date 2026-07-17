-- Necessário para registrar os pontos de cada set no mata-mata.
alter table public.knockout_matches add column if not exists sets jsonb not null default '[]'::jsonb;
