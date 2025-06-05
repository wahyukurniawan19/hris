import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'location_map_page.dart';
import 'success_attendance_page.dart';
import '../bloc/clock_in/clock_in_bloc.dart';
import '../repositories/attendance_repository.dart';
import '../widgets/custom_button.dart';
import '../themes/theme.dart';

class AttendanceClockInPage extends StatelessWidget {
  final Map<String, dynamic> userData;
  final String token;
  final VoidCallback? onSuccess;
  const AttendanceClockInPage({super.key, required this.userData, required this.token, this.onSuccess});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ClockInBloc(repository: AttendanceRepository())..add(ClockInLocationRequested()),
      child: _ClockInForm(userData: userData, token: token, onSuccess: onSuccess),
    );
  }
}

class _ClockInForm extends StatefulWidget {
  final Map<String, dynamic> userData;
  final String token;
  final VoidCallback? onSuccess;
  const _ClockInForm({required this.userData, required this.token, this.onSuccess});

  @override
  State<_ClockInForm> createState() => _ClockInFormState();
}

class _ClockInFormState extends State<_ClockInForm> {
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _onNoteChanged(String value) {
    context.read<ClockInBloc>().add(ClockInNoteChanged(value));
  }

  void _onPickImage() {
    context.read<ClockInBloc>().add(ClockInImagePicked());
  }

  void _onRefreshLocation() {
    context.read<ClockInBloc>().add(ClockInLocationRequested());
  }

  void _onSubmit() {
    context.read<ClockInBloc>().add(
      ClockInSubmitted(
        userId: widget.userData['id'],
        token: widget.token,
        note: _noteController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ClockInBloc, ClockInState>(
      listener: (context, state) {
        if (state.successMessage != null) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => SuccessAttendancePage(
                isClockIn: true,
                userData: widget.userData,
                token: widget.token,
                scheduleDate: '', // Data bisa diambil dari response jika perlu
                scheduleTime: '',
                clockTime: '',
              ),
            ),
            (route) => false,
          );
          if (widget.onSuccess != null) {
            widget.onSuccess!();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Clock In'), backgroundColor: primaryBlue),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: BlocBuilder<ClockInBloc, ClockInState>(
                    builder: (context, state) {
                      _noteController.text = state.note ?? '';
                      _noteController.selection = TextSelection.fromPosition(
                        TextPosition(offset: _noteController.text.length),
                      );
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (state.errorMessage != null)
                            Text(state.errorMessage!, style: const TextStyle(color: Colors.red)),
                          if (state.successMessage != null)
                            Text(state.successMessage!, style: const TextStyle(color: Colors.green)),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _noteController,
                            onChanged: _onNoteChanged,
                            decoration: const InputDecoration(
                              labelText: 'Catatan (opsional)',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 2,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              CustomButton(
                                label: 'Ambil Foto (opsional)',
                                color: primaryBlue,
                                onPressed: state.isLoading ? null : _onPickImage,
                              ),
                              const SizedBox(width: 12),
                              if (state.imageFile != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(state.imageFile!, width: 48, height: 48, fit: BoxFit.cover),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Color(0xFF1A237E)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: state.position != null
                                    ? Row(
                                        children: [
                                          Expanded(child: Text('Lokasi: ${state.position!.latitude}, ${state.position!.longitude}')),
                                          IconButton(
                                            icon: const Icon(Icons.map, color: Color(0xFF1A237E)),
                                            tooltip: 'Lihat di Map',
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) => LocationMapPage(latitude: state.position!.latitude, longitude: state.position!.longitude),
                                                ),
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.open_in_new, color: Color(0xFF1A237E)),
                                            tooltip: 'Buka di Google Maps',
                                            onPressed: () async {
                                              final url = 'https://www.google.com/maps/search/?api=1&query=${state.position!.latitude},${state.position!.longitude}';
                                              await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                                            },
                                          ),
                                        ],
                                      )
                                    : const Text('Mengambil lokasi...'),
                              ),
                              IconButton(
                                icon: const Icon(Icons.refresh),
                                onPressed: state.isLoading ? null : _onRefreshLocation,
                                tooltip: 'Refresh lokasi',
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: CustomButton(
                              label: state.isLoading ? '' : 'Kirim Clock In',
                              color: primaryBlue,
                              onPressed: state.isLoading ? null : _onSubmit,
                              child: state.isLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : null,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 