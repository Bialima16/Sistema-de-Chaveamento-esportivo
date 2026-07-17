export function calculateStandings(comp,group){
  const teams=group.teams.map(t=>({team:t,j:0,v:0,d:0,sv:0,sp:0,pf:0,pc:0}));
  const map=Object.fromEntries(teams.map(x=>[x.team.id,x]));
  const finished=comp.matches.filter(m=>m.group===group.name&&['Finalizada','W.O.'].includes(m.status));
  finished.forEach(m=>{const a=map[m.a],b=map[m.b];if(!a||!b)return;a.j++;b.j++;let setsA=0,setsB=0;(m.sets||[]).forEach(s=>{const pa=+s.a||0,pb=+s.b||0;a.pf+=pa;a.pc+=pb;b.pf+=pb;b.pc+=pa;if(pa>pb)setsA++;else if(pb>pa)setsB++});a.sv+=setsA;a.sp+=setsB;b.sv+=setsB;b.sp+=setsA;const winner=m.winner||(setsA>setsB?m.a:m.b);if(winner===m.a){a.v++;b.d++}else{b.v++;a.d++}});
  const direct=(a,b)=>{const m=finished.find(x=>[x.a,x.b].includes(a.team.id)&&[x.a,x.b].includes(b.team.id));if(!m)return 0;return m.winner===a.team.id?-1:m.winner===b.team.id?1:0};
  return teams.sort((a,b)=>b.v-a.v||(b.sv-b.sp)-(a.sv-a.sp)||(b.pf-b.pc)-(a.pf-a.pc)||direct(a,b)).map((x,i)=>({...x,pos:i+1,pts:x.v*2+(comp.id==='v2f'?x.d:0),ss:x.sv-x.sp,sd:x.pf-x.pc}));
}
