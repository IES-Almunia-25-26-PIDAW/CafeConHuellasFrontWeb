import 'package:cafeconhuellas_front/presentation/widgets/app_footer.dart';
import 'package:cafeconhuellas_front/presentation/widgets/app_header.dart';
import 'package:cafeconhuellas_front/theme/AppColors.dart';
import 'package:flutter/material.dart';

class ContactusScreen extends StatefulWidget {
  const ContactusScreen({super.key});

  @override
  State<ContactusScreen> createState() => _ContactusScreenState();
}

class _ContactusScreenState extends State<ContactusScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();

  void sendForm() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mensaje enviado correctamente')),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppHeader(userImageUrl: 'assets/user.png'),

            // Banner
            Image.asset(
              'assets/images/banners/banner-inicio.png',
              width: double.infinity,
              height: 400,
              fit: BoxFit.cover,
            ),

            const SizedBox(height: 40),

            // Título
            const Text(
              '¿Alguna pregunta? ¡Contáctanos!',
              style: TextStyle(
                fontSize: 36,
                fontFamily: 'WinkyMilky',
                color: AppColors.darkViolet,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            // Columnas: formulario + info de contacto
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Wrap(
                spacing: 40,
                runSpacing: 40,
                alignment: WrapAlignment.center,
                children: [

                  /// FORMULARIO
                  SizedBox(
                    width: 400,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Escríbenos',
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'MilkyVintage',
                            color: AppColors.darkViolet,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: AppColors.cream),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              TextField(
                                controller: nameController,
                                decoration: const InputDecoration(
                                  labelText: 'Nombre',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: messageController,
                                maxLines: 5,
                                decoration: const InputDecoration(
                                  labelText: 'Mensaje',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.darkViolet,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: sendForm,
                                  child: const Text('Enviar', style: TextStyle(fontSize: 16)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// INFORMACIÓN DE CONTACTO
                  SizedBox(
                    width: 340,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Otras formas de contacto',
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'MilkyVintage',
                            color: AppColors.darkViolet,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: AppColors.cream),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _infoRow(Icons.email_outlined, 'contacto@protectora.com'),
                              const SizedBox(height: 12),
                              _infoRow(Icons.phone_outlined, '+34 600 123 456'),
                              const SizedBox(height: 24),
                              const Text(
                                'Síguenos en redes',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.darkViolet,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  _socialChip(Icons.camera_alt_outlined, 'Instagram'),
                                  _socialChip(Icons.facebook_outlined, 'Facebook'),
                                  _socialChip(Icons.alternate_email, 'Twitter'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 60),
            const AppFooter(),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
  return Row(
    children: [
      Icon(icon, color: AppColors.darkViolet, size: 20),
      const SizedBox(width: 10),
      Flexible(  // <- añade Flexible aquí
        child: Text(text, style: const TextStyle(fontSize: 15)),
      ),
    ],
  );
}

Widget _socialChip(IconData icon, String label) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: AppColors.vanilla,
      border: Border.all(color: AppColors.cream),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min, // <- que el Row no ocupe todo el ancho
      children: [
        Icon(icon, size: 18, color: AppColors.darkViolet),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.darkViolet)),
      ],
    ),
  );
}
}