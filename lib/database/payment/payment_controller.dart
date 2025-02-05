import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:tontiflex/database/payment/payment_class.dart';
import 'package:tontiflex/database/payment/payment_service.dart';
import 'package:tontiflex/database/user_db/user_controller.dart';

class PaymentController extends ChangeNotifier {
  final PaymentServices _paymentServices = PaymentServices();
  List<Payment> _userPayments = [];

  Future<bool> makePayment(Payment payment) async {
    try {
      bool success = await _paymentServices.makePayment(payment);
      if (success) {
        notifyListeners();
      }
      return success;
    } catch (e) {
      print('Error making payment: $e');
      return false;
    }
  }

  Future<String> checkStatus(String paymentId) async {
    try {
      String status = await _paymentServices.checkPaymentStatus(paymentId);
      notifyListeners();
      return status;
    } catch (e) {
      print('Error checking payment status: $e');
      return 'Error';
    }
  }

  Future<List<Payment>> getPaymentsByUserId(String userId) async {
    try {
      List<Payment> payments = await _paymentServices.getPaymentsByUserId(userId);
      _userPayments = payments;
      notifyListeners();
      return payments;
    } catch (e) {
      print('Error fetching recent payments: $e');
      return [];
    }
  }
}
