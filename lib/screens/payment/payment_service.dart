import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart' as mobile;
import 'package:flutter/foundation.dart';
import 'package:razorpay_web/razorpay_web.dart' as web;

class PaymentService {
  final mobile.Razorpay _razorpay = mobile.Razorpay();
  late web.Razorpay _web;

  Function(mobile.PaymentSuccessResponse)? _mobileSuccess;
  Function(mobile.PaymentFailureResponse)? _mobileError;
  Function(mobile.ExternalWalletResponse)? _mobileExternalWallet;

  Function(web.PaymentSuccessResponse)? _webSuccess;
  Function(web.PaymentFailureResponse)? _webError;
  Function(web.ExternalWalletResponse)? _webExternalWallet;

  void init({
    Function(mobile.PaymentSuccessResponse)? onMobileSuccess,
    Function(mobile.PaymentFailureResponse)? onMobileError,
    Function(mobile.ExternalWalletResponse)? onMobileExternalWallet,
    Function(web.PaymentSuccessResponse)? onWebSuccess,
    Function(web.PaymentFailureResponse)? onWebError,
    Function(web.ExternalWalletResponse)? onWebExternalWallet,
  }) {
    if (kIsWeb) {
      // Initialize Razorpay for web
      _web = web.Razorpay();
      _webSuccess = onWebSuccess;
      _webError = onWebError;
      _webExternalWallet = onWebExternalWallet;
      debugPrint("Initializing Razorpay for web");
      _web.on(web.RazorpayEvents.EVENT_PAYMENT_SUCCESS, _webSuccess as Function(web.PaymentSuccessResponse));
      _web.on(web.RazorpayEvents.EVENT_PAYMENT_ERROR, _webError as Function(web.PaymentFailureResponse));
      _web.on(web.RazorpayEvents.EVENT_EXTERNAL_WALLET, _webExternalWallet as Function(web.ExternalWalletResponse));
    } else {
      _mobileSuccess = onMobileSuccess;
      _mobileError = onMobileError;
      _mobileExternalWallet = onMobileExternalWallet;

      _razorpay.on(mobile.Razorpay.EVENT_PAYMENT_SUCCESS, _mobileSuccess!);
      _razorpay.on(mobile.Razorpay.EVENT_PAYMENT_ERROR, _mobileError!);
      _razorpay.on(mobile.Razorpay.EVENT_EXTERNAL_WALLET, _mobileExternalWallet!);
    }

    // For web, callbacks are handled directly in openCheckout method
  }

  Future<String> createOrder({required double amount}) async {
    // Create an order with our firebase function
    final url = Uri.parse("https://asia-south1-ecommerce-50a07.cloudfunctions.net/createOrder");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'amount': (amount * 100).toInt(), // Amount in paise
        'currency': 'INR',
      })
    );

    final data = jsonDecode(response.body);
    return data['id']; // Return the order ID
    
  }

  Future<void> openCheckout({
    required double amount,
    required String name,
    required String description,
    required String contact,
    required String email,
  }) async {
    final orderId = await createOrder(amount: amount); 
    var options = {

      'key': 'rzp_test_ls7IwqX7O8o1EY',
      'amount': amount * 100, // Amount in paise
      'currency': "INR",
      'name': name, // Your business name
      'description': description, // Product description
      'order_id': orderId, // Order ID from your backend
      'prefill': {
        'contact': contact,
        'email': email,
      },
      'external': {
        'wallets': ['paytm'], // List of wallets to show
      },
    };

    // Open the Razorpay checkout
    try {
      kIsWeb ? _web.open(options) : _razorpay.open(options);
    } catch (e) {
      // Handle any errors that occur while opening the checkout
      log("Error opening Razorpay checkout: $e");
    }
    return;
  }

  void dispose() {
    if (!kIsWeb) {
      // Unsubscribe from Razorpay events
      _razorpay.clear();
    } else {
      _web.clear();
    }
  }
}
