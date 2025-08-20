// ignore_for_file: prefer_const_constructors
import 'package:ecommerce/screens/cart/views/cart_screen.dart';
import 'package:ecommerce/screens/order/my_orders.dart';
import 'package:ecommerce/user/bloc/user_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:flutter_svg/flutter_svg.dart';

AppBar appBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    title: Text(
      'Jeelani Collection',
      style: TextStyle(
          color: Colors.black, fontSize: 22, fontWeight: FontWeight.w600),
    ),

    // leading: InkWell(
    //   onTap: (){},
    //   hoverColor: Colors.white,
    //   child: Container(
    //     margin: EdgeInsets.all(8),
    //     alignment: Alignment.center,
    //     decoration: BoxDecoration(
    //       color: Color(0xffF7F8F8),
    //       borderRadius: BorderRadius.circular(10)),
    //     child: SvgPicture.asset(
    //       'assets/icons/Arrow-Left.svg',
    //       height: 25,
    //       width: 25,
    //     ),
    //   ),
    // ),

    actions: [
      InkWell(
        onTap: () {},
        // hoverColor: Colors.white,
        child: Container(
          margin: EdgeInsets.all(10),
          alignment: Alignment.center,
          width: 37,
          decoration: BoxDecoration(
              // color: Color(0xffF7F8F8),
              borderRadius: BorderRadius.circular(10)),
          // child: Icon(CupertinoIcons.search,size: 27,),
          child: SvgPicture.asset(
            'assets/icons/search.svg',
            height: 25,
            // set color black
            colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
            width: 25,
          ),
        ),
      ),
      // InkWell(
      //   onTap: () {
      //     Navigator.push(context, MaterialPageRoute(builder: (context) => MyOrdersScreen(),));
      //   },
      //   child: Container(
      //     margin: EdgeInsets.all(10),
      //     alignment: Alignment.center,
      //     child: Icon(Icons.shopping_bag_outlined,size: 27,),
      //   ),
      // ),

      // InkWell(
      //   onTap: (){},
      //   child: Container(
      //     margin: EdgeInsets.all(10),
      //     alignment: Alignment.center,
      //     // User profile icon
      //     child: Icon(Icons.person_outline,size: 27,),
      //   ),
      // ),

      // If user is logged in, show profile icon, otherwise show cart icon

      context.read<UserBloc>().state is UserLoggedIn
          ? InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyOrdersScreen()),
                );
              },
              child: Container(
                margin: EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Icon(Icons.person_outline, size: 27),
              ),
            )
          : InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartScreen(),
                    ));
              },
              child: Container(
                margin: EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.black,
                  size: 27,
                ),
              ),
            ),

      IconButton(
        icon:
            const Icon(CupertinoIcons.arrow_right_to_line, color: Colors.black),
        onPressed: () async {
          // Ask for confirmation first
          final bool? confirm = await showDialog<bool>(
            context: context,
            barrierDismissible:
                false, // must tap one of the buttons—prevents accidental close
            builder: (ctx) => AlertDialog(
              title: const Text('Sign out?'),
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.circular(10),
              // ),
              contentPadding: const EdgeInsets.all(20),
              content: const Text(
                  'Are you sure you want to log out of your account?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: const Text(
                    'Sign out',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          );

          // If the user confirmed, proceed with sign‑out
          if (confirm == true) {
            await FirebaseAuth.instance.signOut();

            // Optional: notify and/or navigate elsewhere
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Signed out')),
              );
            }
          }
        },
      ),

      SizedBox(width: 10), // Add some space between icons
    ],
  );
}
