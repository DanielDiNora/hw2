function invioDelForm(event){
    
    const codice_fiscale= (document.querySelector('#cf')).value;
    const pwd= (document.querySelector('#pwd')).value;
    const dati= {cf : codice_fiscale, pass : pwd};
    if(codice_fiscale.length===0 || pwd.length===0){
        event.currentTarget.querySelector('.error').classList.remove('invisible');
        event.preventDefault();
    }  
    else{
        event.currentTarget.querySelector('.error').classList.add('invisible');
    }
}
function FormRegistrazione(event){
    event.preventDefault();
    document.querySelector('#signup').classList.remove('invisible');
}

const form = document.querySelector('#login');
form.addEventListener('submit',invioDelForm);

const registrati = document.querySelector('form a');
registrati.addEventListener('click',FormRegistrazione);

function invioFormsignup(event){
    event.preventDefault();
    const nome=document.querySelector('#signup #nome');
    const cognome=document.querySelector('#signup #cognome');
    const email=document.querySelector('#signup #e-mail');
    const cf=document.querySelector('#signup #cf2');
    const pwd=document.querySelector('#signup #pwd2');
    const pwdc=document.querySelector('#signup #pwdc');
    const data=document.querySelector('#signup #date');
    const citta=document.querySelector('#signup #citta');
    const tok=document.querySelector("#signup #token");
    var controllo=true;
    if(nome.value==''||cognome.value==''||email.value==''||cf.value==''||pwd.value==''||pwdc.value==''||data.value==''||citta.value==''){
        document.querySelector('#signup .error').classList.remove('invisible');
    }
    else{
        document.querySelector('#signup .error').classList.add('invisible');
        if(!(/[a-z0-9]+@[a-z0-9]+\.[a-z]+$/i).test(email.value)){
            document.querySelector('#signup #errormail').classList.remove('invisible');
            controllo=false;
        }
        else{
            document.querySelector('#signup #errormail').classList.add('invisible');
           
        }
        if(!(/[a-z]{6}[0-9]{2}[a-z]{1}[0-9]{2}[a-z][0-9]{3}[a-z]$/i).test(cf.value)){
            document.querySelector('#signup #errorcf').classList.remove('invisible');
            controllo=false;
        }
        else{
            document.querySelector('#signup #errorcf').classList.add('invisible');
            
        }
        if(!(/(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,16}$/).test(pwd.value)){
        
            document.querySelector('#signup #errorpwd').classList.remove('invisible');
            controllo=false;
        }
        else{
            document.querySelector('#signup #errorpwd').classList.add('invisible');
            
        }
        if(!(pwd.value===pwdc.value)){
        
            document.querySelector('#signup #errorpwdc').classList.remove('invisible');
            controllo=false;
        }
        else{
            document.querySelector('#signup #errorpwdc').classList.add('invisible');
        }
        if(!(/[0-9]{4}[-][0-9]{2}[-][0-9]{2}$/).test(data.value)){
        
            document.querySelector('#signup #errordate').classList.remove('invisible');
            controllo=false;
        }
        else{
            document.querySelector('#signup #errordate').classList.add('invisible');
            
        }

        
        if(controllo){
            const dati={
            'nome' : nome.value,
            'cognome' : cognome.value,
            'email' : email.value,
            'cf' : cf.value,
            'pwd' :pwd.value,
            'pwdc' : pwdc.value,
            'data': data.value,
            'citta': citta.value
            };
            
            const url=window.location.href;
            var splitUrl = url.split('/');
            url2=splitUrl[0]+'//'+splitUrl[2]+'/'+splitUrl[3]+'/'+splitUrl[4]+'/fetch_signup'; 
            fetch(url2,
                {
                    headers: {
                    "Content-Type": "application/json",
                    "X-CSRF-TOKEN": tok.value
                    },
                    method : 'post',
                    body: JSON.stringify(dati)
                }).then(onRespone).then(onjson);
        }
    }
}
function onRespone(response){
    return response.json();
}
function onjson(json){
    const errori= json;
    const signup = document.querySelector('#signup .error2');
    signup.innerHTML='';
    for(let i=0;i<5;i++){
        const signup = document.querySelector('#signup .error2');
        const err= document.createElement('div');
        err.classList.add('error');
        err.textContent=errori[i];
        signup.appendChild(err);

    }
}
const signup = document.querySelector('#signup');
signup.addEventListener('submit',invioFormsignup);