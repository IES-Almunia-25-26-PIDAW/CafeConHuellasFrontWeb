import 'dart:typed_data';

import 'package:cafeconhuellas_front/models/pet.dart';
import 'package:cafeconhuellas_front/utils/api_conector.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

// Diálogo reutilizable para añadir o editar una mascota, esto es para ayudarnos a no repetir código en el AdminScreen, donde se pueden añadir y editar mascotas. El diálogo se encarga de toda la lógica de formulario, validación y subida de imagen, y devuelve el Pet resultante al padre para que lo procese (lo añada o lo actualice según corresponda).
// Si [petToEdit] es null → modo AÑADIR.
// Si [petToEdit] tiene valor  → modo EDITAR (los campos se prerellenan).
// Devuelve el [Pet] resultante o null si el usuario cancela.
class PetFormDialog extends StatefulWidget {
  final Pet? pet;

  const PetFormDialog({super.key, this.pet});

  @override
  State<PetFormDialog> createState() => _PetFormDialogState();
}

class _PetFormDialogState extends State<PetFormDialog> {
  //  Controladores de texto
  late final TextEditingController _nameCtrl;
  late final TextEditingController _breedCtrl;
  late final TextEditingController _descriptionCtrl;
  late final TextEditingController _ageCtrl;
  late final TextEditingController _weightCtrl;
  late final TextEditingController _categoryCtrl;

  //  Estado de los campos que no son texto 
  late String _category;
  late bool _adopted;
  late bool _neutered;
  late bool _isPpp;
  late bool _urgentAdoption;
  late String _imageUrl; // URL ya guardada (de edición o nueva subida)

  // ── Estado de la imagen seleccionada localmente 
  Uint8List? _imageBytes;
  String? _imageFileName;
  bool _uploadingImage = false;
  bool _saving = false;

  bool get _isEditing => widget.pet != null;

  @override
  void initState() {
    super.initState();
    final p = widget.pet;
    // Prerrellenamos con los datos actuales si estamos editando
    _nameCtrl        = TextEditingController(text: p?.name ?? '');
    _breedCtrl       = TextEditingController(text: p?.breed ?? '');
    _descriptionCtrl = TextEditingController(text: p?.description ?? '');
    _ageCtrl         = TextEditingController(text: p != null ? p.age.toString() : '');
    _weightCtrl      = TextEditingController(text: p != null ? p.weight.toString() : '');
    _categoryCtrl    = TextEditingController(text: p?.category ?? '');
    _category        = p?.category ?? 'Perro';
    _adopted         = p?.adopted ?? false;
    _neutered        = p?.neutered ?? false;
    _isPpp           = p?.isPpp ?? false;
    _urgentAdoption  = p?.urgentAdoption ?? false;
    _imageUrl        = p?.imageUrl ?? '';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _breedCtrl.dispose();
    _descriptionCtrl.dispose();
    _ageCtrl.dispose();
    _weightCtrl.dispose();
    _categoryCtrl.dispose();
    super.dispose();
  }

  //  Selección y subida de imagen 
  Future<void> _pickAndUploadImage() async {
    final plugin = ImagePickerPlugin();
    final XFile? picked = await plugin.getImageFromSource(
      source: ImageSource.gallery,
      options: const ImagePickerOptions(maxWidth: 900, imageQuality: 85),
    );
    if (picked == null) return;

    final bytes = await picked.readAsBytes();
    setState(() {
      _imageBytes   = bytes;
      _imageFileName = picked.name;
      _uploadingImage = true;
    });

    try {
      final url = await ApiConector().uploadPetsImage(bytes, picked.name);
      setState(() => _imageUrl = url);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al subir imagen: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _uploadingImage = false);
    }
  }

  //Guardar: valida y devuelve el Pet al padre 
  void _submit() {
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El nombre es obligatorio'), backgroundColor: Colors.orange),
      );
      return;
    }
    final pet = Pet(
      id:          widget.pet?.id ?? 0, // el backend asigna id en POST
      name:        _nameCtrl.text.trim(),
      breed:       _breedCtrl.text.trim(),
      age:         int.tryParse(_ageCtrl.text) ?? 0,
      weight:      double.tryParse(_weightCtrl.text) ?? 0.0,
      adopted:     _adopted,
      neutered:    _neutered,
      isPpp:       _isPpp,
      urgentAdoption:   _urgentAdoption,
      description: _descriptionCtrl.text.trim(),
      category:    _category,
      imageUrl:    _imageUrl,
      imageUrls: [_imageUrl]
      
    );
    Navigator.of(context).pop(pet);
  }
  //  UI
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //  Título
              Text(
                //Si se está editando ponemos "Editar mascota", si se está añadiendo ponemos "Añadir mascota"
                _isEditing ? 'Editar mascota' : 'Añadir mascota',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'MilkyVintage',
                ),
              ),
              const SizedBox(height: 20),
              // Selector de imagen 
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

              // Campos de texto para añadir o editar la mascota
              _field('Nombre *', _nameCtrl),
              _field('Raza', _breedCtrl),
              _field('Categoría', _categoryCtrl),
              _field('Descripción', _descriptionCtrl, maxLines: 3),
              Row(
                children: [
                  Expanded(child: _field('Edad (años)', _ageCtrl, keyboardType: TextInputType.number)),
                  const SizedBox(width: 12),
                  Expanded(child: _field('Peso (kg)', _weightCtrl, keyboardType: TextInputType.numberWithOptions(decimal: true))),
                ],
              ),

              // Especie, elegir especie entre 2 opciones (perro o gato)
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

              // Switches
              const SizedBox(height: 12),
              //elegir click si o no, entre estás opociones
              _switch('Adoptado', _adopted, (v) => setState(() => _adopted = v)),
              _switch('Castrado / Esterilizado', _neutered, (v) => setState(() => _neutered = v)),
              _switch('Es PPP (Potencialmente Peligroso)', _isPpp, (v) => setState(() => _isPpp = v)),
              _switch('Emergencia', _urgentAdoption, (v) => setState(() => _urgentAdoption = v)),
              const SizedBox(height: 24),
              //  Botones
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
    );
  }

  //  Helpers de UI 

  Widget _field(String label, TextEditingController ctrl, {int maxLines = 1, TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.purple[50],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

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

  Widget _switch(String label, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      title: Text(label, style: const TextStyle(fontSize: 14)),
      value: value,
      activeColor: Colors.purple,
      onChanged: onChanged,
    );
  }
}