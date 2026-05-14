import 'package:cafeconhuellas_front/utils/api_conector.dart';
import 'package:cafeconhuellas_front/presentation/widgets/app_header.dart';
import 'package:cafeconhuellas_front/presentation/widgets/app_footer.dart';
import 'package:flutter/material.dart';

/// Main color used throughout the adoption form screen.
const Color _purple = Color(0xFF7B3FE4);

  /// Screen that allows users to submit
  /// an adoption request form.
  ///
  /// The screen contains:
  /// - Personal housing information.
  /// - Adoption motivation.
  /// - Pet experience information.
  /// - Additional notes.
  ///
  /// The form is submitted to the backend API
  /// using the authenticated user's token.
class DonationFormScreen extends StatefulWidget {
  /// JWT authentication token required
  /// to submit the adoption form.
  final String token;
  /// Creates the adoption form screen.
  const DonationFormScreen({super.key, required this.token});

  @override
  State<DonationFormScreen> createState() => _DonationFormScreenState();
}

/// State class responsible for:
/// - Managing form controllers.
/// - Handling validation.
/// - Sending adoption requests.
/// - Managing loading state.
class _DonationFormScreenState extends State<DonationFormScreen> {
  /// Controller for the address input field.
  final _addressCtrl        = TextEditingController();
  /// Controller for the address input field.
  final _cityCtrl           = TextEditingController();
  /// Controller for the housing type input field.
  final _housingTypeCtrl    = TextEditingController();
    /// Controller for the hours-alone input field.
  final _hoursCtrl          = TextEditingController();
   /// Controller for the adoption reason input field.
  final _reasonCtrl         = TextEditingController();
   /// Controller for the additional information field.
  final _additionalInfoCtrl = TextEditingController();
   /// Indicates whether the user has a garden.
  bool _hasGarden        = false;
   /// Indicates whether the user owns other pets.
  bool _hasOtherPets     = false;
  /// Indicates whether the user has children.
  bool _hasChildren      = false;
  /// Indicates whether the user has previous
  /// experience with pets.
  bool _experienceWithPets = false;
  /// Indicates whether the user accepts
  /// post-adoption follow-up.
  bool _agreesToFollowUp = false;
  /// Indicates whether the form is currently
  /// being submitted.
  bool _submitting       = false;
  /// Releases all text controllers when
  /// the widget is removed from memory.
  ///
  /// Prevents memory leaks.
  @override
  void dispose() {
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _housingTypeCtrl.dispose();
    _hoursCtrl.dispose();
    _reasonCtrl.dispose();
    _additionalInfoCtrl.dispose();
    super.dispose();
  }
  /// Handles adoption form submission.
  ///
  /// This method:
  /// 1. Validates required fields.
  /// 2. Validates numeric values.
  /// 3. Creates the form payload.
  /// 4. Sends the form to the backend API.
  /// 5. Displays success or error messages.
  Future<void> _submit() async {
    if (_addressCtrl.text.trim().isEmpty ||
        _cityCtrl.text.trim().isEmpty ||
        _housingTypeCtrl.text.trim().isEmpty ||
        _reasonCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rellena todos los campos obligatorios'),
            backgroundColor: Colors.red),
      );
      return;
    }
    /// Validates hours-alone field.
    final hours = int.tryParse(_hoursCtrl.text.trim());
    if (hours == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las horas deben ser un número'),
            backgroundColor: Colors.red),
      );
      return;
    }
    /// Creates the form payload sent to the API.
    final formData = {
      'address':           _addressCtrl.text.trim(),
      'city':              _cityCtrl.text.trim(),
      'housingType':       _housingTypeCtrl.text.trim(),
      'hasGarden':         _hasGarden.toString(),
      'hasOtherPets':      _hasOtherPets.toString(),
      'hasChildren':       _hasChildren.toString(),
      'hoursAlonePerDay':  hours,
      'experienceWithPets': _experienceWithPets.toString(),
      'reasonForAdoption': _reasonCtrl.text.trim(),
      'agreesToFollowUp':  _agreesToFollowUp.toString(),
      'additionalInfo':    _additionalInfoCtrl.text.trim(),
    };

    final messenger = ScaffoldMessenger.of(context);
    setState(() => _submitting = true);
    try {
      /// Sends adoption form to backend API
      await ApiConector().submitAdoptionForm(formData, widget.token);
      /// Displays success message.
      messenger.showSnackBar(
        const SnackBar(
          content: Text('¡Solicitud enviada con éxito! Te contactaremos pronto ❤️'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      /// Disables loading state if widget
      /// is still mounted.
      if (mounted) setState(() => _submitting = false);
    }
  }
  /// Builds the adoption form screen UI.
  ///
  /// Layout structure:
  /// - Shared application header.
  /// - Banner image.
  /// - Adoption form.
  /// - Shared application footer.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Shared application header.
            AppHeader(),
            /// Main banner image.
            Image.asset('assets/images/banners/banner-inicio.png',
                width: double.infinity, height: 250, fit: BoxFit.cover),
            const SizedBox(height: 40),
             /// Screen title.
            const Text('Formulario de Adopción',
                style: TextStyle(fontSize: 36, fontFamily: 'MilkyVintage', color: _purple)),
            const SizedBox(height: 8),
             /// Screen subtitle.
            const Text('Rellena el formulario para completar tu solicitud de adopción.',
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),
             /// Responsive form container.
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _field('Dirección *', _addressCtrl),
                    _field('Ciudad *', _cityCtrl),
                    _field('Tipo de vivienda * (piso, casa, chalet...)', _housingTypeCtrl),
                    _field('Horas solo al día *', _hoursCtrl, keyboardType: TextInputType.number),
                    _field('Motivo de adopción *', _reasonCtrl, maxLines: 4),
                    _field('Información adicional', _additionalInfoCtrl, maxLines: 3),
                    const SizedBox(height: 8),
                    const Text('Sobre tu hogar',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    _switch('¿Tienes jardín?', _hasGarden,
                        (v) => setState(() => _hasGarden = v)),
                    _switch('¿Tienes otras mascotas?', _hasOtherPets,
                        (v) => setState(() => _hasOtherPets = v)),
                    _switch('¿Tienes niños en casa?', _hasChildren,
                        (v) => setState(() => _hasChildren = v)),
                    _switch('¿Tienes experiencia con mascotas?', _experienceWithPets,
                        (v) => setState(() => _experienceWithPets = v)),
                    _switch('¿Aceptas seguimiento post-adopción?', _agreesToFollowUp,
                        (v) => setState(() => _agreesToFollowUp = v)),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _purple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _submitting ? null : _submit,
                        child: _submitting
                            ? const SizedBox(width: 20, height: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text('Enviar solicitud', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
            const AppFooter(),
          ],
        ),
      ),
    );
  }
  /// Creates a reusable styled text field.
  ///
  /// Parameters:
  /// - [label]: Field label text.
  /// - [ctrl]: Text editing controller.
  /// - [maxLines]: Maximum number of lines.
  /// - [keyboardType]: Input keyboard type.
  Widget _field(String label, TextEditingController ctrl,
      {int maxLines = 1, TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: ctrl,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.purple[50],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _purple, width: 2),
          ),
        ),
      ),
    );
  }
  /// Creates a reusable switch widget.
  ///
  /// Used for boolean form options.
  Widget _switch(String label, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      value: value,
      onChanged: onChanged,
    );
  }
}