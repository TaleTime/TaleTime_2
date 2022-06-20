import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:taletime/utils/authentification_util.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

// ignore: unused_element
final MockUser _mockUser = MockUser();

void main() {
  final MockFirebaseAuth mockAuth = MockFirebaseAuth();
  // ignore: unused_local_variable
  final AuthentificationUtil auth = AuthentificationUtil(auth: mockAuth);

  test("register with email and password", () async {
    
  });

  test("login using email and password", () async {
    
  });

  test("reset password with email", () async {
    
  });
}
