import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:taletime/common%20utils/constants.dart";
import "package:taletime/common%20utils/decoration_util.dart";
import "package:taletime/common%20utils/text_form_field_util.dart";
import "package:taletime/login%20and%20registration/screens/login.dart";
import "package:taletime/login%20and%20registration/utils/authentification_util.dart";

import "../../internationalization/localizations_ext.dart";

/// The Signup class is used to create a new account in the app
/// All  users are stored in Firebase
class SignupPage extends StatefulWidget {
  const SignupPage({super.key, this.redirectTo});

  final Widget? redirectTo;

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  /// The Text-Editing-Controllers are used to catch the input from the user for his username, email and password
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  /// The [_formKey] is used to check if the user input is valid
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // instance of Firebase to use Firebase functions; here: register with email and password
  final FirebaseAuth auth = FirebaseAuth.instance;

  /// disposes all Text-Editing-Controllers when they aren't needed anymore
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: Decorations().appBarDecoration(
        title: AppLocalizations.of(context)!.register,
        context: context,
        automaticArrow: true,
      ),
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
                children: <Widget>[
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
                        child: Text(
                          AppLocalizations.of(context)!.createAccount,
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
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              /// TextField that catches the user input for the username
                              Container(
                                  decoration:
                                      Decorations().inputBoxDecorationShaddow(),
                                  child: TextFormFieldUtil().enterUserNameForm(
                                    context,
                                    _nameController,
                                    TextInputAction.next,
                                  )),
                              const SizedBox(height: 5),
                              Text(AppLocalizations.of(context)!
                                  .usernameDescription),
                              const SizedBox(
                                height: 20,
                              ),

                              /// TextField that catches the user input for the email-adress
                              Container(
                                  decoration:
                                      Decorations().inputBoxDecorationShaddow(),
                                  child: TextFormFieldUtil().enterEmailForm(
                                    context,
                                    _emailController,
                                    TextInputAction.next,
                                  )),
                              const SizedBox(height: 20),
                              Container(

                                  /// TextField that catches the user input for the password
                                  decoration:
                                      Decorations().inputBoxDecorationShaddow(),

                                  /// TextField that catches the user input for the password
                                  child: TextFormFieldUtil().enterPasswordForm(
                                    context,
                                    _passwordController,
                                    TextInputAction.next,
                                  )),
                              const SizedBox(height: 25),

                              /// TextField that catches the user input for the confirm password
                              Container(
                                decoration:
                                    Decorations().inputBoxDecorationShaddow(),
                                child: TextFormFieldUtil().confirmPasswordForm(
                                  context,
                                  _passwordController,
                                  _confirmPasswordController,
                                  TextInputAction.done,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      //Button for the registration
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: elevatedButtonDefaultStyle(),

                            /// creates a new user with the input from the user
                            /// if the input isn't valid, the the user will be informed with a error message under the belonging Textfield
                            onPressed: () async {
                              final String userName = _nameController.text;
                              final String email =
                                  _emailController.text.trim().toLowerCase();
                              final String password =
                                  _passwordController.text.trim();
                              final isValidForm =
                                  _formKey.currentState!.validate();
                              if (isValidForm) {
                                AuthentificationUtil(auth: auth)
                                    .registerWithEmailAndPassword(
                                  userName: userName,
                                  email: email,
                                  password: password,
                                  context: context,
                                  redirectTo: widget.redirectTo,
                                );
                              }
                            },
                            child: Text(
                              AppLocalizations.of(context)!.registerVerb,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(AppLocalizations.of(context)!.alreadyHaveAccount),
                      TextButton(
                        child: Text(AppLocalizations.of(context)!.loginVerb,
                            style: TextStyle(color: kPrimaryColor)),

                        /// redirects the user to the LoginPage
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(
                                redirectTo: widget.redirectTo,
                              ),
                            ),
                          );
                        },
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
