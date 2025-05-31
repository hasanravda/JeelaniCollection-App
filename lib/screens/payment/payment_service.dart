import 'dart:developer';
import 'package:razorpay_flutter/razorpay_flutter.dart' as mobile;
import 'package:flutter/foundation.dart';
import 'package:razorpay_web/razorpay_web.dart' as web;

class PaymentService {
  late mobile.Razorpay _razorpay;
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

  void openCheckout({
    required double amount,
    required String name,
    required String description,
    required String contact,
    required String email,
  }) {
    var options = {
      'key': 'rzp_test_ls7IwqX7O8o1EY',
      'amount': amount * 100, // Amount in paise
      'currency': "INR",
      'name': name, // Your business name
      'description': description, // Product description
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
      if (kIsWeb) {
        // Web platform - use flutter_web with stored callbacks
        _web.open(options);
      } else {
        _razorpay.open(options);
      }
    } catch (e) {
      // Handle any errors that occur while opening the checkout
      log("Error opening Razorpay checkout: $e");
    }
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
