/// Base class for all authentication-related events.
///
/// Authentication events are used by the AuthBloc
/// to trigger state changes such as login,
/// logout, or profile updates.
abstract class AuthEvent {}

/// Event triggered when the user submits
/// login credentials.
///
/// Contains:
/// - User email.
/// - User password.
class LoginSubmitted extends AuthEvent {
  /// User email address.
  final String email;
  /// User password.
  final String password;
  LoginSubmitted(this.email, this.password);
}

/// Event triggered when the user requests
/// to log out from the application.
class LogoutRequested extends AuthEvent {}
/// Event triggered when the user updates
/// their profile avatar.
///
/// Contains the new image URL.
class UpdateAvatarRequested extends AuthEvent {

  /// URL of the new profile image.
  final String imageUrl;

  UpdateAvatarRequested(this.imageUrl);
}