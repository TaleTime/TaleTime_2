import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taletime/utils/authentification_util.dart';
import 'package:taletime/screens/forgot_password.dart';
import 'package:taletime/screens/signup.dart';
import 'package:taletime/utils/constants.dart';
import 'package:taletime/utils/decoration_util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taletime/utils/validation_util.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: Decorations().appBarDecoration(
          title: AppLocalizations.of(context)!.login, context: context),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context)!.loginToAccount,
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 100),
                      height: 200,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(assetLogo),
                            fit: BoxFit.fitHeight),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: <Widget>[
                      Form(
                          key: _formKey,
                          child: Column(children: <Widget>[
                            Container(
                                child: TextFormField(
                                    controller: _emailController,
                                    decoration:
                                        Decorations().textInputDecoration(
                                      AppLocalizations.of(context)!.email,
                                      AppLocalizations.of(context)!.enterEmail,
                                      Icon(Icons.mail, color: kPrimaryColor),
                                    ),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (email) => ValidationUtil()
                                        .validateEmail(email, context)),
                                decoration:
                                    Decorations().inputBoxDecorationShaddow()),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              child: TextFormField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: Decorations().textInputDecoration(
                                    AppLocalizations.of(context)!.password,
                                    AppLocalizations.of(context)!.enterPassword,
                                    Icon(Icons.lock, color: kPrimaryColor),
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (password) => ValidationUtil()
                                      .validatePassword(password, context)),
                              decoration:
                                  Decorations().inputBoxDecorationShaddow(),
                            ),
                            const SizedBox(height: 15.0),
                            Container(
                              margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                              alignment: Alignment.topRight,
                              child: TextButton(
                                  child: Text(
                                      AppLocalizations.of(context)!
                                          .forgotPassword,
                                      style: TextStyle(color: kPrimaryColor)),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ForgotPasswordPage()));
                                  }),
                            ),
                          ])),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    padding: const EdgeInsets.only(top: 3, left: 3),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: () async {
                        // Funktion für Login mit Firebase
                        final String _email =
                            _emailController.text.trim().toLowerCase();
                        final String _password =
                            _passwordController.text.trim();
                        final isValidForm = _formKey.currentState!.validate();
                        if (isValidForm) {
                          AuthentificationUtil(auth: auth)
                              .loginUsingEmailAndPassword(
                                  email: _email,
                                  password: _password,
                                  context: context);
                        }
                      },
                      color: kPrimaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.loginVerb,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(AppLocalizations.of(context)!.dontHaveAccount),
                    TextButton(
                        child: Text(AppLocalizations.of(context)!.registerVerb,
                            style: TextStyle(color: kPrimaryColor)),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignupPage()));
                        }),
                  ],
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
