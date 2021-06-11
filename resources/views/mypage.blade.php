@extends('layout.app')
@section('contenuti aggiuntivi')
<link rel='stylesheet' href='style/mypage.css'>
<script src="scripts/mypage.js" defer></script>
@stop
@section('all')
            <section>
                <div id='sx'>
                    <div id='profilo'>
                        <img src=<?php
                        if($user['img'] != null){
                            
                            echo ("http://".$_SERVER['SERVER_NAME'].$user['img']);
                        }
                        else{
                            echo "'image/imganonimo.png'";
                        }
                        ?>>
                        <h2><?php
                        echo ($user['nome']).' '.($user['cognome']);
                        ?></h2>
                        <h2><?php
                        echo $ruolo;
                        ?></h2>
                    </div>
                    <div id='menu'>
                        <a id='profile'>Il Mio Profilo</a>
                        <a id='cartellaClinica'>La mia cartella clinica</a>
                    <?php
                    if( $ruolo== "Infermiere" || $ruolo== "Medico"){
                        echo  "<a id='gestioneReparto'>Gestisci il mio reaparto</a>";
                    }
                    if( $ruolo== "Infermiere" || $ruolo== "Medico"|| $ruolo== "Tecnico" || $ruolo== "Operatore Socio Sanitario") {
                      
                      echo  "<a id='parchggio'>Prenota il tuo posto nel parcheggio</a>";
                    }
                    ?>
                    </div>
                </div>
                <div id='dx'>
                    <div class='contenuto'>

                    </div>
                    <div id='reparto' class='invisible'>
                        <h1>Reparto</h1>
                        <div id='info'>
                            <div id='id_reparto'>
                                <h2>Reparto</h2>
                            </div>
                            <div id='nome'>
                                <h2>Nome</h2>
                            </div>
                            <div id='sede'>
                                <h2>Sede</h2>
                            </div>
                            <div id='posti_occupati'>
                                <h2>Posti Occupati</h2>
                            </div>
                            <div id='posti_liberi'>
                                <h2>Posti Liberi</h2>
                            </div>
                            <div id='posti_totali'>
                                <h2>Posti Totali</h2>
                            </div>

                        </div>
                        <div id='terapia'>
                            <div id='bottoneTerapia'>Mostra Terapia</div>
                            <h1 class='invisible'>Terapia</h1>
                            <div class='terapia invisible'>
                                
                                <div id='nomePaziente'>
                                    <h2>Nome</h2>
                                </div>
                                <div id='cognomePaziente'>
                                    <h2>Cognome</h2>
                                </div>
                                <div id='farmaco'>
                                    <h2>Farmaco</h2>
                                </div>
                                <div id='quantita_giornaliera'>
                                    <h2>Quantità</h2>
                                </div>
                            </div>
                        </div>
                        <div id='styleRicovero'>
                            <form id='Ricovero'>
                                <h2>Effettua un ricovero</h2>
                                <div class="error invisible">Attenzione compilare tutti i campi</div>
                                <input id="tok" type = "hidden" name = "_token" value = <?php echo "'".csrf_token()."'" ; ?>>
                                <label for="nome">Nome</label><input type="text" id="nome" name="nome">
                                <label for="cognome">Cognome</label><input type="text" id="cognome" name="cognome">
                                <label for="e-mail">E-mail</label><input type="text" id="e-mail" name="e-mail">
                                <div id="errormail" class="invisible">Attenzione errore nell'inserimento della e-mail</div>
                                <label for="citta">Città</label><input type="text" id="citta" name="citta">
                                <label for="date">Data Di Nascita <br>(aaaa-mm-gg)</br></label><input type="text" id="date" name="date">
                                <div id="errordate" class="invisible">Attenzione errore nell'inserimento della data</div>
                                <label for="cf">Codice Fiscale</label><input type="text" id="cf" name="cf">
                                <div id="errorcf" class="invisible">Attenzione errore nell'inserimento del codice fiscale</div>
                                <label for="ananmesi">Ananmesi</label><input type="text" id="ananmesi" name="ananmesi">
                                <label for="submit"></label><input type="submit" id="submit" name="submit">
                            </form> 
                        </div>
                    </div>
                </div>
            </section>
@stop