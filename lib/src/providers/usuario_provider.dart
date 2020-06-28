import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UsuarioProvider {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<bool> signInWithCredentials(String email, String password) async{
    bool login = false;
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      login =true;
    } catch (e) {
    }
    return login;
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }
  Future<FirebaseUser> user() async {
    return _firebaseAuth.currentUser();
  }
  // SignOut
  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }
  Future<FirebaseUser> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = 
        await googleUser.authentication;
      final AuthCredential credential =
        GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken
        );
      await _firebaseAuth.signInWithCredential(credential);
      return _firebaseAuth.currentUser();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  Future<bool> signUp(String email, String password) async{
    bool register = false;
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password);
      register =true;
    } catch (e) {
    }
    return register;
  }
}