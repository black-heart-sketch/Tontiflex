import 'package:logger/logger.dart';

class Payment {
  final String userId;
  final String description;
  final String amount;
  final String paymentMethod;
  final String? phoneNumber;
  final String? cardNumber;
  final String? cvv;
  final String? communityId; // Add this field

  Payment({
    required this.userId,
    required this.description,
    required this.amount,
    required this.paymentMethod,
    this.phoneNumber,
    this.cardNumber,
    this.cvv,
    this.communityId, // Add this field
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    Logger logger = Logger();
    return Payment(
      userId: json['id'].toString(),
      description: json['description'],
      amount: json['amount'].toString(),
      paymentMethod: json['paymentMethod'],
      phoneNumber: json['phoneNumber'],
      cardNumber: json['cardNumber'],
      cvv: json['cvv'],
        communityId:json['communityId']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'description': description,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'phoneNumber': phoneNumber,
      'cardNumber': cardNumber,
      'cvv': cvv,
      'communityId':communityId
    };
  }
}

class FundRetrieval {
  final String userId;
  final String amount;
  final String retrievalMethod;
  final String? phoneNumber;
  final String? bankAccount;

  FundRetrieval({
    required this.userId,
    required this.amount,
    required this.retrievalMethod,
    this.phoneNumber,
    this.bankAccount,
  });

  factory FundRetrieval.fromJson(Map<String, dynamic> json) {
    Logger logger = Logger();
    return FundRetrieval(
      userId: json['userId'].toString(),
      amount: json['amount'].toString(),
      retrievalMethod: json['retrievalMethod'],
      phoneNumber: json['phoneNumber'],
      bankAccount: json['bankAccount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': int.parse(userId),
      'amount': amount,
      'retrievalMethod': retrievalMethod,
      'phoneNumber': phoneNumber,
      'bankAccount': bankAccount,
    };
  }
}