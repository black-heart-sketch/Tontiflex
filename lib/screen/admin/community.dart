import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tontiflex/database/mutuelle/community_class.dart'; // Import the Community class
import 'package:tontiflex/database/mutuelle/community_controller.dart';

import '../../database/user_db/user_controller.dart';

@RoutePage(name: 'CommunityRoute')
class CommunitySearchScreen extends StatefulWidget {
  const CommunitySearchScreen({super.key});

  @override
  State<CommunitySearchScreen> createState() => _CommunitySearchScreenState();
}

class _CommunitySearchScreenState extends State<CommunitySearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch communities when the screen is initialized
    final communityController = context.read<CommunityController>();
    communityController.getAllCommunities();
  }

  void _filterCommunities(String query, List<Community> communities) {
    setState(() {
      _searchController.text = query;
    });
  }

  void _showCommunityDetails(BuildContext context, Community community) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(community.name ?? 'No Name'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Members: ${community.members ?? 'No Members'}"),
            Text("Contribution Frequency: ${community.freqContribution ?? 'N/A'}"),
            Text("Amount to Send: \$${community.amount ?? 'N/A'}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void _navigateToCreateCommunity(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateCommunityScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userController = context.read<UserController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Communities"),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToCreateCommunity(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (query) => _filterCommunities(query, context.read<CommunityController>().communities),
              decoration: InputDecoration(
                hintText: "Search for a community...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Consumer<CommunityController>(
                builder: (context, communityController, child) {
                  final communities = communityController.communities;
                  final filteredCommunities = communities
                      .where((community) =>
                          community.name?.toLowerCase().contains(_searchController.text.toLowerCase()) ?? false)
                      .toList();

                  return ListView.builder(
                    itemCount: filteredCommunities.length,
                    itemBuilder: (context, index) {
                      final community = filteredCommunities[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: InkWell(
                          onTap: () => _showCommunityDetails(context, community),
                          child: ListTile(
                            leading: const Icon(Icons.group, color: Colors.blueAccent),
                            title: Text(community.name ?? 'No Name'),
                            subtitle: Text(
                              "Members: ${community.members?.length ?? 'N/A'} | Contributions: ${community.freqContribution ?? 'N/A'} | Amount: \$${community.amount ?? 'N/A'}",
                            ),
                            trailing: ElevatedButton(
                              onPressed: () async {
                                // Join the community
                                // Ensure 'members' is a flat list
                                List<dynamic> members = List.from(community.members ?? []);
                                if (!members.contains(userController.currentUser?.userId)) {
                                  members.add(userController.currentUser?.userId);
                                }else{
                                  SnackBar(content: Text("you are already a member"),);
                                }

                                Community updatedCommunity = Community(
                                  name: community.name,
                                  freqContribution: community.freqContribution,
                                  amount: community.amount,
                                  members: members,
                                  id: community.id
                                );

                                bool success = await communityController.updateCommunity(
                                  community.id.toString(),
                                  updatedCommunity,
                                );

                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Joined ${community.name} successfully!"),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }


                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                              ),
                              child: const Text("Join"),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}




class CreateCommunityScreen extends StatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  State<CreateCommunityScreen> createState() => _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends State<CreateCommunityScreen> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contributionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final communityController = context.read<CommunityController>();
    final userController = context.read<UserController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Community"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Community Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contributionController,
              decoration: const InputDecoration(
                labelText: "Contribution Frequency",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Amount to Send",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async{
                if (_nameController.text.isNotEmpty &&
                    _contributionController.text.isNotEmpty &&
                    _amountController.text.isNotEmpty) {
                  Community community=Community(name: _nameController.text,freqContribution: _contributionController.text,amount: _amountController.text,members: [userController.currentUser?.userId]);
                 final result=await communityController.createCommunity(community);
                 if(result){
                   Navigator.pop(context, {
                     "name": _nameController.text,
                     "members": 1,
                     "contribution": _contributionController.text,
                     "amount": "\$${_amountController.text}",
                   });
                 }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
              child: const Text("Create Community"),
            ),
          ],
        ),
      ),
    );
  }
}
