import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:taletime/common%20utils/constants.dart";
import "package:taletime/common%20utils/decoration_util.dart";
import "package:taletime/common%20utils/text_form_field_util.dart";
import "package:taletime/login%20and%20registration/screens/login.dart";
import "package:taletime/login%20and%20registration/utils/authentification_util.dart";

import "../../internationalization/localizations_ext.dart";

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  /// The [_formKey] is used to check if the user input is valid
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// The Text-Editing-Controller is used to catch the input from the user for his email-adress
  final TextEditingController _emailController = TextEditingController();

  /// instance of Firebase to use Firebase functions; here: reset password with email
  final FirebaseAuth auth = FirebaseAuth.instance;

  /// disposes the email Text-Editing-Controller when its not needed anymore
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: Decorations().appBarDecoration(
            title: AppLocalizations.of(context)!.resetPassword,
            context: context,
            automaticArrow: true),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SafeArea(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(25, 150, 25, 10),
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.problemsWithLogin,
                              style: const TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                                AppLocalizations.of(context)!
                                    .enterAssociatedEmail,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              AppLocalizations.of(context)!.sendResetLink,
                              style: const TextStyle(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            /// TextField that catches the user input for the email-adress
                            Container(
                              decoration:
                                  Decorations().inputBoxDecorationShaddow(),
                              child: TextFormFieldUtil().enterEmailForm(
                                context,
                                _emailController,
                                TextInputAction.done,
                              ),
                            ),
                            const SizedBox(height: 40.0),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: elevatedButtonDefaultStyle(),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                          child: Text(
                            AppLocalizations.of(context)!.resetPassword,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        /// send the user an email to reset his password
                        /// if the input isn't valid, the the user will be informed with a error message under the belonging Textfield
                        onPressed: () async {
                          final String email =
                              _emailController.text.trim().toLowerCase();
                          final isValidForm = _formKey.currentState!.validate();
                          if (isValidForm) {
                            AuthentificationUtil(auth: auth)
                                .resetPasswordWithEmail(
                                    email: email, context: context);
                          }
                        },
                      ),
                      const SizedBox(height: 30.0),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                                text: AppLocalizations.of(context)!
                                    .rememberPassword),
                            TextSpan(
                              text: AppLocalizations.of(context)!.loginVerb,

                              /// redirects the user to the LoginPage
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage()),
                                  );
                                },
                              style: TextStyle(color: kPrimaryColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
