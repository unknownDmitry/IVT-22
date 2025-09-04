import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'gravity_cubit.dart';
import 'main_screen.dart';

class MainScreenProvider extends StatelessWidget {
  const MainScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GravityCubit(),
      child: MainScreen(),
    );
  }
}
