import 'package:intl/intl.dart';

enum CreditStatus { pending, approved, rejected }

class Credit {
  final int? id;
  final int userId;
  final double amount;
  final DateTime requestDate;
  final DateTime repaymentDate;
  final CreditStatus status;

  Credit({
    this.id,
    required this.userId,
    required this.amount,
    required this.requestDate,
    required this.repaymentDate,
    this.status = CreditStatus.pending,
  });

  factory Credit.fromJson(Map<String, dynamic> json) {
    return Credit(
      id: json['id'],
      userId: json['userId'],
      amount: double.parse(json['amount'].toString()),
      requestDate: DateTime.parse(json['requestDate']),
      repaymentDate: DateTime.parse(json['repaymentDate']),
      status: CreditStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => CreditStatus.pending,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'requestDate': requestDate.toIso8601String(),
      'repaymentDate': repaymentDate.toIso8601String(),
      'status': status.toString().split('.').last,
    };
  }

  String get formattedAmount {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    return formatter.format(amount);
  }

  String get formattedRequestDate {
    return DateFormat('yyyy-MM-dd').format(requestDate);
  }

  String get formattedRepaymentDate {
    return DateFormat('yyyy-MM-dd').format(repaymentDate);
  }

  Credit copyWith({
    int? id,
    int? userId,
    double? amount,
    DateTime? requestDate,
    DateTime? repaymentDate,
    CreditStatus? status,
  }) {
    return Credit(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      requestDate: requestDate ?? this.requestDate,
      repaymentDate: repaymentDate ?? this.repaymentDate,
      status: status ?? this.status,
    );
  }
}

