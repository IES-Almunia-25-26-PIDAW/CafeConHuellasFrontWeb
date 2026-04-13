import 'package:cafeconhuellas_front/models/user.dart';

class AuthState {
  //es importante que guardemos el token y el usuario para luego durante toda la sesión tener el usuario establecido
  //además para la página de perfil del usuario
  final User? user;
  final String? token;
  final bool isLoading;
  final String? errorMessage;

  AuthState({
    this.user,
    this.token,
    this.isLoading = false,
    this.errorMessage,
  });

  bool get isAuthenticated => token != null;

  AuthState copyWith({
    User? user,
    String? token,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      user: user ?? this.user,
      token: token ?? this.token,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}