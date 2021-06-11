<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class cartellaClinica extends Model
{
    protected $table="cartella_clinica";
    protected $primaryKey="id_cartella";
    public $timestamps = false;
    public function has_reparto(){
        return $this->belongsTo('App\Models\reparto',"id_reparto");
    }
    public function has_persona(){
        return $this->belongsTo("persona");
    }

    public function is_an_imp(){
        return $this->hasOne("impiegato");
    }
    public function farmaci(){
        return $this->belongsToMany('App\Models\farmaco',null,"id_cartella","nome_farmaco");
    }
}
