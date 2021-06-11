<?php

use Illuminate\Routing\Controller;
use App\Models\persona;
use App\Models\medico;
use App\Models\impiegato;
use App\Models\infermiere;
use App\Models\tecnico;
use App\Models\oss;
use App\Models\servizi;
use App\Models\reparto;
use App\Models\esame;
use App\Models\cartellaClinica;
use Illuminate\Support\Facades\Session;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

class fetchController extends Controller {

    public function service() {
        $servizi=servizi::All()->toArray();
        $json= servizi::join('reparto','reparto.id_reparto','=','servizi.reparto')
                            ->get(['servizi.Nome as Nome','servizi.descrizione','servizi.descrizione','servizi.image','reparto.nome as reparto']);   
        return $json;        
    }
    public function doctor() {
        $json=medico::join('impiegato','impiegato.id','=','medico.id_impiegato')
                    ->join('reparto','reparto.id_reparto','=','medico.id_reparto')
                    ->join('persona','persona.cf','=','impiegato.cf')
        ->get(['persona.cognome as Nome','medico.specializzazione as Specializzazione' ,'persona.img as image','reparto.nome as reparto']);
        return $json;        
    }

    public function getProfile(){
        if(session('username')!=null){            
            $error='';
            $cf=session('username');
            $user=persona::find($cf);
            $profilo=persona::find($cf)->toArray();
            $ruolo='Paziente';
            $id_imp=(persona::find($cf)->is_an_imp()->get('id')->toArray())[0]['id'];
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
            //array_push($row['ruolo'],'');
            $profilo['ruolo']=$ruolo;
            return $profilo;
        }
    }
    public function getCartella(){
        if(session('username')!=null){
        $totale=array(
            'esami' =>  esame::where('cf',Session::get('username'))->get()->toArray(),
            'cartelle' =>  cartellaClinica::join('reparto','reparto.id_reparto','=','cartella_clinica.id_reparto')->where('cartella_clinica.cf',Session::get('username'))
                            ->get(['cartella_clinica.ananmesi','cartella_clinica.cf','cartella_clinica.data_fine_ricovero',
                            'cartella_clinica.data_inizio_ricovero','cartella_clinica.diagnosi',
                            'cartella_clinica.id_cartella','cartella_clinica.id_reparto','reparto.nome'])->toArray(),
        );
        return $totale;
        }
    }

    public function getInfoReparto(){
        if(session('username')!=null){
            $risultati=array();
            $cf=Session::get('username');
            if((persona::find($cf)->is_an_imp()->first()->infermiere()->first()) != null){
                $ris=persona::find($cf)->is_an_imp()->first()->infermiere()->first()->reparto()->first();
                return $ris;
            }
            else{
                $ris=persona::find($cf)->is_an_imp()->first()->medico()->first()->reparto()->first();
                return $ris;
            }
            
        }
    }   

    public function getTerapia(){
        if(session('username')!=null){
            $cf=session('username');
            if((persona::find($cf)->is_an_imp()->first()->infermiere()->first()) != null){
                $rep=persona::find($cf)->is_an_imp()->first()->infermiere()->first()->reparto()->first();
                $id_rep=$rep['id_reparto'];
                $terapia= cartellaClinica::join('cartella_clinica_farmaco','cartella_clinica_farmaco.id_cartella',"=","cartella_clinica.id_cartella")
                ->join('persona','persona.cf','=','cartella_clinica.cf')
                ->where('cartella_clinica.id_reparto',"=",$id_rep)
                ->where('cartella_clinica.data_fine_ricovero',null)->get(['persona.nome','persona.cognome','nome_farmaco','quantita_giornaliera'])->toArray();
                return $terapia;
            }
            else{
                $rep=persona::find($cf)->is_an_imp()->first()->medico()->first()->reparto()->first();
                $id_rep=$rep['id_reparto'];
                $terapia= cartellaClinica::join('cartella_clinica_farmaco','cartella_clinica_farmaco.id_cartella',"=","cartella_clinica.id_cartella")
                ->join('persona','persona.cf','=','cartella_clinica.cf')
                ->where('cartella_clinica.id_reparto',"=",$id_rep)
                ->where('cartella_clinica.data_fine_ricovero',null)->get(['persona.nome','persona.cognome','nome_farmaco','quantita_giornaliera']);
                return $terapia;
            }
            
        }
    }
    public function test(){
        print_r(persona::find('VRL43VYY0LOBT791')->has_cartella()->where('data_fine_ricovero', null)->first());
    }


    public function addRicovero(){
        if(session('username')!=null){
            $_POST = request()->all();
            $controllo=true;
            $response=array();
            $cf=session('username');
            if((persona::find($cf)->is_an_imp()->first()->infermiere()->first()) != null){
                $rep=persona::find($cf)->is_an_imp()->first()->infermiere()->first()->reparto()->first();
                $id_rep=$rep['id_reparto'];
            }
            else{
                $rep=persona::find($cf)->is_an_imp()->first()->medico()->first()->reparto()->first();
                $id_rep=$rep['id_reparto'];
            }
            if( $_POST['cf']!=null &&  $_POST['nome']!=null && $_POST['cognome']!=null 
                && $_POST['email']!=null && $_POST['data']!=null && $_POST['ananmesi'] !=null){
                if(!preg_match('/[a-z0-9]+@[a-z0-9]+\.[a-z]+$/i',$_POST['email'])){
                    array_push($response,'Errore mail non corretta');
                    $controllo=false;
                }
                if(!preg_match('/[a-z]{6}[0-9]{2}[a-z]{1}[0-9]{2}[a-z][0-9]{3}[a-z]$/i',$_POST['cf'])){
                    array_push($response,"Errore codice ficale non corretto");
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
                    $ananmesi=$_POST['ananmesi'];
                    $data=$_POST['data'];
                    $citta=$_POST['citta'];
                    $persona=persona::find($cf);
                    if($persona != null){
                        if(strtoupper($persona['cf'])==strtoupper($cf) && strtoupper($persona['nome'])==strtoupper($nome) && 
                            strtoupper($persona['cognome'])==strtoupper($cognome) &&
                            strtoupper($persona['Data_Di_Nascita'])==strtoupper($data) && strtoupper($persona['citta'])==strtoupper($citta))
                        {

                            //ok i dai anagrafici corrispondono ma devo controllare che la persona non sia gia ricoverata
                            $controlloPresente=persona::find($cf)->has_cartella()->where('data_fine_ricovero', null)->first();
                            if($controlloPresente == null){
                                $inserimento=new cartellaClinica;
                                $inserimento->cf=$cf;     
                                $inserimento->ananmesi=$ananmesi;
                                $inserimento->data_inizio_ricovero=date("Y-m-d");
                                $inserimento->id_reparto=$id_rep;
                                $res=$inserimento->save();
                                if($res){
                                    array_push($response,"Inserimento del ricovero riuscito" );
                                }
                            }
                            else{
                                array_push($response,"Paziente già ricoverato" );
                            }
                        }
                        else {
                            array_push($response,"I dati inseriti non corrisponsdono con quelli nel nostro sistema");
                        }
                    }
                    else{
                        //Devo inserire anche la persona
                        $inserimentoPersona=new persona;
                        $inserimentoPersona->cf=$cf;     
                        $inserimentoPersona->nome=$nome;
                        $inserimentoPersona->cognome=$cognome;
                        $inserimentoPersona->email=$email;
                        $inserimentoPersona->Data_Di_Nascita=$data;
                        $inserimentoPersona->citta=$citta;
                        $res=$inserimentoPersona->save();
                        if($res){
                            $inserimento=new cartellaClinica;
                            $inserimento->cf=$cf;     
                            $inserimento->ananmesi=$ananmesi;
                            $inserimento->data_inizio_ricovero=date("Y-m-d");
                            $inserimento->id_reparto=$id_rep;
                            $res=$inserimento->save();
                            if($res){
                                array_push($response,"Inserimento del ricovero riuscito" );
                            }
                        }
                    }
                    
                }
            }else{
                array_push($response,"Non sei loggato");
            }
            return $response;
        }
    }

    public function ProfileImage(){
        if(session('username')!=null){
            $file = request()->file('file');
            $response=array();
                $imageFileType = $file->extension();
                if($imageFileType == "jpg" || $imageFileType == "png" || $imageFileType == "jpeg"){
                    if(($file->getSize())<5000000){
                        $destinationPath="./imageProfile/";
                        $fileName=session('username').".".$imageFileType;
                        if($file->storeAs($destinationPath,$fileName )){
                            array_push($response,"Immagine caricata con successo");
                            $persona=persona::find(session('username'));
                            $persona->img="/hw2/storage/app/imageProfile/".$fileName;
                            $res=$persona->save();
                            if(!$res){
                                array_push($response,"Errore nell'inserimento nel database");
                            }
                        }else{
                            array_push($response,"Errore nel caricare l'immagine");
                        }
                    }
                    else{
                        array_push($response,"Errore foto troppo grande(max 5MB)");
                    }
                }
                else{
                    array_push($response,"Imaggine nel formato sbagliato(formati consentiti:jpg,png,jpeg)");
                }
        }
        return $response;
    }
    
    
}

?>
