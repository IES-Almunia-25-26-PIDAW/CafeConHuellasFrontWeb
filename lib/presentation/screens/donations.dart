import 'package:cafeconhuellas_front/models/donation.dart';
import 'package:cafeconhuellas_front/presentation/bloc/auth_bloc.dart' show AuthBloc;
import 'package:cafeconhuellas_front/presentation/widgets/app_footer.dart';
import 'package:cafeconhuellas_front/presentation/widgets/app_header.dart';
import 'package:cafeconhuellas_front/theme/AppColors.dart';
import 'package:cafeconhuellas_front/utils/api_conector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DonationsScreen extends StatelessWidget {
  const DonationsScreen({super.key});

  static const _categories = ['MONETARIA', 'ALIMENTACION', 'MATERIAL', 'JUGUETES', 'MEDICAMENTOS', 'SUSCRIPCION', 'OTROS'];
  static const _methods    = ['EFECTIVO', 'TRANSFERENCIA', 'TARJETA', 'BIZUM', 'ESPECIE'];

  Future<void> _showDonationDialog(BuildContext context) async {
    final amountCtrl = TextEditingController();
    final notesCtrl  = TextEditingController();
    DateTime selectedDate = DateTime.now();
    String category = 'MONETARIA';
    String method   = 'TARJETA';

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Hacer una donación',
              style: TextStyle(fontFamily: 'MilkyVintage', fontSize: 22)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // fecha
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) setState(() => selectedDate = picked);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.purple[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.purple.shade200),
                    ),
                    child: Row(children: [
                      const Icon(Icons.calendar_today, color: Color(0xFF7B3FE4), size: 18),
                      const SizedBox(width: 10),
                      Text(
                        '${selectedDate.day.toString().padLeft(2, '0')}/'
                        '${selectedDate.month.toString().padLeft(2, '0')}/'
                        '${selectedDate.year}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      const Text('Cambiar', style: TextStyle(color: Color(0xFF7B3FE4), fontSize: 12)),
                    ]),
                  ),
                ),
                const SizedBox(height: 12),
                _dialogDropdown('Categoría', category, _categories, (v) => setState(() => category = v!)),
                const SizedBox(height: 12),
                _dialogDropdown('Método de pago', method, _methods, (v) => setState(() => method = v!)),
                const SizedBox(height: 12),
                TextField(
                  controller: amountCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Cantidad (€)',
                    filled: true,
                    fillColor: Colors.purple[50],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Notas (opcional)',
                    filled: true,
                    fillColor: Colors.purple[50],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7B3FE4),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () async {
                final amount = int.tryParse(amountCtrl.text.trim());
                if (amount == null || amount <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Introduce una cantidad válida'), backgroundColor: Colors.red),
                  );
                  return;
                }
                final donation = Donation(
                  id: 0,
                  userId: context.read<AuthBloc>().state.user?.id ?? 0,
                  date: selectedDate,
                  category: category,
                  method: method,
                  amount: amount,
                  notes: notesCtrl.text.trim(),
                );
                try {
                  await ApiConector().addDonation(donation);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('¡Donación realizada con éxito! '), backgroundColor: Colors.green),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error no tienes permisos para hacer esto, inicia sesión primero'), backgroundColor: Colors.red),
                  );
                }
              },
              child: const Text('Confirmar donación'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dialogDropdown(String label, String value, List<String> options, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.purple[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF7B3FE4)),
          items: options.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppHeader(userImageUrl: "assets/user.png"),
            Image.asset("assets/images/banners/banner-inicio.png",
                width: double.infinity, height: 400, fit: BoxFit.cover),
            const SizedBox(height: 40),
            const Text(
              "¿Quieres ayudarnos?",
              style: TextStyle(fontSize: 38, fontFamily: "WinkyMilky", color: AppColors.darkViolet),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Wrap(
                spacing: 60,
                runSpacing: 40,
                alignment: WrapAlignment.center,
                children: [
                  _donationColumn(
                    context,
                    title: "¡Adopta!",
                    text: "Anímate a darle un hogar a uno de nuestros peludos. La adopción es la forma más directa de ayudar, y cada mascota adoptada es una vida salvada.",
                    buttonText: "Adoptar",
                    onPressed: () => Navigator.pushNamed(context, '/formulario-adopta'),
                  ),
                  _donationColumn(
                    context,
                    title: "¡Haznos una donación!",
                    text: "También puedes ayudarnos mediante una donación puntual. "
                        "Cada aportación nos ayuda a seguir rescatando y cuidando animales.",
                    buttonText: "Donar",
                    onPressed: () => _showDonationDialog(context),  // ← aquí
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
            AppFooter(),
          ],
        ),
      ),
    );
  }

  Widget _donationColumn(
    BuildContext context, {
    required String title,
    required String text,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 400,
      child: Column(
        children: [
          Text(title,
              style: const TextStyle(fontSize: 32, fontFamily: "MilkyVintage", color: AppColors.charcoal),
              textAlign: TextAlign.center),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: AppColors.cream),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Text(text,
                    style: const TextStyle(fontSize: 22, fontFamily: "MilkyVintage", color: AppColors.brown),
                    textAlign: TextAlign.center),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  ),
                  onPressed: onPressed,
                  child: Text(buttonText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}