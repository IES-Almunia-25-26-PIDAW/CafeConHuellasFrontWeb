import 'package:cafeconhuellas_front/models/user.dart';
import 'package:cafeconhuellas_front/presentation/bloc/auth_event.dart';
import 'package:cafeconhuellas_front/presentation/bloc/auth_state.dart';
import 'package:cafeconhuellas_front/utils/api_conector.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Bloc responsible for handling all authentication-related logic
/// within the application.
///
/// This bloc manages:
/// - User login.
/// - User logout.
/// - User avatar updates.
///
/// Authentication is separated into its own bloc to keep the
/// application architecture cleaner and more modular, since
/// authentication is a core feature of the app.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  /// API connector used to perform HTTP requests to the backend.
  final ApiConector api;
  /// Bloc constructor.
  ///
  /// Initializes the default state and registers the events
  /// that this bloc will handle.
  AuthBloc(this.api) : super(AuthState()) {
    /// Event responsible for handling user login.
    on<LoginSubmitted>(_onLogin);
    /// Event responsible for handling user logout.
    on<LogoutRequested>(_onLogout);
    /// Event responsible for updating the user's avatar.
    on<UpdateAvatarRequested>((event, emit) async {
      // If there is no authenticated user, do nothing.
      if (state.user == null) return;
      /// Creates a copy of the current user updating only
      /// the image URL.
      final updatedUser = state.user!.copyWith(
        imageUrl: event.imageUrl,
      );
      /// Sends a PUT request to the backend in order
      /// to update the user's avatar.
      ///
      /// A temporary User object is created because
      /// the API requires the complete model.
      await api.updateAvatar(
        User(
          id: updatedUser.id,
          firstName: updatedUser.firstName,
          lastName1: updatedUser.lastName1,
          lastName2: updatedUser.lastName2,
          password: '', // Password is not used by the backend in this PUT request.
          email: updatedUser.email,
          phone: updatedUser.phone,
          role: updatedUser.role,
          imageUrl: event.imageUrl,
        ),
        state.user!.id,
      );

      /// Updates the bloc state with the new avatar.
      emit(state.copyWith(user: updatedUser));
    });
  }
  /// Handles the user login process.
  ///
  /// Workflow:
  /// 1. Emits a loading state.
  /// 2. Sends the login request.
  /// 3. Retrieves the JWT token.
  /// 4. Requests authenticated user information.
  /// 5. Updates the state with the token and user data.
  ///
  /// If an error occurs:
  /// - The state is updated with an error message.
  Future<void> _onLogin(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    /// Enables loading state and clears previous errors.
    emit(state.copyWith(
      isLoading: true,
      clearError: true,
    ));
    try {
      /// Sends login request to the backend.
      final response = await api.login(
        event.email,
        event.password,
      );
      /// Extracts the JWT token from the response.
      final String token = (response['token'] ?? '').toString();
      /// Validates that the token exists.
      if (token.isEmpty) {
        throw Exception('Empty or missing token');
      }
      /// Once authenticated, retrieves current user data.
      UserWithoutPassword? user;
      try {
        user = await api.getMe();
      } catch (parseError) {
        /// If retrieving or parsing the user fails,
        /// execution continues with a valid token.
      }
      /// Updates the bloc state with authentication data.
      emit(state.copyWith(
        isLoading: false,
        token: token,
        user: user,
      ));
    } catch (e) {
      /// If an error occurs during login,
      /// updates the state with an error message.
      emit(state.copyWith(
        isLoading: false,
        errorMessage:
            'Login error. ${e.toString()}',
      ));
    }
  }
  /// Handles the logout process.
  ///
  /// Resets the state to its initial values,
  /// removing:
  /// - JWT token.
  /// - User information.
  /// - Loading and error states.
  void _onLogout(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) {
    /// Completely resets the bloc state.
    emit(AuthState());
  }
}