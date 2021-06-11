<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use App\Models\persona;
use App\Models\infermiere;
use App\Models\medico;
use App\Models\tecnico;
use App\Models\oss;

class impiegato extends Model
{
    protected $table="impiegato";
    protected $primaryKey="ID";
    protected $autoIncrement = false;
    public $timestamps = false;
    public function is_a_persona(){
        return $this->belongsTo("App\Models\persona","cf");
    }

    public function medico(){
        return $this->hasOne("App\Models\medico","ID_impiegato","ID");
    }
    public function infermiere(){
        return $this->hasOne("App\Models\infermiere","ID_impiegato","ID");
    }
    
    public function oss(){
        return $this->hasOne("App\Models\oss","ID_impiegato","ID");
    }
    public function tecnico(){
        return $this->hasOne('App\Models\tecnico',"ID_impiegato","ID");
    }
    public function parcheggio(){
        return $this->hasOne("App\Models\parcheggio","id_impiegato","ID");
    }

}
