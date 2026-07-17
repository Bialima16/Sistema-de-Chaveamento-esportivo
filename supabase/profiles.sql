-- JUSA — vinculação dos usuários do Supabase Auth aos perfis e modalidades
-- Antes de executar, crie no painel Authentication > Users exatamente os cinco e-mails abaixo.

begin;

insert into public.profiles (id,display_name,role,competition_id)
select id,'Administrador JUSA','admin'::public.user_role,null
from auth.users where lower(email)=lower('admin@jusa.app')
on conflict (id) do update set display_name=excluded.display_name,role=excluded.role,competition_id=excluded.competition_id;

insert into public.profiles (id,display_name,role,competition_id)
select id,'Árbitro — Vôlei 2x2 Masculino','referee'::public.user_role,'v2m'
from auth.users where lower(email)=lower('arbitro.v2m@jusa.app')
on conflict (id) do update set display_name=excluded.display_name,role=excluded.role,competition_id=excluded.competition_id;

insert into public.profiles (id,display_name,role,competition_id)
select id,'Árbitro — Vôlei 4x4 Misto','referee'::public.user_role,'v4x'
from auth.users where lower(email)=lower('arbitro.v4x@jusa.app')
on conflict (id) do update set display_name=excluded.display_name,role=excluded.role,competition_id=excluded.competition_id;

insert into public.profiles (id,display_name,role,competition_id)
select id,'Árbitro — Vôlei 2x2 Feminino','referee'::public.user_role,'v2f'
from auth.users where lower(email)=lower('arbitro.v2f@jusa.app')
on conflict (id) do update set display_name=excluded.display_name,role=excluded.role,competition_id=excluded.competition_id;

insert into public.profiles (id,display_name,role,competition_id)
select id,'Árbitro — Futvôlei 2x2 Masculino','referee'::public.user_role,'fvm'
from auth.users where lower(email)=lower('arbitro.fvm@jusa.app')
on conflict (id) do update set display_name=excluded.display_name,role=excluded.role,competition_id=excluded.competition_id;

commit;

-- Devem aparecer exatamente cinco linhas.
select p.display_name,p.role,p.competition_id,u.email
from public.profiles p
join auth.users u on u.id=p.id
order by p.role,p.competition_id nulls first;
