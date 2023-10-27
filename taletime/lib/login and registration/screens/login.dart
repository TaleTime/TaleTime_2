import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:taletime/common%20utils/constants.dart";
import "package:taletime/common%20utils/decoration_util.dart";
import "package:taletime/common%20utils/text_form_field_util.dart";
import "package:taletime/login%20and%20registration/screens/forgot_password.dart";
import "package:taletime/login%20and%20registration/screens/signup.dart";
import "package:taletime/login%20and%20registration/utils/authentification_util.dart";

import "../../internationalization/localizations_ext.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  /// The Text-Editing-Controllers are used to catch the input from the user for his email and password
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  /// The [_formKey] is used to check if the user input is valid
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // instance of Firebase to use Firebase functions; here: login with email and password
  final FirebaseAuth auth = FirebaseAuth.instance;

  /// disposes all Text-Editing-Controllers when they aren't needed anymore
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Decorations().appBarDecoration(
        title: AppLocalizations.of(context)!.login,
        context: context,
        automaticArrow: true,
      ),
      body: SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
                child: Text(
                  AppLocalizations.of(context)!.loginToAccount,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 6,
                child: Image.network(assetLogo),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          /// TextField that catches the user input for the email-adress
                          Container(
                            width: double.infinity,
                            decoration: Decorations().inputBoxDecorationShaddow(),
                            child: TextFormFieldUtil()
                                .enterEmailForm(context, _emailController),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          /// TextField that catches the user input for the password
                          Container(
                            decoration: Decorations().inputBoxDecorationShaddow(),
                            child: TextFormFieldUtil()
                                .enterPasswordForm(context, _passwordController),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(10, 2, 5, 15),
                            alignment: Alignment.topRight,
                            child: TextButton(
                              child: Text(
                                  AppLocalizations.of(context)!.forgotPassword,
                                  style: TextStyle(color: kPrimaryColor)),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPasswordPage(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                    width: double.infinity,
                    //Button for the Login
                    child: ElevatedButton(
                      style: elevatedButtonDefaultStyle(),

                      /// logs in the user with the entered email and password
                      /// if the input isn't valid, the the user will be informed with a error message under the belonging Textfield
                      onPressed: () async {
                        final String email =
                            _emailController.text.trim().toLowerCase();
                        final String password = _passwordController.text.trim();
                        final isValidForm = _formKey.currentState!.validate();
                        if (isValidForm) {
                          AuthentificationUtil(auth: auth)
                              .loginUsingEmailAndPassword(
                                  email: email,
                                  password: password,
                                  context: context);
                        }
                      },
                      child: Text(
                        AppLocalizations.of(context)!.loginVerb,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(AppLocalizations.of(context)!.dontHaveAccount),
                    TextButton(
                        child: Text(AppLocalizations.of(context)!.registerVerb),

                        /// redirects the user to the SignupPage
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignupPage()));
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
