import 'package:flutter/material.dart';
import 'package:taletime/login%20and%20registration/screens/login.dart';
import 'package:taletime/login%20and%20registration/screens/signup.dart';
import 'package:taletime/common%20utils/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// First Screen that appears if you open the app
/// Here the user has the option to go to the Login or Register Page
class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(AppLocalizations.of(context)!.welcome),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context)!.welcomeToTaleTime,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    AppLocalizations.of(context)!.descriptionWelcome,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  )
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                child: Image.network(assetLogo),
              ),
              Column(
                children: <Widget>[
                  /// Login Button
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 15,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: elevatedButtonDefaultStyle(),

                      /// redirects the user to the LoginPage
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      },
                      child: Text(
                        AppLocalizations.of(context)!.loginVerb,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  /// Signup Button
                  SizedBox(
                      height: MediaQuery.of(context).size.height / 15,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: elevatedButtonDefaultStyle(),

                        /// redirects the user to the SignupPage
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignupPage()));
                        },
                        child: Text(
                          AppLocalizations.of(context)!.register,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}