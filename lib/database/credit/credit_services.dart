import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tontiflex/database/credit/credit_class.dart';
import 'package:tontiflex/utility/utility.dart';

class CreditRequestService {
  // Replace with your actual API base URL

  Future<Credit> createCreditRequest(Credit creditRequest) async {
    final response = await http.post(
      Uri.parse('$host/credit-requests'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(creditRequest.toJson()),
    );

    if (response.statusCode == 201) {
      return Credit.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create credit request: ${response.body}');
    }
  }

  Future<List<Credit>> getAllCreditRequests() async {
    final response = await http.get(Uri.parse('$host/credit-requests'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((item) => Credit.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load credit requests: ${response.body}');
    }
  }

  Future<Credit> getCreditRequestById(int id) async {
    final response = await http.get(Uri.parse('$host/credit-requests/$id'));

    if (response.statusCode == 200) {
      return Credit.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load credit request: ${response.body}');
    }
  }

  Future<Credit> updateCreditRequest(int id, Credit creditRequest) async {
    final response = await http.put(
      Uri.parse('$host/credit-requests/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(creditRequest.toJson()),
    );

    if (response.statusCode == 200) {
      return Credit.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update credit request: ${response.body}');
    }
  }

  Future<void> deleteCreditRequest(int id) async {
    final response = await http.delete(Uri.parse('$host/credit-requests/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete credit request: ${response.body}');
    }
  }

  Future<Credit> updateCreditRequestStatus(int id, CreditStatus status) async {
    final response = await http.patch(
      Uri.parse('$host/credit-requests/$id/status'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'status': status.toString().split('.').last}),
    );

    if (response.statusCode == 200) {
      return Credit.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update credit request status: ${response.body}');
    }
  }

  Future<List<Credit>> getAllCreditRequestsByUserId(String userId) async {
    print('userId: $userId');
    final response = await http.get(Uri.parse('$host/credit-requests/user/$userId'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((item) => Credit.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load credit requests: ${response.body}');
    }
  }
}
