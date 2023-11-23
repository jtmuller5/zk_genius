import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:polygonid_flutter_sdk/identity/domain/entities/identity_entity.dart';
import 'package:polygonid_flutter_sdk/identity/domain/entities/private_identity_entity.dart';
import 'package:polygonid_flutter_sdk/identity/domain/exceptions/identity_exceptions.dart';
import 'package:polygonid_flutter_sdk/sdk/polygon_id_sdk.dart';
import 'package:zk_genius/app/services.dart';

@lazySingleton
class IdentityService {
  ValueNotifier<PrivateIdentityEntity?> identity = ValueNotifier(null);
  ValueNotifier<List<IdentityEntity>> identities = ValueNotifier([]);

  void setIdentities(List<IdentityEntity> val) {
    identities.value = val;
  }

  void setIdentity(PrivateIdentityEntity val) {
    identity.value = val;
  }

  Future<PrivateIdentityEntity?> addIdentity({String? secret}) async {
    try {
      PrivateIdentityEntity identity = await PolygonIdSdk.I.identity.addIdentity(secret: secret);

      /*
    {
      privateKey: 6b6cd3ef6ae7723e657b2ba99b2e6e6c68ff7aefda3617a8b5bd0771da1a08d3, [IdentityEntity]
      {
        did: did:polygonid:polygon:mumbai:2qGLJLbA1nbeetyYxfGSuRXQt8WCqpNPQMw77jKjwx,
        publicKey: [
          17727953575939848072406192999912951690177430164367034891231853683902267691448,
          287851490485922607043980931265035908580992684113533304161247079208452707743
        ],
        profiles: {
          0: did:polygonid:polygon:mumbai:2qGLJLbA1nbeetyYxfGSuRXQt8WCqpNPQMw77jKjwx
        }
       }
     }
     */
      debugPrint('Identity added: $identity');
      setIdentity(identity);

      await secureStorage.write(key: '${identity.did}_privateKey', value: identity.privateKey);

      return identity;
    } catch (e) {
      debugPrint('addIdentity error: $e');
      return null;
    }
  }

  Future<void> removeIdentity(String did) async {
    try {
      await PolygonIdSdk.I.identity.removeIdentity(genesisDid: did,privateKey: identity.value!.privateKey);
      debugPrint('Identity removed: $did');
    } catch (e) {
      debugPrint('removeIdentity error: $e');
    }
  }

  Future<void> getDidIdentifier(PrivateIdentityEntity identityEntity) async {
    String privateKey = identityEntity.privateKey;
    String didIdentifier = await PolygonIdSdk.I.identity.getDidIdentifier(
      privateKey: privateKey,
      blockchain: const String.fromEnvironment("BLOCKCHAIN"),
      network: const String.fromEnvironment("NETWORK"),
    );

    debugPrint('didIdentifier: ' + didIdentifier.toString());
  }

  Future<void> getPrivateKey(String secret) async {
    try {
      String privateKey = await PolygonIdSdk.I.identity.getPrivateKey(secret: secret);
      debugPrint('privateKey: ' + privateKey.toString());
    }  catch (e) {
      debugPrint('getPrivateKey error: ${e.toString()}');
    }
  }

  Future<void> getState(String did) async {
    try {
      String state = await PolygonIdSdk.I.identity.getState(did: did);
      debugPrint('state: ' + state.toString());
    } on FetchIdentityStateException catch (e) {
      debugPrint('getState error: ${e.error.toString()}');
    } catch (e) {
      debugPrint('getState error: ${e.toString()}');
    }
  }

  Future<void> addProfile({
    required String genesisDid,
    required String privateKey,
    required BigInt profileNonce,
  }) async {
    await PolygonIdSdk.I.identity.addProfile(
      genesisDid: genesisDid,
      privateKey: privateKey,
      profileNonce: profileNonce,
    );
    debugPrint('privateKey: ' + privateKey.toString());
  }

  Future<void> listIdentities() async {
    List<IdentityEntity> identities = await PolygonIdSdk.I.identity.getIdentities();
    debugPrint('identities: ' + identities.toString());
    setIdentities(identities);
  }
}
