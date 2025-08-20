// ignore_for_file: use_build_context_synchronously

import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:ecommerce/no_internet_screen.dart';
// import 'package:ecommerce/routes/app_route_config.dart';
import 'package:ecommerce/screens/home/blocs/get_product_bloc/get_product_bloc.dart';
import 'package:ecommerce/screens/home/views/home_screen.dart';
// import 'package:ecommerce/screens/home/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:product_repository/product_repository.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isConnected = true;

  @override
  void initState() {
    super.initState();
    // Check for initial internet connectivity
    _checkInternetConnection();
    // Listen for network status changes
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        isConnected = result != ConnectivityResult.none;
      });
    });

  }

  Future<void> _checkInternetConnection() async {
    final result = await Connectivity().checkConnectivity();
    setState(() {
      isConnected = result != ConnectivityResult.none;
    });
    // var connectivityResult = await Connectivity().checkConnectivity();
    // if (connectivityResult == ConnectivityResult.none) {
    //   debugPrint("No connection");
    //   setState(() {
    //     isConnected = false;
    //   });
    // }

    //  else {
    //   debugPrint("connected");
    //   setState(() {
    //     isConnected = true;
    //   });
    // }
    
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetProductBloc(
        FirebaseProductRepo(), // Initialize with your repository
      )..add(GetProduct()), // Add the initial event to fetch products
      child: MaterialApp(
        // routerConfig: isConnected? MyAppRouter().router:_noInternetRouter, // Initialize your router
        title: 'Jeelani Collection',
        theme: ThemeData(
          fontFamily: 'Poppins',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: isConnected
            ? BlocBuilder<GetProductBloc, GetProductState>(
                builder: (context, state) {
                  if (state is GetProductSuccess) {
                    return const HomeScreen(); // Products successfully loaded
                  } else if (state is GetProductLoading) {
                    return const HomeScreen(); // Keep showing home while loading products
                  } else if (state is GetProductFailure) {
                    return _buildFailureUI(
                        context); // Show failure UI with retry
                  }
                  return const Center(
                      child:
                          CircularProgressIndicator()); // Default loading state
                },
              )
            : _buildFailureUI(
                context), // Show failure UI when no internet connection
      ),
    );
  }

  // Failure UI with animation and retry button
  Widget _buildFailureUI(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lottie animation for error
            Lottie.asset(
              'assets/animations/failed-animation.json', // Lottie animation file
              width: 300,
              height: 300,
              repeat: true,
            ),
            const SizedBox(height: 20),
            const Text(
              'Oops! Failed to load products. Please check your internet connection.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Ink(
              child: ElevatedButton(
                onPressed: () {
                  // Retry to load products
                  _checkInternetConnection();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                child: const Text(
                  'Retry',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// separate fallback GoRouter when there's no internet
// final _noInternetRouter = GoRouter(
//   routes: [
//     GoRoute(
//       path: '/',
//       builder: (_, __) =>
//           NoInternetScreen(), // Show failure UI when no internet connection
//     )
//   ],
// );
