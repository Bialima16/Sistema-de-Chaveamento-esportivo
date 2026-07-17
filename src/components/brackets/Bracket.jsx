import{useState}from'react';
import{Trophy,Clock3,CheckCircle2,PenLine}from'lucide-react';
import{calculateStandings}from'../../utils/calculateStandings';
import{useCompetition}from'../../context/CompetitionContext';
import{supabaseService}from'../../services/supabaseService';

function qualifiers(comp){
  const r=comp.groups.map(g=>calculateStandings(comp,g));
  if(comp.id==='v2m')return {A1:r[0]?.[0]?.team,A2:r[0]?.[1]?.team,B1:r[1]?.[0]?.team,B2:r[1]?.[1]?.team,C1:r[2]?.[0]?.team,C2:r[2]?.[1]?.team,D1:r[3]?.[0]?.team,D2:r[3]?.[1]?.team};
  if(comp.id==='v4x')return {A1:r[0]?.[0]?.team,A2:r[0]?.[1]?.team,B1:r[1]?.[0]?.team,B2:r[1]?.[1]?.team};
  return {'1º':r[0]?.[0]?.team,'2º':r[0]?.[1]?.team,'3º':r[0]?.[2]?.team,'4º':r[0]?.[3]?.team};
}

const emptyMatch={scoreA:'',scoreB:'',status:'Pendente',winnerId:null,teamAOverride:null,teamBOverride:null};

function KnockoutMatch({comp,id,label,automaticA,automaticB,enabled}){
  const{user,canEdit,refresh,notify}=useCompetition();
  const saved=comp.knockoutMatches?.[id]||emptyMatch;
  const teamA=saved.teamAOverride||automaticA;
  const teamB=saved.teamBOverride||automaticB;
  const team=id=>comp.teams.find(t=>t.id===id);
  const[editing,setEditing]=useState(false);
  const editable=canEdit(comp.id)&&enabled;
  const save=async e=>{
    e.preventDefault();
    const f=new FormData(e.currentTarget),status=f.get('status'),winnerId=f.get('winner')||null;
    const a=f.get('teamA')||teamA,b=f.get('teamB')||teamB;
    if(!a||!b||a===b)return notify('Selecione duas equipes diferentes');
    if(['Finalizada','W.O.'].includes(status)&&![a,b].includes(winnerId))return notify('Defina o vencedor para finalizar');
    try{await supabaseService.updateKnockout(comp.id,id,{scoreA:f.get('scoreA'),scoreB:f.get('scoreB'),status,winnerId,teamA:user.role==='admin'?a:teamA,teamB:user.role==='admin'?b:teamB});await refresh();setEditing(false);notify('Confronto salvo e sincronizado')}catch{notify('Não foi possível salvar o confronto')}
  };
  return <div className={'duel knockoutduel '+(!enabled?'lockedduel':'')}>
    <div className={saved.winnerId===teamA?'duelwinner':''}><span>{team(teamA)?.name||'A definir'}</span><strong>{saved.scoreA===''?'–':saved.scoreA}</strong></div>
    <div className={saved.winnerId===teamB?'duelwinner':''}><span>{team(teamB)?.name||'A definir'}</span><strong>{saved.scoreB===''?'–':saved.scoreB}</strong></div>
    <small>{label} · {saved.status}</small>
    {editable&&<button className="editduel" onClick={()=>setEditing(!editing)}><PenLine/> Editar confronto</button>}
    {editing&&<form className="knockoutform" onSubmit={save}>
      {user.role==='admin'&&<><label>Equipe A<select name="teamA" defaultValue={teamA||''}><option value="">A definir</option>{comp.teams.map(t=><option key={t.id} value={t.id}>{t.name}</option>)}</select></label><label>Equipe B<select name="teamB" defaultValue={teamB||''}><option value="">A definir</option>{comp.teams.map(t=><option key={t.id} value={t.id}>{t.name}</option>)}</select></label></>}
      <label>Placar A<input name="scoreA" type="number" min="0" defaultValue={saved.scoreA}/></label>
      <label>Placar B<input name="scoreB" type="number" min="0" defaultValue={saved.scoreB}/></label>
      <label>Status<select name="status" defaultValue={saved.status}>{['Pendente','Em andamento','Finalizada','W.O.','Cancelada'].map(x=><option key={x}>{x}</option>)}</select></label>
      <label>Vencedor<select name="winner" defaultValue={saved.winnerId||''}><option value="">A definir</option>{teamA&&<option value={teamA}>{team(teamA)?.name}</option>}{teamB&&<option value={teamB}>{team(teamB)?.name}</option>}</select></label>
      <div><button className="primary">Salvar</button><button type="button" onClick={()=>setEditing(false)}>Cancelar</button></div>
    </form>}
  </div>;
}

export default function Bracket({comp}){
  const groupMatches=comp.matches.filter(m=>m.phase==='Grupos');
  const groupsFinished=groupMatches.length>0&&groupMatches.every(m=>['Finalizada','W.O.'].includes(m.status));
  const q=groupsFinished?qualifiers(comp):{};
  const firstIsQuarter=comp.bracket.length>2;
  const firstIds=comp.bracket.map((_,i)=>(firstIsQuarter?'qf':'sf')+(i+1));
  const winner=id=>comp.knockoutMatches?.[id]?.winnerId||null;
  const firstTeams=comp.bracket.map(pair=>pair.map(position=>q[position]?.id||null));
  const semiTeams=firstIsQuarter?[[winner('qf1'),winner('qf2')],[winner('qf3'),winner('qf4')]]:firstTeams;
  const finalTeams=[winner('sf1'),winner('sf2')];
  const champion=comp.teams.find(t=>t.id===winner('final'));

  return <>
    <div className={'bracketstatus '+(groupsFinished?'ready':'waiting')}>{groupsFinished?<CheckCircle2/>:<Clock3/>}<div><b>{groupsFinished?'Mata-mata definido automaticamente':'Aguardando o fim da fase de grupos'}</b><p>{groupsFinished?'Edite os confrontos para registrar resultados e avançar os vencedores.':'Finalize todas as partidas dos grupos para revelar os confrontos.'}</p></div></div>
    <div className="bracket">
      <div className="round"><h3>{firstIsQuarter?'Quartas de final':'Semifinais'}</h3>{firstTeams.map((teams,i)=><KnockoutMatch key={firstIds[i]} comp={comp} id={firstIds[i]} label={firstIsQuarter?`QF ${i+1}`:`SF ${i+1}`} automaticA={teams[0]} automaticB={teams[1]} enabled={groupsFinished}/>)}</div>
      {firstIsQuarter&&<div className="round"><h3>Semifinais</h3>{semiTeams.map((teams,i)=><KnockoutMatch key={'sf'+(i+1)} comp={comp} id={'sf'+(i+1)} label={`SF ${i+1}`} automaticA={teams[0]} automaticB={teams[1]} enabled={!!teams[0]&&!!teams[1]}/>)}</div>}
      <div className="round"><h3>Final</h3><KnockoutMatch comp={comp} id="final" label="Final" automaticA={finalTeams[0]} automaticB={finalTeams[1]} enabled={!!finalTeams[0]&&!!finalTeams[1]}/><div className="champ"><Trophy/><span>CAMPEÃO</span><b>{champion?.name||'A definir'}</b></div></div>
    </div>
  </>;
}
