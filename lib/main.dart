import 'package:flutter/material.dart';
import 'package:tic_tac_toe/bloc/app.bloc.dart';
import 'package:tic_tac_toe/pages/home.page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppBloc>.value(
          value: AppBloc(),
        ),
      ],
      child: const Main(),
    );
  }
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'D&C',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}