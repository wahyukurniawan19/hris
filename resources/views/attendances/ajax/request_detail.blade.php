<div class="modal-header">
    <h5 class="modal-title" id="modelHeading">Request Detail</h5>
    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
</div>
<div class="modal-body">
    <table class="table table-bordered">
        <thead class="bg-dark text-white">
            <tr>
                <th>Approval</th>
                <th>Employee ID</th>
                <th>PIC</th>
                <th>Status</th>
                <th>Comment</th>
                <th>Decision By</th>
                <th>Updated Date</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>1</td>
                <td>{{ $attendanceRequest->employee_id ?? '' }}</td>
                <td>{{ $attendanceRequest->pic_name ?? '' }}</td>
                <td>{{ ucfirst($attendanceRequest->status_approval) }}</td>
                <td>
                    @if($attendanceRequest->status_approval == 'approved')
                        {{ $attendanceRequest->approve_reason ?? '' }}
                    @elseif($attendanceRequest->status_approval == 'rejected')
                        {{ $attendanceRequest->reject_reason ?? '' }}
                    @else
                        -
                    @endif
                </td>
                <td>
                    @if($attendanceRequest->status_approval == 'approved' || $attendanceRequest->status_approval == 'rejected')
                        {{ $attendanceRequest->decision_by_name ?? '' }}
                    @else
                        -
                    @endif
                </td>
                <td>{{ $attendanceRequest->updated_at ? $attendanceRequest->updated_at->format('Y-m-d H:i:s') : '' }}</td>
            </tr>
        </tbody>
    </table>
</div>
<div class="modal-footer">
    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
</div> 