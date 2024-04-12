import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_auth/cubit/auth_cubit.dart';
import 'package:phone_auth/cubit/auth_state.dart';
import 'package:phone_auth/screens/home_screen.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "OTP Screen",
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: otpController,
              maxLength: 6,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter OTP ',
              ),
            ),
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthLoggedInState) {
                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()));
                }
              },
              builder: (context, state) {
                if (state is AuthLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }
                return CupertinoButton(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                  child: const Text("Done"),
                  onPressed: () {
                    BlocProvider.of<AuthCubit>(context)
                        .verifyOTP(otpController.text);
                  },
                );
              },
            ),
          ],
        ),
      )),
    );
  }
}
