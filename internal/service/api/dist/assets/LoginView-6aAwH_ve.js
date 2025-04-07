import{_ as x,u as V,r as o,c as r,a as e,b as v,i as c,t as m,f as S,w as _,v as h,n as b,s as B,x as C,y as L,A as N,o as l,B as R}from"./index-Bb9AnJlj.js";const A={class:"auth-page"},D={class:"container"},E={class:"auth-card"},M={key:0,class:"auth-error"},T={class:"form-group"},U={key:0,class:"input-error-text"},j={class:"form-group"},z={key:0,class:"input-error-text"},F={class:"form-actions"},I=["disabled"],O={key:0},q={key:1},G={class:"auth-links"},H={__name:"LoginView",setup(J){const n=V(),w=N(),i=o(""),u=o(""),t=o({}),d=o(!1),f=o("");o(!1);function y(){return t.value={},i.value||(t.value.username="Введите логин"),u.value?u.value.length<6&&(t.value.password="Пароль должен содержать минимум 6 символов"):t.value.password="Введите пароль",Object.keys(t.value).length===0}async function g(){if(y()){d.value=!0;try{const a=await n.login(i.value,u.value);if(!a.success){a.accountBlocked?emit("show-message",{type:"error",text:"Ваш аккаунт заблокирован. Пожалуйста, обратитесь в службу поддержки."}):f.value=a.error||"Произошла ошибка при входе в систему";return}w.push("/"),emit("show-message",{type:"success",text:"Вы успешно вошли в систему"})}catch(a){console.error("Ошибка входа:",a),f.value="Произошла непредвиденная ошибка. Попробуйте позже."}finally{d.value=!1}}}return(a,s)=>{const k=L("RouterLink");return l(),r("div",A,[e("div",D,[e("div",E,[s[5]||(s[5]=e("h1",{class:"auth-title"},"Вход в аккаунт",-1)),c(n).error?(l(),r("p",M,m(c(n).error),1)):v("",!0),e("form",{onSubmit:S(g,["prevent"]),class:"auth-form"},[e("div",T,[s[2]||(s[2]=e("label",{for:"username",class:"form-label"},"Логин",-1)),_(e("input",{id:"username",type:"text","onUpdate:modelValue":s[0]||(s[0]=p=>i.value=p),class:b(["form-input",{"input-error":t.value.username}]),placeholder:"Ваш логин"},null,2),[[h,i.value]]),t.value.username?(l(),r("p",U,m(t.value.username),1)):v("",!0)]),e("div",j,[s[3]||(s[3]=e("label",{for:"password",class:"form-label"},"Пароль",-1)),_(e("input",{id:"password",type:"password","onUpdate:modelValue":s[1]||(s[1]=p=>u.value=p),class:b(["form-input",{"input-error":t.value.password}]),placeholder:"Ваш пароль"},null,2),[[h,u.value]]),t.value.password?(l(),r("p",z,m(t.value.password),1)):v("",!0)]),e("div",F,[e("button",{type:"submit",class:"btn btn-accent auth-submit-btn",disabled:d.value||c(n).loading},[c(n).loading||d.value?(l(),r("span",O,"Выполняется вход...")):(l(),r("span",q,"Войти"))],8,I)])],32),e("div",G,[B(k,{to:"/register",class:"auth-link"},{default:C(()=>s[4]||(s[4]=[R("Нет аккаунта? Зарегистрируйтесь")])),_:1})])])])])}}},P=x(H,[["__scopeId","data-v-d4f5d18d"]]);export{P as default};
