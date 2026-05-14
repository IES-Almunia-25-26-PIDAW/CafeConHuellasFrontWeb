import 'dart:typed_data';
import 'package:cafeconhuellas_front/models/event.dart';
import 'package:cafeconhuellas_front/utils/api_conector.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

/// Dialog form used to create or edit an event.
///
/// If [event] is provided the form opens in edit mode,
/// otherwise it opens in create mode.
/// On success it pops returning the resulting [Event]
/// to the caller, which is responsible for calling the Bloc.
class EventFormDialog extends StatefulWidget {
  /// The event to edit. Null when creating a new one.
  final Event? event;
  const EventFormDialog({super.key, this.event});

  @override
  State<EventFormDialog> createState() => _EventFormDialogState();
}

class _EventFormDialogState extends State<EventFormDialog> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _locCtrl;
  late final TextEditingController _capacityCtrl;

  late DateTime _eventDate;
  late String _imageUrl;

  // Exact values accepted by the backend — dropdowns prevent typos.
  static const List<String> _eventTypes    = ['RECAUDACION', 'ADOPCION', 'MERCADILLO', 'EDUCACIÓN', 'OTRO'];
  static const List<String> _statusOptions = ['PROGRAMADO', 'EN_CURSO', 'FINALIZADO', 'CANCELADO'];
  late String _selectedType;
  late String _selectedStatus;

  Uint8List? _imageBytes;
  bool _uploadingImage = false;

  /// True when editing an existing event, false when creating a new one.
  bool get _isEditing => widget.event != null;

  @override
  void initState() {
    super.initState();
    final e = widget.event;
    _nameCtrl     = TextEditingController(text: e?.name ?? '');
    _descCtrl     = TextEditingController(text: e?.description ?? '');
    _locCtrl      = TextEditingController(text: e?.location ?? '');
    _capacityCtrl = TextEditingController(text: (e?.maxCapacity ?? 100).toString());
    // Default date is tomorrow when creating a new event.
    _eventDate = e?.eventdate ?? DateTime.now().add(const Duration(days: 1));
    _imageUrl  = e?.imageUrl ?? '';

    // Normalize type and status to match the dropdown options.
    final t = (e?.eventType ?? '').toUpperCase();
    final s = (e?.status ?? '').toUpperCase();
    _selectedType   = _eventTypes.contains(t)    ? t : _eventTypes.first;
    _selectedStatus = _statusOptions.contains(s) ? s : _statusOptions.first;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _locCtrl.dispose();
    _capacityCtrl.dispose();
    super.dispose();
  }

  // Method used to pick and upload an event image from the gallery.
  Future<void> _pickImage() async {
    final plugin = ImagePickerPlugin();
    final XFile? picked = await plugin.getImageFromSource(
      source: ImageSource.gallery,
      options: const ImagePickerOptions(maxWidth: 900, imageQuality: 85),
    );
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    setState(() { _imageBytes = bytes; _uploadingImage = true; });
    try {
      final url = await ApiConector().uploadEventsImages(bytes, picked.name);
      setState(() => _imageUrl = url);
    } catch (e) {
      if (mounted) _showError('Error uploading image: $e');
    } finally {
      if (mounted) setState(() => _uploadingImage = false);
    }
  }

  // Method used to open the date and time pickers sequentially.
  // If the user cancels the time picker, defaults to 00:00.
  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _eventDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate == null) return;
    if (!mounted) return;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_eventDate),
    );
    // Falls back to 00:00 if the time picker is dismissed.
    final t = pickedTime ?? const TimeOfDay(hour: 0, minute: 0);
    setState(() {
      _eventDate = DateTime(
        pickedDate.year, pickedDate.month, pickedDate.day, t.hour, t.minute,
      );
    });
  }

  // Method used to show a styled error dialog with a backend message.
  Future<void> _showError(String message) async {
    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(children: [
          Icon(Icons.error_outline, color: Colors.red),
          SizedBox(width: 8),
          Text('Error', style: TextStyle(color: Colors.red)),
        ]),
        content: Text(message),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  // Method used to validate fields and pop the dialog with the resulting Event.
  // The caller (Bloc) is responsible for the actual API call.
  Future<void> _submit() async {
    final name = _nameCtrl.text.trim();
    final desc = _descCtrl.text.trim();
    final loc  = _locCtrl.text.trim();

    if (name.isEmpty) {
      await _showError('El nombre del evento es obligatorio.');
      return;
    }
    if (desc.length < 20) {
      await _showError(
        'La descripción debe tener al menos 20 caracteres.\n'
        'Actualmente tiene ${desc.length} caractere${desc.length == 1 ? '' : 's'}.',
      );
      return;
    }
    if (name.length < 5) {
      await _showError('El nombre del evento debe tener al menos 5 caracteres.');
      return;
    }
    if (_imageUrl.isEmpty) {
      await _showError('La imagen del evento es obligatoria. Por favor, añádele una imagen representativa.');
      return;
    }
    if (loc.length < 2) {
      await _showError('La ubicación del evento debe tener al menos 2 caracteres.');
      return;
    }
    if (_capacityCtrl.text.trim().isNotEmpty) {
      final capacity = int.tryParse(_capacityCtrl.text.trim());
      if (capacity == null || capacity <= 0) {
        await _showError('La capacidad máxima debe ser un número entero positivo.');
        return;
      }
    }
    if (loc.isEmpty) {
      await _showError('La ubicación es obligatoria.');
      return;
    }

    final event = Event(
      id:          _isEditing ? widget.event!.id : 0,
      name:        name,
      description: desc,
      eventdate:   _eventDate,
      location:    loc,
      imageUrl:    _imageUrl,
      eventType:   _selectedType,
      status:      _selectedStatus,
      maxCapacity: int.tryParse(_capacityCtrl.text) ?? 100,
    );

    // Returns the event to the parent — it calls the Bloc, the Bloc calls the API.
    if (mounted) Navigator.pop(context, event);
  }

  @override
  Widget build(BuildContext context) {
    const Color purple = Color(0xFF7B3FE4);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Title
              Text(
                _isEditing ? 'Editar Evento' : 'Nuevo Evento',
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold,
                    fontFamily: 'MilkyVintage', color: purple),
              ),
              const SizedBox(height: 20),

              // Image picker — shows preview or upload indicator.
              GestureDetector(
                onTap: _uploadingImage ? null : _pickImage,
                child: Container(
                  height: 150, width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.purple[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.purple[200]!),
                    image: _imageBytes != null
                        ? DecorationImage(image: MemoryImage(_imageBytes!), fit: BoxFit.cover)
                        : (_imageUrl.isNotEmpty
                            ? DecorationImage(image: NetworkImage(_imageUrl), fit: BoxFit.cover)
                            : null),
                  ),
                  child: (_imageBytes == null && _imageUrl.isEmpty)
                      ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          const Icon(Icons.add_a_photo, size: 36, color: purple),
                          const SizedBox(height: 6),
                          Text('Añadir imagen', style: TextStyle(color: Colors.purple[300], fontSize: 13)),
                        ])
                      : (_uploadingImage
                          ? const Center(child: CircularProgressIndicator(color: purple))
                          : null),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 12),
                child: Text(
                  _imageUrl.isNotEmpty ? 'Imagen lista ✓' : 'Toca para añadir imagen',
                  style: TextStyle(
                    fontSize: 12,
                    color: _imageUrl.isNotEmpty ? Colors.green[700] : Colors.grey[500],
                  ),
                ),
              ),

              // Text fields
              _field('Nombre del evento *', _nameCtrl),
              _field('Descripción * (mín. 20 caracteres)', _descCtrl, maxLines: 4),
              _field('Ubicación *', _locCtrl),
              _field('Capacidad máxima', _capacityCtrl, keyboardType: TextInputType.number),

              // Date picker — always shows the selected date.
              const SizedBox(height: 4),
              InkWell(
                onTap: _selectDate,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.purple[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.purple[200]!),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: purple, size: 20),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Fecha del evento', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                          Text(
                            "${_eventDate.day.toString().padLeft(2, '0')}/"
                            "${_eventDate.month.toString().padLeft(2, '0')}/"
                            "${_eventDate.year}  "
                            "${_eventDate.hour.toString().padLeft(2, '0')}:"
                            "${_eventDate.minute.toString().padLeft(2, '0')}",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Text('Cambiar', style: TextStyle(color: purple, fontSize: 13)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Event type dropdown
              _dropdown('Tipo de evento', _selectedType, _eventTypes, purple,
                  (v) => setState(() => _selectedType = v!)),
              const SizedBox(height: 12),

              // Status dropdown
              _dropdown('Estado', _selectedStatus, _statusOptions, purple,
                  (v) => setState(() => _selectedStatus = v!)),
              const SizedBox(height: 28),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancelar', style: TextStyle(color: Colors.grey[600])),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _uploadingImage ? null : _submit,
                    icon: const Icon(Icons.save),
                    label: Text(_isEditing ? 'Guardar cambios' : 'Crear evento'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper that builds a styled text field.
  Widget _field(String label, TextEditingController ctrl,
      {int maxLines = 1, TextInputType? keyboardType}) {
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
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF7B3FE4), width: 2),
          ),
        ),
      ),
    );
  }

  // Helper that builds a styled dropdown.
  Widget _dropdown(String label, String value, List<String> options,
      Color purple, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.purple[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple[200]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF7B3FE4)),
          items: options
              .map((o) => DropdownMenuItem(value: o, child: Text(o)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}