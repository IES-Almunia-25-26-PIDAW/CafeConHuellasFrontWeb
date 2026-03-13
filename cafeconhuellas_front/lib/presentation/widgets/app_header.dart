import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppHeader extends StatelessWidget {
  final String userImageUrl;
  const AppHeader({super.key, required this.userImageUrl});


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isCompactHeader = screenWidth < 1100;
    final logoHeight = screenWidth < 900 ? 50.0 : screenWidth < 1200 ? 58.0 : 66.0;
    final navFontSize = screenWidth < 900 ? 16.0 : screenWidth < 1200 ? 20.0 : 24.0;
    final menuFontSize = screenWidth < 900 ? 15.0 : screenWidth < 1200 ? 19.0 : 22.0;
    final itemSpacing = screenWidth < 900 ? 12.0 : screenWidth < 1200 ? 25.0 : 30.0;
    final avatarRadius = screenWidth < 900 ? 17.0 : 20.0;

    return Container(
      height: screenWidth < 900 ? 74 : 84,
      padding: EdgeInsets.symmetric(horizontal: screenWidth < 900 ? 12 : 20),
      decoration: const BoxDecoration(
        color: Color(0xFFB39DDB),
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF7E57C2),
          ),
        ),
      ),
      child: Row(
        children: [
          //Logo
          GestureDetector(
            onTap: () {
              context.go('/');
            },
            child: Image.asset('assets/logo.png', height: logoHeight),
          ),
          SizedBox(width: itemSpacing),
          //Navegation
          Expanded(
            child: isCompactHeader
                ? LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minWidth: constraints.maxWidth),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _navItem(context, 'Inicio', '/', navFontSize),
                              SizedBox(width: itemSpacing),
                              _navItem(context, 'Eventos', '/events', navFontSize),
                              SizedBox(width: itemSpacing),
                              PopupMenuButton<String>(
                                child: Text(
                                  'La protectora ▾',
                                  style: TextStyle(fontSize: menuFontSize, fontFamily: 'WinkyMilky'),
                                ),
                                onSelected: (value) {
                                  context.go(value);
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: '/information',
                                    child: Text(
                                      'Informacion',
                                      style: TextStyle(fontSize: menuFontSize, fontFamily: 'WinkyMilky'),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: '/events',
                                    child: Text(
                                      'Eventos',
                                      style: TextStyle(fontSize: menuFontSize, fontFamily: 'WinkyMilky'),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: '/contact-us',
                                    child: Text(
                                      'Contacto',
                                      style: TextStyle(fontSize: menuFontSize, fontFamily: 'WinkyMilky'),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: itemSpacing),
                              PopupMenuButton<String>(
                                child: Text(
                                  'Actividades ▾',
                                  style: TextStyle(fontSize: menuFontSize, fontFamily: 'WinkyMilky'),
                                ),
                                onSelected: (value) {
                                  context.go(value);
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: '/help-us',
                                    child: Text(
                                      'Ayudas',
                                      style: TextStyle(fontSize: menuFontSize, fontFamily: 'WinkyMilky'),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: '/donations',
                                    child: Text(
                                      'Donaciones',
                                      style: TextStyle(fontSize: menuFontSize, fontFamily: 'WinkyMilky'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _navItem(context, 'Inicio', '/', navFontSize),
                        SizedBox(width: itemSpacing),
                        _navItem(context, 'Mascotas', '/pets', navFontSize),
                        SizedBox(width: itemSpacing),
                        PopupMenuButton<String>(
                          child: Text(
                            'La protectora ▾',
                            style: TextStyle(fontSize: menuFontSize, fontFamily: 'WinkyMilky'),
                          ),
                          onSelected: (value) {
                            context.go(value);
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: '/information',
                              child: Text(
                                'Informacion',
                                style: TextStyle(fontSize: menuFontSize, fontFamily: 'WinkyMilky'),
                              ),
                            ),
                            PopupMenuItem(
                              value: '/events',
                              child: Text(
                                'Eventos',
                                style: TextStyle(fontSize: menuFontSize, fontFamily: 'WinkyMilky'),
                              ),
                            ),
                            PopupMenuItem(
                              value: '/contact-us',
                              child: Text(
                                'Contacto',
                                style: TextStyle(fontSize: menuFontSize, fontFamily: 'WinkyMilky'),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: itemSpacing),
                        PopupMenuButton<String>(
                          child: Text(
                            'Actividades ▾',
                            style: TextStyle(fontSize: menuFontSize, fontFamily: 'WinkyMilky'),
                          ),
                          onSelected: (value) {
                            context.go(value);
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: '/help-us',
                              child: Text(
                                'Ayudas',
                                style: TextStyle(fontSize: menuFontSize, fontFamily: 'WinkyMilky'),
                              ),
                            ),
                            PopupMenuItem(
                              value: '/donations',
                              child: Text(
                                'Donaciones',
                                style: TextStyle(fontSize: menuFontSize, fontFamily: 'WinkyMilky'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
          SizedBox(width: itemSpacing),
          CircleAvatar(
            radius: avatarRadius,
            backgroundImage: AssetImage(userImageUrl),
          )
        ],
      ),
    );
  }
}

Widget _navItem(BuildContext context, String title, String route, double fontSize) {
  return GestureDetector(
    onTap: () {
      context.go(route);
    },
    child: Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: fontSize,
        fontFamily: 'WinkyMilky',
      ),
    ),
  );
}