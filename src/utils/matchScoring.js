export const isSingleSet=(competitionId,phase)=>competitionId==='fvm'&&phase==='Grupos';
export const targetForSet=index=>index===2?15:18;
export function isValidSet(set,index){const a=Number(set?.a),b=Number(set?.b),target=targetForSet(index);return Number.isInteger(a)&&Number.isInteger(b)&&Math.max(a,b)>=target&&Math.abs(a-b)>=2}
export function summarizeSets(sets=[]){let a=0,b=0;sets.forEach((s,i)=>{if(isValidSet(s,i)){if(+s.a>+s.b)a++;else b++}});return{a,b,winner:a>b?'a':b>a?'b':null}}
export function validateFinalSets(sets,single){if(single)return isValidSet(sets[0],0)?null:'O placar deve chegar a 18 pontos com diferença mínima de 2.';if(!isValidSet(sets[0],0)||!isValidSet(sets[1],1))return'Preencha os dois primeiros sets com diferença mínima de 2 pontos.';const firstTwo=summarizeSets(sets.slice(0,2));if(firstTwo.a===1&&firstTwo.b===1&&!isValidSet(sets[2],2))return'O terceiro set deve chegar a 15 pontos com diferença mínima de 2.';return null}
