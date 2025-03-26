<link rel="stylesheet" href="{{ asset('vendor/css/dropzone.min.css') }}">
<div class="modal-header">
    <h5 class="modal-title" id="modelHeading">@lang('modules.attendance.clock_in')</h5>
    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
            aria-hidden="true">×</span></button>
</div>

@if ($cannotLogin == false)
<x-form id="clockInForm">
    <div class="modal-body">
            <div class="row justify-content-between">
                <div class="col" id="task_div">
                    <h4 class="mb-4 d-flex justify-content-between"><span><i class="fa fa-clock"></i> {{ now()->timezone(company()->timezone)->translatedFormat(company()->date_format . ' ' . company()->time_format) }}</span>
                        <span class="badge badge-info f-14"
                              style="background-color: {{ $shiftAssigned->color }}">{{ $shiftAssigned->shift_name }}</span>
                    </h4>
                    <div class="row">
                        <div class="col-md-6">
                            <x-forms.text fieldId="location" :fieldLabel="__('Location')"
                                fieldName="location" :fieldPlaceholder="__('Location')" :fieldValue="$lead->location ?? ''"
                                :fieldReadOnly="true">
                            </x-forms.text>
                        </div>
                        <div class="col-md-6">
                            <x-forms.select fieldId="work_from_type" :fieldLabel="__('modules.attendance.working_from')"
                                            fieldName="work_from_type" fieldRequired="true"
                                            search="true">
                                <option value="office">@lang('modules.attendance.office')</option>
                                <option value="home">@lang('modules.attendance.home')</option>
                                <option value="other">@lang('modules.attendance.other')</option>
                            </x-forms.select>
                        </div>
                        <div class="col-md-12" id="other_place" style="display:none">
                            <x-forms.text fieldId="working_from" :fieldLabel="__('modules.attendance.otherPlace')"
                                          fieldName="working_from" fieldRequired="true">
                            </x-forms.text>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <x-forms.text fieldId="notes" :fieldLabel="__('Notes')"
                                fieldName="notes" :fieldPlaceholder="__('Notes')" :fieldValue="$lead->notes ?? ''">
                            </x-forms.text>
                        </div>
                        <div class="col-md-6">
                        <x-forms.file allowedFileExtensions="png jpg jpeg svg bmp" class="mr-0 mr-lg-2 mr-md-2 cropper"
                            :fieldLabel="__('Attachments')" fieldName="photo" fieldId="photo"
                            fieldHeight="119" :popover="__('File')" style="display: none;" />
                            <img id="photo-preview" src="" alt="Preview Foto" style="display: none; width: 100%; max-height: 300px; margin-top: 47px;">
                            <video id="camera-preview" width="100%" autoplay style="display: none; margin-top: 47px;"></video>
                            <canvas id="camera-canvas" style="display: none;"></canvas>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <x-forms.button-primary id="open-camera">@lang('Open Camera')</x-forms.button-primary>
                            <x-forms.button-primary id="take-photo">@lang('Take Photo')</x-forms.button-primary>
                        </div>
                    </div>
                </div>
            </div>
    </div>
    <div class="modal-footer">
        <x-forms.button-cancel data-dismiss="modal" class="border-0 mr-3">@lang('app.cancel')</x-forms.button-cancel>
        <x-forms.button-primary id="save-clock-in">@lang('modules.attendance.clock_in')</x-forms.button-primary>
    </div>
</x-form>
@else
    <div class="modal-body">
        <x-alert type="danger">@lang('messages.clockInNotAllowed')</x-alert>
    </div>
@endif

@if ($attendanceSettings->radius_check == 'yes' || $attendanceSettings->save_current_location)
    <script>
       setCurrentLocation();
    </script>
@endif

<script>
    $('.select-picker').selectpicker();

    $(function () {
        $('#work_from_type').change(function () {

            ($(this).val() == 'other') ? $('#other_place').show() : $('#other_place').hide();

        });
    });

    $('body').on('click', '#save-clock-in', function () {
        const workingFrom = $('#working_from').val();
        const location = $('#location').val();
        const work_from_type = $('#work_from_type').val();

        const currentLatitude = document.getElementById("current-latitude").value;
        const currentLongitude = document.getElementById("current-longitude").value;
        const notes = $('#notes').val();

        const token = "{{ csrf_token() }}";

        $.easyAjax({
            url: "{{ route('attendances.store_clock_in') }}",
            type: "POST",
            buttonSelector: "#save-clock-in",
            disableButton: true,
            blockUI: true,
            container: '#clockInForm',
            data: {
                working_from: workingFrom,
                location: location,
                work_from_type: work_from_type,
                currentLatitude: currentLatitude,
                currentLongitude: currentLongitude,
                notes: notes,
                _token: token
            },
            success: function (response) {
                if (response.status === 'success') {
                    window.location.reload();
                }
            }
        })
    })
    function setCurrentLocation() {
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function (position) {
                var lat = document.getElementById("current-latitude").value;
                var lon = document.getElementById("current-longitude").value;

                fetch(`https://nominatim.openstreetmap.org/reverse?format=json&lat=${lat}&lon=${lon}`)
                    .then(response => response.json())
                    .then(data => {
                        document.getElementById('location').value = data.display_name;
                    })
                    .catch(error => console.log('Error mendapatkan lokasi:', error));
            }, function (error) {
                console.log('Gagal mendapatkan lokasi:', error);
            });
        }
    }

    $(document).on('shown.bs.modal', '#clockInModal', function () {
        setCurrentLocation();
    });
    document.getElementById('open-camera').addEventListener('click', function() {
        let video = document.getElementById('camera-preview');
        let takePhotoBtn = document.getElementById('take-photo');
        let photoPreview = document.getElementById('photo-preview');

        photoPreview.src = '';
        photoPreview.style.display = 'none';

        navigator.mediaDevices.getUserMedia({ video: { facingMode: "environment" } })
            .then(function(stream) {
                video.srcObject = stream;
                video.style.display = 'block';
                takePhotoBtn.style.display = 'block';
            })
            .catch(function(error) {
                alert("Kamera tidak dapat diakses: " + error);
            });
    });

    document.getElementById('take-photo').addEventListener('click', function() {
        let video = document.getElementById('camera-preview');
        let canvas = document.getElementById('camera-canvas');
        let context = canvas.getContext('2d');
        let photoPreview = document.getElementById('photo-preview');

        canvas.width = video.videoWidth;
        canvas.height = video.videoHeight;
        context.drawImage(video, 0, 0, canvas.width, canvas.height);

        canvas.toBlob(function(blob) {
            let fileInput = document.getElementById('photo');
            let file = new File([blob], "photo.jpg", { type: "image/jpeg" });

            let dataTransfer = new DataTransfer();
            dataTransfer.items.add(file);
            fileInput.files = dataTransfer.files;

            let imageUrl = URL.createObjectURL(blob);
            photoPreview.src = imageUrl;
            photoPreview.style.display = 'block';
        });

        let stream = video.srcObject;
        let tracks = stream.getTracks();
        tracks.forEach(track => track.stop());

        video.style.display = 'none';
    });
</script>
