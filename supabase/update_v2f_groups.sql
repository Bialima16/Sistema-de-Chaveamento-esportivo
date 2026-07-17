-- Atualização oficial do Vôlei 2x2 Feminino: 6 duplas, 15 jogos e 5 rodadas.
begin;
update public.competitions set format='6 duplas · grupo único',advance_rule='4 melhores avançam para as semifinais' where id='v2f';
update public.knockout_matches set team_a_id=null,team_b_id=null,score_a=null,score_b=null,sets='[]'::jsonb,winner_id=null,status='Pendente' where competition_id='v2f';
delete from public.matches where competition_id='v2f';
delete from public.athletes where competition_id='v2f';

insert into public.teams (id,competition_id,group_id,name,university,sort_order) values
('v2fa-1','v2f','v2fa','Anne e Julia Fontes','',1),
('v2fa-2','v2f','v2fa','Letícia e Julia Vieira','',2),
('v2fa-3','v2f','v2fa','Clara e Isadora','',3),
('v2fa-4','v2f','v2fa','Amanda e Julia','',4),
('v2fa-5','v2f','v2fa','Beatriz e Ana Luiza','',5),
('v2fa-6','v2f','v2fa','Ana Clara e Letícia','',6)
on conflict (id) do update set name=excluded.name,group_id=excluded.group_id,sort_order=excluded.sort_order;

insert into public.athletes (team_id,competition_id,name,sort_order) values
('v2fa-1','v2f','Anne',1),('v2fa-1','v2f','Julia Fontes',2),
('v2fa-2','v2f','Letícia',1),('v2fa-2','v2f','Julia Vieira',2),
('v2fa-3','v2f','Clara',1),('v2fa-3','v2f','Isadora',2),
('v2fa-4','v2f','Amanda',1),('v2fa-4','v2f','Julia',2),
('v2fa-5','v2f','Beatriz',1),('v2fa-5','v2f','Ana Luiza',2),
('v2fa-6','v2f','Ana Clara',1),('v2fa-6','v2f','Letícia',2);

insert into public.matches (id,competition_id,group_id,phase,match_order,team_a_id,team_b_id) values
('v2f-g-1','v2f','v2fa','Grupos',1,'v2fa-1','v2fa-6'),
('v2f-g-2','v2f','v2fa','Grupos',2,'v2fa-2','v2fa-5'),
('v2f-g-3','v2f','v2fa','Grupos',3,'v2fa-3','v2fa-4'),
('v2f-g-4','v2f','v2fa','Grupos',4,'v2fa-1','v2fa-5'),
('v2f-g-5','v2f','v2fa','Grupos',5,'v2fa-6','v2fa-4'),
('v2f-g-6','v2f','v2fa','Grupos',6,'v2fa-2','v2fa-3'),
('v2f-g-7','v2f','v2fa','Grupos',7,'v2fa-1','v2fa-4'),
('v2f-g-8','v2f','v2fa','Grupos',8,'v2fa-5','v2fa-3'),
('v2f-g-9','v2f','v2fa','Grupos',9,'v2fa-6','v2fa-2'),
('v2f-g-10','v2f','v2fa','Grupos',10,'v2fa-1','v2fa-3'),
('v2f-g-11','v2f','v2fa','Grupos',11,'v2fa-4','v2fa-2'),
('v2f-g-12','v2f','v2fa','Grupos',12,'v2fa-5','v2fa-6'),
('v2f-g-13','v2f','v2fa','Grupos',13,'v2fa-1','v2fa-2'),
('v2f-g-14','v2f','v2fa','Grupos',14,'v2fa-3','v2fa-6'),
('v2f-g-15','v2f','v2fa','Grupos',15,'v2fa-4','v2fa-5');

insert into public.checkins (athlete_id,competition_id) select id,competition_id from public.athletes where competition_id='v2f' on conflict (athlete_id) do nothing;
commit;
select count(*) as jogos_femininos from public.matches where competition_id='v2f';
