@extends('layout.app')
@section('contenuti aggiuntivi')
<link rel='stylesheet' href='style/Login.css'>
<script src="scripts/Login.js" defer></script>
@stop
@section('all')
            <section>
                <form id="login" method="post" >
                    <h2>Accedi ai nostri servizi online</h2>
                    <div class="error invisible">Attenzione compilare tutti i campi</div>
                    <div class="error">{{ $error }}</div>
                    <input type = "hidden" name = "_token" value = <?php echo "'".csrf_token()."'" ; ?>>
                    <label for="cf">Codice Fiscale</label><input type="text" id="cf" name="cf" value='{{ old('cf') }}'>
                    <label for="pwd">Password</label><input type="password" id="pwd" name="pwd">
                    <input type = "submit" class = "submit" value = "Accedi">
                    <a href=''>Non sei registrato? Registrati ora</a>
                </form>
                <form id="signup" class='invisible' method="post">
                    <h2>Registrati ai nostri servizi online</h2>
                    <div class="error invisible">Attenzione compilare tutti i campi</div>
                    <label for="nome">Nome</label><input type="text" id="nome" name="nome">
                    <input id='token' type = "hidden" name = "_token" value = <?php echo "'".csrf_token()."'" ; ?>>
                    <label for="cognome">Cognome</label><input type="text" id="cognome" name="cognome">
                    <label for="e-mail">E-mail</label><input type="text" id="e-mail" name="e-mail">
                    <div id="errormail" class="invisible">Attenzione errore nell'inserimento della e-mail</div>
                    <label for="citta">Città</label><input type="text" id="citta" name="citta">
                    <label for="date">Data Di Nascita <br>(aaaa-mm-gg)</br></label><input type="text" id="date" name="date">
                    <div id="errordate" class="invisible">Attenzione errore nell'inserimento della data</div>
                    <label for="cf">Codice Fiscale</label><input type="text" id="cf2" name="cf">
                    <div id="errorcf" class="invisible">Attenzione errore nell'inserimento del codice fiscale</div>
                    <label for="pwd">Password</label><input type="password" id="pwd2" name="pwd">
                    <div id="errorpwd" class="invisible">Errore: la password deve 
                                                        <ul>
                                                        <li>essere lunga tra 8-16 caratteri</li>
                                                        <li>contenere almeno un carattere maiuscolo</li>
                                                        <li>contenere almeno un numero</li> 
                                                        </ul>
                    </div>
                    <label for="pwdc">Conferma Password</label><input type="password" id="pwdc" name="pwdc">
                    <div id="errorpwdc" class="invisible">Attenzione le password non corrispondono</div>
                    <input type = "submit" class="submit" value = "Registrati">
                    <div class="error2"></div>
                </form>
            </section>
@stop