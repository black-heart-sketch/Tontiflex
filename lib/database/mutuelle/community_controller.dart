import 'package:flutter/foundation.dart';
import 'package:tontiflex/database/mutuelle/community_class.dart'; // Import the Community class
import 'package:tontiflex/database/mutuelle/community_services.dart'; // Import the CommunityServices class

class CommunityController extends ChangeNotifier {
  final CommunityServices _communityServices = CommunityServices();
  List<Community> _communities = [];
  List<Community>  userCommunities = [];
  List<Community> get communities => _communities;

  CommunityController() {
    getAllCommunities();
  }

  // Fetch all communities
  Future<void> getAllCommunities() async {
    try {
      _communities = await _communityServices.getAllCommunities();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching communities: $e');
      }
    }
  }

  // Create a new community
  Future<bool> createCommunity(Community community) async {
    try {
      bool success = await _communityServices.createCommunity(community);
      if (success) {
        await getAllCommunities(); // Refresh the list of communities
      }
      return success;
    } catch (e) {
      if (kDebugMode) {
        print('Error creating community: $e');
      }
      return false;
    }
  }

  // Update an existing community
  Future<bool> updateCommunity(String id, Community community) async {
    try {
      bool success = await _communityServices.updateCommunity(id, community);
      if (success) {
        await getAllCommunities(); // Refresh the list of communities
      }
      return success;
    } catch (e) {
      if (kDebugMode) {
        print('Error updating community: $e');
      }
      return false;
    }
  }

  // Delete a community
  Future<bool> deleteCommunity(String id) async {
    try {
      bool success = await _communityServices.deleteCommunity(id);
      if (success) {
        await getAllCommunities(); // Refresh the list of communities
      }
      return success;
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting community: $e');
      }
      return false;
    }
  }

  // Associate a user with a community
  Future<bool> createUserCommunity({String? userId, String? communityId}) async {
    try {
      bool success = await _communityServices.createUserCommunity(userId!, communityId!);
      if (success) {
        notifyListeners(); // Notify listeners to update the UI
      }
      return success;
    } catch (e) {
      if (kDebugMode) {
        print('Error creating user-community association: $e');
      }
      return false;
    }
  }

  // Fetch communities by user ID
  Future<List<Community>> getCommunitiesByUserId(String userId) async {
    try {
       userCommunities = await _communityServices.getCommunitiesByUserId(userId);
      return userCommunities;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching communities for user: $e');
      }
      return [];
    }
  }
}