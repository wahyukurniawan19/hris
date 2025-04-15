<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('employee_details', function (Blueprint $table) {
            if (!Schema::hasColumn('employee_details', 'npwp')) {
                $table->string('npwp')->nullable()->after('employee_id');
            }
            if (!Schema::hasColumn('employee_details', 'nik')) {
                $table->string('nik')->nullable()->after('npwp');
            }
            if (!Schema::hasColumn('employee_details', 'religion')) {
                $table->string('religion')->nullable()->after('nik');
            }
            if (!Schema::hasColumn('employee_details', 'place_birth')) {
                $table->string('place_birth')->nullable()->after('religion');
            }
            if (!Schema::hasColumn('employee_details', 'bpjs_ks')) {
                $table->string('bpjs_ks')->nullable()->after('place_birth');
            }
            if (!Schema::hasColumn('employee_details', 'bpjs_kt')) {
                $table->string('bpjs_kt')->nullable()->after('bpjs_ks');
            }
            if (!Schema::hasColumn('employee_details', 'level_grade')) {
                $table->string('level_grade')->nullable()->after('bpjs_kt');
            }
            if (!Schema::hasColumn('employee_details', 'ptkp')) {
                $table->string('ptkp')->nullable()->after('level_grade');
            }
            if (!Schema::hasColumn('employee_details', 'bank')) {
                $table->string('bank')->nullable()->after('ptkp');
            }
            if (!Schema::hasColumn('employee_details', 'no_rekening')) {
                $table->string('no_rekening')->nullable()->after('bank');
            }
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('employee_details', function (Blueprint $table) {
            $table->dropColumn([
                'npwp',
                'nik',
                'religion',
                'place_birth',
                'bpjs_ks',
                'bpjs_kt',
                'level_grade',
                'ptkp',
                'bank',
                'no_rekening',
            ]);
        });
    }
};
