<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class farmaco extends Model
{
    protected $table="farmaco";
    protected $primaryKey="nome";
    public $timestamps = false;
    protected $autoIncrement = false;
    public function cartella(){
        return $this->belongsToMany("cartella_clinica",null,"nome_farmaco");
    }
}
