<?php

use Illuminate\Routing\Controller;
use App\Models\persona;
use App\Models\medico;
use App\Models\impiegato;
use App\Models\infermiere;
use App\Models\tecnico;
use App\Models\oss;
use Illuminate\Support\Facades\Session;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

class apiController extends Controller {

    public function nutritionix() {
        $_GET=request()->all();
        $json=HTTP::withHeaders([
            'Content-Type : application/json',
            'x-app-id' => env('API_ID_NUTRI'),
            'x-app-key' => env('API_key_NUTRI')
        ])->get("https://trackapi.nutritionix.com/v2/search/instant?query=".$_GET['query']);
        return $json;        
    
    }

}

?>
