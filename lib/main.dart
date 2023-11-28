import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_phone_auth_firebase/Cubit/auth_cubit.dart';
import 'package:flutter_bloc_phone_auth_firebase/Cubit/auth_state.dart';
import 'package:flutter_bloc_phone_auth_firebase/View/enter_phone_number_screen.dart';
import 'package:flutter_bloc_phone_auth_firebase/View/home_screen.dart';
import 'package:flutter_bloc_phone_auth_firebase/firebase_options.dart';

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
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<AuthCubit, AuthState>(
          buildWhen: (previous, current) {
            return previous is AuthInitialState;
          },
          builder: (context, state) {
            if (state is AuthLogInState) {
              return const HomeScreen();
            } else if (state is AuthLogOutState) {
              return const EnterPhoneNumberScreen();
            } else {
              return const Scaffold();
            }
          },
        ),
      ),
    );
  }
}
