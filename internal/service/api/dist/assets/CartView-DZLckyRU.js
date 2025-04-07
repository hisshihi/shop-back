import{_ as P,l as T,u as E,r as d,g as f,c as o,a as t,s as k,x as C,y as L,F as V,b as A,w as F,v as O,n as R,D as j,t as l,e as z,A as Q,o as a,B as g}from"./index-Bb9AnJlj.js";const U={class:"cart-page"},J={class:"container"},G={key:0,class:"order-success"},H={key:0,class:"empty-cart"},K={key:1,class:"checkout-form"},W={class:"form-group"},X={class:"form-group"},Y={class:"summary-total checkout-total"},Z={class:"checkout-actions"},tt=["disabled"],st={key:0},et={key:1},ot=["disabled"],at={key:0,class:"order-error"},nt={key:2,class:"cart-content"},lt={class:"cart-items"},rt={class:"item-image"},it=["src","alt"],ut={class:"item-details"},dt={class:"item-price"},ct={class:"item-quantity"},pt=["onClick","disabled"],vt={class:"quantity-value"},mt=["onClick"],_t={class:"item-total"},yt=["onClick"],ht={class:"cart-sidebar"},bt={class:"cart-summary"},ft={class:"summary-row"},kt={class:"summary-total"},Ct={key:0,class:"order-error"},gt={__name:"CartView",setup(qt){const u=T(),y=E(),q=Q(),c=d(!1),w=d(!1),r=d(null),m=d(!1),p=d(""),h=d("card"),b=f(()=>u.cartItems),_=f(()=>u.totalCartPrice),$=f(()=>b.value.length>0);function v(n){return parseFloat(n).toFixed(2)}function B(n){const s=u.getCartItemId(n);s&&u.removeFromCart(s)}function x(n,s){u.updateCartItemQuantity(n,s)}function I(){u.clearCart()}function M(){if(!y.isAuthenticated){q.push("/login");return}m.value=!0}function N(){m.value=!1}async function D(){if(!y.isAuthenticated){q.push("/login");return}if(!p.value.trim()){r.value="Укажите адрес доставки";return}c.value=!0,r.value=null;try{const n={total_amount:_.value.toString(),payment_method:h.value,delivery_address:p.value,items:b.value.map(i=>({product_id:i.product_id,quantity:i.quantity,price:i.price}))};if(!(await fetch("http://localhost:8080/api/v1/order",{method:"POST",headers:{"Content-Type":"application/json",Authorization:`Bearer ${y.token}`},body:JSON.stringify(n)})).ok)throw new Error("Не удалось создать заказ");w.value=!0,I()}catch(n){r.value=n.message||"Произошла ошибка при оформлении заказа"}finally{c.value=!1,m.value=!1}}return(n,s)=>{const i=L("RouterLink");return a(),o("div",U,[t("div",J,[s[16]||(s[16]=t("h1",{class:"page-title"},"Корзина",-1)),w.value?(a(),o("div",G,[s[3]||(s[3]=t("h2",null,"Заказ успешно оформлен!",-1)),s[4]||(s[4]=t("p",null,"Благодарим за покупку в нашем магазине.",-1)),k(i,{to:"/",class:"btn btn-primary"},{default:C(()=>s[2]||(s[2]=[g("Вернуться к покупкам")])),_:1})])):(a(),o(V,{key:1},[$.value?m.value?(a(),o("div",K,[s[11]||(s[11]=t("h2",{class:"section-title"},"Оформление заказа",-1)),t("div",W,[s[7]||(s[7]=t("label",{for:"deliveryAddress",class:"form-label"},"Адрес доставки:",-1)),F(t("input",{id:"deliveryAddress",type:"text","onUpdate:modelValue":s[0]||(s[0]=e=>p.value=e),class:R(["form-input",{"input-error":r.value&&!p.value.trim()}]),placeholder:"Введите полный адрес доставки"},null,2),[[O,p.value]])]),t("div",X,[s[9]||(s[9]=t("label",{for:"paymentMethod",class:"form-label"},"Способ оплаты:",-1)),F(t("select",{id:"paymentMethod","onUpdate:modelValue":s[1]||(s[1]=e=>h.value=e),class:"form-input"},s[8]||(s[8]=[t("option",{value:"card"},"Банковская карта",-1),t("option",{value:"cash"},"Наличные при получении",-1)]),512),[[j,h.value]])]),t("div",Y,[s[10]||(s[10]=t("span",null,"Итого к оплате:",-1)),t("span",null,l(v(_.value))+" ₽",1)]),t("div",Z,[t("button",{onClick:D,class:"btn btn-accent",disabled:c.value},[c.value?(a(),o("span",st,"Оформление заказа...")):(a(),o("span",et,"Подтвердить заказ"))],8,tt),t("button",{onClick:N,class:"btn btn-outline",disabled:c.value}," Вернуться в корзину ",8,ot)]),r.value?(a(),o("p",at,l(r.value),1)):A("",!0)])):(a(),o("div",nt,[t("div",lt,[(a(!0),o(V,null,z(b.value,e=>(a(),o("div",{key:e.id,class:"cart-item"},[t("div",rt,[t("img",{src:e.photo_url?`data:${e.photo_mime||"image/jpeg"};base64,${e.photo_url}`:"https://placehold.co/600x400?text=Нет+фото",alt:e.name},null,8,it)]),t("div",ut,[k(i,{to:`/product/${e.product_id}`,class:"item-name"},{default:C(()=>[g(l(e.name),1)]),_:2},1032,["to"]),t("div",dt,l(v(e.price))+" ₽",1)]),t("div",ct,[t("button",{onClick:S=>x(e.product_id,e.quantity-1),class:"quantity-btn",disabled:e.quantity<=1}," - ",8,pt),t("span",vt,l(e.quantity),1),t("button",{onClick:S=>x(e.product_id,e.quantity+1),class:"quantity-btn"}," + ",8,mt)]),t("div",_t,l(v(parseFloat(e.price)*e.quantity))+" ₽ ",1),t("button",{onClick:S=>B(e.product_id),class:"remove-btn"}," Удалить ",8,yt)]))),128))]),t("div",ht,[t("div",bt,[s[14]||(s[14]=t("h3",{class:"summary-title"},"Итого",-1)),t("div",ft,[s[12]||(s[12]=t("span",null,"Сумма:",-1)),t("span",null,l(v(_.value))+" ₽",1)]),s[15]||(s[15]=t("div",{class:"summary-row"},[t("span",null,"Доставка:"),t("span",null,"Бесплатно")],-1)),t("div",kt,[s[13]||(s[13]=t("span",null,"К оплате:",-1)),t("span",null,l(v(_.value))+" ₽",1)]),t("button",{onClick:M,class:"btn btn-accent checkout-btn"}," Оформить заказ "),r.value?(a(),o("p",Ct,l(r.value),1)):A("",!0)]),t("button",{onClick:I,class:"btn btn-outline clear-cart-btn"}," Очистить корзину ")])])):(a(),o("div",H,[s[6]||(s[6]=t("p",null,"Ваша корзина пуста",-1)),k(i,{to:"/",class:"btn btn-primary"},{default:C(()=>s[5]||(s[5]=[g("Перейти к покупкам")])),_:1})]))],64))])])}}},xt=P(gt,[["__scopeId","data-v-54350c42"]]);export{xt as default};
