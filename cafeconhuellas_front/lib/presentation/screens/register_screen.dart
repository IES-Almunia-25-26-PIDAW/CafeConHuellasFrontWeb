import 'package:cafeconhuellas_front/theme/AppColors.dart';
import 'package:cafeconhuellas_front/utils/api_conector.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final firstNameController = TextEditingController();
  final lastName1Controller = TextEditingController();
  final lastName2Controller = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastName1Controller.dispose();
    lastName2Controller.dispose();
    emailController.dispose();
    phoneController.dispose();
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
                            "Registro",
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: AppColors.darkPurple,
                              fontFamily: 'WinkyMilky',
                            ),
                          ),
                          const SizedBox(height: 20),
                          _input("Nombre", firstNameController),
                          const SizedBox(height: 15),
                          _input("Apellido", lastName1Controller),
                          const SizedBox(height: 15),
                          _input("Apellido2", lastName2Controller),
                          const SizedBox(height: 15),
                          _input("Email", emailController),
                          const SizedBox(height: 15),
                          _input("Teléfono", phoneController),
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
                                await ApiConector().register({
                                  "firstName": firstNameController.text,
                                  "lastName1": lastName1Controller.text,
                                  "lastName2": lastName2Controller.text,
                                  "email": emailController.text,
                                  "password": passwordController.text,
                                  "phone": phoneController.text,
                                  "role": "USER",
                                  "imageUrl": ""
                                });
                                //cuando hacemos un await el context puede haberse destruido mientras esperabas, esto ayuda a que nos aseguremos de que
                                //el widget sigue activo antes de usar el contexto abajo, sin esta producción podría dar un error
                                if (!context.mounted) return;
                                //dialogo de éxito, ahora tocara loguearse, recuerda q el contexto es el widget actual.
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Éxito"),
                                      content: const Text("Usuario creado correctamente. Ahora inicia sesión."),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            context.go('/login');
                                          },
                                          child: const Text("OK"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } catch (e) {
                                if (!context.mounted) return;
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Error"),
                                      content: Text("Error al registrar: $e"),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text("Cerrar"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            child: const Text(
                              "Registrarse",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'MilkyVintage',
                                fontSize: 23,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () { context.go('/login'); },
                            child: const Text("¿Ya tienes cuenta? Inicia sesión"),
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