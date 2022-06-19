import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:taletime/screens/login.dart';
import 'package:taletime/utils/authentification_util.dart';
import 'package:taletime/utils/constants.dart';
import 'package:taletime/utils/decoration_util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: Decorations().appBarDecoration(
            title: AppLocalizations.of(context)!.resetPassword,
            context: context),
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
                                  color: Colors.black),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              AppLocalizations.of(context)!
                                  .enterAssociatedEmail,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              AppLocalizations.of(context)!.sendResetLink,
                              style: const TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: TextFormField(
                                  controller: _emailController,
                                  decoration: Decorations().textInputDecoration(
                                      AppLocalizations.of(context)!.email,
                                      AppLocalizations.of(context)!.enterEmail,
                                      Icon(Icons.email_rounded,
                                          color: kPrimaryColor)),
                                  validator: (email) => AuthentificationUtil()
                                      .validateEmail(email, context)),
                              decoration:
                                  Decorations().inputBoxDecorationShaddow(),
                            ),
                            const SizedBox(height: 40.0),
                          ],
                        ),
                      ),
                      Container(
                        decoration: Decorations().buttonBoxDecoration(context),
                        child: ElevatedButton(
                          style: Decorations().buttonStyle(),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                            child: Text(
                              AppLocalizations.of(context)!.resetPassword,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onPressed: () async {
                            final String email =
                                _emailController.text.trim().toLowerCase();
                            final isValidForm =
                                _formKey.currentState!.validate();
                            if (isValidForm) {
                              AuthentificationUtil().resetPasswordWithEmail(
                                  email: email, context: context);
                            }
                          },
                        ),
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
