import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taletime/internationalization/l10n.dart';
import 'package:taletime/internationalization/locale_provider.dart';
import 'package:taletime/utils/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/* die Setting klasse habe ich nur drei funktionen eingeführt 
Sprache umsetellen dunkel umstellen und password ändern
sie muss auf jeden Fall erweitert werden .*/
class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool dark = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    Locale? selectedLanguage = provider.locale;
    //var selected;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(AppLocalizations.of(context)!.settings),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.white,
          ),
        ),
        actions: [
          Icon(Icons.settings, color: Colors.white),
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
                        items: L10n.all.map(
                          (locale) {
                            final flag = L10n.getFlag(locale.languageCode);
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
                          });
                        }))),
            Container(
              child: SwitchListTile(
                secondary: const Icon(
                  Icons.dark_mode_sharp,
                  color: Colors.black,
                ),
                title: Text(AppLocalizations.of(context)!.darkMode),
                value: dark,
                onChanged: (val) {
                  setState(() {
                    dark = val;
                  });
                },
                activeTrackColor: kPrimaryColor,
                activeColor: Colors.black12,
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
                color: Colors.white,
                splashColor: Colors.green,
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
