import 'package:cafeconhuellas_front/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

/// Screen that allows users to log into the application.
///
/// This screen contains:
/// - Email input field.
/// - Password input field.
/// - Login button.
/// - Link to the registration screen.
///
/// Uses [BlocConsumer] to react to [AuthBloc] state changes.
class LoginPage extends StatefulWidget {
  /// Creates the login screen widget.
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

/// State class responsible for managing:
/// - Form controllers.
/// - Form submission.
/// - Widget lifecycle.
class _LoginPageState extends State<LoginPage> {

  /// Controller used for the email input field.
  final emailController = TextEditingController();

  /// Controller used for the password input field.
  final passwordController = TextEditingController();

  /// Releases all text controllers when
  /// the widget is removed from memory.
  ///
  /// Prevents memory leaks.
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /// Builds the login screen UI.
  ///
  /// Layout structure:
  /// - Centered card with login form.
  /// - Email and password input fields.
  /// - Login button with loading indicator.
  /// - Link to the registration screen.
  ///
  /// Listens to [AuthBloc]:
  /// - Redirects to home on successful authentication.
  /// - Shows an error dialog on failed login.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          /// Redirect to home on successful login.
          if (state.isAuthenticated) {
            context.go('/');
          } else if (state.errorMessage != null) {
            /// Show error dialog on failed login.
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: const Text('Ha habido algun error con el incio de sesión o la contraseña o usuario no es correcto, prueba de nuevo o regístrate.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        },
        builder: (context, state) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              /// Screen title.
                              Text(
                                'Iniciar Sesión',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: AppColors.darkPurple,
                                  fontFamily: 'WinkyMilky',
                                ),
                              ),
                              const SizedBox(height: 20),
                              /// Email input field.
                              _input('Email', emailController),
                              const SizedBox(height: 15),
                              /// Password input field.
                              _input('Contraseña', passwordController, isPassword: true),
                              const SizedBox(height: 20),
                              /// Login button.
                              ///
                              /// Disabled while [AuthBloc] is loading.
                              /// Shows a loading indicator during submission.
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.purple,
                                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: state.isLoading
                                    ? null
                                    : () {
                                        context.read<AuthBloc>().add(
                                          LoginSubmitted(
                                            emailController.text.trim(),
                                            passwordController.text,
                                          ),
                                        );
                                      },
                                child: state.isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                      )
                                    : const Text(
                                        'Iniciar sesión',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'MilkyVintage',
                                          fontSize: 23,
                                        ),
                                      ),
                              ),
                              /// Link to the registration screen.
                              TextButton(
                                onPressed: () {
                                  context.go('/register');
                                },
                                child: const Text('¿No tienes cuenta? Regístrate'),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// Creates a reusable styled text input field.
///
/// Parameters:
/// - [label]: Label text shown inside the field.
/// - [controller]: Controller linked to the input field.
/// - [isPassword]: Whether to obscure the input text. Defaults to false.
Widget _input(String label, TextEditingController controller, {bool isPassword = false}) {
  return TextField(
    controller: controller,
    obscureText: isPassword,
    decoration: InputDecoration(
      labelText: label,
      filled: true,
      fillColor: AppColors.vanilla,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}