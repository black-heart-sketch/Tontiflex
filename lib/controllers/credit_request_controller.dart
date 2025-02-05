import 'package:flutter/foundation.dart';
import 'package:tontiflex/database/credit/credit_services.dart';
import '../database/credit/credit_class.dart';

class CreditRequestController extends ChangeNotifier {
  final CreditRequestService _service = CreditRequestService();
  
  List<Credit> _creditRequests = [];
  Credit? _selectedCreditRequest;
  bool _isLoading = false;
  String? _error;

  List<Credit> get creditRequests => _creditRequests;
  Credit? get selectedCreditRequest => _selectedCreditRequest;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchAllCreditRequests() async {
    _isLoading = true;
    try {
      _creditRequests = await _service.getAllCreditRequests();
      _error = null;
    } catch (e) {
      _error = 'Failed to fetch credit requests: $e';
    } finally {
      _isLoading = false;
    }
  }

  Future<void> createCreditRequest(Credit creditRequest) async {
    _isLoading = true;
    try {
      final newCreditRequest = await _service.createCreditRequest(creditRequest);
      _creditRequests.add(newCreditRequest);
      _error = null;
    } catch (e) {
      _error = 'Failed to create credit request: $e';
    } finally {
      _isLoading = false;
    }
  }

  Future<void> updateCreditRequest(int id, Credit creditRequest) async {
    _isLoading = true;
    try {
      final updatedCreditRequest = await _service.updateCreditRequest(id, creditRequest);
      final index = _creditRequests.indexWhere((request) => request.id == id);
      if (index != -1) {
        _creditRequests[index] = updatedCreditRequest;
      }
      _error = null;
    } catch (e) {
      _error = 'Failed to update credit request: $e';
    } finally {
      _isLoading = false;
    }
  }

  Future<void> deleteCreditRequest(int id) async {
    
    try {
      await _service.deleteCreditRequest(id);
      _creditRequests.removeWhere((request) => request.id == id);
      _error = null;
    } catch (e) {
      _error = 'Failed to delete credit request: $e';
    } finally {
      _isLoading = false;
    }
  }

  Future<void> updateCreditRequestStatus(int id, CreditStatus status) async {
    try {
      final updatedCreditRequest = await _service.updateCreditRequestStatus(id, status);
      final index = _creditRequests.indexWhere((request) => request.id == id);
      if (index != -1) {
        _creditRequests[index] = updatedCreditRequest;
      }
      _error = null;
    } catch (e) {
      _error = 'Failed to update credit request status: $e';
    } finally {
      _isLoading = false;
    }
  }

  void selectCreditRequest(Credit? creditRequest) {
    _selectedCreditRequest = creditRequest;
    notifyListeners();
  }

 

  Future<List<Credit>> fetchCreditRequestsByUserId(String userId) async {
    _isLoading = true;
    try {
      _creditRequests = await _service.getAllCreditRequestsByUserId(userId);
      _error = null;
    } catch (e) {
      _error = 'Failed to fetch credit requests: $e';
    } finally {
      _isLoading = false;
    }
    return _creditRequests;
  }
}
