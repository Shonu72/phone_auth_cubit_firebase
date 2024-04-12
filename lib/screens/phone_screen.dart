import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_auth/cubit/auth_cubit.dart';
import 'package:phone_auth/cubit/auth_state.dart';
import 'package:phone_auth/screens/otp_screen.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Phone Page"),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: phoneController,
              maxLength: 10,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Phone Number',
              ),
            ),
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthCodeSentState) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OTPScreen()));
                }
              },
              builder: (context, state) {
                if (state is AuthLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }
                return CupertinoButton(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                  child: const Text("Next"),
                  onPressed: () {
                    String phoneNuber = "+91${phoneController.text}";
                    BlocProvider.of<AuthCubit>(context).sendOTP(phoneNuber);
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
