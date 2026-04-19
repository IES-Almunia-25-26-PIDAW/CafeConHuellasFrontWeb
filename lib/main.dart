
import 'package:cafeconhuellas_front/presentation/bloc/pet_bloc.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_event.dart';
import 'package:cafeconhuellas_front/presentation/bloc/auth_bloc.dart';
import 'package:cafeconhuellas_front/utils/api_conector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/app_router.dart';
import 'config/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(ApiConector()),
        ),
       BlocProvider(
          // Anteriormente lo hacíamos en el router pero nos dimos cuenta que cada vez que entrábamos a la página  se creaba un nuevo bloc
          //así que inicializamos el bloc aquí para que esté disponible en toda la app y no se reinicie cada vez que entramos a la página de mascotas
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
