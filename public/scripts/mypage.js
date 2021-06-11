function loadProfile(event){

    const sezione=document.querySelector('.contenuto');
    sezione.classList.remove("invisible");
    const reparto=document.querySelector('#reparto');
    reparto.classList.add('invisible');
    sezione.innerHTML='';
    const titolo=document.createElement('h1');
    titolo.textContent="Il Mio Profilo";
    sezione.appendChild(titolo);
    const url=window.location.href;
    var splitUrl = url.split('/');
    url2=splitUrl[0]+'//'+splitUrl[2]+'/'+splitUrl[3]+'/'+splitUrl[4]+'/fetch_profile'; 
    fetch(url2).then(onRespone).then(onJsonProfile);
}
function onRespone(response){
    return response.json();
}
function onJsonProfile(json){
    const profilo=json;
    const element=document.createElement('div');
    element.classList.add('dxprofile')
    const sezione=document.querySelector('.contenuto');
    sezione.appendChild(element);
    riempoProfilo(json,'Nome','nome');
    riempoProfilo(json,'Cognome','cognome');
    riempoProfilo(json,'Codice Fiscale','cf');
    riempoProfilo(json,'E-mail','email');
    riempoProfilo(json,'Professione','ruolo');
    riempoProfilo(json,'Data Di Nascita','Data_Di_Nascita');
    const form=document.createElement('form');
    const input=document.createElement('input');
    const submit=document.createElement('input');
    const titolo=document.createElement('h1');
    const errore=document.createElement('div');
    const centro=document.createElement('div');
    centro.classList.add('formCentrato')
    errore.classList.add('error');
    errore.classList.add('invisible');
    titolo.textContent='Aggiungi una foto al tuo profilo';
    input.setAttribute("type","file");
    submit.setAttribute("type","submit");
    input.setAttribute("name","file");
    input.classList.add('file');
    form.appendChild(titolo);
    form.appendChild(errore);
    form.appendChild(input);
    form.appendChild(submit);
    centro.appendChild(form);
    sezione.appendChild(centro);
    form.addEventListener('submit', onSelectFile);
}
function onSelectFile(event){
    event.preventDefault();
    const inputFile=document.querySelector('.file');
    const form=new FormData(document.querySelector('form'));
    const file=inputFile.files;
    if(file[0].size<5000000){
        const formato=file[0].type.split('/');
        const tok=document.getElementById("tok");
        if(formato[1]=='jpg' ||formato[1]=='jpeg' ||formato[1]=='png'){
        const url=window.location.href;
        var splitUrl = url.split('/');
        url2=splitUrl[0]+'//'+splitUrl[2]+'/'+splitUrl[3]+'/'+splitUrl[4]+'/fetch_sendProfileImage'; 
        fetch(url2,{
            headers: {
            "X-CSRF-TOKEN": tok.value
            },
            method : 'post',
            body: form
        }).then(onRespone).then(onJsonImageProfile);
        }
        else{
            const errore=document.querySelector('.error');
            errore.classList.remove('invisible');
            errore.textContent='File nel formato sbagliato (formati consentiti jpg,jpeg,png)';
        }
    }
    else{
        const errore=document.querySelector('.error');
        errore.classList.remove('invisible');
        errore.textContent='File Troppo Grande(max=5MB)';
    }
}

function onJsonImageProfile(json){
    const errore=document.querySelector('.error');
    errore.classList.remove('invisible');
    errore.textContent=json[0];
}
function riempoProfilo(profilo,titolo,indice){
    const cf=document.createElement('div');
    const element=document.createElement('h2');
    element.textContent=titolo;
    cf.classList.add('informazioni');
    const contenuto=document.createElement('div');
    contenuto.textContent=profilo[indice];
    contenuto.classList.add('contenuto');
    const sezione=document.querySelector('.dxprofile');
    cf.appendChild(element);
    cf.appendChild(contenuto);
    sezione.appendChild(cf);
}
function loadCartellaClinica(event){
    const sezione=document.querySelector('.contenuto');
    sezione.innerHTML='';
    const reparto=document.querySelector('#reparto');
    reparto.classList.add('invisible');
    sezione.classList.remove("invisible");
    const titolo=document.createElement('h1');
    titolo.textContent="Cartelle Cliniche";
    sezione.appendChild(titolo);
    const url=window.location.href;
    var splitUrl = url.split('/');
    url2=splitUrl[0]+'//'+splitUrl[2]+'/'+splitUrl[3]+'/'+splitUrl[4]+'/fetch_cartella'; 
    fetch(url2).then(onRespone).then(onJsonCartella);
}
function onJsonCartella(json){
    const cartelle=json['cartelle'];

    const cc=document.createElement('div');
    cc.classList.add('CartelleCliniche');
    

    const id_cartella=document.createElement('div');
    id_cartella.classList.add('id_cartella');
    const id_cartellaTitolo=document.createElement('h2');
    id_cartellaTitolo.textContent='ID Cartella';
    id_cartella.appendChild(id_cartellaTitolo);
    
    const diagnosi=document.createElement('div');
    diagnosi.classList.add('diagnosi');
    const diagnosiTitolo=document.createElement('h2');
    diagnosiTitolo.textContent='Diagnosi';
    diagnosi.appendChild(diagnosiTitolo);
    
    const ananmesi=document.createElement('div');
    ananmesi.classList.add('ananmesi');
    const ananmesiTitolo=document.createElement('h2');
    ananmesiTitolo.textContent='Ananmesi';
    ananmesi.appendChild(ananmesiTitolo);
    
    const data_inizio=document.createElement('div');
    data_inizio.classList.add('data_inizio');
    const data_inizioTitolo=document.createElement('h2');
    data_inizioTitolo.textContent='Data Inzio Ricovero';
    data_inizio.appendChild(data_inizioTitolo);

    const data_fine=document.createElement('div');
    data_fine.classList.add('data_fine');
    const data_fineTitolo=document.createElement('h2');
    data_fineTitolo.textContent='Data Fine ricovero';
    data_fine.appendChild(data_fineTitolo);

    const nome=document.createElement('div');
    nome.classList.add('nomeReparto');
    const nomeTitolo=document.createElement('h2');
    nomeTitolo.textContent='Nome Reparto';
    nome.appendChild(nomeTitolo);
    
    
    const sezione=document.querySelector('.contenuto');
    sezione.appendChild(cc);
    for(var i=0; i < cartelle.length;i++){
        
        var info=document.createElement('div');
        info.classList.add('informazione');
        info.textContent=cartelle[i].id_reparto
        id_cartella.appendChild(info);

        info=document.createElement('div');
        info.classList.add('informazione');
        info.textContent=cartelle[i].diagnosi;
        diagnosi.appendChild(info);

        info=document.createElement('div');
        info.classList.add('informazione');
        info.textContent=cartelle[i].data_inizio_ricovero;
        data_inizio.appendChild(info);

        info=document.createElement('div');
        info.classList.add('informazione');
        info.textContent=cartelle[i].data_fine_ricovero;
        data_fine.appendChild(info);

        info=document.createElement('div');
        info.classList.add('informazione');
        info.textContent=cartelle[i].ananmesi;
        ananmesi.appendChild(info);

        info=document.createElement('div');
        info.classList.add('informazione');
        info.textContent=cartelle[i].nome;
        nome.appendChild(info);
    }
    cc.appendChild(id_cartella);
    cc.appendChild(diagnosi);
    cc.appendChild(ananmesi);
    cc.appendChild(data_inizio);
    cc.appendChild(data_fine);
    cc.appendChild(nome);
    loadEsami(json['esami']);
}

function loadEsami(esami){
    const titolo=document.createElement('h1');
    const sezione=document.querySelector('.contenuto');
    titolo.textContent='Esami';
    sezione.appendChild(titolo);
    const sezioneEsami=document.createElement('div');
    sezioneEsami.classList.add('esami');

    const id_esame=document.createElement('div');
    id_esame.classList.add('id_esame');
    const id_esameTitolo=document.createElement('h2');
    id_esameTitolo.textContent='ID Esame';
    id_esame.appendChild(id_esameTitolo);
    
    const tipoEsame=document.createElement('div');
    tipoEsame.classList.add('tipoEsame');
    const tipoEsameTitolo=document.createElement('h2');
    tipoEsameTitolo.textContent='Tipo Esame';
    tipoEsame.appendChild(tipoEsameTitolo);
    
    const referto=document.createElement('div');
    referto.classList.add('referto');
    const refertoTitolo=document.createElement('h2');
    refertoTitolo.textContent='Referto';
    referto.appendChild(refertoTitolo);
    
    const data_esame=document.createElement('div');
    data_esame.classList.add('data_esame');
    const data_esameTitolo=document.createElement('h2');
    data_esameTitolo.textContent='Data Esame';
    data_esame.appendChild(data_esameTitolo);
    for(var i=0; i < esami.length;i++){
        
        var info=document.createElement('div');
        info.classList.add('informazione');
        info.textContent=esami[i].id_esame;
        id_esame.appendChild(info);

        info=document.createElement('div');
        info.classList.add('informazione');
        info.textContent=esami[i].referto;
        referto.appendChild(info);

        info=document.createElement('div');
        info.classList.add('informazione');
        info.textContent=esami[i].data_esame;
        data_esame.appendChild(info);

        info=document.createElement('div');
        info.classList.add('informazione');
        info.textContent=esami[i].tipo_esame;
        tipoEsame.appendChild(info);
    }
    sezioneEsami.appendChild(id_esame);
    sezioneEsami.appendChild(tipoEsame);
    sezioneEsami.appendChild(referto);
    sezioneEsami.appendChild(data_esame);
    sezione.appendChild(sezioneEsami);
}


function loadInfoReaprto(event){
    const url=window.location.href;
    var splitUrl = url.split('/');
    url2=splitUrl[0]+'//'+splitUrl[2]+'/'+splitUrl[3]+'/'+splitUrl[4]+'/fetch_reparto'; 
    fetch(url2).then(onRespone).then(onJsonReparto);
}
function onJsonReparto(json){
    const sezione=document.querySelector('.contenuto');
    sezione.classList.add('invisible');
    const reparto=document.querySelector('#reparto');
    reparto.classList.remove('invisible');
    informazioni=json;
    riempiInfoReparto(informazioni ,'#id_reparto','id_reparto');
    riempiInfoReparto(informazioni ,'#posti_occupati','num_posti_occupati');
    riempiInfoReparto(informazioni ,'#posti_liberi','num_posti_liberi');
    riempiInfoReparto(informazioni ,'#posti_totali','num_posti_tot');
    riempiInfoReparto(informazioni ,'#sede','sede');
    riempiInfoReparto(informazioni ,'#nome','nome');
}
function riempiInfoReparto(informazioni , id,index){
        var oldInfo=document.querySelector(id+' .informazione');

        info=document.createElement('div');
        colonna=document.querySelector(id);
        if(oldInfo!=null){
        colonna.removeChild(oldInfo);
        }
        info.classList.add('informazione');
        info.textContent=informazioni[index];
        colonna.appendChild(info);
}

// qui vado a gestire la terapia che puo essere mostrata o nascosta
function showterapia(event){
    event.currentTarget.removeEventListener('click',showterapia);
    event.currentTarget.addEventListener('click',hiddenterapia);
    event.currentTarget.textContent='Nascodi Terapia';
    const terapia=document.querySelector('.terapia');
    terapia.classList.remove('invisible');
    const titolo=document.querySelector('#terapia h1');
    titolo.classList.remove('invisible');
    const url=window.location.href;
    var splitUrl = url.split('/');
    url2=splitUrl[0]+'//'+splitUrl[2]+'/'+splitUrl[3]+'/'+splitUrl[4]+'/fetch_terapia'; 
    fetch(url2).then(onRespone).then(onJsonTerapia);
}
function onJsonTerapia(json){
    var oldInfo=document.querySelectorAll('.terapia .informazione');
    for(var i=0;i< oldInfo.length;i++){
        const parent =oldInfo[i].parentNode
        if(oldInfo[i]!=null){
            parent.removeChild(oldInfo[i]);
        }
    }
    for(i=0;i<json.length;i++){
        riempiTerapia(json[i],'#nomePaziente','nome');
        riempiTerapia(json[i],'#cognomePaziente','cognome');
        riempiTerapia(json[i],'#farmaco','nome_farmaco');
        riempiTerapia(json[i],'#quantita_giornaliera','quantita_giornaliera');
    }
}
function riempiTerapia(informazioni , id,index){
    info=document.createElement('div');
    colonna=document.querySelector(id);
    
    info.classList.add('informazione');
    info.textContent=informazioni[index];
    colonna.appendChild(info);
}
function hiddenterapia(event){
    const terapia=document.querySelector('.terapia');
    terapia.classList.add('invisible');
    const titolo=document.querySelector('#terapia h1');
    titolo.classList.add('invisible');

    event.currentTarget.textContent='Mostra Terapia';
    event.currentTarget.addEventListener('click',showterapia);
}


const profilo=document.querySelector('#profile');
profilo.addEventListener('click',loadProfile);

const cartella=document.querySelector('#cartellaClinica');
cartella.addEventListener('click',loadCartellaClinica);

const reparto=document.querySelector('#gestioneReparto');
if(reparto != null){
reparto.addEventListener('click',loadInfoReaprto);
const terapia=document.querySelector('#bottoneTerapia');
terapia.addEventListener('click',showterapia);
}
// vado a gestire il form di ricovero

function sendRicovero(event){
    event.preventDefault();
    const nome=document.querySelector('#Ricovero #nome');
    const cognome=document.querySelector('#Ricovero #cognome');
    const email=document.querySelector('#Ricovero #e-mail');
    const cf=document.querySelector('#Ricovero #cf');
    const ananmesi=document.querySelector('#Ricovero #ananmesi');
    const data=document.querySelector('#Ricovero #date');
    const citta=document.querySelector('#Ricovero #citta');
    const tok=document.getElementById("tok");
    var controllo=true;
    if(nome.value==''||cognome.value==''||email.value==''||cf.value==''||data.value==''||citta.value==''||ananmesi.value=='' ){
        document.querySelector('#Ricovero .error').classList.remove('invisible');
    }
    else{
        document.querySelector('#Ricovero .error').classList.add('invisible');
        if(!(/[a-z0-9]+@[a-z0-9]+\.[a-z]+$/i).test(email.value)){
            document.querySelector('#Ricovero #errormail').classList.remove('invisible');
            controllo=false;
        }
        else{
            document.querySelector('#Ricovero #errormail').classList.add('invisible');
           
        }
        if(!(/[a-z]{6}[0-9]{2}[a-z]{1}[0-9]{2}[a-z][0-9]{3}[a-z]$/i).test(cf.value)){
            document.querySelector('#Ricovero #errorcf').classList.remove('invisible');
            controllo=false;
        }
        else{
            document.querySelector('#Ricovero #errorcf').classList.add('invisible');
            
        }
        if(!(/[0-9]{4}[-][0-9]{2}[-][0-9]{2}$/).test(data.value)){
        
            document.querySelector('#Ricovero #errordate').classList.remove('invisible');
            controllo=false;
        }
        else{
            document.querySelector('#Ricovero #errordate').classList.add('invisible');
            
        }

        
        if(controllo){
            const dati={
            'nome' : nome.value,
            'cognome' : cognome.value,
            'email' : email.value,
            'cf' : cf.value,
            'ananmesi' :ananmesi.value,
            'data': data.value,
            'citta': citta.value
            };
            
            const url=window.location.href;
            var splitUrl = url.split('/');
            url2=splitUrl[0]+'//'+splitUrl[2]+'/'+splitUrl[3]+'/'+splitUrl[4]+'/fetch_ricovero'; 
            fetch(url2,{
                headers: {
                "Content-Type": "application/json",
                "X-CSRF-TOKEN": tok.value
                },
                method : 'post',
                body: JSON.stringify(dati)
            }).then(onRespone).then(onJsonRicovero);
        }
    }
}
function onJsonRicovero(json){
    const errore=document.querySelector('#reparto .error');
    errore.textContent=json[0];
    errore.classList.remove('invisible');
}
const ricovero=document.querySelector('#Ricovero');
ricovero.addEventListener('submit',sendRicovero);

//infine vado a gestire la prenotazione del parcheggio

function parcheggio(event){
    const sezione=document.querySelector('.contenuto');
    sezione.classList.remove("invisible");
    const reparto=document.querySelector('#reparto');
    reparto.classList.add('invisible');
    sezione.innerHTML='';
    const titolo=document.createElement('h1');
    titolo.textContent="Prenota Il tuo posto nel parcheggio";
    
    sezione.appendChild(titolo);
    const parcheggi=document.createElement('div');
    parcheggi.classList.add('parcheggi');
    sezione.appendChild(parcheggi);
    const url=window.location.href;
    var splitUrl = url.split('/');
    url2=splitUrl[0]+'//'+splitUrl[2]+'/'+splitUrl[3]+'/'+splitUrl[4]+'/fetch_parcheggio'; 
    fetch(url2).then(onRespone).then(onJsonParcheggio);
}
function ordinamento(a,b){
    if (Number(a.num_parcheggio) < Number(b.num_parcheggio)){
        return -1;
      }
      else if (Number(a.num_parcheggio) > Number(b.num_parcheggio)){
        return 1;
      }
      return 0;
}
function onJsonParcheggio(json){
    json.sort(ordinamento);
    const parcheggi=document.querySelector('.parcheggi');
    const sede1=document.createElement('div');
    const sede2=document.createElement('div');
    const sede3=document.createElement('div');
    const nesima=document.createElement('div');
    const librino=document.createElement('div');
    const centro=document.createElement('div');
    const nome1=document.createElement('h1');
    const nome2=document.createElement('h1');
    const nome3=document.createElement('h1');
    nome1.textContent="Garibaldi Centro";
    nome2.textContent="Garibaldi Librino";
    nome3.textContent="Garibaldi Nesima";
    sede1.classList.add('sede');
    sede2.classList.add('sede');
    sede3.classList.add('sede');
    centro.classList.add('postiSede');
    librino.classList.add('postiSede');
    nesima.classList.add('postiSede');
    sede1.appendChild(nome1);
    sede2.appendChild(nome2);
    sede3.appendChild(nome3);
    
    for(var i=0; i<json.length;i++){
        const posto=document.createElement('div');
        posto.classList.add('posto');
        posto.dataset.numero=json[i].num_parcheggio;
        posto.textContent=json[i].num_parcheggio;
        if(json[i].id_impiegato== null ){
            posto.classList.add('libero');
            posto.addEventListener('click',selected);
        }
        else{
            posto.classList.add('occupato');
        }
        if((json[i].sede).toLowerCase()=="garibaldi centro"){
            centro.appendChild(posto);
        }else if((json[i].sede).toLowerCase()=="garibaldi librino"){
            librino.appendChild(posto);
        }
        else{
            nesima.appendChild(posto);
        }
    }
    sede1.appendChild(centro);
    sede2.appendChild(librino);
    sede3.appendChild(nesima);
    parcheggi.appendChild(sede1);
    parcheggi.appendChild(sede2);
    parcheggi.appendChild(sede3);
    const bottone=document.createElement('div');
    bottone.textContent='Prenota';
    bottone.classList.add('button');
    bottone.addEventListener('click',prenota);
    const errore=document.createElement('div');
    errore.classList.add('error');
    //errore.classList.add('invisible');
    parcheggi.appendChild(errore);
    parcheggi.appendChild(bottone);
}
function selected(event){
    event.currentTarget.classList.add('selected');
    const posti=document.querySelectorAll('.libero');
    for(i=0;i<posti.length;i++){
        posti[i].removeEventListener('click',selected);
    }
    event.currentTarget.addEventListener('click',deselected);  
}
function deselected(event){
    event.currentTarget.removeEventListener('click',deselected);
    event.currentTarget.classList.remove('selected');
    const posti=document.querySelectorAll('.libero');
    for(i=0;i<posti.length;i++){
        posti[i].addEventListener('click',selected);
    }
}
function prenota(event){
    const selected=document.querySelector(".selected");
    if(selected != null){
    const errore =document.querySelector('.error');
    errore.classList.add('invisible');
    const tok=document.getElementById("tok");
    const sede=selected.parentNode.parentNode.querySelector('h1').textContent;
    dati= {
        'sede' : sede,
        'num_parcheggio':selected.textContent,
        '_token' :tok.value
    }
    const url=window.location.href;
    var splitUrl = url.split('/');
    url2=splitUrl[0]+'//'+splitUrl[2]+'/'+splitUrl[3]+'/'+splitUrl[4]+'/fetch_prenotaParcheggio'; 
    fetch(url2,{
        headers: {
        "Content-Type": "application/json",
        "X-CSRF-TOKEN": tok.value
        },
        method : 'post',
        body: JSON.stringify(dati)
    }).then(onRespone).then(onJsonParcheggio2);
    }
    else {
        const errore =document.querySelector('.error');
        errore.textContent='Selezionare un posto da prenotare'
        errore.classList.remove('invisible');
    }
}
function onJsonParcheggio2(json){
    errore=document.querySelector('.error');
    errore.textContent=json[0];
    errore.classList.remove('invisible');
}
const park=document.querySelector('#parchggio');
if(park != null){
park.addEventListener('click',parcheggio);
}
loadProfile()

