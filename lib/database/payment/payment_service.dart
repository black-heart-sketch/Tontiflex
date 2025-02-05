import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:tontiflex/database/payment/payment_class.dart';

class PaymentServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  Future<bool> makePayment(Payment payment) async {
    try {
      await _firestore.collection('payments').add(payment.toJson());
      _logger.i('Payment successfully added for user: ${payment.userId}');
      return true;
    } catch (e) {
      _logger.e('Error making payment: $e');
      return false;
    }
  }

  Future<String> checkPaymentStatus(String paymentId) async {
    try {
      DocumentSnapshot doc =
      await _firestore.collection('payments').doc(paymentId).get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return data['status'] ?? 'Unknown';
      } else {
        return 'Not Found';
      }
    } catch (e) {
      _logger.e('Error checking payment status: $e');
      return 'Error';
    }
  }

  Future<List<Payment>> getPaymentsByUserId(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('payments')
          .where('userId', isEqualTo: userId)
          .get();

      List<Payment> payments = snapshot.docs
          .map((doc) => Payment.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      _logger.i('Fetched payments for user $userId: $payments');
      return payments;
    } catch (e) {
      _logger.e('Error fetching payments for user $userId: $e');
      return [];
    }
  }
}
