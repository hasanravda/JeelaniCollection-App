import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/firebase_options.dart';
import 'package:ecommerce/screens/cart/bloc/cart_bloc.dart';
import 'package:ecommerce/screens/splash_screen.dart';
import 'package:ecommerce/simple_bloc_observer.dart';
import 'package:ecommerce/user/bloc/user_bloc.dart';
// import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  // setUrlStrategy(PathUrlStrategy());
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // _initializeAppCheck();
  // FirebaseAppCheck.instance.activate(
  //   webProvider: ReCaptchaV3Provider('6Ld7YHwrAAAAAPDohdKqNOu1uyyJmzbSk8RVSQ6s'),
  //   androidProvider: AndroidProvider.playIntegrity,
  //   appleProvider: AppleProvider.appAttest,
  // );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<CartBloc>(
          create: (context) => CartBloc()..add(LoadCartEvent()),
        ),
        BlocProvider(create: (_) => UserBloc()..add(CheckUserLogin())),
        // Other bloc providers
      ],
      // child: MyApp(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-commerce App',
        home: SplashScreen(),
      ),
    ),
  );
}
// Future<void> _initializeAppCheck() async {
//   await FirebaseFirestore.instance.enableNetwork();

//   await Future.delayed(const Duration(milliseconds: 300));
//   FirebaseAppCheck.instance.activate(
//     webProvider: ReCaptchaV3Provider('6Ld7YHwrAAAAAPDohdKqNOu1uyyJmzbSk8RVSQ6s'),
//     androidProvider: AndroidProvider.debug,
//     appleProvider: AppleProvider.appAttest,
//   );
// }
