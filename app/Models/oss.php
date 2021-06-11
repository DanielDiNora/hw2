<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
class oss extends Model
{
    protected $table="oss";
    protected $primaryKey="id_impiegato";
    protected $autoIncrement = false;
    public $timestamps = false;
    
    public function is_a_impiegato(){
        return $this->belongsTo("App\Models\impiegato","ID_impiegato");
    }

    public function reparto(){
        return $this->belongsTo("reparto");
    }

}
