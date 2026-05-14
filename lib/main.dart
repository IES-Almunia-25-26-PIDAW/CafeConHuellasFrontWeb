import 'package:cafeconhuellas_front/presentation/bloc/pet_bloc.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_event.dart';
import 'package:cafeconhuellas_front/presentation/bloc/auth_bloc.dart';
import 'package:cafeconhuellas_front/utils/api_conector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'config/app_router.dart';
import 'config/app_theme.dart';

void main() {
  // Enables clean URLs (no hash) for web routing.
  usePathUrlStrategy();
  runApp(const MyApp());
}

/// Root widget of the application.
///
/// Initializes global BlocProviders so that
/// AuthBloc and PetsBloc are available throughout
/// the entire widget tree without being recreated
/// on every navigation.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(ApiConector()),
        ),
        BlocProvider(
          // Initialized here instead of in the router to avoid
          // creating a new bloc instance every time the pets page is visited.
          create: (context) => PetsBloc(api: ApiConector())..add(LoadPets())..add(LoadEvents()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: AppTheme().getTheme(),
        routerConfig: appRouter,
      ),
    );
  }
}