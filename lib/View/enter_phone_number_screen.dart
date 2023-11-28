import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_phone_auth_firebase/Cubit/auth_cubit.dart';
import 'package:flutter_bloc_phone_auth_firebase/Cubit/auth_state.dart';
import 'package:flutter_bloc_phone_auth_firebase/View/enter_otp_screen.dart';

class EnterPhoneNumberScreen extends StatefulWidget {
  const EnterPhoneNumberScreen({super.key});

  @override
  State<EnterPhoneNumberScreen> createState() => _EnterPhoneNumberScreenState();
}

class _EnterPhoneNumberScreenState extends State<EnterPhoneNumberScreen> {
  TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter Phone Number"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        child: Column(
          children: [
            SizedBox(height: height * 0.03),
            TextFormField(
              controller: phoneNumberController,
              keyboardType: TextInputType.number,
              maxLength: 10,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "00000 00000",
                labelText: "Phone Number",
              ),
            ),
            SizedBox(height: height * 0.03),
            BlocConsumer<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is AuthLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return ElevatedButton(
                    onPressed: () {
                      String phoneNumber = phoneNumberController.text;

                      if (!phoneNumber.startsWith('+')) {
                        phoneNumber = '+44$phoneNumber';
                        log("PHONE NUMBER ======== $phoneNumber");
                      }

                      BlocProvider.of<AuthCubit>(context).sendOtp(phoneNumber);
                    },
                    style: ButtonStyle(
                      fixedSize: MaterialStatePropertyAll(
                        Size(width * 0.85, height * 0.07),
                      ),
                    ),
                    child: const Text("Send OTP"),
                  );
                }
              },
              listener: (context, state) {
                if (state is AuthCodeSentState) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EnterOtpScreen(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }
}
