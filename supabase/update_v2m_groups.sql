-- Atualização oficial do Vôlei 2x2 Masculino: 4 grupos de 4 equipes e 24 jogos.
begin;

update public.competitions set format='16 equipes · 4 grupos' where id='v2m';

-- Limpa resultados e dependências operacionais da modalidade antes de trocar os elencos.
update public.knockout_matches set team_a_id=null,team_b_id=null,score_a=null,score_b=null,sets='[]'::jsonb,winner_id=null,status='Pendente' where competition_id='v2m';
delete from public.matches where competition_id='v2m';
delete from public.athletes where competition_id='v2m';

insert into public.teams (id,competition_id,group_id,name,university,sort_order) values
('v2ma-1','v2m','v2ma','Gustavo e Davi','',1),
('v2ma-2','v2m','v2ma','Breno e Pablo','',2),
('v2ma-3','v2m','v2ma','João e Danilo','',3),
('v2ma-4','v2m','v2ma','Fernando e Cauã','',4),
('v2mb-1','v2m','v2mb','Carlos H. e João P.','',1),
('v2mb-2','v2m','v2mb','Felipe e Domingos','',2),
('v2mb-3','v2m','v2mb','Pedro e Eliabe','',3),
('v2mb-4','v2m','v2mb','Nathan e Keven','',4),
('v2mc-1','v2m','v2mc','Abner e Guilherme','',1),
('v2mc-2','v2m','v2mc','Pietro e João T.','',2),
('v2mc-3','v2m','v2mc','Honorato, Yago e Renan','',3),
('v2mc-4','v2m','v2mc','Davi e Rodrigo','',4),
('v2md-1','v2m','v2md','Pedro C. e Ramon V.','',1),
('v2md-2','v2m','v2md','Davi P. e João G.','',2),
('v2md-3','v2m','v2md','PH e João Gui.','',3),
('v2md-4','v2m','v2md','Matheus e Henry','',4)
on conflict (id) do update set group_id=excluded.group_id,name=excluded.name,sort_order=excluded.sort_order;

insert into public.athletes (team_id,competition_id,name,sort_order) values
('v2ma-1','v2m','Gustavo',1),('v2ma-1','v2m','Davi',2),('v2ma-2','v2m','Breno',1),('v2ma-2','v2m','Pablo',2),('v2ma-3','v2m','João',1),('v2ma-3','v2m','Danilo',2),('v2ma-4','v2m','Fernando',1),('v2ma-4','v2m','Cauã',2),
('v2mb-1','v2m','Carlos H.',1),('v2mb-1','v2m','João P.',2),('v2mb-2','v2m','Felipe',1),('v2mb-2','v2m','Domingos',2),('v2mb-3','v2m','Pedro',1),('v2mb-3','v2m','Eliabe',2),('v2mb-4','v2m','Nathan',1),('v2mb-4','v2m','Keven',2),
('v2mc-1','v2m','Abner',1),('v2mc-1','v2m','Guilherme',2),('v2mc-2','v2m','Pietro',1),('v2mc-2','v2m','João T.',2),('v2mc-3','v2m','Honorato',1),('v2mc-3','v2m','Yago',2),('v2mc-3','v2m','Renan',3),('v2mc-4','v2m','Davi',1),('v2mc-4','v2m','Rodrigo',2),
('v2md-1','v2m','Pedro C.',1),('v2md-1','v2m','Ramon V.',2),('v2md-2','v2m','Davi P.',1),('v2md-2','v2m','João G.',2),('v2md-3','v2m','PH',1),('v2md-3','v2m','João Gui.',2),('v2md-4','v2m','Matheus',1),('v2md-4','v2m','Henry',2);

-- Jogos na ordem oficial: cada par de linhas forma uma rodada.
insert into public.matches (id,competition_id,group_id,phase,match_order,team_a_id,team_b_id) values
('v2m-g-1','v2m','v2ma','Grupos',1,'v2ma-1','v2ma-4'),
('v2m-g-2','v2m','v2ma','Grupos',2,'v2ma-2','v2ma-3'),
('v2m-g-3','v2m','v2ma','Grupos',3,'v2ma-1','v2ma-3'),
('v2m-g-4','v2m','v2ma','Grupos',4,'v2ma-4','v2ma-2'),
('v2m-g-5','v2m','v2ma','Grupos',5,'v2ma-1','v2ma-2'),
('v2m-g-6','v2m','v2ma','Grupos',6,'v2ma-3','v2ma-4'),
('v2m-g-7','v2m','v2mb','Grupos',7,'v2mb-1','v2mb-4'),
('v2m-g-8','v2m','v2mb','Grupos',8,'v2mb-2','v2mb-3'),
('v2m-g-9','v2m','v2mb','Grupos',9,'v2mb-1','v2mb-3'),
('v2m-g-10','v2m','v2mb','Grupos',10,'v2mb-4','v2mb-2'),
('v2m-g-11','v2m','v2mb','Grupos',11,'v2mb-1','v2mb-2'),
('v2m-g-12','v2m','v2mb','Grupos',12,'v2mb-3','v2mb-4'),
('v2m-g-13','v2m','v2mc','Grupos',13,'v2mc-1','v2mc-4'),
('v2m-g-14','v2m','v2mc','Grupos',14,'v2mc-2','v2mc-3'),
('v2m-g-15','v2m','v2mc','Grupos',15,'v2mc-1','v2mc-3'),
('v2m-g-16','v2m','v2mc','Grupos',16,'v2mc-4','v2mc-2'),
('v2m-g-17','v2m','v2mc','Grupos',17,'v2mc-1','v2mc-2'),
('v2m-g-18','v2m','v2mc','Grupos',18,'v2mc-3','v2mc-4'),
('v2m-g-19','v2m','v2md','Grupos',19,'v2md-1','v2md-4'),
('v2m-g-20','v2m','v2md','Grupos',20,'v2md-2','v2md-3'),
('v2m-g-21','v2m','v2md','Grupos',21,'v2md-1','v2md-3'),
('v2m-g-22','v2m','v2md','Grupos',22,'v2md-4','v2md-2'),
('v2m-g-23','v2m','v2md','Grupos',23,'v2md-1','v2md-2'),
('v2m-g-24','v2m','v2md','Grupos',24,'v2md-3','v2md-4');

insert into public.checkins (athlete_id,competition_id) select id,competition_id from public.athletes where competition_id='v2m' on conflict (athlete_id) do nothing;
commit;

select g.name,count(m.id) as jogos
from public.groups g left join public.matches m on m.group_id=g.id
where g.competition_id='v2m'
group by g.name,g.sort_order order by g.sort_order;
