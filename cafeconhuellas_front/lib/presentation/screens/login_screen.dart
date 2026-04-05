import 'package:cafeconhuellas_front/theme/AppColors.dart';
import 'package:cafeconhuellas_front/utils/api_conector.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  //aquí controlamos el estado de los campos de texto, es importante liberar los recursos que usan estos controladores cuando el widget se destruye, por eso el dispose() abajo.
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
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
                          Text(
                            "Iniciar Sesión",
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: AppColors.darkPurple,
                              fontFamily: 'WinkyMilky',
                            ),
                          ),
                          const SizedBox(height: 20),
                          _input("Email", emailController),
                          const SizedBox(height: 15),
                          _input("Contraseña", passwordController, isPassword: true),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.purple,
                              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              try {
                                await ApiConector().login(
                                  emailController.text,
                                  passwordController.text,
                                );
                                if (!context.mounted) return;
                                context.go('/home');
                                  } catch (e) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text("Error"),
                                          content: const Text("Email o contraseña incorrectos"),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: const Text("OK"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                            },
                            child: const Text(
                              "Iniciar sesión",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'MilkyVintage',
                                fontSize: 23
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {context.go('/register');},
                            child: const Text("¿No tienes cuenta? Regístrate"),
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
      ),
    );
  }
}
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