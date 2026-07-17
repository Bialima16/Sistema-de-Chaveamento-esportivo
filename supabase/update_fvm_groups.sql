-- Atualização oficial do Futvôlei: 6 duplas, 15 jogos, semifinais e final.
begin;
update public.competitions set format='6 duplas · grupo único',advance_rule='4 melhores avançam para as semifinais' where id='fvm';
update public.knockout_matches set team_a_id=null,team_b_id=null,score_a=null,score_b=null,sets='[]'::jsonb,winner_id=null,status='Pendente' where competition_id='fvm';
delete from public.matches where competition_id='fvm';
delete from public.athletes where competition_id='fvm';

insert into public.teams (id,competition_id,group_id,name,university,sort_order) values
('fvma-1','fvm','fvma','Abner e Guilherme','',1),
('fvma-2','fvm','fvma','Lucas e Pedro','',2),
('fvma-3','fvm','fvma','Renan e Rômulo','',3),
('fvma-4','fvm','fvma','Marinho e Davi','',4),
('fvma-5','fvm','fvma','Vinicius e Davi','',5),
('fvma-6','fvm','fvma','Benicio e Iago','',6)
on conflict (id) do update set name=excluded.name,group_id=excluded.group_id,sort_order=excluded.sort_order;

insert into public.athletes (team_id,competition_id,name,sort_order) values
('fvma-1','fvm','Abner',1),('fvma-1','fvm','Guilherme',2),
('fvma-2','fvm','Lucas',1),('fvma-2','fvm','Pedro',2),
('fvma-3','fvm','Renan',1),('fvma-3','fvm','Rômulo',2),
('fvma-4','fvm','Marinho',1),('fvma-4','fvm','Davi',2),
('fvma-5','fvm','Vinicius',1),('fvma-5','fvm','Davi',2),
('fvma-6','fvm','Benicio',1),('fvma-6','fvm','Iago',2);

insert into public.matches (id,competition_id,group_id,phase,match_order,team_a_id,team_b_id) values
('fvm-g-1','fvm','fvma','Grupos',1,'fvma-1','fvma-6'),
('fvm-g-2','fvm','fvma','Grupos',2,'fvma-2','fvma-5'),
('fvm-g-3','fvm','fvma','Grupos',3,'fvma-3','fvma-4'),
('fvm-g-4','fvm','fvma','Grupos',4,'fvma-1','fvma-5'),
('fvm-g-5','fvm','fvma','Grupos',5,'fvma-6','fvma-4'),
('fvm-g-6','fvm','fvma','Grupos',6,'fvma-2','fvma-3'),
('fvm-g-7','fvm','fvma','Grupos',7,'fvma-1','fvma-4'),
('fvm-g-8','fvm','fvma','Grupos',8,'fvma-5','fvma-3'),
('fvm-g-9','fvm','fvma','Grupos',9,'fvma-6','fvma-2'),
('fvm-g-10','fvm','fvma','Grupos',10,'fvma-1','fvma-3'),
('fvm-g-11','fvm','fvma','Grupos',11,'fvma-4','fvma-2'),
('fvm-g-12','fvm','fvma','Grupos',12,'fvma-5','fvma-6'),
('fvm-g-13','fvm','fvma','Grupos',13,'fvma-1','fvma-2'),
('fvm-g-14','fvm','fvma','Grupos',14,'fvma-3','fvma-6'),
('fvm-g-15','fvm','fvma','Grupos',15,'fvma-4','fvma-5');

insert into public.checkins (athlete_id,competition_id) select id,competition_id from public.athletes where competition_id='fvm' on conflict (athlete_id) do nothing;
commit;
select count(*) as jogos_futvolei from public.matches where competition_id='fvm';
