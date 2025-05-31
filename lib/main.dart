import 'package:ecommerce/app.dart';
import 'package:ecommerce/firebase_options.dart';
import 'package:ecommerce/screens/cart/bloc/cart_bloc.dart';
import 'package:ecommerce/simple_bloc_observer.dart';
import 'package:ecommerce/user/bloc/user_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp( MultiBlocProvider(
      providers: [
        BlocProvider<CartBloc>(
          create: (context) => CartBloc()..add(LoadCartEvent()),
        ),
        BlocProvider(create: (_) => UserBloc()..add(CheckUserLogin())),
        // Other bloc providers
      ],
      child: MyApp(),
    ),);
}

