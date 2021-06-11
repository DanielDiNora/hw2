<?php

use Illuminate\Routing\Controller;
use App\Models\persona;
use App\Models\medico;
use App\Models\impiegato;
use App\Models\infermiere;
use App\Models\tecnico;
use App\Models\oss;
use Illuminate\Support\Facades\Session;
use Illuminate\Http\Request;

class MyPageController extends Controller {

    public function create() {
    if(Session::get('username') == null){
        return redirect('login');
    }
    // // recupero i dati dell'utente grazie al codice fiscale salvato nella sessione peer riempire la pagina
    $user=persona::find(Session::get('username'));
    $ruolo='Paziente';
    if( ($user->is_an_imp()->first()->medico()->first()) != null ) {
        $ruolo='Medico';
    }

    if( ($user->is_an_imp()->first()->infermiere()->first()) != null) {
        $ruolo='Infermiere';  
    }

    if( ($user->is_an_imp()->first()->tecnico()->first()) != null) {
        $ruolo='Tecnico';
    }
    if( ($user->is_an_imp()->first()->oss()->first()) != null) {
        $ruolo='Operatore Socio Sanitario';
    }
    return view('mypage')->with("ruolo",$ruolo)->with("user",$user);
 }

}

?>
