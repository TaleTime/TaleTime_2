import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taletime/internationalization/l10n.dart';
import 'package:taletime/internationalization/locale_provider.dart';
import 'package:taletime/utils/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taletime/utils/theme_provider.dart';

class SettingsPage extends StatefulWidget {
  //final DocumentSnapshot profile;
  final profile;
  final profiles;
  const SettingsPage(this.profile, this.profiles,{Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState(this.profile, this.profiles);
}

class _SettingsPageState extends State<SettingsPage> {

  //late final DocumentSnapshot profile;
  final profile;
  final profiles;

  _SettingsPageState(this.profile, this.profiles);

  @override
  Widget build(BuildContext context) {

    Future<void> updateLanguage(String profileId, String language) {
      return profiles
          .doc(profileId)
          .update({
        'language': language})
          .then((value) => print("profile Updated"))
          .catchError((error) => print("Failed to update profile: $error"));
    }

    Future<void> updateTheme(String profileId, bool theme) {
      return profiles
          .doc(profileId)
          .update({
        'theme': theme})
          .then((value) => print("profile Updated"))
          .catchError((error) => print("Failed to update profile: $error"));
    }

    final languageProvider = Provider.of<LocaleProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    Locale currentLanguage = Locale(profile["language"]);

    Locale? selectedLanguage = languageProvider.locale;

    Locale getSelecetedLanguage(Locale language){
      setState(() {
        languageProvider.setLocale(language);
      });
      return languageProvider.locale;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
        ),
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
                child: ListTile(
                    leading: const Icon(Icons.language_outlined),
                    title: Text(AppLocalizations.of(context)!.changeLanguage),
                    trailing: DropdownButton<Locale>(
                        value: selectedLanguage,
                        items: L10n.supportedLanguages.map(
                          (locale) {
                            final flag =
                                L10n.getCountryFlag(locale.languageCode);
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
                        }))),
            Container(
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
            Container(
              child: ListTile(
                leading: const Icon(Icons.password_rounded),
                title: Text(AppLocalizations.of(context)!.changePassword),
                trailing: MaterialButton(
                  onPressed: () {},
                ),
              ),
            ),
            Container(
              height: 40,
              width: double.infinity,
              child: MaterialButton(
                onPressed: () {},
                child: Row(
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    Icon(Icons.password),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      AppLocalizations.of(context)!.changePassword,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w100),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
