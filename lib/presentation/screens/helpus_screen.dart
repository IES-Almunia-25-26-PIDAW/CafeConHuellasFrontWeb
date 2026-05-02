import 'package:cafeconhuellas_front/models/pet.dart';
import 'package:cafeconhuellas_front/models/userPetRelationship.dart';
import 'package:cafeconhuellas_front/presentation/bloc/auth_bloc.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_bloc.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_event.dart';
import 'package:cafeconhuellas_front/presentation/widgets/app_footer.dart';
import 'package:cafeconhuellas_front/presentation/widgets/app_header.dart';
import 'package:cafeconhuellas_front/theme/AppColors.dart';
import 'package:cafeconhuellas_front/utils/api_conector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HelpScreen extends StatelessWidget {

  const HelpScreen({super.key});
    Widget _dateSelector({
      required String label,
      required DateTime date,
      required VoidCallback onTap,
      bool isOptional = false,
      VoidCallback? onClear,
    }) {
      return InkWell(
        onTap: onTap,
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
            Expanded(
              child: Text(
                isOptional && onClear == null
                    ? label
                    : '${label}: ${date.day.toString().padLeft(2,'0')}/${date.month.toString().padLeft(2,'0')}/${date.year}',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            if (onClear != null)
              GestureDetector(
                onTap: onClear,
                child: const Icon(Icons.close, size: 16, color: Colors.grey),
              )
            else
              const Text('Cambiar', style: TextStyle(color: Color(0xFF7B3FE4), fontSize: 12)),
          ]),
        ),
      );
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column (
          children: [
            AppHeader(userImageUrl: "assets/user.png"),
            //banner
            Image.asset("assets/images/banners/banner-inicio.png", width: double.infinity, height: 400, fit:BoxFit.cover),
            const SizedBox(height: 60),
            //TITULO
            _title("¿Cómo puedes ayudar?"),
            //INTRO
            Padding(padding: const EdgeInsets.symmetric(horizontal: 60.0),
                    child:Wrap(
                      spacing: 40,
                      runSpacing: 40,
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                         /// CARD TEXTO
                        _card(
                            child: const Text(
                            "Hay muchas formas de colaborar con nuestra protectora, "
                           "cada pequeña acción ayuda a cambiar la vida de nuestros animales.",
                            textAlign: TextAlign.center,
                            ),
                          ),
                        //CARD LINKS
                        _card(
                          child: Column(
                          children: [
                          _link(context, "Voluntariado"),
                          _link(context, "Casa de acogida"),
                          _link(context, "Paseos"),
                          _link(context, "Apadrinamiento"),
                            ],
                          ),
                        ),
                        const SizedBox(height: 80),
                        //VOLUNTARIADO
                        _helpSection(
                          context,
                          title: "Voluntariado",
                          image: "assets/images/help_section/volunteering.jpg",
                          text: "Colabora con nosotros ayudando en el cuidado diario.",
                          button: "Quiero ser voluntario",
                          reverse: false,
                          relation: "VOLUNTARIADO",
                        ),
                        //CASA DE ACOGIDA
                        _helpSection(
                          context,
                          title: "Casa de acogida",
                          image: "assets/images/help_section/petfoster.jpg",
                          text: "Ofrece tu hogar temporalmente a un animal.",
                          button: "Ofrecer acogida",
                          reverse: true,
                          relation: "CASA_DE_ACOGIDA",
                        ),  
                        //PASEOS
                        _helpSection(
                          context,
                          title: "Paseos",
                          image: "assets/images/help_section/walks.jpg",
                          text: "Ayuda a nuestros perros saliendo a pasear.",
                          button: "Apuntarme a paseos",
                          reverse: false,
                          relation: "PASEO",
                        ),
                        //APADRINAMIENTO
                        _helpSection(
                          context,
                          title: "Apadrinamiento",
                          image: "assets/images/help_section/sponsorship.jpg",
                          text: "Contribuye económicamente al cuidado de un animal.",
                          button: "Apadrinar",
                          reverse: true,
                          relation: "APADRINAMIENTO",
                        ),
                        const SizedBox(height: 100),
                        
                        ]
                      )
                    ),
                    AppFooter()
                  ],
                )
      ),
    );
  }
    Future<void> _showRelationshipDialog(BuildContext context, String tipoRelacion) async {
    // comprobamos si el usuario está logueado
    final authState = context.read<AuthBloc>().state;
    if (!authState.isAuthenticated || authState.user == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('¡Necesitas una cuenta!',
              style: TextStyle(fontFamily: 'MilkyVintage', fontSize: 22)),
          content: const Text(
            'Para poder ayudarnos necesitas estar registrado e iniciar sesión primero.',
            textAlign: TextAlign.center,
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
              onPressed: () {
                Navigator.pop(ctx);
                context.go('/login');
              },
              child: const Text('Iniciar sesión / Registrarse'),
            ),
          ],
        ),
      );
      return;
    }
    // si está logueado cargamos las mascotas y mostramos el diálogo
    List<Pet> pets = [];
    context.read<PetsBloc>().state.pets
    .where((p) => p.adoptionStatus == 'NO_ADOPTADO')
    .toList();
    if (!context.mounted) return;
    DateTime startDate = DateTime.now();
    DateTime? endDate;
    Pet? selectedPet = pets.isNotEmpty ? pets.first : null;
    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(tipoRelacion,
              style: const TextStyle(fontFamily: 'MilkyVintage', fontSize: 22,
                  color: Color(0xFF7B3FE4))),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // mascota
                if (pets.isEmpty)
                  const Text('No hay mascotas disponibles.')
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.purple[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.purple.shade200),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<Pet>(
                        value: selectedPet,
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF7B3FE4)),
                        items: pets.map((p) => DropdownMenuItem(
                          value: p,
                          child: Text(p.name),
                        )).toList(),
                        onChanged: (v) => setState(() => selectedPet = v),
                      ),
                    ),
                  ),
                const SizedBox(height: 12),

                // fecha inicio
                _dateSelector(
                  label: 'Fecha de inicio',
                  date: startDate,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: DateTime.now().subtract(const Duration(days: 1)),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now().subtract(const Duration(days: 1)),
                    );
                    if (picked != null) setState(() => startDate = picked);
                  },
                ),
                const SizedBox(height: 12),

                // fecha fin (opcional)
                _dateSelector(
                  label: 'Fecha de fin',
                  date: endDate ?? DateTime.now().add(const Duration(days: 1)),
                  onTap: () async {
                    final manana = DateTime.now().add(const Duration(days: 1));
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: endDate ?? manana,
                      firstDate: manana,
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) setState(() => endDate = picked);
                  },
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
              onPressed: selectedPet == null ? null : () async {
                if (endDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('La fecha de fin es obligatoria'),
                          backgroundColor: Colors.orange),
                    );
                    return;
                  }
                final relation = Userpetrelationship(
                  id: 0,
                  userId: authState.user!.id,
                  petId: selectedPet!.id,
                  relationshipType: tipoRelacion.toUpperCase().replaceAll(' ', '_'),
                  startDate: startDate,
                  endDate: endDate,
                  active: false, // el admin la activará cuando la acepte
                );
                try {
                  context.read<PetsBloc>().add(AddPetUserRelation(relation));
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('¡Solicitud enviada! Te avisaremos pronto ❤️'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                  );
                }
              },
              child: const Text('Enviar solicitud'),
            ),
          ],
        ),
      ),
    );
  }

 /// TITULO
  Widget _title(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 38,
          fontFamily: "WinkyMilky",
          color: AppColors.darkViolet,
        ),
      ),
    );
  }
  
  /// CARD
  Widget _card({required Widget child}) {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(35),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cream),
        color: Colors.white,
      ),
      child: child,
    );
  }

  /// LINK CARD
  Widget _link(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextButton(
        onPressed: () {},
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 28,
            fontFamily: "MilkyVintage",
            color: AppColors.green,
          ),
        ),
      ),
    );
  }

  /// SECCIÓN DE AYUDA
  Widget _helpSection(
    BuildContext context, {
    required String title,
    required String image,
    required String text,
    required String relation,
    required bool reverse,
    required String button,
  }) {
    final content = [
      /// IMAGEN
      ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          image,
          width: 380,
          height: 260,
          fit: BoxFit.cover,
        ),
      ),
      /// CARD INFO
      Container(
        width: 450,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.cream),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.brown,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                _showRelationshipDialog(context, relation);
              },
              child: Text(button),
            ),
          ],
        ),
      ),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 60),
      child: Column(
        children: [
          _title(title),
          Wrap(
            spacing: 60,
            runSpacing: 40,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: reverse ? content.reversed.toList() : content,
          ),
        ],
      ),
    );
  }
}
 