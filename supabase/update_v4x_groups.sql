-- Atualização oficial do Vôlei 4x4 Misto: 2 grupos, 12 jogos, semifinais e final.
begin;
update public.competitions set format='8 equipes · 2 grupos',advance_rule='2 melhores de cada grupo avançam para as semifinais' where id='v4x';
update public.knockout_matches set team_a_id=null,team_b_id=null,score_a=null,score_b=null,sets='[]'::jsonb,winner_id=null,status='Pendente' where competition_id='v4x';
delete from public.matches where competition_id='v4x';
delete from public.athletes where competition_id='v4x';

insert into public.teams (id,competition_id,group_id,name,university,sort_order) values
('v4a-1','v4x','v4a','Carlos, João P., Anne e Julia','',1),
('v4a-2','v4x','v4a','Abner, Guilherme, Gabrielly e E','',2),
('v4a-3','v4x','v4a','Davi, Rodrigo, Letícia e Julia','',3),
('v4a-4','v4x','v4a','Ana, Bea, Iago, Renato, Gui e Carlos','',4),
('v4b-1','v4x','v4b','Honorato, Wairan, Julia e Amanda','',1),
('v4b-2','v4x','v4b','Pietro, João, Clara e Alanis','',2),
('v4b-3','v4x','v4b','João G., Davi, Vanielle e Maressa','',3),
('v4b-4','v4x','v4b','Keven, Yago, Grazy, Sofia e Pedro','',4)
on conflict (id) do update set group_id=excluded.group_id,name=excluded.name,university=excluded.university,sort_order=excluded.sort_order;

insert into public.athletes (team_id,competition_id,name,sort_order) values
('v4a-1','v4x','Carlos',1),('v4a-1','v4x','João P.',2),('v4a-1','v4x','Anne',3),('v4a-1','v4x','Julia',4),
('v4a-2','v4x','Abner',1),('v4a-2','v4x','Guilherme',2),('v4a-2','v4x','Gabrielly',3),('v4a-2','v4x','E',4),
('v4a-3','v4x','Davi',1),('v4a-3','v4x','Rodrigo',2),('v4a-3','v4x','Letícia',3),('v4a-3','v4x','Julia',4),
('v4a-4','v4x','Ana',1),('v4a-4','v4x','Bea',2),('v4a-4','v4x','Iago',3),('v4a-4','v4x','Renato',4),('v4a-4','v4x','Gui',5),('v4a-4','v4x','Carlos',6),
('v4b-1','v4x','Honorato',1),('v4b-1','v4x','Wairan',2),('v4b-1','v4x','Julia',3),('v4b-1','v4x','Amanda',4),
('v4b-2','v4x','Pietro',1),('v4b-2','v4x','João',2),('v4b-2','v4x','Clara',3),('v4b-2','v4x','Alanis',4),
('v4b-3','v4x','João G.',1),('v4b-3','v4x','Davi',2),('v4b-3','v4x','Vanielle',3),('v4b-3','v4x','Maressa',4),
('v4b-4','v4x','Keven',1),('v4b-4','v4x','Yago',2),('v4b-4','v4x','Grazy',3),('v4b-4','v4x','Sofia',4),('v4b-4','v4x','Pedro',5);

insert into public.matches (id,competition_id,group_id,phase,match_order,team_a_id,team_b_id) values
('v4x-g-1','v4x','v4a','Grupos',1,'v4a-1','v4a-2'),
('v4x-g-2','v4x','v4a','Grupos',2,'v4a-3','v4a-4'),
('v4x-g-3','v4x','v4a','Grupos',3,'v4a-1','v4a-3'),
('v4x-g-4','v4x','v4a','Grupos',4,'v4a-2','v4a-4'),
('v4x-g-5','v4x','v4a','Grupos',5,'v4a-1','v4a-4'),
('v4x-g-6','v4x','v4a','Grupos',6,'v4a-2','v4a-3'),
('v4x-g-7','v4x','v4b','Grupos',7,'v4b-1','v4b-2'),
('v4x-g-8','v4x','v4b','Grupos',8,'v4b-3','v4b-4'),
('v4x-g-9','v4x','v4b','Grupos',9,'v4b-1','v4b-3'),
('v4x-g-10','v4x','v4b','Grupos',10,'v4b-2','v4b-4'),
('v4x-g-11','v4x','v4b','Grupos',11,'v4b-1','v4b-4'),
('v4x-g-12','v4x','v4b','Grupos',12,'v4b-2','v4b-3');

insert into public.checkins (athlete_id,competition_id) select id,competition_id from public.athletes where competition_id='v4x' on conflict (athlete_id) do nothing;
commit;
select g.name,count(m.id) as jogos from public.groups g left join public.matches m on m.group_id=g.id where g.competition_id='v4x' group by g.name,g.sort_order order by g.sort_order;
