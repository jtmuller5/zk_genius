import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:polygonid_flutter_sdk/identity/domain/entities/identity_entity.dart';
import 'package:polygonid_flutter_sdk/identity/domain/entities/private_identity_entity.dart';
import 'package:zk_genius/app/router.dart';
import 'package:zk_genius/app/services.dart';
import 'package:zk_genius/features/communities/ui/communities/communities_view.dart';
import 'package:zk_genius/features/home/ui/home/widgets/drawer.dart';

@RoutePage()
class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    if (!(sharedPrefs.getBool('onboarded') ?? false)) {
      router.replace(const OnboardingRoute());
    }
    identityService.listIdentities();
    super.initState();
  }

  int index = 0;

  void setIndex(int val) {
    setState(() => index = val);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              router.push(const SettingsRoute());
            },
          ),
        ],
      ),
      drawer: const HomeDrawer(),
      body: Column(
        children: [
          Row(
            children: [
              ElevatedButton(
                onPressed: () async {
                  await identityService.addIdentity();
                },
                child: const Text('Add Identity'),
              ),
            ],
          ),
          ValueListenableBuilder(
            valueListenable: identityService.identities,
            builder: (context, value, child) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  IdentityEntity identity = value[index];
                  return ListTile(
                    title: Text(identity.did),
                    subtitle: Text(identity.publicKey.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,),
                    onTap: () async {
                      try {
                        String? privateKey = await secureStorage.read(key: '${identity.did}_privateKey');

                        debugPrint('privateKey: ' + privateKey.toString());
                        identityService.getPrivateKey(privateKey!);
                        //identityService.getState(identity.did);
                      } catch (e) {
                        debugPrint('getPrivateKey error: $e');
                      }
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await identityService.removeIdentity(identity.did);
                      },
                    ),
                  );
                },
                itemCount: value.length,
                shrinkWrap: true,
              );
            },
          )
        ],
      ),
    );
  }
}
