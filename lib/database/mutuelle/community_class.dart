import 'package:tontiflex/database/user_db/user_class.dart';

class Community {
  String? id;
  String? name;
  List<dynamic>? members;
  String? freqContribution;
  String? amount;

  Community({
    this.id,
    this.name,
    this.members,
    this.freqContribution,
    this.amount
  });

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      id: json['id'],
      name: json['name'],
      members: json['members'],
      freqContribution: json['freqContribution'],
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'members': members,
      'freqContribution': freqContribution,
      'amount': amount,
    };
  }
}
