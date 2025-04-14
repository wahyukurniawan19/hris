<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use App\Traits\CustomFieldsTrait;
// use App\Traits\HasCompany;

class Lookup extends BaseModel
{

    use CustomFieldsTrait;
    // Nama tabel
    protected $table = 'lookup_m';

    // Nama primary key
    protected $primaryKey = 'lookup_id';

    // Tidak menggunakan timestamps default (created_at, updated_at)
    public $timestamps = false;

    // Fillable fields untuk mass assignment
    protected $fillable = [
        'lookup_type',
        'lookup_nama',
        'lookup_value',
        'additional_data',
        'created_date',
    ];

    // Jika kamu ingin automatically cast 'created_date' sebagai datetime
    protected $casts = [
        'created_date' => 'datetime',
    ];
}
