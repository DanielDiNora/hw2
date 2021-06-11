<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use App\Models\impiegato;
use App\Models\reparto;


class infermiere extends Model
{
    protected $table="infermiere";
    protected $primaryKey="ID_impiegato";
    protected $autoIncrement = false;
    public $timestamps = false;
    
    public function is_a_impiegato(){
        return $this->belongsTo("App\Models\impiegato","ID_impiegato");
    }

    public function reparto(){
        return $this->belongsTo('App\Models\reparto',"ID_reparto");
    }

}
