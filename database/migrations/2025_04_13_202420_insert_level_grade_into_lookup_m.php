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
        $levelGrades = [
            'V'     => 'V',
            'IV/3'  => 'IV/3',
            'IV/2'  => 'IV/2',
            'IV/1'  => 'IV/1',
            'III/2' => 'III/2',
            'III/1' => 'III/1',
            'II/5'  => 'II/5',
            'II/4'  => 'II/4',
            'II/3'  => 'II/3',
            'II/2'  => 'II/2',
            'II/1'  => 'II/1',
            'I/2'   => 'I/2',
            'I/1'   => 'I/1',
        ];

        foreach ($levelGrades as $name => $value) {
            DB::table('lookup_m')->insert([
                'lookup_type'   => 'level_grade',
                'lookup_nama'   => $name,
                'lookup_value'  => $value,
                'additional_data' => null
            ]);
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        DB::table('lookup_m')->where('lookup_type', 'level_grade')->delete();
    }
};
