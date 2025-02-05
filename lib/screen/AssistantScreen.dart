import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tontiflex/database/mutuelle/community_class.dart'; // Updated import
import 'package:tontiflex/database/mutuelle/community_controller.dart';
import 'package:tontiflex/database/user_db/user_controller.dart';
import 'package:tontiflex/screen/history.dart';

import '../theme/color.dart';

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  late CommunityController _communityController; // Updated to use CommunityController

  @override
  void initState() {
    super.initState();
    _communityController = Provider.of<CommunityController>(context, listen: false);
    _communityController.getAllCommunities(); // Updated to fetch communities
  }

  SvgPicture svgIcon(String src, {Color? color}) {
    return SvgPicture.asset(
      src,
      height: 24,
      colorFilter: ColorFilter.mode(
          color ??
              Theme.of(context).iconTheme.color!.withOpacity(
                  Theme.of(context).brightness == Brightness.dark ? 0.3 : 1),
          BlendMode.srcIn),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Services"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: svgIcon("assets/icons/assistant.svg"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            getServices(),
          ],
        ),
      ),
    );
  }

  Widget getServices() {
    return Padding(
      padding: const EdgeInsets.only(top: 25, bottom: 40, left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Communities", // Updated title
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: grey.withOpacity(0.1),
                  spreadRadius: 10,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Consumer<CommunityController>(
                    builder: (context, controller, child) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: controller.communities.length,
                        itemBuilder: (BuildContext context, int index) {
                          Community community = controller.communities[index]; // Updated to use Community
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _showCommunityInfo(context, community); // Updated method name
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: secondary.withOpacity(0.3),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.people, // Updated icon
                                              color: primary,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 15),
                                        Text(
                                          community.name ?? 'No Name', // Updated to use community name
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Icon(Icons.arrow_forward_ios, size: 16),
                                  ],
                                ),
                              ),
                              if (index < controller.communities.length - 1)
                                Padding(
                                  padding: const EdgeInsets.only(left: 50, top: 10, bottom: 10),
                                  child: Divider(thickness: 0.2),
                                ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 25),
          

        ],
      ),
    );
  }

  void _showCommunityInfo(BuildContext context, Community community) {
    final userController = Provider.of<UserController>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(community.name ?? 'No Name'), // Updated to use community name
          content: Text(community.freqContribution ?? 'No Description'), // Updated to use community description
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            // TextButton(
            //   child: const Text("Join"), // Updated button text
            //   onPressed: () {
            //     _communityController.createUserCommunity(
            //       userId: userController.currentUser!.userId.toString(), // Updated to use userId
            //       communityId: community.id!, // Updated to use communityId
            //     );
            //     Navigator.pop(context);
            //   },
            // ),
          ],
        );
      },
    );
  }
}