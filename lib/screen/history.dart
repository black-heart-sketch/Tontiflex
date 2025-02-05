import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tontiflex/database/history/history_class.dart';
import 'package:tontiflex/database/user_db/user_controller.dart';
import '../database/history/history_controller.dart';
import '../theme/color.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  
  @override
  Widget build(BuildContext context) {
    final historyController = Provider.of<HistoryController>(context, listen: false);
    final userController = Provider.of<UserController>(context, listen: false);
    historyController.getHistoryByUserId(userController.currentUser!.userId.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text("Historique"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [getHistory()],
        ),
      ),
    );
  }

  Widget getHistory() {
    return Consumer<HistoryController>(
      builder: (context, historyController, child) {
        return Padding(
          padding: const EdgeInsets.only(top: 17, bottom: 30, left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: historyController.histories.length,
                        itemBuilder: (BuildContext context, int index) {
                          History history = historyController.histories[index];
                          
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Handle tap if needed
                                },
                                child: Container(
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
                                        Row(
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
                                                      Icons.history,
                                                      color: primary,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 15),
                                                Text(
                                                  "${history.amount} Fcfa",
                                                  style: TextStyle(fontSize: 15),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              "${history.communityName}",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 50, top: 5, bottom: 5),
                                child: Divider(thickness: 0.2),
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
     
              SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }

 
}
