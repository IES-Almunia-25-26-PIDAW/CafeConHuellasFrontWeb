import 'dart:typed_data';

import 'package:cafeconhuellas_front/models/pet.dart';
import 'package:cafeconhuellas_front/utils/api_conector.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

/// Dialog form used to create or edit a pet.
///
/// If [pet] is provided the form opens in edit mode,
/// otherwise it opens in create mode.
/// On success it pops returning the resulting [Pet]
/// to the caller, which is responsible for calling the Bloc.
class PetFormDialog extends StatefulWidget {
  /// The pet to edit. Null when creating a new one.
  final Pet? pet;

  const PetFormDialog({super.key, this.pet});

  @override
  State<PetFormDialog> createState() => _PetFormDialogState();
}

class _PetFormDialogState extends State<PetFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _breedCtrl;
  late final TextEditingController _descriptionCtrl;
  late final TextEditingController _ageCtrl;
  late final TextEditingController _weightCtrl;

  // Exact values accepted by the backend.
  static const List<String> _adoptionStatusOptions = ['NO_ADOPTADO', 'EN_PROCESO', 'ADOPTADO'];

  late String _adoptionStatus;
  late String _category;
  late bool _neutered;
  late bool _isPpp;
  late bool _urgentAdoption;
  late String _imageUrl;

  Uint8List? _imageBytes;
  String? _imageFileName;
  bool _uploadingImage = false;
  bool _saving = false;

  /// True when editing an existing pet, false when creating a new one.
  bool get _isEditing => widget.pet != null;

  @override
  void initState() {
    super.initState();
    final p = widget.pet;
    _nameCtrl        = TextEditingController(text: p?.name ?? '');
    _breedCtrl       = TextEditingController(text: p?.breed ?? '');
    _descriptionCtrl = TextEditingController(text: p?.description ?? '');
    _ageCtrl         = TextEditingController(text: p != null ? p.age.toString() : '');
    _weightCtrl      = TextEditingController(text: p != null ? p.weight.toString() : '');
    _category        = p?.category ?? 'Perro';
    _neutered        = p?.neutered ?? false;
    _isPpp           = p?.isPpp ?? false;
    _urgentAdoption  = p?.urgentAdoption ?? false;
    _imageUrl        = p?.imageUrl ?? '';
    _adoptionStatus  = p?.adoptionStatus ?? 'NO_ADOPTADO';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _breedCtrl.dispose();
    _descriptionCtrl.dispose();
    _ageCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }

  // Validators

  // Validates that the field contains only letters and meets the minimum length.
  String? _validateOnlyLetters(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return '$fieldName es obligatorio';
    final soloLetras = RegExp(r"^[a-záéíóúäëïöüàèìòùñA-ZÁÉÍÓÚÄËÏÖÜÀÈÌÒÙÑ\s'-]+$", unicode: true);
    if (!soloLetras.hasMatch(value.trim())) return 'Solo se permiten letras en $fieldName';
    if (value.trim().length < 2) return '$fieldName debe tener al menos 2 caracteres';
    return null;
  }

  // Validates that the description is not empty and has at least 10 characters.
  String? _validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) return 'La descripción es obligatoria';
    if (value.trim().length < 10) return 'Mínimo 10 caracteres';
    return null;
  }

  // Validates that the age is an integer between 0 and 20.
  String? _validateAge(String? value) {
    if (value == null || value.trim().isEmpty) return 'La edad es obligatoria';
    final age = int.tryParse(value.trim());
    if (age == null) return 'Introduce un número entero';
    if (age < 0 || age > 20) return 'Edad no válida (0-20)';
    return null;
  }

  // Validates that the weight is a positive number between 0.1 and 200 kg.
  String? _validateWeight(String? value) {
    if (value == null || value.trim().isEmpty) return 'El peso es obligatorio';
    final weight = double.tryParse(value.trim().replaceAll(',', '.'));
    if (weight == null) return 'Introduce un número válido';
    if (weight < 0.1) return 'El peso mínimo es 0.1 kg';
    if (weight > 200) return 'El peso no puede superar 200 kg';
    return null;
  }

  // Method used to pick an image from the gallery and upload it to the server.
  Future<void> _pickAndUploadImage() async {
    final plugin = ImagePickerPlugin();
    final XFile? picked = await plugin.getImageFromSource(
      source: ImageSource.gallery,
      options: const ImagePickerOptions(maxWidth: 900, imageQuality: 85),
    );
    if (picked == null) return;

    final bytes = await picked.readAsBytes();
    setState(() {
      _imageBytes    = bytes;
      _imageFileName = picked.name;
      _uploadingImage = true;
    });

    String? uploadError;
    String? uploadedUrl;

    try {
      uploadedUrl = await ApiConector().uploadPetsImage(bytes, picked.name);
    } catch (e) {
      uploadError = e.toString();
    }

    if (!mounted) return;
    setState(() {
      _uploadingImage = false;
      if (uploadedUrl != null) _imageUrl = uploadedUrl;
    });

    if (uploadError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al subir imagen: $uploadError'), backgroundColor: Colors.red),
      );
    }
  }

  // Method used to validate the form and pop the dialog with the resulting Pet.
  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Añade una foto a la mascota'), backgroundColor: Colors.orange),
      );
      return;
    }

    final pet = Pet(
      id:             widget.pet?.id ?? 0,
      name:           _nameCtrl.text.trim(),
      breed:          _breedCtrl.text.trim(),
      age:            int.parse(_ageCtrl.text.trim()),
      weight:         double.parse(_weightCtrl.text.trim().replaceAll(',', '.')),
      neutered:       _neutered,
      isPpp:          _isPpp,
      urgentAdoption: _urgentAdoption,
      description:    _descriptionCtrl.text.trim(),
      category:       _category,
      adoptionStatus: _adoptionStatus,
      imageUrl:       _imageUrl,
      imageUrls:      [_imageUrl],
    );

    Navigator.of(context).pop(pet);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isEditing ? 'Editar mascota' : 'Añadir mascota',
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, fontFamily: 'MilkyVintage'),
                ),
                const SizedBox(height: 20),

                // Image picker — circular avatar with upload overlay.
                Center(
                  child: GestureDetector(
                    onTap: _uploadingImage ? null : _pickAndUploadImage,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 52,
                          backgroundColor: Colors.purple[50],
                          backgroundImage: _imageBytes != null
                              ? MemoryImage(_imageBytes!)
                              : (_imageUrl.isNotEmpty ? NetworkImage(_imageUrl) as ImageProvider : null),
                          child: (_imageBytes == null && _imageUrl.isEmpty)
                              ? const Icon(Icons.pets, size: 40, color: Colors.purple)
                              : null,
                        ),
                        if (_uploadingImage)
                          const CircleAvatar(
                            radius: 52,
                            backgroundColor: Colors.black26,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          ),
                        // Badge showing camera icon or checkmark depending on upload state.
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.purple,
                          child: Icon(
                            _imageUrl.isNotEmpty ? Icons.check : Icons.camera_alt,
                            size: 15,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6, bottom: 18),
                    child: Text(
                      _imageUrl.isNotEmpty ? 'Imagen lista ✓' : 'Toca para añadir foto',
                      style: TextStyle(
                        fontSize: 12,
                        color: _imageUrl.isNotEmpty ? Colors.green[700] : Colors.grey[600],
                      ),
                    ),
                  ),
                ),

                // Form fields
                _field('Nombre *', _nameCtrl,
                    validator: (v) => _validateOnlyLetters(v, 'el nombre')),
                _field('Raza *', _breedCtrl,
                    validator: (v) => _validateOnlyLetters(v, 'la raza')),
                _field('Descripción *', _descriptionCtrl,
                    maxLines: 3, validator: _validateDescription),
                Row(
                  children: [
                    Expanded(child: _field('Edad (años) *', _ageCtrl,
                        keyboardType: TextInputType.number, validator: _validateAge)),
                    const SizedBox(width: 12),
                    Expanded(child: _field('Peso (kg) *', _weightCtrl,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: _validateWeight)),
                  ],
                ),

                // Species selector
                const SizedBox(height: 8),
                const Text('Especie', style: TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _categoryChip('Perro', 'Perro', Icons.pets),
                    const SizedBox(width: 10),
                    _categoryChip('Gato', 'Gato', Icons.catching_pokemon),
                  ],
                ),
                const SizedBox(height: 16),

                // Adoption status dropdown
                const Text('Estado de adopción', style: TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.purple[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.purple[200]!),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _adoptionStatus,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.purple),
                      items: _adoptionStatusOptions
                          .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                          .toList(),
                      onChanged: (v) => setState(() => _adoptionStatus = v!),
                    ),
                  ),
                ),

                // Boolean toggles
                const SizedBox(height: 12),
                _switch('Castrado / Esterilizado', _neutered, (v) => setState(() => _neutered = v)),
                _switch('Es PPP (Potencialmente Peligroso)', _isPpp, (v) => setState(() => _isPpp = v)),
                _switch('Emergencia', _urgentAdoption, (v) => setState(() => _urgentAdoption = v)),
                const SizedBox(height: 24),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: (_saving || _uploadingImage) ? null : _submit,
                      icon: const Icon(Icons.save),
                      label: Text(_isEditing ? 'Guardar cambios' : 'Añadir mascota'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // UI helpers

  // Helper that builds a styled text form field.
  Widget _field(
    String label,
    TextEditingController ctrl, {
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.purple[50],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  // Helper that builds a selectable species chip.
  Widget _categoryChip(String label, String value, IconData icon) {
    final selected = _category == value;
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon, size: 16), const SizedBox(width: 6), Text(label)],
      ),
      selected: selected,
      selectedColor: Colors.purple,
      labelStyle: TextStyle(color: selected ? Colors.white : Colors.black),
      onSelected: (_) => setState(() => _category = value),
    );
  }

  // Helper that builds a labeled switch tile.
  Widget _switch(String label, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      title: Text(label, style: const TextStyle(fontSize: 14)),
      value: value,
      activeThumbColor: Colors.purple,
      onChanged: onChanged,
    );
  }
}