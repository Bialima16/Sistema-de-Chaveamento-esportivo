import{supabase}from'./supabaseClient';

const bracketByCompetition={v2m:[['A1','B2'],['C1','D2'],['B1','A2'],['D1','C2']],v4x:[['A1','B2'],['B1','A2']],v2f:[['1º','4º'],['2º','3º']],fvm:[['1º','4º'],['2º','3º']]};

function assert(result){if(result.error)throw result.error;return result.data}

export const supabaseService={
  async loadAll(){
    const results=await Promise.all([
      supabase.from('competitions').select('*').order('sort_order'),
      supabase.from('groups').select('*').order('sort_order'),
      supabase.from('teams').select('*').order('sort_order'),
      supabase.from('athletes').select('*').order('sort_order'),
      supabase.from('matches').select('*').order('match_order'),
      supabase.from('knockout_matches').select('*'),
      supabase.auth.getSession()
    ]);
    const[competitions,groups,teams,athletes,matches,knockout]=results.map((r,i)=>i===6?r.data:assert(r));
    let checkins=[];
    if(results[6].data.session)checkins=assert(await supabase.from('checkins').select('*'));
    const athleteMap=athletes.reduce((map,a)=>{(map[a.team_id]??=[]).push(a);return map},{});
    const teamObjects=teams.map(t=>({...t,university:t.university||'',athletes:(athleteMap[t.id]||[]).map(a=>a.name),athleteRecords:athleteMap[t.id]||[]}));
    const teamMap=Object.fromEntries(teamObjects.map(t=>[t.id,t]));
    const groupMap=Object.fromEntries(groups.map(g=>[g.id,g]));
    const competitionsData=competitions.map(c=>{
      const compTeams=teamObjects.filter(t=>t.competition_id===c.id);
      const compGroups=groups.filter(g=>g.competition_id===c.id).map(g=>({id:g.id,name:g.name,teams:compTeams.filter(t=>t.group_id===g.id)}));
      const compKnockout=Object.fromEntries(knockout.filter(k=>k.competition_id===c.id).map(k=>[k.id,{scoreA:k.score_a??'',scoreB:k.score_b??'',status:k.status,winnerId:k.winner_id,teamAOverride:k.team_a_id,teamBOverride:k.team_b_id}]));
      return{id:c.id,name:c.name,short:c.short_name,format:c.format,advance:c.advance_rule,status:c.status,groups:compGroups,teams:compTeams,matches:matches.filter(m=>m.competition_id===c.id).map(m=>({id:m.id,a:m.team_a_id,b:m.team_b_id,order:m.match_order,group:groupMap[m.group_id]?.name||'',groupId:m.group_id,phase:m.phase,scoreA:m.score_a??'',scoreB:m.score_b??'',sets:m.sets||[],winner:m.winner_id,status:m.status,date:m.match_date||'',time:m.match_time?.slice(0,5)||'',court:m.court,notes:m.notes||''})),bracket:bracketByCompetition[c.id],knockoutMatches:compKnockout,manualRanking:false};
    });
    const checkinMap={};checkins.forEach(x=>{checkinMap[x.athlete_id]={arrived:x.arrived,notes:x.notes}});
    return{competitions:competitionsData,checkins:checkinMap,updatedAt:new Date().toISOString()};
  },
  async signIn(email,password){assert(await supabase.auth.signInWithPassword({email,password}));return this.getCurrentUser()},
  async signOut(){assert(await supabase.auth.signOut())},
  async getCurrentUser(){const{data:{user}}=await supabase.auth.getUser();if(!user)return null;const profile=assert(await supabase.from('profiles').select('*').eq('id',user.id).single());return{id:user.id,email:user.email,name:profile.display_name,role:profile.role,competitionId:profile.competition_id}},
  async updateMatch(id,values){assert(await supabase.from('matches').update({score_a:values.scoreA===''?null:+values.scoreA,score_b:values.scoreB===''?null:+values.scoreB,status:values.status,match_date:values.date||null,match_time:values.time||null,court:values.court,winner_id:values.winnerId||null}).eq('id',id))},
  async updateKnockout(competitionId,id,values){assert(await supabase.from('knockout_matches').update({score_a:values.scoreA===''?null:+values.scoreA,score_b:values.scoreB===''?null:+values.scoreB,status:values.status,winner_id:values.winnerId||null,team_a_id:values.teamA||null,team_b_id:values.teamB||null}).eq('competition_id',competitionId).eq('id',id))},
  async updateCheckin(athleteId,values){assert(await supabase.from('checkins').update(values).eq('athlete_id',athleteId))},
  subscribe(refresh){return supabase.channel('jusa-live').on('postgres_changes',{event:'*',schema:'public',table:'matches'},refresh).on('postgres_changes',{event:'*',schema:'public',table:'knockout_matches'},refresh).on('postgres_changes',{event:'*',schema:'public',table:'checkins'},refresh).subscribe()}
};
