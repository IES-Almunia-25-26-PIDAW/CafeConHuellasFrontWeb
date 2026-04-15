import 'package:cafeconhuellas_front/models/user.dart';
import 'package:cafeconhuellas_front/presentation/bloc/auth_event.dart';
import 'package:cafeconhuellas_front/presentation/bloc/auth_state.dart';
import 'package:cafeconhuellas_front/utils/api_conector.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// hacemos un bloc nuevo para la autenticación ya que es una parte bastante importante y está bien que la separemos de otras partes de la app, como mascotas u eventos.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthState()) {
    on<LoginSubmitted>(_onLogin);
    on<LogoutRequested>(_onLogout);
  }
  //emitimos un estado de carga mientras hacemos la petición, luego emitimos el token y el usuario si todo ha ido bien, o un mensaje de error si ha habido algún problema, como credenciales incorrectas o problemas de conexión.
  Future<void> _onLogin(LoginSubmitted event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final response = await ApiConector().login(event.email, event.password);
      final String token = (response['token'] ?? '').toString();


      if (token.isEmpty) {
        throw Exception('Token vacío o ausente');
      }
      //Una vez que ya tenemos el token seteado podemos hacer la petición a users/me
      
      UserWithoutPassword? user;
      try {
          user = await ApiConector().getMe();
        }
       catch (parseError) {
        // Si falla el parseo de usuario, continuamos sin él
        print('No se pudo cargar el perfil');
      }

      emit(state.copyWith(
        isLoading: false,
        token: token,
        user: user,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Error al iniciar sesión. ${e.toString()}',
      ));
    }
  }
//MÉTODO PARA CERRAR SESIÓN, simplemente reseteamos el estado a su valor inicial, lo que borra el token y los datos del usuario.
  void _onLogout(LogoutRequested event, Emitter<AuthState> emit) {
    emit(AuthState()); // Resetea todo el estado
  }
}