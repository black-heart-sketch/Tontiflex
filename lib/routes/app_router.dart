import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:tontiflex/screen/admin/admindasboard.dart';
import 'package:tontiflex/screen/admin/managenotification.dart';
import 'package:tontiflex/screen/admin/usersdasboard.dart';

import '../entry_point.dart';
import '../retrivalform.dart';
import '../screen/admin/community.dart';
import '../screen/auth/login_screen.dart';
import '../screen/auth/signup_screen.dart';
import '../screen/dashboard.dart';
import '../screen/onboard/onbording_screnn.dart';
import '../screen/paymentform.dart';
import '../screen/profile/edit_screen.dart';
import '../splash_screen.dart';
part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashScreenRoute.page, initial: true),
        AutoRoute(page: LoginScreenRoute.page, initial: false),
        AutoRoute(page: SignUpScreenRoute.page, initial: false),
        AutoRoute(page: EntryPointRoute.page, initial: false),
        AutoRoute(page: OnboardingScreenRoute.page, initial: false),
        AutoRoute(page: LoginScreenRoute.page, initial: false),
        AutoRoute(page: SignUpScreenRoute.page, initial: false),
        AutoRoute(page: EntryPointRoute.page, initial: false),
        AutoRoute(page: OnboardingScreenRoute.page, initial: false),
        AutoRoute(page: DashBoardScreenRoute.page, initial: false),
        AutoRoute(page: EditProfileRoute.page),
        AutoRoute(page: PaymentForm.page),
        AutoRoute(page: AdminDasbBoardRoute.page, initial: false),
        AutoRoute(page: ManageNotificationRoute.page),
        AutoRoute(page: UsersDashboardRoute.page),
        AutoRoute(page: CommunityRoute.page),
        AutoRoute(page: RetrieveFundRoute.page)
      ];
}
