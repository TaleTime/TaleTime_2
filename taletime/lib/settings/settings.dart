///The [Setting] class offers many functions for the user.
///The user can change the language (German, English, Arabic).
///The user can change the mode (light, dark).
///The user can change the password
///you can change the profiles
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taletime/internationalization/l10n.dart';
import 'package:taletime/internationalization/locale_provider.dart';
import 'package:taletime/profiles/screens/profiles_page.dart';
import 'package:taletime/settings/changePassword.dart';
import 'package:taletime/common%20utils/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taletime/common%20utils/theme_provider.dart';

class SettingsPage extends StatefulWidget {
  //final DocumentSnapshot profile;
  final profile;
  final profiles;
  const SettingsPage(this.profile, this.profiles, {Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() =>
      _SettingsPageState(this.profile, this.profiles);
}

class _SettingsPageState extends State<SettingsPage> {
  final profile;
  final profiles;

  _SettingsPageState(this.profile, this.profiles);
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    Future<void> updateLanguage(String profileId, String language) {
      return profiles
          .doc(profileId)
          .update({'language': language})
          .then((value) => print("profile Updated"))
          .catchError((error) => print("Failed to update profile: $error"));
    }

    Future<void> updateTheme(String profileId, bool theme) {
      return profiles
          .doc(profileId)
          .update({'theme': theme})
          .then((value) => print("profile Updated"))
          .catchError((error) => print("Failed to update profile: $error"));
    }

    final languageProvider = Provider.of<LocaleProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    Locale currentLanguage = Locale(profile["language"]);

    Locale? selectedLanguage = languageProvider.locale;

    Locale getSelecetedLanguage(Locale language) {
      setState(() {
        languageProvider.setLocale(language);
      });
      return languageProvider.locale;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        automaticallyImplyLeading: false,
        actions: [
          Icon(Icons.settings),
          Container(padding: const EdgeInsets.all(16.0))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Container(
                child: Card(
              child: ListTile(
                  leading: const Icon(Icons.language_outlined),
                  title: Text(AppLocalizations.of(context)!.changeLanguage),
                  trailing: DropdownButton<Locale>(
                      value: selectedLanguage,
                      items: L10n.supportedLanguages.map(
                        (locale) {
                          final flag = L10n.getCountryFlag(locale.languageCode);
                          return DropdownMenuItem(
                            child: Text(flag,
                                style: const TextStyle(fontSize: 32)),
                            value: locale,
                            onTap: () {
                              final provider = Provider.of<LocaleProvider>(
                                  context,
                                  listen: false);
                              provider.setLocale(locale);
                            },
                          );
                        },
                      ).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedLanguage = value;
                          updateLanguage(profile["id"], value.toString());
                        });
                      })),
            )),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Card(
                child: SwitchListTile(
                  secondary: const Icon(
                    Icons.dark_mode_sharp,
                  ),
                  title: Text(AppLocalizations.of(context)!.darkMode),
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    final provider =
                        Provider.of<ThemeProvider>(context, listen: false);
                    provider.toggleTheme(value);
                    setState(() {
                      updateTheme(profile["id"], value);
                    });
                  },
                  activeTrackColor: kPrimaryColor,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.password),
                  title: Text(AppLocalizations.of(context)!.changePassword),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const ChangePassword();
                    }));
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
                child: ListTile(
              leading: Icon(Icons.person),
              title: Text(AppLocalizations.of(context)!.changeProfile),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return ProfilesPage(auth.currentUser!.uid);
                }));
              },
            ))
          ],
        ),
      ),
    );
  }
}
