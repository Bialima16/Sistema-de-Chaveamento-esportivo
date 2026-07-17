-- JUSA — dados completos iniciais
-- Execute após supabase/schema.sql.

begin;

insert into public.groups (id,competition_id,name,sort_order) values
('v2ma','v2m','Grupo A',1),('v2mb','v2m','Grupo B',2),('v2mc','v2m','Grupo C',3),('v2md','v2m','Grupo D',4),
('v4a','v4x','Grupo A',1),('v4b','v4x','Grupo B',2),
('v2fa','v2f','Grupo Único',1),('fvma','fvm','Grupo Único',1)
on conflict (id) do update set name=excluded.name,sort_order=excluded.sort_order;

insert into public.teams (id,competition_id,group_id,name,university,sort_order) values
('v2ma-1','v2m','v2ma','Gustavo / Davi','',1),('v2ma-2','v2m','v2ma','João Emanuel / Danilo','',2),('v2ma-3','v2m','v2ma','Breno / Pablo','',3),('v2ma-4','v2m','v2ma','Fernando / Cauã','',4),
('v2mb-1','v2m','v2mb','Carlos H. / João P.','',1),('v2mb-2','v2m','v2mb','Felipe / José Adriel','',2),('v2mb-3','v2m','v2mb','Pedro V. / Eliabe','',3),('v2mb-4','v2m','v2mb','Nathan / Keven','',4),
('v2mc-1','v2m','v2mc','Abner / Guilherme','',1),('v2mc-2','v2m','v2mc','Pietro / João T.','',2),('v2mc-3','v2m','v2mc','Davi / Rodrigo','',3),
('v2md-1','v2m','v2md','Pedro H. / Ramon V.','',1),('v2md-2','v2m','v2md','Davi P. / João G.','',2),('v2md-3','v2m','v2md','PH / João Gui','',3),('v2md-4','v2m','v2md','Honorato / Yago','',4),
('v4a-1','v4x','v4a','Time Carlos Huan','Unifor',1),('v4a-2','v4x','v4a','Time Abner Viana','UFC',2),('v4a-3','v4x','v4a','Time Davi Lopes','UFC',3),('v4a-4','v4x','v4a','Time Pietro Maia','Unifor',4),
('v4b-1','v4x','v4b','Time Beatriz Lima','Unifor',1),('v4b-2','v4x','v4b','Time João Honorato','Unifor',2),('v4b-3','v4x','v4b','Time João Guilherme','Unifor',3),('v4b-4','v4x','v4b','Time Yago Alex','Unifor',4),
('v2fa-1','v2f','v2fa','Anne Liang / Julia Fontes','',1),('v2fa-2','v2f','v2fa','Letícia Oliveira / Júlia Vieira','',2),('v2fa-3','v2f','v2fa','Isadora Cruz / Clara Amorim','',3),('v2fa-4','v2f','v2fa','Amanda Landon / Júlia Guimarães','',4),('v2fa-5','v2f','v2fa','Beatriz Lima / Ana Luiza','',5),
('fvma-1','fvm','fvma','Abner / Guilherme','',1),('fvma-2','fvm','fvma','Lucas / Pedro','',2),('fvma-3','fvm','fvma','Renan / Rômulo','',3),('fvma-4','fvm','fvma','Marinho / Davi','',4)
on conflict (id) do update set group_id=excluded.group_id,name=excluded.name,university=excluded.university,sort_order=excluded.sort_order;

-- Atletas: a chave natural usada nesta carga é equipe + nome.
insert into public.athletes (team_id,competition_id,name,sort_order)
select v.team_id,t.competition_id,v.name,v.sort_order
from (values
('v2ma-1','Gustavo',1),('v2ma-1','Davi',2),('v2ma-2','João Emanuel',1),('v2ma-2','Danilo',2),('v2ma-3','Breno',1),('v2ma-3','Pablo',2),('v2ma-4','Fernando',1),('v2ma-4','Cauã',2),
('v2mb-1','Carlos H.',1),('v2mb-1','João P.',2),('v2mb-2','Felipe',1),('v2mb-2','José Adriel',2),('v2mb-3','Pedro V.',1),('v2mb-3','Eliabe',2),('v2mb-4','Nathan',1),('v2mb-4','Keven',2),
('v2mc-1','Abner',1),('v2mc-1','Guilherme',2),('v2mc-2','Pietro',1),('v2mc-2','João T.',2),('v2mc-3','Davi',1),('v2mc-3','Rodrigo',2),
('v2md-1','Pedro H.',1),('v2md-1','Ramon V.',2),('v2md-2','Davi P.',1),('v2md-2','João G.',2),('v2md-3','PH',1),('v2md-3','João Gui',2),('v2md-4','Honorato',1),('v2md-4','Yago',2),
('v4a-1','Carlos Huan Celestino',1),('v4a-1','João Pedro Lobo',2),('v4a-1','Anne Liang',3),('v4a-1','Julia Fontes',4),
('v4a-2','Abner Viana',1),('v4a-2','Guilherme Pontes',2),('v4a-2','Gabrielly',3),('v4a-2','Parceira',4),
('v4a-3','Davi da Silva Lopes',1),('v4a-3','Rodrigo Alves',2),('v4a-3','Letícia Oliveira',3),('v4a-3','Júlia Vieira',4),
('v4a-4','Pietro Maia de Alcântara',1),('v4a-4','João Travasso Barroso',2),('v4a-4','Maria Clara',3),('v4a-4','Alanis Moreira',4),
('v4b-1','Beatriz Lima',1),('v4b-1','Ana Luiza',2),('v4b-1','Iago',3),('v4b-1','Renato',4),('v4b-1','Guilherme',5),('v4b-1','Carlos',6),
('v4b-2','João Honorato',1),('v4b-2','Bruno Wairan',2),('v4b-2','Julia',3),('v4b-2','Amanda',4),
('v4b-3','João Guilherme Araujo Alves',1),('v4b-3','Davi Pinheiro Mesquita',2),('v4b-3','Vanielle Cardoso',3),('v4b-3','Maressa Cardoso',4),
('v4b-4','Yago Alex',1),('v4b-4','Pedro',2),('v4b-4','Graze',3),('v4b-4','Keven Daniel',4),('v4b-4','Sofia',5),
('v2fa-1','Anne Liang',1),('v2fa-1','Julia Fontes',2),('v2fa-2','Letícia Oliveira',1),('v2fa-2','Júlia Vieira',2),('v2fa-3','Isadora Cruz',1),('v2fa-3','Clara Amorim',2),('v2fa-4','Amanda Landon',1),('v2fa-4','Júlia Guimarães',2),('v2fa-5','Beatriz Lima',1),('v2fa-5','Ana Luiza',2),
('fvma-1','Abner',1),('fvma-1','Guilherme',2),('fvma-2','Lucas',1),('fvma-2','Pedro',2),('fvma-3','Renan',1),('fvma-3','Rômulo',2),('fvma-4','Marinho',1),('fvma-4','Davi',2)
) as v(team_id,name,sort_order)
join public.teams t on t.id=v.team_id
where not exists (select 1 from public.athletes a where a.team_id=v.team_id and a.name=v.name);

-- Jogos dos grupos com quatro/chaves múltiplas: todos contra todos dentro de cada grupo.
with pairings as (
  select a.competition_id,a.group_id,a.id team_a_id,b.id team_b_id,
    row_number() over(partition by a.competition_id order by g.sort_order,a.sort_order,b.sort_order) match_order
  from public.teams a
  join public.teams b on b.group_id=a.group_id and b.sort_order>a.sort_order
  join public.groups g on g.id=a.group_id
  where a.competition_id in ('v2m','v4x')
)
insert into public.matches (id,competition_id,group_id,phase,match_order,team_a_id,team_b_id)
select competition_id||'-g-'||match_order,competition_id,group_id,'Grupos',match_order,team_a_id,team_b_id from pairings
on conflict (id) do nothing;

-- Ordem oficial do Vôlei 2x2 Feminino.
insert into public.matches (id,competition_id,group_id,phase,match_order,team_a_id,team_b_id) values
('v2f-g-1','v2f','v2fa','Grupos',1,'v2fa-2','v2fa-5'),('v2f-g-2','v2f','v2fa','Grupos',2,'v2fa-3','v2fa-4'),
('v2f-g-3','v2f','v2fa','Grupos',3,'v2fa-1','v2fa-2'),('v2f-g-4','v2f','v2fa','Grupos',4,'v2fa-5','v2fa-3'),
('v2f-g-5','v2f','v2fa','Grupos',5,'v2fa-4','v2fa-1'),('v2f-g-6','v2f','v2fa','Grupos',6,'v2fa-2','v2fa-3'),
('v2f-g-7','v2f','v2fa','Grupos',7,'v2fa-5','v2fa-4'),('v2f-g-8','v2f','v2fa','Grupos',8,'v2fa-1','v2fa-3'),
('v2f-g-9','v2f','v2fa','Grupos',9,'v2fa-2','v2fa-4'),('v2f-g-10','v2f','v2fa','Grupos',10,'v2fa-5','v2fa-1')
on conflict (id) do nothing;

-- Ordem oficial do Futvôlei 2x2 Masculino.
insert into public.matches (id,competition_id,group_id,phase,match_order,team_a_id,team_b_id) values
('fvm-g-1','fvm','fvma','Grupos',1,'fvma-1','fvma-2'),('fvm-g-2','fvm','fvma','Grupos',2,'fvma-3','fvma-4'),
('fvm-g-3','fvm','fvma','Grupos',3,'fvma-1','fvma-3'),('fvm-g-4','fvm','fvma','Grupos',4,'fvma-2','fvma-4'),
('fvm-g-5','fvm','fvma','Grupos',5,'fvma-1','fvma-4'),('fvm-g-6','fvm','fvma','Grupos',6,'fvma-2','fvma-3')
on conflict (id) do nothing;

-- Estrutura vazia das fases eliminatórias.
insert into public.knockout_matches (competition_id,id,phase,match_order) values
('v2m','qf1','Quartas de Final',1),('v2m','qf2','Quartas de Final',2),('v2m','qf3','Quartas de Final',3),('v2m','qf4','Quartas de Final',4),('v2m','sf1','Semifinal',1),('v2m','sf2','Semifinal',2),('v2m','final','Final',1),
('v4x','sf1','Semifinal',1),('v4x','sf2','Semifinal',2),('v4x','final','Final',1),
('v2f','sf1','Semifinal',1),('v2f','sf2','Semifinal',2),('v2f','final','Final',1),
('fvm','sf1','Semifinal',1),('fvm','sf2','Semifinal',2),('fvm','final','Final',1)
on conflict (competition_id,id) do nothing;

insert into public.checkins (athlete_id,competition_id)
select id,competition_id from public.athletes
on conflict (athlete_id) do nothing;

commit;

-- Resultado esperado: 8 grupos, 32 equipes, 83 atletas, 49 jogos e 16 confrontos eliminatórios.
select
  (select count(*) from public.groups) as grupos,
  (select count(*) from public.teams) as equipes,
  (select count(*) from public.athletes) as atletas,
  (select count(*) from public.matches) as jogos,
  (select count(*) from public.knockout_matches) as mata_mata;
