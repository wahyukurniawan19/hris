<?php

namespace App\Enums;

enum EmployeePTKP: string
{

    // phpcs:disable
    case TK_0 = 'TK/0';
    case TK_1 = 'TK/1';
    case TK_2 = 'TK/2';
    case TK_3 = 'TK/3';
    case K_0  = 'K/0';
    case K_1  = 'K/1';
    case K_2  = 'K/2';
    case K_3  = 'K/3';
    // phpcs:enable

    // This method is used to display the enum value in the user interface.
    public function label(): string
    {
        return match ($this) {
            self::TK_0,
            self::TK_1,
            self::TK_2,
            self::TK_3,
            self::K_0,
            self::K_1,
            self::K_2,
            self::K_3 => __('app.employeePKTP.' . $this->value),
        
            default => $this->value,
        };
        
    }

    // This method is return all the values as array.
    public static function toArray(): array
    {
        $EmployeePTKP = [];

        foreach (EmployeePTKP::cases() as $status) {
            $EmployeePTKP [] = $status->value;
        }

        return $EmployeePTKP;
    }

}
