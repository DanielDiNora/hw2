<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class reparto extends Model
{
    protected $table="reparto";
    protected $primaryKey="id_reparto";
    protected $autoIncrement = false;
    public $timestamps = false;
    

    public function is_a_medico(){
        return $this->hasMany("App\Models\medico","ID_reparto","id_reparto");
    }
    public function is_a_infermiere(){
        return $this->hasMany("App\Models\infermiere","ID_reparto","id_reparto");
    }
    
    public function is_a_oss(){
        return $this->hasMany("App\Models\oss");
    }
    public function is_a_tecnico(){
        return $this->belongsToMany('App\Models\tecnico');
    }
    public function hasCartelle(){
        return $this->hasMany("App\Models\cartellaClinica","ID_reparto");
    }
    public function servizi(){
        return $this->hasMany("App\Models\servizi","id_reparto","reparto");
    }
}
