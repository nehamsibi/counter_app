import 'package:counter3_app/bloc/counter_bloc.dart';
import 'package:counter3_app/data/repository.dart';
import 'package:counter3_app/ui/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  final CounterRepository counterRepository = CounterRepository();

  runApp(MyApp(counterRepository: counterRepository));
}

class MyApp extends StatelessWidget {
  final CounterRepository counterRepository;

  MyApp({required this.counterRepository});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => CounterBloc(repository: counterRepository),
        child: HomeScreen(),
      ),
    );
  }
}
