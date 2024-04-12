import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_auth/cubit/auth_cubit.dart';
import 'package:phone_auth/cubit/auth_state.dart';
import 'package:phone_auth/screens/phone_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Center(
        child: Column(
          children: [
            const Text("You are logged in"),
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthLoggedOutState) {
                  Navigator.popUntil(context, (route) => route.isFirst);
                }
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PhoneScreen()));
              },
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<AuthCubit>(context).logout();
                  },
                  child: const Text("Log Out"),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
