<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class tecnico extends Model
{
    protected $table="tecnico";
    protected $primaryKey="id_impiegato";
    protected $autoIncrement = false;
    public $timestamps = false;
    
    public function is_a_impiegato(){
        return $this->belongsTo("impiegato");
    }

    public function reparto(){
        return $this->belongsToMany("reparto");
    }

}
