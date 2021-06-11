<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use App\Models\reparto;

class medico extends Model
{
    protected $table="medico";
    protected $primaryKey="id_impiegato";
    protected $autoIncrement = false;
    public $timestamps = false;
    
    public function is_a_impiegato(){
        return $this->belongsTo("App\Models\impiegato","ID_impiegato");
    }

    public function reparto(){
        return $this->belongsTo('App\Models\reparto',"ID_reparto");
    }
    public function cartella(){
        return $this->hasMany("cartella_clinica");
    }

}
