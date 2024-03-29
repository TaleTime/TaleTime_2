import "package:flutter/material.dart";
import "package:taletime/login%20and%20registration/screens/login.dart";
import "package:taletime/login%20and%20registration/screens/signup.dart";
import "package:taletime/common%20utils/constants.dart";
import "../../internationalization/localizations_ext.dart";

/// First Screen that appears if you open the app
/// Here the user has the option to go to the Login or Register Page
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 20),
                        child: Center(
                          child: Text(
                            textAlign: TextAlign.center,
                            AppLocalizations.of(context)!.welcomeToTaleTime,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 20),
                          child: Text(
                            AppLocalizations.of(context)!.descriptionWelcome,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          )),
                      SizedBox(
                        height: 200,
                        child: Image.asset("assets/logo.png"),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Column(
                          children: <Widget>[
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child:

                                    /// Login Button
                                    SizedBox(
                                  height: 50,
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: elevatedButtonDefaultStyle(),

                                    /// redirects the user to the LoginPage
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginPage()));
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.loginVerb,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                    ),
                                  ),
                                )),
                            SizedBox(
                                height: 50,
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: elevatedButtonDefaultStyle(),

                                  /// redirects the user to the SignupPage
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SignupPage()));
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.register,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
