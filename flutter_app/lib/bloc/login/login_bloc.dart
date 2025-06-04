import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../repositories/auth_repository.dart';

// Event
abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;
  const LoginSubmitted({required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}

// State
abstract class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}
class LoginLoading extends LoginState {}
class LoginSuccess extends LoginState {
  final Map<String, dynamic> userData;
  final String token;
  const LoginSuccess({required this.userData, required this.token});
  @override
  List<Object?> get props => [userData, token];
}
class LoginFailure extends LoginState {
  final String error;
  const LoginFailure(this.error);
  @override
  List<Object?> get props => [error];
}

// Bloc
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;
  LoginBloc({required this.authRepository}) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final data = await authRepository.login(email: event.email, password: event.password);
      emit(LoginSuccess(userData: data['user'], token: data['token']));
    } catch (e) {
      emit(LoginFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }
} 