import{d as T,r as g,u as M,s as P,a as E,o as I,b as c,c as f,e,f as C,t as h,F as S,g as U,h as G,w as F,i as k,v as D,j as J,n as L,k as B,l as H,m as R,p as W,q as Q,x as V}from"./index-veI2LYaI.js";const O=T("clients",()=>{const v=g([]),i=g(!1),t=g(null);M();async function u(){try{i.value=!0,t.value=null;const{data:m,error:n}=await P.from("clients").select("*").order("name");if(n)throw n;v.value=m}catch(m){throw t.value=m instanceof Error?m.message:"Failed to fetch clients",m}finally{i.value=!1}}async function s(m){try{i.value=!0,t.value=null;const{data:n,error:o}=await P.from("clients").insert([m]).select().single();if(o)throw o;return n&&v.value.push(n),n}catch(n){throw t.value=n instanceof Error?n.message:"Failed to create client",n}finally{i.value=!1}}async function l(m,n){try{i.value=!0,t.value=null;const{data:o,error:a}=await P.from("clients").update(n).eq("id",m).select().single();if(a)throw a;if(o){const x=v.value.findIndex(p=>p.id===m);x!==-1&&(v.value[x]=o)}return o}catch(o){throw t.value=o instanceof Error?o.message:"Failed to update client",o}finally{i.value=!1}}async function w(m){try{i.value=!0,t.value=null;const{error:n}=await P.from("clients").delete().eq("id",m);if(n)throw n;v.value=v.value.filter(o=>o.id!==m)}catch(n){throw t.value=n instanceof Error?n.message:"Failed to delete client",n}finally{i.value=!1}}return{clients:v,loading:i,error:t,fetchClients:u,createClient:s,updateClient:l,deleteClient:w}}),K=T("projects",()=>{const v=g([]),i=g(!1),t=g(null),u=M();async function s(n){try{i.value=!0,t.value=null;let o=P.from("projects").select("*").order("created_at",{ascending:!1});n&&(o=o.eq("client_id",n));const{data:a,error:x}=await o;if(x)throw x;v.value=a}catch(o){throw t.value=o instanceof Error?o.message:"Failed to fetch projects",o}finally{i.value=!1}}async function l(n){var o;if(!((o=u.user)!=null&&o.id))throw new Error("User not authenticated");try{i.value=!0,t.value=null;const{data:a,error:x}=await P.from("projects").insert([{...n,created_by:u.user.id}]).select().single();if(x)throw x;return a&&v.value.unshift(a),a}catch(a){throw t.value=a instanceof Error?a.message:"Failed to create project",a}finally{i.value=!1}}async function w(n,o){try{i.value=!0,t.value=null;const{data:a,error:x}=await P.from("projects").update(o).eq("id",n).select().single();if(x)throw x;if(a){const p=v.value.findIndex(_=>_.id===n);p!==-1&&(v.value[p]=a)}return a}catch(a){throw t.value=a instanceof Error?a.message:"Failed to update project",a}finally{i.value=!1}}async function m(n){try{i.value=!0,t.value=null;const{error:o}=await P.from("projects").delete().eq("id",n);if(o)throw o;v.value=v.value.filter(a=>a.id!==n)}catch(o){throw t.value=o instanceof Error?o.message:"Failed to delete project",o}finally{i.value=!1}}return{projects:v,loading:i,error:t,fetchProjects:s,createProject:l,updateProject:w,deleteProject:m}}),X={class:"p-6"},Y={class:"flex justify-between items-center mb-6"},Z={key:0,class:"text-center py-4"},ee={key:1,class:"text-red-600 py-4"},te={key:2,class:"space-y-4"},se=["onClick"],oe={class:"flex justify-between items-start"},le={class:"font-medium text-gray-900"},ne={class:"text-sm text-gray-600"},re={key:0,class:"text-sm text-gray-600"},ie={class:"flex gap-2"},ae=["onClick"],de=["onClick"],ue=E({__name:"ClientList",setup(v){const i=O();return I(()=>{i.fetchClients()}),(t,u)=>(c(),f("div",X,[e("div",Y,[u[1]||(u[1]=e("h2",{class:"text-xl font-semibold"},"Clients",-1)),e("button",{class:"px-4 py-2 bg-indigo-600 text-white rounded hover:bg-indigo-700",onClick:u[0]||(u[0]=s=>t.$emit("new-client"))}," Add Client ")]),C(i).loading?(c(),f("div",Z," Loading... ")):C(i).error?(c(),f("div",ee,h(C(i).error),1)):(c(),f("div",te,[(c(!0),f(S,null,U(C(i).clients,s=>(c(),f("div",{key:s.id,class:"bg-white p-4 rounded-lg shadow-sm border border-gray-200 hover:border-indigo-500 cursor-pointer",onClick:l=>t.$emit("select-client",s)},[e("div",oe,[e("div",null,[e("h3",le,h(s.name),1),e("p",ne,h(s.email),1),s.phone?(c(),f("p",re,h(s.phone),1)):G("",!0)]),e("div",ie,[e("button",{class:"text-sm px-3 py-1 text-gray-600 hover:text-indigo-600",onClick:F(l=>t.$emit("edit-client",s),["stop"])}," Edit ",8,ae),e("button",{class:"text-sm px-3 py-1 text-red-600 hover:text-red-700",onClick:F(l=>t.$emit("delete-client",s),["stop"])}," Delete ",8,de)])])],8,se))),128))]))]))}}),ce={class:"p-6"},ve={class:"text-xl font-semibold mb-6"},me={class:"flex justify-end gap-4"},pe=E({__name:"ClientForm",props:{client:{}},emits:["save","cancel"],setup(v,{emit:i}){var n,o,a;const t=v,u=i,s=g(((n=t.client)==null?void 0:n.name)??""),l=g(((o=t.client)==null?void 0:o.email)??""),w=g(((a=t.client)==null?void 0:a.phone)??"");function m(){u("save",{name:s.value,email:l.value,phone:w.value||null})}return(x,p)=>(c(),f("div",ce,[e("h2",ve,h(x.client?"Edit Client":"New Client"),1),e("form",{onSubmit:F(m,["prevent"]),class:"space-y-4"},[e("div",null,[p[4]||(p[4]=e("label",{class:"block text-sm font-medium text-gray-700"},"Name",-1)),k(e("input",{"onUpdate:modelValue":p[0]||(p[0]=_=>s.value=_),type:"text",required:"",class:"mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"},null,512),[[D,s.value]])]),e("div",null,[p[5]||(p[5]=e("label",{class:"block text-sm font-medium text-gray-700"},"Email",-1)),k(e("input",{"onUpdate:modelValue":p[1]||(p[1]=_=>l.value=_),type:"email",required:"",class:"mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"},null,512),[[D,l.value]])]),e("div",null,[p[6]||(p[6]=e("label",{class:"block text-sm font-medium text-gray-700"},"Phone",-1)),k(e("input",{"onUpdate:modelValue":p[2]||(p[2]=_=>w.value=_),type:"tel",class:"mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"},null,512),[[D,w.value]])]),e("div",me,[e("button",{type:"button",class:"px-4 py-2 text-gray-700 hover:text-gray-900",onClick:p[3]||(p[3]=_=>x.$emit("cancel"))}," Cancel "),p[7]||(p[7]=e("button",{type:"submit",class:"px-4 py-2 bg-indigo-600 text-white rounded hover:bg-indigo-700"}," Save ",-1))])],32)]))}}),fe={class:"p-6"},ye={class:"flex justify-between items-center mb-6"},ge={key:0,class:"text-gray-600"},xe={key:0,class:"text-center py-4"},be={key:1,class:"text-red-600 py-4"},he={key:2,class:"space-y-4"},we={class:"flex justify-between items-start"},$e={class:"font-medium text-gray-900"},_e={class:"text-sm text-gray-600"},Ce={class:"flex gap-2"},ke=["onClick"],je=["onClick"],Pe=E({__name:"ProjectList",props:{selectedClient:{}},setup(v){const i=v,t=K();return I(()=>{i.selectedClient&&t.fetchProjects(i.selectedClient.id)}),J(()=>i.selectedClient,u=>{u&&t.fetchProjects(u.id)}),(u,s)=>(c(),f("div",fe,[e("div",ye,[s[1]||(s[1]=e("h2",{class:"text-xl font-semibold"},"Projects",-1)),e("button",{class:"px-4 py-2 bg-indigo-600 text-white rounded hover:bg-indigo-700",onClick:s[0]||(s[0]=l=>u.$emit("new-project"))}," Add Project ")]),u.selectedClient?(c(),f(S,{key:1},[C(t).loading?(c(),f("div",xe," Loading... ")):C(t).error?(c(),f("div",be,h(C(t).error),1)):(c(),f("div",he,[(c(!0),f(S,null,U(C(t).projects,l=>(c(),f("div",{key:l.id,class:"bg-white p-4 rounded-lg shadow-sm border border-gray-200"},[e("div",we,[e("div",null,[e("h3",$e,h(l.name),1),e("p",_e,h(l.description),1),e("span",{class:L(["inline-block mt-2 px-2 py-1 text-xs rounded",{"bg-green-100 text-green-800":l.status==="active","bg-gray-100 text-gray-800":l.status==="completed","bg-yellow-100 text-yellow-800":l.status==="on-hold","bg-red-100 text-red-800":l.status==="cancelled"}])},h(l.status),3)]),e("div",Ce,[e("button",{class:"text-sm px-3 py-1 text-gray-600 hover:text-indigo-600",onClick:w=>u.$emit("edit-project",l)}," Edit ",8,ke),e("button",{class:"text-sm px-3 py-1 text-red-600 hover:text-red-700",onClick:w=>u.$emit("delete-project",l)}," Delete ",8,je)])])]))),128))]))],64)):(c(),f("div",ge," Select a client to view their projects "))]))}}),Se={class:"p-6"},De={class:"text-xl font-semibold mb-6"},Fe=["value"],Ee=["value"],Ve={class:"flex justify-end gap-4"},Le=E({__name:"ProjectForm",props:{project:{},client:{}},emits:["save","cancel"],setup(v,{emit:i}){var x,p,_,q,N;const t=v,u=i,s=O(),l=g(((x=t.project)==null?void 0:x.name)??""),w=g(((p=t.project)==null?void 0:p.description)??""),m=g(((_=t.project)==null?void 0:_.status)??"active"),n=g(((q=t.project)==null?void 0:q.client_id)??((N=t.client)==null?void 0:N.id)??""),o=["active","completed","on-hold","cancelled"];function a(){u("save",{name:l.value,description:w.value||null,status:m.value,client_id:n.value})}return(A,y)=>(c(),f("div",Se,[e("h2",De,h(A.project?"Edit Project":"New Project"),1),e("form",{onSubmit:F(a,["prevent"]),class:"space-y-4"},[e("div",null,[y[6]||(y[6]=e("label",{class:"block text-sm font-medium text-gray-700 mb-1"},"Client",-1)),k(e("select",{"onUpdate:modelValue":y[0]||(y[0]=$=>n.value=$),required:"",class:"mt-1 block w-full px-3 py-2 rounded-md border border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"},[y[5]||(y[5]=e("option",{value:"",disabled:""},"Select a client",-1)),(c(!0),f(S,null,U(C(s).clients,$=>(c(),f("option",{key:$.id,value:$.id},h($.name),9,Fe))),128))],512),[[B,n.value]])]),e("div",null,[y[7]||(y[7]=e("label",{class:"block text-sm font-medium text-gray-700 mb-1"},"Name",-1)),k(e("input",{"onUpdate:modelValue":y[1]||(y[1]=$=>l.value=$),type:"text",required:"",class:"mt-1 block w-full px-3 py-2 rounded-md border border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"},null,512),[[D,l.value]])]),e("div",null,[y[8]||(y[8]=e("label",{class:"block text-sm font-medium text-gray-700 mb-1"},"Description",-1)),k(e("textarea",{"onUpdate:modelValue":y[2]||(y[2]=$=>w.value=$),rows:"3",class:"mt-1 block w-full px-3 py-2 rounded-md border border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"},null,512),[[D,w.value]])]),e("div",null,[y[9]||(y[9]=e("label",{class:"block text-sm font-medium text-gray-700 mb-1"},"Status",-1)),k(e("select",{"onUpdate:modelValue":y[3]||(y[3]=$=>m.value=$),class:"mt-1 block w-full px-3 py-2 rounded-md border border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"},[(c(),f(S,null,U(o,$=>e("option",{key:$,value:$},h($),9,Ee)),64))],512),[[B,m.value]])]),e("div",Ve,[e("button",{type:"button",class:"px-4 py-2 text-gray-700 hover:text-gray-900",onClick:y[4]||(y[4]=$=>A.$emit("cancel"))}," Cancel "),y[10]||(y[10]=e("button",{type:"submit",class:"px-4 py-2 bg-indigo-600 text-white rounded hover:bg-indigo-700"}," Save ",-1))])],32)]))}}),Ue=(v,i)=>{const t=v.__vccOpts||v;for(const[u,s]of i)t[u]=s;return t},qe={},Ne={class:"flex flex-1 overflow-hidden"},Ae={class:"w-1/3 border-r border-gray-200 overflow-y-auto bg-gray-50"},Oe={class:"flex-1 overflow-y-auto bg-white"};function Be(v,i){return c(),f("div",Ne,[e("div",Ae,[H(v.$slots,"master")]),e("main",Oe,[H(v.$slots,"detail")])])}const Me=Ue(qe,[["render",Be]]),Ie={class:"h-full p-6 overflow-y-auto"},ze={class:"bg-white rounded-lg shadow-sm border border-gray-200 p-6"},He={class:"flex justify-between items-start mb-6"},Qe={class:"text-2xl font-semibold text-gray-900"},Te={class:"text-sm text-gray-600 mt-1"},Ge={class:"prose max-w-none"},Je={class:"text-gray-600"},Ke={class:"mt-6 border-t border-gray-200 pt-6"},Re={class:"grid grid-cols-2 gap-4"},We={class:"text-sm text-gray-900"},Xe={class:"text-sm text-gray-900"},Ye=E({__name:"ProjectDetails",props:{project:{}},setup(v){const i=v,t=O(),u=g("");return I(async()=>{await t.fetchClients();const s=t.clients.find(l=>l.id===i.project.client_id);u.value=(s==null?void 0:s.name)??"Unknown Client"}),(s,l)=>(c(),f("div",Ie,[e("div",ze,[e("div",He,[e("div",null,[e("h2",Qe,h(s.project.name),1),e("p",Te,"Client: "+h(u.value),1)]),e("span",{class:L(["px-3 py-1 text-sm rounded-full",{"bg-green-100 text-green-800":s.project.status==="active","bg-gray-100 text-gray-800":s.project.status==="completed","bg-yellow-100 text-yellow-800":s.project.status==="on-hold","bg-red-100 text-red-800":s.project.status==="cancelled"}])},h(s.project.status),3)]),e("div",Ge,[l[0]||(l[0]=e("h3",{class:"text-lg font-medium text-gray-900 mb-2"},"Description",-1)),e("p",Je,h(s.project.description||"No description provided."),1)]),e("div",Ke,[l[3]||(l[3]=e("h3",{class:"text-lg font-medium text-gray-900 mb-2"},"Project Details",-1)),e("dl",Re,[e("div",null,[l[1]||(l[1]=e("dt",{class:"text-sm font-medium text-gray-500"},"Created",-1)),e("dd",We,h(new Date(s.project.created_at).toLocaleDateString()),1)]),e("div",null,[l[2]||(l[2]=e("dt",{class:"text-sm font-medium text-gray-500"},"Last Updated",-1)),e("dd",Xe,h(new Date(s.project.updated_at).toLocaleDateString()),1)])])])])]))}}),Ze={class:"h-screen flex flex-col"},et={class:"bg-white shadow-sm border-b border-gray-200 flex-shrink-0"},tt={class:"px-4 py-3"},st={class:"flex justify-between items-center mb-2"},ot={class:"flex items-center gap-4"},lt={class:"text-sm text-gray-600"},nt={class:"flex gap-4"},rt={key:1,class:"p-6"},it={class:"flex justify-between items-center mb-6"},at={class:"space-y-4"},dt={class:"space-y-3"},ut={class:"space-y-3"},ct=["onClick"],vt={class:"flex justify-between items-start"},mt={class:"font-medium text-gray-900"},pt={class:"text-sm text-gray-600"},ft={class:"flex gap-2"},yt=["onClick"],gt=["onClick"],bt=E({__name:"Profile",setup(v){const i=M(),t=O(),u=K(),s=g("clients"),l=g(),w=g(),m=g(),n=g(!1),o=g(),a=g(!1),x=g(""),p=g("all"),_=R(()=>u.projects.filter(b=>{var d;const r=b.name.toLowerCase().includes(x.value.toLowerCase())||((d=b.description)==null?void 0:d.toLowerCase().includes(x.value.toLowerCase())),j=p.value==="all"||b.status===p.value;return r&&j}));J(s,b=>{l.value=void 0,w.value=void 0,m.value=void 0,n.value=!1,o.value=void 0,a.value=!1,b==="projects"&&(u.fetchProjects(),t.fetchClients())});async function q(b){try{m.value?await t.updateClient(m.value.id,b):await t.createClient(b),n.value=!1,m.value=void 0}catch(r){console.error("Failed to save client:",r)}}async function N(b){var r;if(confirm(`Are you sure you want to delete ${b.name}?`))try{await t.deleteClient(b.id),((r=l.value)==null?void 0:r.id)===b.id&&(l.value=void 0)}catch(j){console.error("Failed to delete client:",j)}}async function A(b){try{o.value?await u.updateProject(o.value.id,b):await u.createProject(b),a.value=!1,o.value=void 0}catch(r){console.error("Failed to save project:",r)}}async function y(b){var r;if(confirm(`Are you sure you want to delete ${b.name}?`))try{await u.deleteProject(b.id),((r=w.value)==null?void 0:r.id)===b.id&&(w.value=void 0)}catch(j){console.error("Failed to delete project:",j)}}function $(b){w.value=b}return(b,r)=>{var j;return c(),f("div",Ze,[e("header",et,[e("div",tt,[e("div",st,[r[13]||(r[13]=e("h1",{class:"text-xl font-semibold text-gray-900"},"Dashboard",-1)),e("div",ot,[e("span",lt,h((j=C(i).user)==null?void 0:j.email),1),e("button",{onClick:r[0]||(r[0]=(...d)=>C(i).signOut&&C(i).signOut(...d)),class:"px-3 py-1.5 text-sm bg-red-600 text-white rounded hover:bg-red-700"}," Sign Out ")])]),e("nav",nt,[e("button",{onClick:r[1]||(r[1]=d=>s.value="clients"),class:L(["px-3 py-2 text-sm font-medium rounded-md",s.value==="clients"?"bg-indigo-100 text-indigo-700":"text-gray-600 hover:text-gray-900"])}," Clients ",2),e("button",{onClick:r[2]||(r[2]=d=>s.value="projects"),class:L(["px-3 py-2 text-sm font-medium rounded-md",s.value==="projects"?"bg-indigo-100 text-indigo-700":"text-gray-600 hover:text-gray-900"])}," Projects ",2)])])]),W(Me,null,{master:Q(()=>[s.value==="clients"?(c(),f(S,{key:0},[n.value?(c(),V(pe,{key:0,client:m.value,onSave:q,onCancel:r[3]||(r[3]=d=>{n.value=!1,m.value=void 0})},null,8,["client"])):(c(),V(ue,{key:1,onNewClient:r[4]||(r[4]=d=>n.value=!0),onSelectClient:r[5]||(r[5]=d=>l.value=d),onEditClient:r[6]||(r[6]=d=>{m.value=d,n.value=!0}),onDeleteClient:N}))],64)):(c(),f("div",rt,[e("div",it,[r[14]||(r[14]=e("h2",{class:"text-xl font-semibold"},"Projects",-1)),e("button",{class:"px-4 py-2 bg-indigo-600 text-white rounded hover:bg-indigo-700",onClick:r[7]||(r[7]=d=>a.value=!0)}," Add Project ")]),e("div",at,[e("div",dt,[k(e("input",{"onUpdate:modelValue":r[8]||(r[8]=d=>x.value=d),type:"text",placeholder:"Search projects...",class:"w-full px-3 py-2 border border-gray-300 rounded-md"},null,512),[[D,x.value]]),k(e("select",{"onUpdate:modelValue":r[9]||(r[9]=d=>p.value=d),class:"w-full px-3 py-2 border border-gray-300 rounded-md"},r[15]||(r[15]=[e("option",{value:"all"},"All Status",-1),e("option",{value:"active"},"Active",-1),e("option",{value:"completed"},"Completed",-1),e("option",{value:"on-hold"},"On Hold",-1),e("option",{value:"cancelled"},"Cancelled",-1)]),512),[[B,p.value]])]),e("div",ut,[(c(!0),f(S,null,U(_.value,d=>(c(),f("div",{key:d.id,class:"bg-white p-4 rounded-lg shadow-sm border border-gray-200 hover:border-indigo-500 cursor-pointer",onClick:z=>$(d)},[e("div",vt,[e("div",null,[e("h3",mt,h(d.name),1),e("p",pt,h(d.description),1),e("span",{class:L(["inline-block mt-2 px-2 py-1 text-xs rounded",{"bg-green-100 text-green-800":d.status==="active","bg-gray-100 text-gray-800":d.status==="completed","bg-yellow-100 text-yellow-800":d.status==="on-hold","bg-red-100 text-red-800":d.status==="cancelled"}])},h(d.status),3)]),e("div",ft,[e("button",{class:"text-sm px-3 py-1 text-gray-600 hover:text-indigo-600",onClick:F(z=>{o.value=d,a.value=!0},["stop"])}," Edit ",8,yt),e("button",{class:"text-sm px-3 py-1 text-red-600 hover:text-red-700",onClick:F(z=>y(d),["stop"])}," Delete ",8,gt)])])],8,ct))),128))])])]))]),detail:Q(()=>[a.value?(c(),V(Le,{key:0,project:o.value,client:l.value,onSave:A,onCancel:r[10]||(r[10]=d=>{a.value=!1,o.value=void 0})},null,8,["project","client"])):s.value==="clients"&&l.value?(c(),V(Pe,{key:1,"selected-client":l.value,onNewProject:r[11]||(r[11]=d=>a.value=!0),onEditProject:r[12]||(r[12]=d=>{o.value=d,a.value=!0}),onDeleteProject:y},null,8,["selected-client"])):s.value==="projects"&&w.value?(c(),V(Ye,{key:2,project:w.value},null,8,["project"])):G("",!0)]),_:1})])}}});export{bt as default};