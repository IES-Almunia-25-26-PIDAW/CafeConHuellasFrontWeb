import 'package:cafeconhuellas_front/models/user.dart';

/// Represents the authentication state
/// of the application.
///
/// This state stores:
/// - The authenticated user.
/// - The JWT authentication token.
/// - Loading status.
/// - Error messages.
///
/// The state is managed by the AuthBloc.
class AuthState {
  /// Authenticated user information.
  ///
  /// Null if no user is logged in.
  final UserWithoutPassword? user;
  /// JWT authentication token.
  ///
  /// Null if the user is not authenticated.
  final String? token;
  /// Indicates whether an authentication-related
  /// operation is currently in progress.
  final bool isLoading;
  /// Stores any authentication-related error message.
  ///
  /// Null if no error exists.
  final String? errorMessage;
  AuthState({
    this.user,
    this.token,
    this.isLoading = false,
    this.errorMessage,
  });

  /// Returns true if the user is authenticated.
  ///
  /// Authentication is determined by the presence
  /// of a valid token.
  bool get isAuthenticated => token != null;
  /// Creates a copy of the current state
  /// replacing only the provided values.
  ///
  /// Used to preserve immutability while updating state.
  AuthState copyWith({
    UserWithoutPassword? user,
    String? token,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      user: user ?? this.user,
      token: token ?? this.token,
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
          clearError
              ? null
              : (errorMessage ?? this.errorMessage),
    );
  }
}