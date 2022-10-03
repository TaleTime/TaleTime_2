
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations returned
/// by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// localizationDelegates list, and the locales they support in the app's
/// supportedLocales list. For example:
///
/// ```
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en')
  ];

  /// Willkommen bei TaleTime
  ///
  /// In en, this message translates to:
  /// **'Welcome to TaleTime'**
  String get welcomeToTaleTime;

  /// Das cloudfähige, geschichtenerzählende Vorlesetool für Spaß mit der ganzen Familie
  ///
  /// In en, this message translates to:
  /// **'The cloud-ready, storytelling audiobook app for fun with the whole family'**
  String get descriptionWelcome;

  /// Registrierung
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get register;

  /// Registrieren
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get registerVerb;

  /// Anmelden
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginVerb;

  /// Anmeldung
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get login;

  /// Anmeldung zu Ihrem Konto
  ///
  /// In en, this message translates to:
  /// **'Sign In to your Account'**
  String get loginToAccount;

  /// Email-Adresse
  ///
  /// In en, this message translates to:
  /// **'Email adress'**
  String get email;

  /// Geben Sie Ihre Email-Adresse ein
  ///
  /// In en, this message translates to:
  /// **'Enter your email adress'**
  String get enterEmail;

  /// Passwort
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Geben Sie Ihr Passwort ein
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// Passwort vergessen?
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// Passwort bestätigen
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// Bestätigen Sie Ihr Passwort
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmYourPassword;

  /// Die Passwörter stimmen nicht überein
  ///
  /// In en, this message translates to:
  /// **'The passwords don\'t match'**
  String get passwordsDontMatch;

  /// Sie haben noch kein Konto?
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an Account?'**
  String get dontHaveAccount;

  /// Erstellen Sie ein kostenloses Konto
  ///
  /// In en, this message translates to:
  /// **'Create an account, it\'s free.'**
  String get createAccount;

  /// Benutzername
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// Geben Sie Ihren Benutzernamen ein
  ///
  /// In en, this message translates to:
  /// **'Enter your username'**
  String get enterUsername;

  /// Sie haben bereits ein Konto?
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// Passwort zurücksetzen
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// Probleme beim Anmelden?
  ///
  /// In en, this message translates to:
  /// **'Problems with Login?'**
  String get problemsWithLogin;

  /// Geben Sie die mit Ihrem Konto verbundene Email-Adresse ein.
  ///
  /// In en, this message translates to:
  /// **'Enter the email address associated with your account.'**
  String get enterAssociatedEmail;

  /// Wir senden Ihnen einen Link an ihre Email-Adresse, um Ihr Passwort zurücksetzen zu können.
  ///
  /// In en, this message translates to:
  /// **'We will email you a link to reset your password.'**
  String get sendResetLink;

  /// Passwort doch nicht vergessen?
  ///
  /// In en, this message translates to:
  /// **'Remember password? '**
  String get rememberPassword;

  /// Email-Adresse ist erforderlich
  ///
  /// In en, this message translates to:
  /// **'Email adress is required'**
  String get emailRequired;

  /// Geben Sie eine gültige Email-Adresse ein
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email adress'**
  String get enterValidEmail;

  /// Passwort ist erforderlich
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// Passwort muss mindestens 6 Zeichen lang sein
  ///
  /// In en, this message translates to:
  /// **'Password needs to be at least 6 characters long'**
  String get passwordLength;

  /// Benutzername ist erforderlich
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get usernameRequired;

  /// Benutzername muss mindestens 6 Zeichen lang sein
  ///
  /// In en, this message translates to:
  /// **'Username needs to be at least 6 characters long'**
  String get usernameLength;

  /// Es wurde kein Nutzer mit der eingegebenen Email gefunden.
  ///
  /// In en, this message translates to:
  /// **'No user found with the associated email adress'**
  String get userNotFound;

  /// Falsches Passwort.
  ///
  /// In en, this message translates to:
  /// **'Wrong Password.'**
  String get wrongPassword;

  /// Es existiert bereits ein Nutzer mit der eingegebenen Email-Adresse.
  ///
  /// In en, this message translates to:
  /// **'Email already in use.'**
  String get emailAlreadyInUse;

  /// Ok
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// Ja
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// Nein
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Email wurde erfolgreich versendet
  ///
  /// In en, this message translates to:
  /// **'Email was succesfully sent'**
  String get emailSent;

  /// Meine Profile
  ///
  /// In en, this message translates to:
  /// **'My Profiles'**
  String get myProfiles;

  /// Abmelden...
  ///
  /// In en, this message translates to:
  /// **'Signing out out...'**
  String get loggingOut;

  /// Wollen Sie sich wirklich vom Ihrem Konto abmelden?
  ///
  /// In en, this message translates to:
  /// **'Do you really want to sign out?'**
  String get confirmLogout;

  /// Lösche Profil...
  ///
  /// In en, this message translates to:
  /// **'Delete profile...'**
  String get deleteProfile;

  /// Wollen Sie wirklich dieses Profil löschen?
  ///
  /// In en, this message translates to:
  /// **'Do you really want to delte this profile?'**
  String get confirmProfileDeletion;

  /// Bearbeiten
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Löschen
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Mein Konto
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get myAccount;

  /// Profil wechseln
  ///
  /// In en, this message translates to:
  /// **'Change Profile'**
  String get changeProfile;

  /// Abmelden
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// Anmelden erfolgreich
  ///
  /// In en, this message translates to:
  /// **'Sign In succesful'**
  String get signInSuccesful;

  /// Registrieren erfolgreich
  ///
  /// In en, this message translates to:
  /// **'Sign Up succesful'**
  String get signUpSuccesful;

  /// Hauptmenü
  ///
  /// In en, this message translates to:
  /// **'Main Menu'**
  String get mainMenu;

  /// Einstellungen
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Favoriten
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// Jetzt anhören
  ///
  /// In en, this message translates to:
  /// **'Listen now'**
  String get listenNow;

  /// Suchen
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Sprache umstellen
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// Dark Mode
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Passwort ändern
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// Willkommen
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// Neues Profil
  ///
  /// In en, this message translates to:
  /// **'New Profile'**
  String get newProfile;

  /// Profil hinzufügen
  ///
  /// In en, this message translates to:
  /// **'Add Profile'**
  String get addProfile;

  /// Hörer
  ///
  /// In en, this message translates to:
  /// **'Listener'**
  String get listener;

  /// Erzähler
  ///
  /// In en, this message translates to:
  /// **'Story-teller'**
  String get storyteller;

  /// Titel ist erforderlich
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get titleRequired;

  /// Titel muss mindestens 6 Zeichen lang sein
  ///
  /// In en, this message translates to:
  /// **'Title needs to be at least 3 characters long'**
  String get titleLength;

  /// Profil-Name
  ///
  /// In en, this message translates to:
  /// **'Profile-Name'**
  String get profileName;

  /// Geben Sie einen Profilnamen ein
  ///
  /// In en, this message translates to:
  /// **'Enter a profile name'**
  String get enterProfile;

  /// Altes Passwort
  ///
  /// In en, this message translates to:
  /// **'Old password'**
  String get oldPassword;

  /// Geben Sie Ihr altes Passwort ein
  ///
  /// In en, this message translates to:
  /// **'Enter Old password'**
  String get enterOldPassword;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
