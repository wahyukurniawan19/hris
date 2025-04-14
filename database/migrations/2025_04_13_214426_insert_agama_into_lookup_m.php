<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        $data = [
            ['Islam', 'Islam'],
            ['Kristen Protestan', 'Kristen Protestan'],
            ['Katolik', 'Katolik'],
            ['Hindu', 'Hindu'],
            ['Buddha', 'Buddha'],
            ['Konghucu', 'Konghucu'],
        ];

        foreach ($data as [$nama, $value]) {
            DB::table('lookup_m')->insert([
                'lookup_type'   => 'agama',
                'lookup_nama'   => $nama,
                'lookup_value'  => $value,
            ]);
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        DB::table('lookup_m')->where('lookup_type', 'agama')->delete();
    }
};
