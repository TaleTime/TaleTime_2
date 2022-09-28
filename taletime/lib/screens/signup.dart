import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taletime/utils/authentification_util.dart';
import 'package:taletime/screens/login.dart';
import 'package:taletime/utils/constants.dart';
import 'package:taletime/utils/decoration_util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taletime/utils/text_form_field_util.dart';
import 'package:taletime/utils/validation_util.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;

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
                  //Textfelder für die Eingabe der Daten
                  SafeArea(
                      child: Column(
                    children: [
                      Form(
                          key: _formKey,
                          child: Column(children: <Widget>[
                            Container(
                                child: TextFormFieldUtil().enterUserNameForm(
                                    context, _nameController),
                                decoration:
                                    Decorations().inputBoxDecorationShaddow()),
                            const SizedBox(height: 25),
                            Container(
                                child: TextFormFieldUtil()
                                    .enterEmailForm(context, _emailController),
                                decoration:
                                    Decorations().inputBoxDecorationShaddow()),
                            const SizedBox(height: 20),
                            Container(
                                child: TextFormFieldUtil().enterPasswordForm(
                                    context, _passwordController),
                                decoration:
                                    Decorations().inputBoxDecorationShaddow()),
                            const SizedBox(height: 25),
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
              //Button für die Registrierung
              Container(
                  padding: const EdgeInsets.only(top: 3, left: 3),
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height / 13,
                      width: double.infinity,
                      child: ElevatedButton(
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
