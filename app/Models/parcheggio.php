<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use App\Models\impiegato;

class parcheggio extends Model
{
    protected $table="parcheggio";
    protected $primaryKey="num_parcheggio";
    protected $autoIncrement = false;
    public $timestamps = false;
    public function imp(){
        return $this->hasOne("App\Models\impiegato","id_impiegato");
    }
}
