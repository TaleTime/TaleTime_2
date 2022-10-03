import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taletime/login%20and%20registration/utils/authentification_util.dart';
import 'package:taletime/login%20and%20registration/screens/login.dart';
import 'package:taletime/common%20utils/constants.dart';
import 'package:taletime/common%20utils/decoration_util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taletime/common%20utils/text_form_field_util.dart';

/// The Signup class is used to create a new account in the app
/// All  users are stored in Firebase
class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
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
          automaticArrow: true),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(children: <Widget>[
                SafeArea(
                    child: Column(children: [
                  Text(
                    AppLocalizations.of(context)!.createAccount,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 7,
                    child: Image.network(assetLogo),
                  ),
                  const SizedBox(height: 20),
                ]))
              ]),
              Column(
                children: <Widget>[
                  SafeArea(
                      child: Column(
                    children: [
                      Form(
                          key: _formKey,
                          child: Column(children: <Widget>[
                            /// TextField that catches the user input for the username
                            Container(
                                child: TextFormFieldUtil().enterUserNameForm(
                                    context, _nameController),
                                decoration:
                                    Decorations().inputBoxDecorationShaddow()),
                            const SizedBox(height: 25),

                            /// TextField that catches the user input for the email-adress
                            Container(
                                child: TextFormFieldUtil()
                                    .enterEmailForm(context, _emailController),
                                decoration:
                                    Decorations().inputBoxDecorationShaddow()),
                            const SizedBox(height: 20),
                            Container(

                                /// TextField that catches the user input for the password
                                child: TextFormFieldUtil().enterPasswordForm(
                                    context, _passwordController),
                                decoration:
                                    Decorations().inputBoxDecorationShaddow()),
                            const SizedBox(height: 25),

                            /// TextField that catches the user input for the confirm password
                            Container(
                                height: MediaQuery.of(context).size.height / 13,
                                child: TextFormFieldUtil().confirmPasswordForm(
                                    context,
                                    _passwordController,
                                    _confirmPasswordController),
                                decoration:
                                    Decorations().inputBoxDecorationShaddow())
                          ]))
                    ],
                  ))
                ],
              ),
              //Button for the registration
              Container(
                  padding: const EdgeInsets.only(top: 3, left: 3),
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height / 13,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: elevatedButtonDefaultStyle(),

                        /// creates a new user with the input from the user
                        /// if the input isn't valid, the the user will be informed with a error message under the belonging Textfield
                        onPressed: () async {
                          final String _userName = _nameController.text;
                          final String _email =
                              _emailController.text.trim().toLowerCase();
                          final String _password =
                              _passwordController.text.trim();
                          final isValidForm = _formKey.currentState!.validate();
                          if (isValidForm) {
                            AuthentificationUtil(auth: auth)
                                .registerWithEmailAndPassword(
                                    userName: _userName,
                                    email: _email,
                                    password: _password,
                                    context: context);
                          }
                        },
                        child: Text(
                          AppLocalizations.of(context)!.registerVerb,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                      ))),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(AppLocalizations.of(context)!.alreadyHaveAccount),
                  TextButton(
                      child: Text(AppLocalizations.of(context)!.loginVerb,
                          style: TextStyle(color: kPrimaryColor)),

                      /// redirects the user to the LoginPage
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
