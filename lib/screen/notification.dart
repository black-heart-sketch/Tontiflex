import 'package:flutter/material.dart';
import 'package:tontiflex/database/notifcation/notification_class.dart';
import 'package:tontiflex/database/notifcation/notification_controller.dart';
import 'package:intl/intl.dart';

import '../theme/color.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationController notificationController =
      NotificationController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(children: [getNotification()]),
      ),
    );
  }

  Widget getNotification() {
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
                  FutureBuilder<List<Notifications>>(
                    future: notificationController.fetchNotifications(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No notifications'));
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          final notification = snapshot.data![index];
                          return Column(
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
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  color: secondary
                                                      .withOpacity(0.3),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    Icons
                                                        .notification_important,
                                                    color: primary,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 15),
                                              Column(children: [
                                                Text(
                                                notification.title ?? '',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                              Text(
                                                notification.description ?? '',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                              ],)
                                            ],
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: () =>
                                                notificationController
                                                    .deleteNotification(
                                                        notification.id),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        notification.date != null
                                            ? DateFormat('MMM d, yyyy h:mm a').format(DateTime.parse(notification.date!))
                                            : '',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 50, top: 5, bottom: 5),
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
        ],
      ),
    );
  }
}
