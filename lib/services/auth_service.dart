import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> login() async {
    final account = await GoogleSignIn().signIn();
    if (account == null) return null;
    final provider = await account.authentication;
    final creds = await _auth.signInWithCredential(
      GoogleAuthProvider.credential(
        idToken: provider.idToken,
        accessToken: provider.accessToken,
      ),
    );
    return creds.user;
  }

  Future<String?> fetchAuthToken(User? user, {bool forceRefresh = false}) async {
    return user?.getIdToken(forceRefresh);
  }
}
