<?php

namespace App\DataTables;

use App\Models\EmployeeDetails;
use App\Models\AttendanceRequest;
use App\Models\Leave;
use App\Models\LeaveSetting;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Support\Facades\Log;
use Yajra\DataTables\Html\Button;
use Yajra\DataTables\Html\Column;
use App\Traits\HasCompany;
use App\Scopes\ActiveScope;

class RequestAttendanceDataTable extends BaseDataTable
{

    private $editLeavePermission;
    private $deleteLeavePermission;
    private $deleteApproveLeavePermission;
    private $viewLeavePermission;
    private $approveRejectPermission;
    private $reportingPermission;
    private $reportingTo;

    public function __construct()
    {
        parent::__construct();
        $this->editLeavePermission = user()->permission('edit_leave');
        $this->deleteLeavePermission = user()->permission('delete_leave');
        $this->deleteApproveLeavePermission = user()->permission('delete_approve_leaves');
        $this->viewLeavePermission = user()->permission('view_leave');
        $this->approveRejectPermission = user()->permission('approve_or_reject_leaves');
        $this->reportingPermission = LeaveSetting::value('manager_permission');
        $this->reportingTo = EmployeeDetails::where('reporting_to', user()->id)->get();
    }

    /**
     * Build DataTable class.
     *
     * @param mixed $query Results from query() method.
     * @return \Yajra\DataTables\DataTableAbstract
     */

     public function dataTable($query)
     {
         return datatables()
             ->eloquent($query)
             ->addIndexColumn()
     
             ->addColumn('check', function ($row) {
                 return '<input type="checkbox" class="select-table-row" data-unique-id="1" id="datatable-row-' . $row->id . '"  name="datatable_ids[]" value="' . $row->id . '" onclick="dataTableRowCheck(' . $row->id . ')">';
             })
             ->addColumn('employee_name', function ($row) {
                 return $row->user->name;
             })
             ->editColumn('employee', function ($row) {
                 return view('components.employee', [
                     'user' => $row->user
                 ]);
             })
             ->addColumn('attendance_date', function ($row) {
                 return Carbon::parse($row->attendance_date)->translatedFormat($this->company->date_format) .' ('.Carbon::parse($row->attendance_date)->translatedFormat('l').')';
             })
             ->addColumn('status', function ($row) {
                 if ($row->status_approval == 'approved') {
                     $class = 'text-light-green';
                     $status = __('app.approved');
                 } elseif ($row->status_approval == 'pending') {
                     $class = 'text-yellow';
                     $status = __('app.pending');
                 } else {
                     $class = 'text-red';
                     $status = __('app.rejected');
                 }
     
                 return '<i class="fa fa-circle mr-1 ' . $class . ' f-10"></i> ' . $status;
             })
             ->addColumn('clock_in_time', function ($row) {
                return $row->clock_in_time ? $row->clock_in_time->format('H:i') : '-';
             })
             ->addColumn('clock_out_time', function ($row) {
                return $row->clock_out_time ? $row->clock_out_time->format('H:i') : '-';
             })
             ->addColumn('action', function ($row) {
                 $actions = '<div class="task_view">
                     <div class="dropdown">
                         <a class="task_view_more d-flex align-items-center justify-content-center dropdown-toggle" type="link" data-toggle="dropdown">
                             <i class="icon-options-vertical icons"></i>
                         </a>
                         <div class="dropdown-menu dropdown-menu-right">';
     
                 $actions .= '<a href="javascript:void(0);" class="dropdown-item attendance-request-detail" data-id="' . $row->id . '"><i class="fa fa-eye mr-2"></i>' . __('app.view') . '</a>';
     
                 if ($row->status_approval == 'pending' && $this->approveRejectPermission == 'all') {
                     $actions .= '<a class="dropdown-item attendance-action-approved" data-req-attendance-id="' . $row->id . '" data-req-attendance-action="approved" href="javascript:;"><i class="fa fa-check mr-2"></i>' . __('app.approve') . '</a>';
                     $actions .= '<a class="dropdown-item attendance-action-reject" data-req-attendance-id="' . $row->id . '" data-req-attendance-action="rejected" href="javascript:;"><i class="fa fa-times mr-2"></i>' . __('app.reject') . '</a>';
                 }
     
                 if ($this->editAttendancePermission == 'all') {
                     $actions .= '<a class="dropdown-item openRightModal" href="' . route('attendances.edit', $row->id) . '"><i class="fa fa-edit mr-2"></i>' . __('app.edit') . '</a>';
                 }
     
                 if ($this->deleteAttendancePermission == 'all') {
                     $actions .= '<a class="dropdown-item delete-table-row" data-attendance-id="' . $row->id . '" href="javascript:;"><i class="fa fa-trash mr-2"></i>' . __('app.delete') . '</a>';
                 }
     
                 $actions .= '</div></div></div>';
                 return $actions;
             })
             ->smart(false)
             ->setRowId(fn($row) => 'row-' . $row->id)
             ->rawColumns(['check', 'employee', 'attendance_date', 'clock_in_time', 'clock_out_time', 'status', 'action']);
     }
     

    /**
     * @param Leave $model
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function query(AttendanceRequest $model)
    {
        $setting = company();
    
        $model = AttendanceRequest::withoutGlobalScopes();

        $attendanceList = $model->with([
            'user' => function ($q) {
                $q->withoutGlobalScopes();
            },
            'user.employeeDetail' => function ($q) {
                $q->withoutGlobalScopes();
            },
            'user.employeeDetail.designation' => function ($q) {
                $q->withoutGlobalScopes();
            },
            'user.session' => function ($q) {
                $q->withoutGlobalScopes();
            }
        ])
        ->join('users', 'attendance_requests.user_id', 'users.id')
        ->join('employee_details', 'employee_details.user_id', 'users.id')
        ->leftJoin('designations', 'designations.id', '=', 'employee_details.designation_id')
        ->select(
            'attendance_requests.*',
            'attendance_requests.created_at as attendance_date',
            'users.name as user_name',
            'employee_details.department_id',
            'designations.name as designation_name'
        );
    
        if (!is_null(request()->startDate)) {
            $startDate = Carbon::createFromFormat($this->company->date_format, request()->startDate)->toDateString();
            $attendanceList->whereDate('attendance_requests.created_at', '>=', $startDate);
        }
    
        if (!is_null(request()->endDate)) {
            $endDate = Carbon::createFromFormat($this->company->date_format, request()->endDate)->toDateString();
            $attendanceList->whereDate('attendance_requests.created_at', '<=', $endDate);
        }
    
        if (request()->employeeId != 'all' && request()->employeeId != '') {
            $attendanceList->where('users.id', request()->employeeId);
        }
    
        if (request()->leave_year != '') {
            $attendanceList->whereYear('attendance_requests.created_at', request()->leave_year);
        }
    
        if (request()->status != 'all' && request()->status != '') {
            $attendanceList->where('attendance_requests.status_approval', request()->status);
        }
    
        if (request()->searchText != '') {
            $attendanceList->where('users.name', 'like', '%' . request()->searchText . '%');
        }
    
        return $attendanceList;
    }

    /**
     * Optional method if you want to use html builder.
     *
     * @return \Yajra\DataTables\Html\Builder
     */
    public function html()
    {
        $dataTable = $this->setBuilder('req-attendance-table', 2)
            ->parameters([
                'initComplete' => 'function () {
                   window.LaravelDataTables["req-attendance-table"].buttons().container()
                    .appendTo("#table-actions")
                }',
                'fnDrawCallback' => 'function( oSettings ) {
                    $("body").tooltip({
                        selector: \'[data-toggle="tooltip"]\'
                    });
                    $(".statusChange").selectpicker();
                }',
            ]);

        return $dataTable;
    }

    /**
     * Get columns.
     *
     * @return array
     */
    protected function getColumns()
    {
        return [
            'check' => [
                'title' => '<input type="checkbox" name="select_all_table" id="select-all-table" onclick="selectAllTable(this)">',
                'exportable' => false,
                'orderable' => false,
                'searchable' => false,
                'visible' => true // Mengubah sesuai dengan kebutuhan untuk visible, jika ingin selalu visible
            ],
            '#' => ['data' => 'DT_RowIndex', 'orderable' => false, 'searchable' => false, 'visible' => false, 'title' => '#'],
            __('app.id') => ['data' => 'id', 'name' => 'attendance_requests.id', 'title' => __('app.id'), 'visible' => false],
            __('app.employee') => ['data' => 'employee', 'name' => 'user.name', 'exportable' => false, 'title' => __('app.employee')],
            'Attendance Date' => ['data' => 'attendance_date', 'name' => 'attendance_requests.attendance_date', 'title' => 'Attendance Date'],
            'Clock In' => ['data' => 'clock_in_time', 'name' => 'attendance_requests.clock_in_time', 'title' => 'Clock In'],
            'Clock Out' => ['data' => 'clock_out_time', 'name' => 'attendance_requests.clock_out_time', 'title' => 'Clock Out'],
            'Status' => ['data' => 'status_approval', 'name' => 'attendance_requests.status_approval', 'title' => 'Status'],
            Column::computed('action', __('app.action'))
                ->exportable(false)
                ->printable(false)
                ->orderable(false)
                ->searchable(false)
                ->addClass('text-right pr-20')
        ];
    }

}
