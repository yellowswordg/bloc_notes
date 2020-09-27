import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/blocs.dart';

import 'blocs/blocs.dart';
import 'config/themes.dart';
import 'repositories/repositories.dart';
import 'screens/home_screen.dart';

void main() {
  // BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ThemeBloc(
              ThemeState(themeData: Themes.themeData[AppTheme.LightTheme])),
        ),
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(
            authRepository: AuthRepository(),
          )..add(AppStarted()),
        ),
        BlocProvider<NotesBloc>(
          create: (_) => NotesBloc(
              authRepository: AuthRepository(),
              notesRepository: NotesRepository()),
        )
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Bloc Notes',
            theme: state.themeData,
            home: HomeScreen(),
          );
        },
      ),
    );
  }
}
