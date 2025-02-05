import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:logger/logger.dart';
import 'package:tontiflex/database/mutuelle/community_class.dart'; // Import the Community class

class CommunityServices {
  final Logger logger = Logger();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance

  // Fetch all communities
  Future<List<Community>> getAllCommunities() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('communities').get();

      List<Community> communities = [];
      for (var doc in snapshot.docs) {
        communities.add(Community.fromJson(doc.data() as Map<String, dynamic>));
      }

      logger.i('Fetched communities: $communities');
      return communities;
    } catch (e) {
      logger.e('Error fetching communities: $e');
      return [];
    }
  }

  // Create a new community
  Future<bool> createCommunity(Community community) async {
    try {
      String communityId = _firestore.collection('communities').doc().id; // Generate a unique ID for the community
      community.id = communityId; // Set the ID in the community object

      await _firestore.collection('communities').doc(communityId).set(community.toJson());
      logger.i('Community created successfully with ID: $communityId');
      return true;
    } catch (e) {
      logger.e('Error creating community: $e');
      return false;
    }
  }

  // Update an existing community
  Future<bool> updateCommunity(String communityId, Community community) async {
    try {
      await _firestore.collection('communities').doc(communityId).update(community.toJson());
      logger.i('Community updated successfully');
      return true;
    } catch (e) {
      logger.e('Error updating community: $e');
      return false;
    }
  }

  // Delete a community
  Future<bool> deleteCommunity(String communityId) async {
    try {
      await _firestore.collection('communities').doc(communityId).delete();
      logger.i('Community deleted successfully');
      return true;
    } catch (e) {
      logger.e('Error deleting community: $e');
      return false;
    }
  }

  // Fetch communities by user ID
  Future<List<Community>> getCommunitiesByUserId(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('communities')
          .where('members', arrayContains: userId)  // ✅ Fix here
          .get();

      List<Community> userCommunities = snapshot.docs
          .map((doc) => Community.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      logger.i('Fetched communities for user $userId: $userCommunities');
      return userCommunities;
    } catch (e) {
      logger.e('Error fetching communities for user $userId: $e');
      return [];
    }
  }


  // Associate a user with a community
  Future<bool> createUserCommunity(String userId, String communityId) async {
    try {
      await _firestore.collection('communities').doc(communityId).update({
        'members': {'id': userId},
      });
      logger.i('User $userId associated with community $communityId');
      return true;
    } catch (e) {
      logger.e('Error associating user with community: $e');
      return false;
    }
  }
}