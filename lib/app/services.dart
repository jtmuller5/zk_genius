import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zk_genius/app/get_it.dart';
import 'package:zk_genius/app/router.dart';
import 'package:zk_genius/features/identity/services/identity_service.dart';
import 'package:zk_genius/features/monitoring/services/fast_analytics_service.dart';
import 'package:zk_genius/features/monitoring/services/fast_crash_service.dart';
import 'package:zk_genius/features/settings/services/settings_service.dart';

AppRouter get router => getIt.get<AppRouter>();

FastAnalyticsService get analyticsService => getIt.get<FastAnalyticsService>();

FastCrashService get crashService => getIt.get<FastCrashService>();

FlutterSecureStorage get secureStorage => getIt.get<FlutterSecureStorage>();

IdentityService get identityService => getIt.get<IdentityService>();

SettingsService get settingsService => getIt.get<SettingsService>();

SharedPreferences get sharedPrefs => getIt.get<SharedPreferences>();


