<?php

use Illuminate\Support\Facades\Route;
/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/
//Route::get('/',function(){
 //   return view('welcome');
//});
Route::get("/Home","HomeController@home");

Route::get("login","LoginController@login");
Route::post("login","LoginController@checkLogin");
Route::get("logout","LoginController@logout");
Route::post("fetch_signup","LoginController@signup");

Route::get("mypage","MyPageController@create");

Route::get("api_nutritionix","apiController@nutritionix");

Route::get("fetch_parcheggio","parkingController@get");
Route::post("fetch_prenotaParcheggio","parkingController@prenota");

Route::get("fetch_service","fetchController@service");
Route::get("fetch_doctor","fetchController@doctor");

Route::get("fetch_profile","fetchController@getProfile");
Route::get("fetch_cartella","fetchController@getCartella");
Route::get("fetch_reparto","fetchController@getInfoReparto");
Route::get("fetch_terapia","fetchController@getTerapia");

Route::post("fetch_ricovero","fetchController@addRicovero");
Route::get("fetch_test","fetchController@test");
Route::post("fetch_sendProfileImage","fetchController@ProfileImage");




