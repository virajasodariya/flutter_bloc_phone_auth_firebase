import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_phone_auth_firebase/Cubit/auth_cubit.dart';
import 'package:flutter_bloc_phone_auth_firebase/Cubit/auth_state.dart';
import 'package:flutter_bloc_phone_auth_firebase/View/enter_phone_number_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "jcb",
              style: TextStyle(fontSize: 22),
            ),
            SizedBox(height: height * 0.03),
            const Text(
              "Phone Number",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: height * 0.03),
            BlocConsumer<AuthCubit, AuthState>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<AuthCubit>(context).logOut();
                  },
                  style: ButtonStyle(
                    fixedSize: MaterialStatePropertyAll(
                      Size(width * 0.85, height * 0.07),
                    ),
                  ),
                  child: const Text("Log Out"),
                );
              },
              listener: (context, state) {
                if (state is AuthLogOutState) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EnterPhoneNumberScreen(),
                    ),
                  );
                }
              },
            ),
            SizedBox(height: height * 0.03),
          ],
        ),
      ),
    );
  }
}
