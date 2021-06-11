<?php

use Illuminate\Routing\Controller;
use App\Models\persona;
use App\Models\medico;
use App\Models\impiegato;
use App\Models\infermiere;
use App\Models\tecnico;
use App\Models\oss;
use App\Models\parcheggio;
use Illuminate\Support\Facades\Session;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

class parkingController extends Controller {

    public function get() {
        if(session('username')!= null){
            $parcheggi=parcheggio::All();
            return $parcheggi;
        }
        

    }
    public function prenota() {
        if(session('username')!= null){
            $controllo=true;
            $response=array();
            $_POST = request()->all();
            $cf=session('username');
            $id_imp=(persona::find($cf)->is_an_imp()->get('id')->toArray())[0]['id'];
            $sede=$_POST['sede'];
            $num_parcheggio=$_POST['num_parcheggio'];
            if($sede!= null && $num_parcheggio != null ){
                $Pcontrollo=(impiegato::find($id_imp)->parcheggio()->get()->toArray());
                if($Pcontrollo!=null){
                   array_push($response,'Hai già prenotato un parcheggio');    
                }
                else{
                    $Pcontrollo=parcheggio::where('num_parcheggio',$num_parcheggio)->where('sede',$sede)->get()->toArray();
                    if($Pcontrollo[0]['id_impiegato'] == null){
                        $inserimento=parcheggio::where('num_parcheggio',$num_parcheggio)->where('sede',$sede)->first();
                        parcheggio::where('num_parcheggio',$num_parcheggio)->where('sede',$sede)->update(['id_impiegato'=>$id_imp]);
                        $res_controllo=$inserimento->save();
                        if($res_controllo){
                            array_push($response,'Parcheggio prenotato');
                        }
                        else{
                            array_push($response,'Errore nella prenotazione');
                        }
                    }
                    else{
                        array_push($response,'Parcheggio era già occupato');
                    }
                }
            }
            else{
                array_push($response,'Dati inviati al server sbagliati');
            }
            return $response;
        }    
    }
}

?>