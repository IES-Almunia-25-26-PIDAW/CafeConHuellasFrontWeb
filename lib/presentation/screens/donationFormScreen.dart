import 'package:cafeconhuellas_front/utils/api_conector.dart';
import 'package:cafeconhuellas_front/presentation/widgets/app_header.dart';
import 'package:cafeconhuellas_front/presentation/widgets/app_footer.dart';
import 'package:flutter/material.dart';

const Color _purple = Color(0xFF7B3FE4);

class DonationFormScreen extends StatefulWidget {
  final String token;
  const DonationFormScreen({super.key, required this.token});

  @override
  State<DonationFormScreen> createState() => _DonationFormScreenState();
}

class _DonationFormScreenState extends State<DonationFormScreen> {
  final _addressCtrl        = TextEditingController();
  final _cityCtrl           = TextEditingController();
  final _housingTypeCtrl    = TextEditingController();
  final _hoursCtrl          = TextEditingController();
  final _reasonCtrl         = TextEditingController();
  final _additionalInfoCtrl = TextEditingController();

  bool _hasGarden        = false;
  bool _hasOtherPets     = false;
  bool _hasChildren      = false;
  bool _experienceWithPets = false;
  bool _agreesToFollowUp = false;
  bool _submitting       = false;

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

    final hours = int.tryParse(_hoursCtrl.text.trim());
    if (hours == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las horas deben ser un número'),
            backgroundColor: Colors.red),
      );
      return;
    }

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
      await ApiConector().submitAdoptionForm(formData, widget.token);
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
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppHeader(),
            Image.asset('assets/images/banners/banner-inicio.png',
                width: double.infinity, height: 250, fit: BoxFit.cover),
            const SizedBox(height: 40),
            const Text('Formulario de Adopción',
                style: TextStyle(fontSize: 36, fontFamily: 'MilkyVintage', color: _purple)),
            const SizedBox(height: 8),
            const Text('Rellena el formulario para completar tu solicitud de adopción.',
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),
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

  Widget _switch(String label, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      value: value,
      onChanged: onChanged,
    );
  }
}