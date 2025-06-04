<?php


/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

ApiRoute::get('purchased-module', [\App\Http\Controllers\HomeController::class, 'installedModule']);


use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use App\Http\Controllers\AttendanceController;


Route::post('/login', function(Request $request) {
    $request->validate([
        'email' => 'required|email',
        'password' => 'required'
    ]);

    $user = User::where('email', $request->email)->first();

    if (!$user || !Hash::check($request->password, $user->password)) {
        return response()->json(['message' => 'Email atau password salah'], 401);
    }

    // Generate Sanctum token
    $token = $user->createToken('mobile')->plainTextToken;

    return response()->json([
        'message' => 'Login berhasil',
        'user' => $user,
        'token' => $token
    ]);
});

Route::post('/logout', function(Request $request) {
    Auth::logout();
    $request->session()->invalidate();
    $request->session()->regenerateToken();
    return response()->json(['message' => 'Logout berhasil']);
});

Route::middleware('auth:sanctum')->post('clock-in', [AttendanceController::class, 'clockIn']);
Route::middleware('auth:sanctum')->post('clock-out', [AttendanceController::class, 'clockOut']);
Route::middleware('auth:sanctum')->get('attendance/clock-times-batch/{user_id}/{start_date}/{end_date}', [AttendanceController::class, 'getClockTimesBatch']);
Route::middleware('auth:sanctum')->get('attendance/summary-json/{user_id}/{start_date}/{end_date}', [AttendanceController::class, 'getAttendanceSummaryJson']);
