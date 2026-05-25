import 'package:flutter/material.dart';

/// Screen displayed when the user's session has expired.
///
/// Informs the user that their session is no longer valid
/// and prompts them to log in again.
class SessionExpiredScreen extends StatelessWidget {
  /// Creates the session expired screen widget.
  const SessionExpiredScreen({super.key});

  /// Builds the session expired screen UI.
  ///
  /// Layout structure:
  /// - App bar with screen title.
  /// - Centered expiry message.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// App bar displaying the screen title.
      appBar: AppBar(
        title: const Text('Sesion expirada'),
      ),
      /// Centered session expired message.
      body: const Center(
        child: Text('Tu sesion ha expirado. Inicia sesion de nuevo.'),
      ),
    );
  }
}