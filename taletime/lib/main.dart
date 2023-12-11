import "package:audio_service/audio_service.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:flutter_native_splash/flutter_native_splash.dart";
import "package:provider/provider.dart";
import 'package:taletime/player/services/audio_handler.dart';
import "package:taletime/common%20utils/theme_provider.dart";
import "package:taletime/internationalization/l10n.dart";
import "package:taletime/internationalization/locale_provider.dart";
import "package:taletime/login%20and%20registration/screens/welcome.dart";
import "package:taletime/profiles/screens/profiles_page.dart";

import "../internationalization/localizations_ext.dart";
import "firebase/firebase_options.dart";

late AudioHandler audioHandler;

/// Main-Class of the TaleTime-App

/// initiliazes the Firebase Options for the App
Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Audio Service
  audioHandler = await AudioService.init(
    builder: () => AudioPlayerHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: "de.htwsaar.taletime.player",
      androidNotificationChannelName: "TaleTime",
      androidNotificationOngoing: false,
      androidStopForegroundOnPause: true,

    )
  );

  runApp(
    const TaleTimeApp(),
  );
  FlutterNativeSplash.remove();
}

class TaleTimeApp extends StatefulWidget {
  const TaleTimeApp({super.key});

  @override
  State<TaleTimeApp> createState() => _TaleTimeState();
}

class _TaleTimeState extends State<TaleTimeApp> {
  /// creates the Providers for the App
  /// current Providers:
  /// LocaleProvider --> Used to change the Language of the App
  /// ThemeProvider  --> Used to change the Theme of the App: Lightmode/Darkmode
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<LocaleProvider>(
          create: (context) => LocaleProvider()),
      ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider())
    ], child: const Providers());
  }
}

/// initializes the LocaleProvider (locale; supportedLocales; localizationDelegates)
/// and the ThemeProvider (theme; darkTheme)
class Providers extends StatelessWidget {
  const Providers({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LocaleProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      themeMode: themeProvider.themeMode,
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      locale: languageProvider.locale,
      supportedLocales: L10n.supportedLanguages,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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

              /// if the user is already logged in he will be redirected to the ProfilesPage
              if (user != null) {
                return ProfilesPage(user.uid);

                /// if the user isn't logged in he will be redirected to the WelcomePage
              } else {
                return const WelcomePage();
              }
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
