<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use App\Models\impiegato;
use App\Models\cartellaClinica;

class persona extends Model
{
    protected $table="persona";
    protected $primaryKey="cf";
    protected $autoIncrement = false;
    public $timestamps = false;
    protected $keyType="string";
    public function is_an_imp(){
        return $this->hasOne("App\Models\impiegato","cf");
    }
    public function has_cartella(){
        return $this->hasMany("App\Models\cartellaClinica","cf");
    }
    public function has_esame(){
        return $this->hasMany("esame");
    }
}
