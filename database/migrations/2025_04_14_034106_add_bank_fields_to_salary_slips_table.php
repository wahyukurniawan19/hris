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
        Schema::table('salary_slips', function (Blueprint $table) {
            if (!Schema::hasColumn('salary_slips', 'bank')) {
                $table->string('bank')->nullable()->after('additional_earning_json');
            }

            if (!Schema::hasColumn('salary_slips', 'no_rekening')) {
                $table->string('no_rekening')->nullable()->after('bank');
            }
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('salary_slips', function (Blueprint $table) {
            if (Schema::hasColumn('salary_slips', 'bank')) {
                $table->dropColumn('bank');
            }

            if (Schema::hasColumn('salary_slips', 'no_rekening')) {
                $table->dropColumn('no_rekening');
            }
        });
    }
};
