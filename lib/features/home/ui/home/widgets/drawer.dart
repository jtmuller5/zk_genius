import 'package:flutter/material.dart';
import 'package:zk_genius/app/text_theme.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:zk_genius/app/router.dart';
import 'package:zk_genius/app/services.dart';
import 'package:zk_genius/features/shared/ui/app_logo.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                children: [
                  DrawerHeader(
                    child: Center(
                      child: Image.asset('assets/images/logo.png'),
                    ),
                  ),
                ],
              ),
            ),
            const AboutListTile(
              applicationName: 'zk_genius',
              dense: true,
              applicationIcon: AppLogo(sideLength: 48),
              aboutBoxChildren: [
                Text('zk_genius is a Flutter application.'),
              ],
            ),
            FutureBuilder(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      'Version: ${snapshot.data!.version}',
                      style: context.bodySmall,
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
