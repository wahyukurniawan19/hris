import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import '../../repositories/attendance_repository.dart';

// Event
abstract class ClockInEvent extends Equatable {
  const ClockInEvent();
  @override
  List<Object?> get props => [];
}

class ClockInStarted extends ClockInEvent {}
class ClockInLocationRequested extends ClockInEvent {}
class ClockInImagePicked extends ClockInEvent {}
class ClockInNoteChanged extends ClockInEvent {
  final String note;
  const ClockInNoteChanged(this.note);
  @override
  List<Object?> get props => [note];
}
class ClockInSubmitted extends ClockInEvent {
  final int userId;
  final String token;
  final String? note;
  const ClockInSubmitted({required this.userId, required this.token, this.note});
  @override
  List<Object?> get props => [userId, token, note];
}

// State
class ClockInState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;
  final Position? position;
  final File? imageFile;
  final String? note;
  const ClockInState({
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
    this.position,
    this.imageFile,
    this.note,
  });
  ClockInState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    Position? position,
    File? imageFile,
    String? note,
  }) {
    return ClockInState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
      position: position ?? this.position,
      imageFile: imageFile ?? this.imageFile,
      note: note ?? this.note,
    );
  }
  @override
  List<Object?> get props => [isLoading, errorMessage, successMessage, position, imageFile, note];
}

// Bloc
class ClockInBloc extends Bloc<ClockInEvent, ClockInState> {
  final AttendanceRepository repository;
  ClockInBloc({required this.repository}) : super(const ClockInState()) {
    on<ClockInStarted>(_onStarted);
    on<ClockInLocationRequested>(_onLocationRequested);
    on<ClockInImagePicked>(_onImagePicked);
    on<ClockInNoteChanged>(_onNoteChanged);
    on<ClockInSubmitted>(_onSubmitted);
  }

  void _onStarted(ClockInStarted event, Emitter<ClockInState> emit) async {
    emit(state.copyWith(isLoading: false, errorMessage: null, successMessage: null));
  }

  void _onLocationRequested(ClockInLocationRequested event, Emitter<ClockInState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final position = await repository.getCurrentLocation();
      emit(state.copyWith(isLoading: false, position: position));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  void _onImagePicked(ClockInImagePicked event, Emitter<ClockInState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final imageFile = await repository.pickImage();
      emit(state.copyWith(isLoading: false, imageFile: imageFile));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  void _onNoteChanged(ClockInNoteChanged event, Emitter<ClockInState> emit) {
    emit(state.copyWith(note: event.note));
  }

  void _onSubmitted(ClockInSubmitted event, Emitter<ClockInState> emit) async {
    if (state.position == null) {
      emit(state.copyWith(errorMessage: 'Harap ambil lokasi terlebih dahulu.'));
      return;
    }
    emit(state.copyWith(isLoading: true, errorMessage: null, successMessage: null));
    try {
      final data = await repository.submitClockIn(
        token: event.token,
        userId: event.userId,
        note: state.note,
        imageFile: state.imageFile,
        latitude: state.position!.latitude,
        longitude: state.position!.longitude,
      );
      emit(state.copyWith(isLoading: false, successMessage: 'Clock In berhasil!'));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString().replaceFirst('Exception: ', '')));
    }
  }
} 