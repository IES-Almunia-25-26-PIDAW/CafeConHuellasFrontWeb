abstract class AuthEvent {}

//evento de hacer login con los datos
class LoginSubmitted extends AuthEvent {
  final String email;
  final String password;

  LoginSubmitted(this.email, this.password);
}

class LogoutRequested extends AuthEvent {}
class UpdateAvatarRequested extends AuthEvent {
  final String imageUrl;
  UpdateAvatarRequested(this.imageUrl);

}