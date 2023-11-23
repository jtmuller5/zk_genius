import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:polygonid_flutter_sdk/common/domain/entities/env_entity.dart';
import 'package:polygonid_flutter_sdk/sdk/polygon_id_sdk.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:zk_genius/app/get_it.dart';
import 'package:zk_genius/app/router.dart';
import 'package:zk_genius/app/services.dart';
import 'package:zk_genius/app/theme.dart';
import 'package:zk_genius/features/shared/utils/navigation/basic_observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await analyticsService.initialize();
  GetIt.instance.registerSingleton(AppRouter());
  await PolygonIdSdk.init(
      env: EnvEntity(
    blockchain: const String.fromEnvironment('BLOCKCHAIN'),
    network: const String.fromEnvironment('NETWORK'),
    web3Url: const String.fromEnvironment('WEB3_URL'),
    web3RdpUrl: const String.fromEnvironment('WEB3_RDP_URL'),
    web3ApiKey: const String.fromEnvironment('INFURA_API_KEY'),
    idStateContract: const String.fromEnvironment('ID_STATE_CONTRACT'),
    pushUrl: const String.fromEnvironment('PUSH_URL'),
    ipfsUrl: const String.fromEnvironment('IPFS_URL'),
  ));

  lightLogoColorScheme = await ColorScheme.fromImageProvider(provider: const AssetImage('assets/images/logo.png'), brightness: Brightness.light);
  darkLogoColorScheme = await ColorScheme.fromImageProvider(provider: const AssetImage('assets/images/logo.png'), brightness: Brightness.dark);

  await SentryFlutter.init(
    (options) {
      options.dsn = const String.fromEnvironment('SENTRY_DSN');
    },
    appRunner: () => runApp(const MainApp()),
  );

  // runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: settingsService.themeMode,
        builder: (context, mode, child) {
          return MaterialApp.router(
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: mode,
            routerConfig: router.config(
              navigatorObservers: () => [
                SentryNavigatorObserver(),
                BasicObserver(),
              ],
            ),
          );
        });
  }
}
