import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taletime/screens/profiles_page.dart';
import 'package:taletime/screens/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase/firebase_options.dart';

// ignore: slash_for_doc_comments
/**
 * author: Gianluca Goebel
 * Main-Klasse der TaleTime-App
 */

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    const TaleTimeApp(),
  );
}

class TaleTimeApp extends StatelessWidget {
  const TaleTimeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              User? user = _auth.currentUser;
              if (user != null) {
                return const ProfilesPage();
              } else {
                return const WelcomePage();
              }
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}