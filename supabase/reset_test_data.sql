-- Limpa somente dados operacionais de teste. Preserva modalidades, grupos, equipes, atletas e partidas.
begin;
update public.matches set score_a=null,score_b=null,sets='[]'::jsonb,winner_id=null,status='Pendente',match_date=null,match_time=null,notes='';
update public.knockout_matches set team_a_id=null,team_b_id=null,score_a=null,score_b=null,sets='[]'::jsonb,winner_id=null,status='Pendente';
update public.checkins set arrived=false,notes='';
commit;
select
  (select count(*) from public.matches where status<>'Pendente' or score_a is not null or score_b is not null) as jogos_com_dados,
  (select count(*) from public.knockout_matches where status<>'Pendente' or winner_id is not null) as mata_mata_com_dados,
  (select count(*) from public.checkins where arrived or notes<>'') as checkins_com_dados;
