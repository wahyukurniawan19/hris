import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import '../../repositories/attendance_repository.dart';

// Event
abstract class ClockOutEvent extends Equatable {
  const ClockOutEvent();
  @override
  List<Object?> get props => [];
}

class ClockOutStarted extends ClockOutEvent {}
class ClockOutLocationRequested extends ClockOutEvent {}
class ClockOutImagePicked extends ClockOutEvent {}
class ClockOutNoteChanged extends ClockOutEvent {
  final String note;
  const ClockOutNoteChanged(this.note);
  @override
  List<Object?> get props => [note];
}
class ClockOutSubmitted extends ClockOutEvent {
  final int userId;
  final String token;
  final String? note;
  const ClockOutSubmitted({required this.userId, required this.token, this.note});
  @override
  List<Object?> get props => [userId, token, note];
}

// State
class ClockOutState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;
  final Position? position;
  final File? imageFile;
  final String? note;
  const ClockOutState({
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
    this.position,
    this.imageFile,
    this.note,
  });
  ClockOutState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    Position? position,
    File? imageFile,
    String? note,
  }) {
    return ClockOutState(
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
class ClockOutBloc extends Bloc<ClockOutEvent, ClockOutState> {
  final AttendanceRepository repository;
  ClockOutBloc({required this.repository}) : super(const ClockOutState()) {
    on<ClockOutStarted>(_onStarted);
    on<ClockOutLocationRequested>(_onLocationRequested);
    on<ClockOutImagePicked>(_onImagePicked);
    on<ClockOutNoteChanged>(_onNoteChanged);
    on<ClockOutSubmitted>(_onSubmitted);
  }

  void _onStarted(ClockOutStarted event, Emitter<ClockOutState> emit) async {
    emit(state.copyWith(isLoading: false, errorMessage: null, successMessage: null));
  }

  void _onLocationRequested(ClockOutLocationRequested event, Emitter<ClockOutState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final position = await repository.getCurrentLocation();
      emit(state.copyWith(isLoading: false, position: position));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  void _onImagePicked(ClockOutImagePicked event, Emitter<ClockOutState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final imageFile = await repository.pickImage();
      emit(state.copyWith(isLoading: false, imageFile: imageFile));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  void _onNoteChanged(ClockOutNoteChanged event, Emitter<ClockOutState> emit) {
    emit(state.copyWith(note: event.note));
  }

  void _onSubmitted(ClockOutSubmitted event, Emitter<ClockOutState> emit) async {
    if (state.position == null) {
      emit(state.copyWith(errorMessage: 'Harap ambil lokasi terlebih dahulu.'));
      return;
    }
    emit(state.copyWith(isLoading: true, errorMessage: null, successMessage: null));
    try {
      final data = await repository.submitClockOut(
        token: event.token,
        userId: event.userId,
        note: state.note,
        imageFile: state.imageFile,
        latitude: state.position!.latitude,
        longitude: state.position!.longitude,
      );
      emit(state.copyWith(isLoading: false, successMessage: 'Clock Out berhasil!'));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString().replaceFirst('Exception: ', '')));
    }
  }
} 