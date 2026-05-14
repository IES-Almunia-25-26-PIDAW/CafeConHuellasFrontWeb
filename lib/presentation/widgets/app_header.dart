import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

/// Responsive top navigation bar displayed across all pages.
///
/// Shows the app logo, navigation links, dropdown menus,
/// and the user avatar. Adapts its layout based on screen width:
/// - Below 1100px: horizontally scrollable compact nav.
/// - Above 1100px: centered full nav row.
class AppHeader extends StatelessWidget {
  /// Fallback avatar image path used when no user is logged in.
  final String userImageUrl;
  const AppHeader({super.key, this.userImageUrl = "assets/user.png"});

  @override
  Widget build(BuildContext context) {
    // Responsive sizing based on screen width.
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
          // Logo — tapping navigates to home.
          GestureDetector(
            onTap: () {
              context.go('/');
            },
            child: Image.asset('assets/logo.png', height: logoHeight),
          ),
          SizedBox(width: itemSpacing),
          // Navigation — compact (scrollable) or full row depending on width.
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
                              _navItem(context, 'Mascotas', '/pets', navFontSize),
                              SizedBox(width: itemSpacing),
                              // Dropdown: shelter info section.
                              PopupMenuButton<String>(
                                tooltip: '',
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
                                    value: '/contactus',
                                    child: Text(
                                      'Contacto',
                                      style: TextStyle(fontSize: menuFontSize, fontFamily: 'WinkyMilky'),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: itemSpacing),
                              // Dropdown: activities section.
                              PopupMenuButton<String>(
                                tooltip: '',
                                child: Text(
                                  'Actividades ▾',
                                  style: TextStyle(fontSize: menuFontSize, fontFamily: 'WinkyMilky'),
                                ),
                                onSelected: (value) {
                                  context.go(value);
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: '/helpus',
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
                        // Dropdown: shelter info section.
                        PopupMenuButton<String>(
                          tooltip: '',
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
                              value: '/contactus',
                              child: Text(
                                'Contacto',
                                style: TextStyle(fontSize: menuFontSize, fontFamily: 'WinkyMilky'),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: itemSpacing),
                        // Dropdown: activities section.
                        PopupMenuButton<String>(
                          tooltip: '',
                          child: Text(
                            'Actividades ▾',
                            style: TextStyle(fontSize: menuFontSize, fontFamily: 'WinkyMilky'),
                          ),
                          onSelected: (value) {
                            context.go(value);
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: '/helpus',
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
          // Avatar — navigates to profile if logged in, otherwise to login.
          GestureDetector(
            onTap: () {
              final authState = context.read<AuthBloc>().state;
              if (authState.isAuthenticated) {
                context.go('/profile');
              } else {
                context.go('/login');
              }
            },
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                // Resolves the avatar image: network if available, asset otherwise.
                final String resolvedImage =
                    (state.user?.imageUrl.isNotEmpty ?? false) ? state.user!.imageUrl : userImageUrl;
                final ImageProvider imageProvider = resolvedImage.startsWith('http')
                    ? NetworkImage(resolvedImage)
                    : AssetImage(resolvedImage) as ImageProvider;

                return CircleAvatar(
                  radius: avatarRadius,
                  backgroundImage: imageProvider,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
/// Helper that builds a tappable text navigation item.
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