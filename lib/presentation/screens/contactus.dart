import 'package:cafeconhuellas_front/presentation/widgets/app_footer.dart';
import 'package:cafeconhuellas_front/presentation/widgets/app_header.dart';
import 'package:cafeconhuellas_front/theme/AppColors.dart';
import 'package:flutter/material.dart';

/// Screen that allows users to contact the organization.
///
/// This screen contains:
/// - A contact form.
/// - Alternative contact information.
/// - Social media links.
///
/// It also includes the application's shared
/// header and footer components.
class ContactusScreen extends StatefulWidget {
  /// Creates the contact screen widget.
  const ContactusScreen({super.key});
  @override
  State<ContactusScreen> createState() =>
      _ContactusScreenState();
}

/// State class responsible for managing:
/// - Form controllers.
/// - Form submission.
/// - Widget lifecycle.
class _ContactusScreenState
    extends State<ContactusScreen> {
  /// Controller used for the name input field.
  final nameController = TextEditingController();
  /// Controller used for the email input field.
  final emailController = TextEditingController();
  /// Controller used for the message input field.
  final messageController = TextEditingController();
  /// Handles contact form submission.
  ///
  /// Currently displays a confirmation snackbar.
  /// This method can later be connected to
  /// a backend API or email service.
  void sendForm() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Mensaje enviado correctamente',
        ),
      ),
    );
  }
  /// Releases all text controllers when
  /// the widget is removed from memory.
  ///
  /// Prevents memory leaks.
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    messageController.dispose();

    super.dispose();
  }
  /// Builds the contact screen UI.
  ///
  /// Layout structure:
  /// - Application header.
  /// - Banner image.
  /// - Contact form.
  /// - Contact information section.
  /// - Application footer.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Shared application header.
            AppHeader(
              userImageUrl: 'assets/user.png',
            ),
            /// Main banner image.
            Image.asset(
              'assets/images/banners/banner-inicio.png',
              width: double.infinity,
              height: 400,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 40),
            /// Main screen title.
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
            /// Main responsive content section.
            ///
            /// Uses a Wrap widget to adapt properly
            /// on smaller screen sizes.
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
              ),
              child: Wrap(
                spacing: 40,
                runSpacing: 40,
                alignment: WrapAlignment.center,
                children: [
                  /// CONTACT FORM SECTION
                  SizedBox(
                    width: 400,
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        /// Contact form title.
                        const Text(
                          'Escríbenos',
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'MilkyVintage',
                            color: AppColors.darkViolet,
                          ),
                        ),
                        const SizedBox(height: 16),
                        /// Contact form container.
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: AppColors.cream,
                            ),
                            borderRadius:
                                BorderRadius.circular(12),
                          ),

                          child: Column(
                            children: [
                              /// Name input field.
                              TextField(
                                controller: nameController,
                                decoration:
                                    const InputDecoration(
                                  labelText: 'Nombre',
                                  border:
                                      OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 16),
                              /// Email input field.
                              TextField(
                                controller:
                                    emailController,
                                keyboardType:
                                    TextInputType
                                        .emailAddress,
                                decoration:
                                    const InputDecoration(
                                  labelText: 'Email',
                                  border:
                                      OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 16),
                              /// Message input field.
                              TextField(
                                controller:
                                    messageController,
                                maxLines: 5,
                                decoration:
                                    const InputDecoration(
                                  labelText: 'Mensaje',
                                  border:
                                      OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 20),
                              /// Submit button.
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style:
                                      ElevatedButton
                                          .styleFrom(
                                    backgroundColor:
                                        AppColors
                                            .darkViolet,
                                    foregroundColor:
                                        Colors.white,
                                    padding:
                                        const EdgeInsets
                                            .symmetric(
                                      vertical: 16,
                                    ),
                                    shape:
                                        RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        10,
                                      ),
                                    ),
                                  ),

                                  onPressed: sendForm,

                                  child: const Text(
                                    'Enviar',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// CONTACT INFORMATION SECTION
                  SizedBox(
                    width: 340,
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [

                        /// Contact information title.
                        const Text(
                          'Otras formas de contacto',
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'MilkyVintage',
                            color: AppColors.darkViolet,
                          ),
                        ),

                        const SizedBox(height: 16),

                        /// Contact information container.
                        Container(
                          width: double.infinity,
                          padding:
                              const EdgeInsets.all(24),

                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: AppColors.cream,
                            ),
                            borderRadius:
                                BorderRadius.circular(12),
                          ),

                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              /// Email information row.
                              _infoRow(
                                Icons.email_outlined,
                                'contacto@protectora.com',
                              ),
                              const SizedBox(height: 12),
                              /// Phone information row.
                              _infoRow(
                                Icons.phone_outlined,
                                '+34 600 123 456',
                              ),
                              const SizedBox(height: 24),
                              /// Social media section title.
                              const Text(
                                'Síguenos en redes',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.w600,
                                  color:
                                      AppColors.darkViolet,
                                ),
                              ),
                              const SizedBox(height: 12),
                              /// Social media chips container.
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  _socialChip(
                                    Icons.camera_alt_outlined,
                                    'Instagram',
                                  ),
                                  _socialChip(
                                    Icons.facebook_outlined,
                                    'Facebook',
                                  ),
                                  _socialChip(
                                    Icons.alternate_email,
                                    'Twitter',
                                  ),
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
            /// Shared application footer.
            const AppFooter(),
          ],
        ),
      ),
    );
  }

  /// Creates a reusable information row
  /// with an icon and descriptive text.
  ///
  /// Used for displaying:
  /// - Email.
  /// - Phone number.
  Widget _infoRow(
    IconData icon,
    String text,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.darkViolet,
          size: 20,
        ),
        const SizedBox(width: 10),
        /// Flexible prevents overflow issues
        /// on smaller screen sizes.
        Flexible(
          child: Text(
            text,
            style: const TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }

  /// Creates a reusable social media chip.
  ///
  /// Displays:
  /// - Social media icon.
  /// - Platform label.
  Widget _socialChip(
    IconData icon,
    String label,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),

      decoration: BoxDecoration(
        color: AppColors.vanilla,
        border: Border.all(
          color: AppColors.cream,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center,
        /// Prevents the row from occupying
        /// the full available width.
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: AppColors.darkViolet,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.darkViolet,
            ),
          ),
        ],
      ),
    );
  }
}