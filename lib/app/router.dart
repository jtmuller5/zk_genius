import 'package:auto_route/auto_route.dart';
import 'package:zk_genius/features/home/ui/home/home_view.dart';

import 'package:zk_genius/features/home/ui/onboarding/onboarding_view.dart';
import 'package:zk_genius/features/settings/ui/settings/settings_view.dart';
import 'package:zk_genius/modules/notes/ui/notes/notes_view.dart';

part 'router.gr.dart';

@AutoRouterConfig(replaceInRouteName: ('View,Route'))
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomeRoute.page, initial: true),
        AutoRoute(page: OnboardingRoute.page),
        AutoRoute(page: SettingsRoute.page),
      ];
}
