import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:taletime/common%20utils/constants.dart";
import "package:taletime/common%20utils/decoration_util.dart";
import "package:taletime/common%20utils/text_form_field_util.dart";
import "package:taletime/login%20and%20registration/utils/authentification_util.dart";

import "../../internationalization/localizations_ext.dart";

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key, this.initialEmail});

  final String? initialEmail;

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  /// The [_formKey] is used to check if the user input is valid
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// The Text-Editing-Controller is used to catch the input from the user for his email-adress
  final TextEditingController _emailController = TextEditingController();

  /// instance of Firebase to use Firebase functions; here: reset password with email
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    if (widget.initialEmail != null) {
      _emailController.text = widget.initialEmail!;
    }
  }

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
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
                        child: Text(
                          AppLocalizations.of(context)!.problemsWithLogin,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(AppLocalizations.of(context)!.enterAssociatedEmail,
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
                      const SizedBox(height: 40.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              /// TextField that catches the user input for the email-adress
                              Container(
                                decoration: Decorations().inputBoxDecorationShaddow(),
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
                                .resetPasswordWithEmail(email: email, context: context);
                          }
                        },
                      ),
                      const SizedBox(height: 30.0),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(AppLocalizations.of(context)!.rememberPassword),
                        TextButton(
                            child: Text(AppLocalizations.of(context)!.loginVerb),

                            /// redirects the user to the SignupPage
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      ],
                    ),
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
