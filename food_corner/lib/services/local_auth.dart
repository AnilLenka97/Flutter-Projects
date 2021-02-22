import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuth {
  static bool isLoggedInByUserIdAndPassword = false;
  static final LocalAuthentication _localAuth = LocalAuthentication();

  static Future<bool> authenticate() async {
    try {
      if (await _localAuth.canCheckBiometrics) {
        return await _localAuth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: true,
        );
      }
    } on PlatformException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
    return false;
  }
}
