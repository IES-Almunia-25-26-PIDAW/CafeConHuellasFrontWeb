import 'dart:typed_data';

import 'package:cafeconhuellas_front/theme/AppColors.dart';
import 'package:cafeconhuellas_front/utils/api_conector.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

/// Screen that allows new users to register an account.
///
/// This screen contains:
/// - Profile photo selector.
/// - First name, last names, email, phone, and password fields.
/// - Form validation for all fields.
/// - Registration button.
/// - Link to the login screen.
class RegisterScreen extends StatefulWidget {
  /// Creates the register screen widget.
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

/// State class responsible for managing:
/// - Form controllers and validation key.
/// - Image selection state.
/// - Form submission and loading state.
/// - Widget lifecycle.
class _RegisterScreenState extends State<RegisterScreen> {

  /// Global key used to validate the form.
  final _formKey = GlobalKey<FormState>();

  /// Controller used for the first name input field.
  final firstNameController = TextEditingController();

  /// Controller used for the first last name input field.
  final lastName1Controller = TextEditingController();

  /// Controller used for the second last name input field.
  final lastName2Controller = TextEditingController();

  /// Controller used for the email input field.
  final emailController = TextEditingController();

  /// Controller used for the phone input field.
  final phoneController = TextEditingController();

  /// Controller used for the password input field.
  final passwordController = TextEditingController();

  /// Bytes of the selected profile image.
  ///
  /// Null if no image has been selected.
  Uint8List? _imageBytes;

  /// File name of the selected profile image.
  ///
  /// Null if no image has been selected.
  String? _imageFileName;

  /// Whether the registration form is currently submitting.
  bool _isLoading = false;

  /// Releases all text controllers when
  /// the widget is removed from memory.
  ///
  /// Prevents memory leaks.
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

  /// Opens the device image gallery and stores the selected image.
  ///
  /// Updates [_imageBytes] and [_imageFileName] on success.
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

  /// Validates that the field contains only letters.
  ///
  /// Returns an error message if invalid, or null if valid.
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Este campo es obligatorio';
    final soloLetras = RegExp(r"^[a-záéíóúäëïöüàèìòùñA-ZÁÉÍÓÚÄËÏÖÜÀÈÌÒÙÑ\s'-]+$", unicode: true);
    if (!soloLetras.hasMatch(value.trim())) return 'Solo se permiten letras';
    return null;
  }

  /// Validates that the field contains a valid email address.
  ///
  /// Returns an error message if invalid, or null if valid.
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'El email es obligatorio';
    final emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.]+$');
    if (!emailRegex.hasMatch(value.trim())) return 'Introduce un email válido';
    return null;
  }

  /// Validates that the field contains a valid phone number.
  ///
  /// Returns an error message if invalid, or null if valid.
  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return 'El teléfono es obligatorio';
    final phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');
    if (!phoneRegex.hasMatch(value.trim())) return 'Teléfono no válido';
    return null;
  }

  /// Validates that the password meets the minimum length requirement.
  ///
  /// Returns an error message if invalid, or null if valid.
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'La contraseña es obligatoria';
    if (value.length < 6) return 'Mínimo 6 caracteres';
    return null;
  }

  /// Handles form submission.
  ///
  /// Validates all fields before proceeding.
  /// Uploads the selected image if present.
  /// Sends the registration data to the backend API.
  ///
  /// Shows a success dialog and redirects to login on success.
  /// Shows an error dialog if the registration fails.
  ///
  /// Verifies [mounted] before using [BuildContext] after async gaps.
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    String? imageUrl;
    String? errorMessage;

    try {
      /// Upload avatar image if one was selected.
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
        "imageUrl": imageUrl,
      });

    } catch (e) {
      errorMessage = e.toString();
    }

    /// Verify mounted before using context after the async gap.
    if (!mounted) return;

    setState(() => _isLoading = false);

    if (errorMessage != null) {
      /// Show error dialog on failed registration.
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
      /// Show success dialog and redirect to login.
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

  /// Builds the register screen UI.
  ///
  /// Layout structure:
  /// - Centered card with registration form.
  /// - Avatar selector.
  /// - Name, email, phone, and password fields.
  /// - Registration button with loading indicator.
  /// - Link to the login screen.
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
                            /// Screen title.
                            Text(
                              "Registro",
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color: AppColors.darkPurple,
                                    fontFamily: 'WinkyMilky',
                                  ),
                            ),
                            const SizedBox(height: 16),
                            /// Avatar image selector.
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
                            /// Image selection status label.
                            Text(
                              _imageBytes != null ? "Foto seleccionada ✓" : "Añadir foto de perfil",
                              style: TextStyle(
                                fontSize: 12,
                                color: _imageBytes != null ? Colors.green[700] : Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 20),
                            /// First name input field.
                            _input("Nombre", firstNameController, validator: _validateName),
                            const SizedBox(height: 15),
                            /// First last name input field.
                            _input("Primer apellido", lastName1Controller, validator: _validateName),
                            const SizedBox(height: 15),
                            /// Second last name input field.
                            _input("Segundo apellido", lastName2Controller, validator: _validateName),
                            const SizedBox(height: 15),
                            /// Email input field.
                            _input("Email", emailController, validator: _validateEmail),
                            const SizedBox(height: 15),
                            /// Phone input field.
                            _input("Teléfono", phoneController, validator: _validatePhone),
                            const SizedBox(height: 15),
                            /// Password input field.
                            _input("Contraseña", passwordController, isPassword: true, validator: _validatePassword),
                            const SizedBox(height: 20),
                            /// Registration button.
                            ///
                            /// Disabled while submitting.
                            /// Shows a loading indicator during submission.
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
                            /// Link to the login screen.
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

/// Creates a reusable styled validated text input field.
///
/// Parameters:
/// - [label]: Label text shown inside the field.
/// - [controller]: Controller linked to the input field.
/// - [isPassword]: Whether to obscure the input text. Defaults to false.
/// - [validator]: Optional validation function returning an error message or null.
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