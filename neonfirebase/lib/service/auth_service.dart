import 'package:firebase_auth/firebase_auth.dart';
import 'package:neonfirebase/service/user_service.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;
  //kullanıcının yaptığı değişiklerden haverdar olmak için
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
Future<void> createUser({required String email, required String password}) async {
  try {
    final cred = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    // Kullanıcı profili oluştur
    await UserService().createUserProfile(
      userId: cred.user!.uid,
      email: email,
    );
  } on FirebaseAuthException catch (e) {
    String errorMessage = 'Registration failed';
    if (e.code == 'weak-password') {
      errorMessage = 'weak password';
    } else if (e.code == 'email-already-in-use') {
      errorMessage = 'This email is already in use';
    }
    throw Exception(errorMessage);
  } catch (e) {
    throw Exception('Beklenmeyen hata: $e');
  }
}

  Future<void> signInUser(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception('Failed to sign in user: ${e.message}');
    }
  }

  Future<void> signOutUser() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out user: ${e.toString()}');
    }
  }
}
