import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:taletime/internationalization/l10n.dart';
import 'package:taletime/internationalization/locale_provider.dart';
import 'package:taletime/screens/profiles_page.dart';
import 'package:taletime/screens/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'firebase/firebase_options.dart';

/// author: Gianluca Goebel
/// Main-Klasse der TaleTime-App

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    const TaleTimeApp(),
  );
}

class TaleTimeApp extends StatefulWidget {
  const TaleTimeApp({Key? key}) : super(key: key);
  @override
  _TaleTimeState createState() => _TaleTimeState();
}

class _TaleTimeState extends State<TaleTimeApp> {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<LocaleProvider>(
      create: (context) => LocaleProvider(),
      builder: (context, child) {
        final provider = Provider.of<LocaleProvider>(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const HomePage(),
          locale: provider.locale,
          supportedLocales: L10n.all,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
        );
      });
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
