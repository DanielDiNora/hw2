<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
class esame extends Model
{
    protected $table="esame";
    protected $primaryKey="id_esame";
    public $timestamps = false;
    public $autoIncrement = false;
    public function has_reparto(){
        return $this->belongsTo("cartella");
    }
    public function has_persona(){
        return $this->belongsTo("persona");
    }

    public function refertato_da(){
        return $this->belongsTo("medico");
    }
}
