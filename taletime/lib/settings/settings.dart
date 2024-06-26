import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:taletime/common%20utils/tale_time_logger.dart";
import "package:taletime/internationalization/l10n.dart";
import "package:taletime/internationalization/locale_provider.dart";
import "package:taletime/profiles/screens/profiles_page.dart";
import "package:taletime/settings/changePassword.dart";
import "package:taletime/common%20utils/constants.dart";
import "package:taletime/state/profile_state.dart";
import "../internationalization/localizations_ext.dart";
import "package:taletime/common%20utils/theme_provider.dart";
import "../onboarding/onboarding_main.dart";
import "package:taletime/settings/downloads.dart";

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final logger = TaleTimeLogger.getLogger();

  _SettingsPageState();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileState>(
      builder: (context, profileState, _) {
        Future<void> updateLanguage(String language) {
          return profileState.profileRef!
              .update({"language": language})
              .then((value) => logger.v("profile Updated"))
              .catchError(
                  (error) => logger.e("Failed to update profile: $error"));
        }

        Future<void> updateTheme(bool theme) {
          return profileState.profileRef!
              .update({"theme": theme})
              .then((value) => logger.v("profile Updated"))
              .catchError(
                  (error) => logger.e("Failed to update profile: $error"));
        }

        final languageProvider = Provider.of<LocaleProvider>(context);
        final themeProvider = Provider.of<ThemeProvider>(context);

        Locale? selectedLanguage = languageProvider.locale;

        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.settings),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_circle_left_outlined, size: 33),
              ),
              Container(padding: const EdgeInsets.all(16.0))
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                Card(
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
                                value: locale,
                                onTap: () {
                                  final provider = Provider.of<LocaleProvider>(
                                      context,
                                      listen: false);
                                  provider.setLocale(locale);
                                },
                                child: Text(flag,
                                    style: const TextStyle(fontSize: 32)),
                              );
                            },
                          ).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedLanguage = value;
                              updateLanguage(value.toString());
                            });
                          })),
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
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
                        updateTheme(value);
                      });
                    },
                    activeTrackColor: kPrimaryColor,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.password),
                    title: Text(AppLocalizations.of(context)!.changePassword),
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return const ChangePassword();
                      }));
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                    child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(AppLocalizations.of(context)!.changeProfile),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return ProfilesPage();
                    }));
                  },
                )),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  //Added new Downloads Section to find the downloaded stories
                  child: ListTile(
                    leading: const Icon(Icons.download_rounded),
                    title: Text(AppLocalizations.of(context)!.downloads),
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return const DownloadsPage();
                      }));
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                    child: ListTile(
                  leading: const Icon(Icons.help),
                  title: Text(AppLocalizations.of(context)!.onboarding),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const OnboardingMain()));
                  },
                ))
              ],
            ),
          ),
        );
      },
    );
  }
}
