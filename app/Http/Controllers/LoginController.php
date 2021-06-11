<?php

use Illuminate\Routing\Controller;
use App\Models\persona;
use Illuminate\Support\Facades\Session;
use Illuminate\Http\Request;

class LoginController extends Controller {

    public function login() {
        $error='';
    if(session('username')!= null){
        
        return redirect('mypage')->with("error",$error);
    }
    
    return view('login')->with("error",$error);
    }
    public function checkLogin() {
        $_POST=request()->all();
        $error='';
  //  effettuo il login tramite l'invio del form ricaricando la pagina
        if($_POST['cf']!=null && $_POST['pwd']!=null){
            $response=persona::find($_POST['cf']);
            if($response!=null){
                $user=$response->toArray();
                if(!($user['psw']==NULL)){
                    if($user['psw']==$_POST['pwd']){
                        Session::put('username',$_POST['cf']);
                        return redirect('mypage');
                    }
                    else{
                        $error='Password errata';
                    }
                }
                else{
                    $error='Non sei ancora registrato al nostro portale';
                }
            }
            else{
                $error='Il tuo codice fiscale non è presente nei nostri sistemi';
            }
        return view('login')->with("error",$error);
        }
    }

    public function logout(){

        Session::flush();
        return redirect('./login');
    }

    public function signup(){
    //mi vengono mandati i dati tramite fetch per la registrazione controllo i dati e registro la persona
    $controllo=true;
    $response=array();
    $_POST = request()->all();
    if( $_POST['cf']!=null && $_POST['pwd']!=null && $_POST['nome']!=null && $_POST['cognome']!=null && $_POST['email']!=null){
        if(!preg_match('/[a-z0-9]+@[a-z0-9]+\.[a-z]+$/i',$_POST['email'])){
            array_push($response,'Errore mail non corretta');
            $controllo=false;
        }
        if(!preg_match('/[a-z]{6}[0-9]{2}[a-z]{1}[0-9]{2}[a-z][0-9]{3}[a-z]$/i',$_POST['cf'])){
            array_push($response,"Errore codice ficale non corretto");
            $controllo=false;
        }
        if(!preg_match('/(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,16}$/',$_POST['pwd'])){
            array_push($response,"Errore password non corretta");
            $controllo=false;
        }
        if(!preg_match('/[0-9]{4}[-][0-9]{2}[-][0-9]{2}$/',$_POST['data'])){
        
            array_push($response,"Errore data non corretta");
            $controllo=false;
        }
        if($controllo){
            $cf=$_POST['cf'];
            $nome=$_POST['nome'];
            $cognome=$_POST['cognome'];
            $email=$_POST['email'];
            $pwd=$_POST['pwd'];
            $data=$_POST['data'];
            $citta=$_POST['citta'];
            $user=persona::find($cf);
            if($user != null){
                if($user['psw']==null){
                    //controllo se il campo psw è vuoto vuol dire che quella persona è presente nei sistemi ma non ancora registrato
                    //quindi controllo se i dati anagrafici sono giusti e in caso positivi registro.
                    if($user['nome']==$nome && $user['cognome']==$cognome &&
                        $user['Data_Di_Nascita']==$data && $user['citta']==$citta){
                            $user['psw']=$pwd;
                            $user['email']=$email;
                            $user->save();
                            array_push($response,"Registrazione effettuata");
                        }
                        else{
                            array_push($response,"Sei presente nel nostro database ma hai sbagliato qualche dato nella tua anagrafica");
                        }
                }
                else{
                    array_push($response,"Sei già registrato");
                }
            }
            if($user==null){
                $persona=new persona;
                $persona->nome=$nome;
                $persona->cf=$cf;
                $persona->cognome=$cognome;
                $persona->email=$email;
                $persona->psw=$pwd;
                $persona->Data_Di_Nascita=$data;
                $persona->citta=$citta;
                $persona->save();
                array_push($response,"Registrazione effettuata");
            }
        }
    }else{
        array_push($response,"Sono qui");
    }
    return $response;
    }


}

?>
