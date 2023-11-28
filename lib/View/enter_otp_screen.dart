import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_phone_auth_firebase/Cubit/auth_cubit.dart';
import 'package:flutter_bloc_phone_auth_firebase/Cubit/auth_state.dart';
import 'package:flutter_bloc_phone_auth_firebase/View/home_screen.dart';
import 'package:flutter_bloc_phone_auth_firebase/Widget/snackbar.dart';

class EnterOtpScreen extends StatefulWidget {
  const EnterOtpScreen({super.key});

  @override
  State<EnterOtpScreen> createState() => _EnterOtpScreenState();
}

class _EnterOtpScreenState extends State<EnterOtpScreen> {
  TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter Otp"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        child: Column(
          children: [
            SizedBox(height: height * 0.03),
            TextFormField(
              controller: otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "000000",
                labelText: "OTP",
              ),
            ),
            SizedBox(height: height * 0.03),
            BlocConsumer<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is AuthLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<AuthCubit>(context)
                          .verifyOtp(otpController.text);
                    },
                    style: ButtonStyle(
                      fixedSize: MaterialStatePropertyAll(
                        Size(width * 0.85, height * 0.07),
                      ),
                    ),
                    child: const Text("Verify"),
                  );
                }
              },
              listener: (context, state) {
                if (state is AuthLogInState) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                } else if (state is AuthErrorState) {
                  showCommonSnackBar(
                    context,
                    state.errorMessage,
                    Colors.red,
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
    otpController.dispose();
    super.dispose();
  }
}
