import assert from 'node:assert/strict';
import {execFileSync} from 'node:child_process';
import {readFileSync,writeFileSync,mkdirSync} from 'node:fs';
assert.equal(process.env.GITHUB_ACTIONS,'true');assert.equal(process.platform,'linux');assert.equal(execFileSync('calcit',['-v'],{encoding:'utf8'}).trim(),'0.30.1');
const run=(...a)=>execFileSync('calcit',['calcit.cirru',...a],{encoding:'utf8',maxBuffer:48e6,stdio:['ignore','pipe','pipe']});
const blob=()=>execFileSync('git',['hash-object','calcit.cirru'],{encoding:'utf8'}).trim();assert.equal(blob(),'ba61a263e66db88821870dd3fb5b96a315a2b119');
const norm=v=>Array.isArray(v)?v.map(norm):v&&typeof v==='object'?Object.fromEntries(Object.entries(v).map(([k,x])=>[k,k==='__edn_set'?x.map(norm).sort((a,b)=>JSON.stringify(a).localeCompare(JSON.stringify(b))):norm(x)])):v;
const q=(...a)=>norm(JSON.parse(run('query',...a,'--format','json')).data);
const input=JSON.parse(readFileSync('reviewed.json','utf8')),before={config:norm(input.config.data),namespaces:input.namespaces.map(x=>norm(x.data)),defs:input.definitions.map(x=>norm(x.data))};
assert.equal(before.defs.length,40);assert.equal(before.defs.reduce((n,d)=>n+d.tests.length,0),3);assert.equal(before.defs.reduce((n,d)=>n+d.examples.length,0),0);assert.deepEqual(q('config'),before.config);assert.deepEqual(q('ns').namespaces.map(n=>q('ns',n)),before.namespaces);for(const d of before.defs)assert.deepEqual(q('def',d.id),d);
const expected=structuredClone(before),ops=[],sites=[],counts={option:0,tag:0,listLength:0,setCount:0};
const show=(id,path)=>JSON.parse(run('tree','show',id,'--path','@'+path.join('.'),'--format','json')).tree;
const replace=(id,path,old,value)=>{assert.deepEqual(show(id,path),old);ops.push(['tree','replace',id,'--path','@'+path.join('.'),'--input-format','json-ast','--code',JSON.stringify(value)]);sites.push({id,path,before:old,after:value});};
const methods={'option:unwrap-or':'.unwrap-or','option:unwrap':'.unwrap','option:some?':'.some?'};
const ids=['app.config/default-tab','app.config/dev?','app.config/hide-tabs?','app.main/replace-url'];
function walk(x,path,id){if(!Array.isArray(x)||['quote','quasiquote','comment',';'].includes(x[0]))return x;if(methods[x[0]]){replace(id,[...path,0],x[0],methods[x[0]]);x[0]=methods[x[0]];counts.option++;}if(x[0]==='turn-tag'){assert.equal(id,'app.config/default-tab');assert.deepEqual(x,['turn-tag',['option:unwrap-or',['get-env','|tab'],'|inversion-circles']]);replace(id,[...path,0],x[0],'to-tag');x[0]='to-tag';counts.tag++;}return x.map((v,i)=>walk(v,[...path,i],id));}
for(const id of ids){const d=expected.defs.find(d=>d.id===id);d.code=walk(d.code,[],id);}
for(const [id,item]of [['app.schema/tab-groups',"'app.schema/TabGroup"],['app.schema/tabs',"'app.schema/Tab"]])assert.deepEqual(expected.defs.find(d=>d.id===id).schema,['::',"'List",item]);
const group=expected.defs.find(d=>d.id==='app.schema/TabGroup'),test=group.tests[0];assert.equal(test.name,'all-navigation-tabs-have-unique-identities');
function testWalk(x){if(!Array.isArray(x))return x;if(x[0]==='count'){assert.equal(x.length,2);if(x[1]==='tabs'||x[1]==='tab-groups'){x[0]='.len';counts.listLength++;}else{assert.deepEqual(x[1],['.to-set',['.map','tabs',['fn',['tab'],[':id','tab']]]]);x[0]='.count';counts.setCount++;}}return x.map(testWalk);}
test.code=testWalk(test.code);ops.push(['edit','add-test',group.id,test.name,'--overwrite','--tags',test.tags.join(','),'--input-format','json-ast','--code',JSON.stringify(test.code)]);
assert.deepEqual(counts,{option:5,tag:1,listLength:3,setCount:1});assert.equal(ops.length,7);
for(const d of before.defs){const e=expected.defs.find(x=>x.id===d.id);for(const k of Object.keys(d).filter(k=>k!=='code'&&k!=='tests'))assert.deepEqual(e[k],d[k]);if(!ids.includes(d.id))assert.deepEqual(e.code,d.code);if(d.id!==group.id)assert.deepEqual(e.tests,d.tests);}
mkdirSync('acceptance',{recursive:true});for(const [name,value]of Object.entries({before,expected,sites,operations:ops}))writeFileSync('acceptance/'+name+'.json',JSON.stringify(value,null,2));
const txn=['edit','transaction','--file','acceptance/operations.json','--format','json'],preview=JSON.parse(run(...txn,'--dry-run'));assert.ok(preview.scoped_revision);writeFileSync('acceptance/preview.json',JSON.stringify(preview,null,2));writeFileSync('acceptance/applied.json',run(...txn,'--expect-revision',preview.scoped_revision));
const after={config:q('config'),namespaces:q('ns').namespaces.map(n=>q('ns',n)),defs:expected.defs.map(d=>q('def',d.id))};assert.deepEqual(after,expected);writeFileSync('acceptance/after.json',JSON.stringify(after,null,2));writeFileSync('acceptance/snapshot-after-blob.txt',blob());writeFileSync('acceptance/summary.json',JSON.stringify({definitions:40,namespaces:7,tests:3,examples:0,operations:7,counts},null,2));
