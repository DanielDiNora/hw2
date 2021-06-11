<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class servizi extends Model
{
    protected $table="servizi";
    protected $primaryKey="Nome";
    protected $autoIncrement = false;
    public $timestamps = false;
    protected $keyType="string";

    public function reparto(){
        return $this->belongsTo('App\Models\reparto',"reparto");
    }

}
