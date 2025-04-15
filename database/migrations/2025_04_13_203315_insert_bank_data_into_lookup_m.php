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
        $banks = [
            'BCA' => 'Bank Central Asia',
            'BNI' => 'Bank Negara Indonesia',
            'BRI' => 'Bank Rakyat Indonesia',
            'Mandiri' => 'Bank Mandiri',
            'BTN' => 'Bank Tabungan Negara',
            'CIMB' => 'CIMB Niaga',
            'Danamon' => 'Bank Danamon',
            'Permata' => 'Bank Permata',
            'OCBC' => 'OCBC NISP',
            'Maybank' => 'Maybank Indonesia',
            'Panin' => 'Bank Panin',
            'Mega' => 'Bank Mega',
            'Syariah Indonesia' => 'Bank Syariah Indonesia',
        ];

        foreach ($banks as $nama => $value) {
            DB::table('lookup_m')->insert([
                'lookup_type'    => 'bank',
                'lookup_nama'    => $nama,
                'lookup_value'   => $value,
                'additional_data'=> null,
            ]);
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        DB::table('lookup_m')
            ->where('lookup_type', 'bank')
            ->whereIn('lookup_nama', [
                'BCA', 'BNI', 'BRI', 'Mandiri', 'BTN', 'CIMB',
                'Danamon', 'Permata', 'OCBC', 'Maybank',
                'Panin', 'Mega', 'Syariah Indonesia',
            ])
            ->delete();
    }
};
