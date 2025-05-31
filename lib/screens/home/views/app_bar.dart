 // ignore_for_file: prefer_const_constructors
import 'package:ecommerce/screens/cart/views/cart_screen.dart';
import 'package:ecommerce/screens/order/my_orders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
 
 AppBar appBar(BuildContext context) {
    return AppBar( 
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: Text(
        'Jeelani Collection',
        style: TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.w600
        ),
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
          onTap: (){},
          // hoverColor: Colors.white,
          child: Container(
            margin: EdgeInsets.all(10),
            alignment: Alignment.center,
            width: 37,
            decoration: BoxDecoration(
                // color: Color(0xffF7F8F8),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(CupertinoIcons.search,size: 27,),
            // child: SvgPicture.asset(
            //   'assets/icons/search.svg',
            //   height: 25,
            //   width: 25,
            // ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MyOrdersScreen(),));
          },
          child: Container(
            margin: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Icon(Icons.shopping_bag_outlined,size: 27,),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen(),));
          },
          child: Container(
            margin: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Icon(Icons.shopping_cart_outlined,size: 27,),
          ),
        ),
        // InkWell(
        //   onTap: (){},
        //   child: Container(
        //     margin: EdgeInsets.all(10),
        //     alignment: Alignment.center,
        //     // User profile icon
        //     child: Icon(Icons.person_outline,size: 27,),
        //   ),
        // ),
        SizedBox(width: 10,)
      ],
    );
  }