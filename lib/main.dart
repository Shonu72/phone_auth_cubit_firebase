import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_auth/cubit/auth_cubit.dart';
import 'package:phone_auth/cubit/auth_state.dart';
import 'package:phone_auth/firebase_options.dart';
import 'package:phone_auth/screens/home_screen.dart';
import 'package:phone_auth/screens/phone_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => AuthCubit(),
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthLoggedInState) {
              return const HomeScreen();
            } else if (state is AuthLoggedOutState) {
              return const PhoneScreen();
            } else {
              return const Scaffold(
                body: Center(
                  child: Text("You are lost"),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
