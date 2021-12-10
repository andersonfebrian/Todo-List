import 'package:firebase_auth/firebase_auth.dart';

String bindAuthException(FirebaseAuthException exception) {
  switch (exception.code) {
    case 'email-already-in-use':
      return "Email already exists.";
    case 'invalid-email':
      return "Invalid Email Address.";
    case 'user-not-found':
    case 'wrong-password':
      return "Incorrect Email or Password";
    case 'weak-password':
      return 'Password should be greater than 6 characters!';
  }
  return "An Exception Occured, Please try again later.";
}
