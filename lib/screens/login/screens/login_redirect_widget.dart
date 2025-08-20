// import 'package:ecommerce/screens/login/screens/login_bottomsheet.dart';
// import 'package:flutter/material.dart';

// class LoginRedirectWidget extends StatefulWidget {
//   const LoginRedirectWidget({
//     super.key,
//   });

//   @override
//   State<LoginRedirectWidget> createState() => LoginRedirectWidgetState();
// }

// class LoginRedirectWidgetState extends State<LoginRedirectWidget> {
//   bool _isSheetOpen = false;
//   @override
//   void initState() {
//     super.initState();

//     // Automatically show login bottom sheet if not logged in
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!_isSheetOpen) {
//         _isSheetOpen = true;
//         showModalBottomSheet(
//           context: context,
//           isScrollControlled: true,
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//           ),
//           builder: (context) => const LoginBottomSheet(),
//         ).whenComplete(() {
//           // Reset flag when sheet is closed
//           _isSheetOpen = false;
//           // Optionally, you can refresh the state or perform other actions here
//           setState(() {});
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//         return Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.lock_outline, size: 64, color: Colors.grey),
//               const SizedBox(height: 16),
//               const Text("Please log in to view your profile"),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () {
//                   if (!_isSheetOpen){
//                   _isSheetOpen = true;
//                   showModalBottomSheet(
//                     context: context,
//                     isScrollControlled: true,
//                     shape: const RoundedRectangleBorder(
//                       borderRadius:
//                           BorderRadius.vertical(top: Radius.circular(25)),
//                     ),
//                     builder: (context) => const LoginBottomSheet(),
//                   ).whenComplete(() {
//                     _isSheetOpen = false;
//                   });
//                 }
//                   },  // Prevent multiple sheets
//                 child: const Text("Login"),
//               ),
//             ],
//           ),
//         );
//   }
// }

import 'package:ecommerce/screens/login/screens/login_bottomsheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginRedirectWidget extends StatefulWidget {
  const LoginRedirectWidget({super.key});
  

  // Check if user is logged in
  static bool isUserLoggedIn() {
    final user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  static bool _isSheetOpen = false;

  static void showLoginSheet(BuildContext context) {
    if (_isSheetOpen) return;

    _isSheetOpen = true;
    showModalBottomSheet(
      context: context,
      isScrollControlled:true, // keep this if you're using full height with keyboard
      isDismissible: false, // prevents closing when tapped outside
      enableDrag: false, // prevents swiping down to close
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => const LoginBottomSheet(),
    ).whenComplete(() {
      _isSheetOpen = false;
    });
  }

  @override
  State<LoginRedirectWidget> createState() => _LoginRedirectWidgetState();
}

class _LoginRedirectWidgetState extends State<LoginRedirectWidget> {
  // final user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();

    // Automatically show login bottom sheet if not logged in
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (!LoginRedirectWidget.isUserLoggedIn() && !LoginRedirectWidget._isSheetOpen) {
    //     LoginRedirectWidget.showLoginSheet(context);
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_outline, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text("Please log in to view your profile"),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => LoginRedirectWidget.showLoginSheet(context),
            child: const Text("Login"),
          ),
        ],
      ),
    );
  }
}
