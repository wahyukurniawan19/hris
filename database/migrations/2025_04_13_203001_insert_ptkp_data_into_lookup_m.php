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
        $ptkpValues = [
            'TK/0' => 'TK/0',
            'TK/1' => 'TK/1',
            'TK/2' => 'TK/2',
            'TK/3' => 'TK/3',
            'K/0'  => 'K/0',
            'K/1'  => 'K/1',
            'K/2'  => 'K/2',
            'K/3'  => 'K/3',
        ];

        foreach ($ptkpValues as $name => $value) {
            DB::table('lookup_m')->insert([
                'lookup_type'    => 'ptkp',
                'lookup_nama'    => $name,
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
            ->where('lookup_type', 'ptkp')
            ->whereIn('lookup_nama', [
                'TK/0', 'TK/1', 'TK/2', 'TK/3',
                'K/0', 'K/1', 'K/2', 'K/3'
            ])
            ->delete();
    }
};
