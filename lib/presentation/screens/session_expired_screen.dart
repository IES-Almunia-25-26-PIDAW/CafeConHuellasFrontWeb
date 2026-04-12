import 'package:flutter/material.dart';

class SessionExpiredScreen extends StatelessWidget {
  const SessionExpiredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sesion expirada'),
      ),
      body: const Center(
        child: Text('Tu sesion ha expirado. Inicia sesion de nuevo.'),
      ),
    );
  }
}
