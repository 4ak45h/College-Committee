import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  bool get isLoggedIn => currentUser != null;

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      // Step 1: Sign in
      UserCredential credential =
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      User? user = credential.user;
      if (user == null) {
        throw "User not found";
      }

      // Step 2: Verify Admin Role in Firestore
      DocumentSnapshot adminDoc =
      await _firestore.collection('admins').doc(user.uid).get();

      if (!adminDoc.exists) {
        await _auth.signOut();
        throw "This account is not authorized as ADMIN";
      }

      // Step 3: Update lastLogin
      await _firestore.collection('admins').doc(user.uid).update({
        'lastLogin': FieldValue.serverTimestamp(),
      });

      return {
        'success': true,
        'user': user,
      };
    } on FirebaseAuthException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
  Future<DocumentSnapshot> getAdminProfile() async {

    User? user = _auth.currentUser;

    if (user == null) {
      throw "No logged in user";
    }

    return await _firestore
        .collection('admins')
        .doc(user.uid)
        .get();
  }
  Future<void> updatePassword(String newPassword) async {
    User? user = _auth.currentUser;

    if (user == null) {
      throw "No authenticated user found";
    }

    await user.updatePassword(newPassword);
  }
  Future<void> updatePasswordWithReauth({
    required String currentPassword,
    required String newPassword,
  }) async {

    User? user = _auth.currentUser;

    if (user == null) {
      throw "No authenticated user";
    }

    String email = user.email!;

    // Step 1: Reauthenticate
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );

    await user.reauthenticateWithCredential(credential);

    // Step 2: Update password
    await user.updatePassword(newPassword);
  }

  String _handleError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return "Admin account not found";
      case 'wrong-password':
        return "Incorrect password";
      case 'invalid-email':
        return "Invalid email format";
      default:
        return "Login failed: ${e.message}";
    }
  }
}
