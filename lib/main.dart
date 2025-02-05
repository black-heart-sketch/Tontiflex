import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tontiflex/routes/app_router.dart';

import 'database/history/history_controller.dart';
import 'database/mutuelle/community_controller.dart';
import 'database/notifcation/notification_controller.dart';
import 'database/payment/payment_controller.dart';
import 'database/user_db/user_controller.dart';
import 'firebase_options.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserController()),
        ChangeNotifierProvider(create: (_) => PaymentController()),
        ChangeNotifierProvider(create: (_) => HistoryController()),
        ChangeNotifierProvider(create: (_) => NotificationController()),
        ChangeNotifierProvider(create: (_)=>CommunityController())
        // ChangeNotifierProvider(create: (_) => MutuelleController()),
        // ChangeNotifierProvider(create: (_) => CreditRequestController()),
      ],
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _appRouter.config(),
    );
  }
}
