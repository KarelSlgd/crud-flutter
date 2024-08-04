import 'package:crudsito/presentation/cubit/auto_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repository/auto_repository.dart';
import 'presentation/screens/get_all_autos_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AutoRepository>(
          create: (context) => AutoRepository(
              apiUrl:
                  'https://db3jebyot6.execute-api.us-east-1.amazonaws.com/Prod'),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AutoCubit>(
            create: (context) => AutoCubit(
              autoRepository: RepositoryProvider.of<AutoRepository>(context),
            ),
          ),
        ],
        child: const MaterialApp(
          title: 'Auto CRUD',
          debugShowCheckedModeBanner: false,
          home: AutoListView(),
        ),
      ),
    );
  }
}
