import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taletime/screens/home.dart';
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
                return const Home();
              } else {
                return const WelcomePage();
              }
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}


















// ====================== ALTE LÖSUNG ===========================================================================================

/** 
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
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthenticationService>().authStateChanges, initialData: null,
        )
      ],
      child: const MaterialApp(
        title: 'Flutter Demo',
        home: AuthenticationWrapper(),
      ),
    );
  }
    
  
  
}


class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return const Home();
    }
    return const WelcomePage();
  }
}
*/




/** 
class TaleTimeApp extends StatelessWidget {
  const TaleTimeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TaleTimeApp());
}






















class TaleTimeApp extends StatelessWidget {
  const TaleTimeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            } else if (snapshot.hasData) {
              return const Home();
            } else {
              return const WelcomePage();
            }
          },
        ),
      );
}
*/