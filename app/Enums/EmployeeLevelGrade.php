<?php

namespace App\Enums;

enum EmployeeLevelGrade: string
{

    // phpcs:disable
    case V = 'V';
    case IV_3 = 'IV/3';
    case IV_2 = 'IV/2';
    case IV_1 = 'IV/1';
    case III_2 = 'III/2';
    case III_1 = 'III/1';
    case II_5 = 'II/5';
    case II_4 = 'II/4';
    case II_3 = 'II/3';
    case II_2 = 'II/2';
    case II_1 = 'II/1';
    case I_2 = 'I/2';
    case I_1 = 'I/1';
    // phpcs:enable

    // This method is used to display the enum value in the user interface.
    public function label(): string
    {
        return match ($this) {
            self::V,
            self::IV_3,
            self::IV_2,
            self::IV_1,
            self::III_2,
            self::III_1,
            self::II_5,
            self::II_4,
            self::II_3,
            self::II_2,
            self::II_1,
            self::I_2,
            self::I_1 => __('app.levelGrade.' . $this->value),
        
            default => $this->value,
        };
    }

    // This method is return all the values as array.
    public static function toArray(): array
    {
        $EmployeeLevelGrade = [];

        foreach (EmployeeLevelGrade::cases() as $status) {
            $EmployeeLevelGrade [] = $status->value;
        }

        return $EmployeeLevelGrade;
    }

}
