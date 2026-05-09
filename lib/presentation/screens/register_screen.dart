import 'dart:typed_data';

import 'package:cafeconhuellas_front/theme/AppColors.dart';
import 'package:cafeconhuellas_front/utils/api_conector.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastName1Controller = TextEditingController();
  final lastName2Controller = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  Uint8List? _imageBytes;
  String? _imageFileName;
  bool _isLoading = false;

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

  Future<void> _pickImage() async {
    final plugin = ImagePickerPlugin();
    final XFile? picked = await plugin.getImageFromSource(
      source: ImageSource.gallery,
      options: const ImagePickerOptions(maxWidth: 800, imageQuality: 85),
    );
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    setState(() {
      _imageBytes = bytes;
      _imageFileName = picked.name;
    });
  }

  // Validadores 
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Este campo es obligatorio';
    final soloLetras = RegExp(r"^[a-záéíóúäëïöüàèìòùñA-ZÁÉÍÓÚÄËÏÖÜÀÈÌÒÙÑ\s'-]+$", unicode: true);
    if (!soloLetras.hasMatch(value.trim())) return 'Solo se permiten letras';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'El email es obligatorio';
    final emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.]+$');
    if (!emailRegex.hasMatch(value.trim())) return 'Introduce un email válido';
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return 'El teléfono es obligatorio';
    final phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');
    if (!phoneRegex.hasMatch(value.trim())) return 'Teléfono no válido';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'La contraseña es obligatoria';
    if (value.length < 6) return 'Mínimo 6 caracteres';
    return null;
  }

  // Submit 

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    String? imageUrl;
    String? errorMessage;

    try {
      if (_imageBytes != null && _imageFileName != null) {
        imageUrl = await ApiConector().uploadAvatar(_imageBytes!, _imageFileName!);
      }

      await ApiConector().register({
        "firstName": firstNameController.text.trim(),
        "lastName1": lastName1Controller.text.trim(),
        "lastName2": lastName2Controller.text.trim(),
        "email": emailController.text.trim(),
        "password": passwordController.text,
        "phone": phoneController.text.trim(),
        "role": "USER",
        "imageUrl": ?imageUrl,
      });

    } catch (e) {
      errorMessage = e.toString();
    }

    // ✅ Un único punto de uso del context, ya fuera del try/catch
    if (!mounted) return;

    setState(() => _isLoading = false);

    if (errorMessage != null) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Error"),
          content: Text("Error al registrar: $errorMessage"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cerrar"),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
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
        ),
      );
    }
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
                      child: Form(
                        key: _formKey,
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
                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap: _pickImage,
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  CircleAvatar(
                                    radius: 52,
                                    backgroundColor: AppColors.vanilla,
                                    backgroundImage: _imageBytes != null ? MemoryImage(_imageBytes!) : null,
                                    child: _imageBytes == null
                                        ? Icon(Icons.person, size: 48, color: AppColors.purple)
                                        : null,
                                  ),
                                  CircleAvatar(
                                    radius: 15,
                                    backgroundColor: AppColors.purple,
                                    child: Icon(
                                      _imageBytes != null ? Icons.check : Icons.camera_alt,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _imageBytes != null ? "Foto seleccionada ✓" : "Añadir foto de perfil",
                              style: TextStyle(
                                fontSize: 12,
                                color: _imageBytes != null ? Colors.green[700] : Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 20),
                            _input("Nombre", firstNameController, validator: _validateName),
                            const SizedBox(height: 15),
                            _input("Primer apellido", lastName1Controller, validator: _validateName),
                            const SizedBox(height: 15),
                            _input("Segundo apellido", lastName2Controller, validator: _validateName),
                            const SizedBox(height: 15),
                            _input("Email", emailController, validator: _validateEmail),
                            const SizedBox(height: 15),
                            _input("Teléfono", phoneController, validator: _validatePhone),
                            const SizedBox(height: 15),
                            _input("Contraseña", passwordController, isPassword: true, validator: _validatePassword),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.purple,
                                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: _isLoading ? null : _submit,
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                    )
                                  : const Text(
                                      "Registrarse",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'MilkyVintage',
                                        fontSize: 23,
                                      ),
                                    ),
                            ),
                            TextButton(
                              onPressed: () => context.go('/login'),
                              child: const Text("¿Ya tienes cuenta? Inicia sesión"),
                            ),
                          ],
                        ),
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

Widget _input(
  String label,
  TextEditingController controller, {
  bool isPassword = false,
  String? Function(String?)? validator,
}) {
  return TextFormField(
    controller: controller,
    obscureText: isPassword,
    validator: validator,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    decoration: InputDecoration(
      labelText: label,
      filled: true,
      fillColor: AppColors.vanilla,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}