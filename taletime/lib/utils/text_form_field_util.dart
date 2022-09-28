import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taletime/utils/decoration_util.dart';
import 'package:taletime/utils/validation_util.dart';

class TextFormFieldUtil {
  TextFormField enterUserNameForm(
      BuildContext context, TextEditingController nameController) {
    return TextFormField(
        controller: nameController,
        decoration: Decorations().textInputDecoration(
            AppLocalizations.of(context)!.username,
            AppLocalizations.of(context)!.enterUsername,
            Icon(Icons.person)),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (name) => ValidationUtil().validateUserName(name, context));
  }

  TextFormField enterEmailForm(
      BuildContext context, TextEditingController emailController) {
    return TextFormField(
        controller: emailController,
        decoration: Decorations().textInputDecoration(
          AppLocalizations.of(context)!.email,
          AppLocalizations.of(context)!.enterEmail,
          Icon(Icons.mail),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (email) => ValidationUtil().validateEmail(email, context));
  }

  TextFormField enterOldPasswordForm(
      BuildContext context, TextEditingController oldPasswordController) {
    return TextFormField(
        controller: oldPasswordController,
        obscureText: true,
        decoration: Decorations().textInputDecoration(
          AppLocalizations.of(context)!.oldPassword,
          AppLocalizations.of(context)!.enterOldPassword,
          Icon(Icons.lock),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (password) =>
            ValidationUtil().validatePassword(password, context));
  }

  TextFormField enterPasswordForm(
      BuildContext context, TextEditingController passwordController) {
    return TextFormField(
        controller: passwordController,
        obscureText: true,
        decoration: Decorations().textInputDecoration(
          AppLocalizations.of(context)!.password,
          AppLocalizations.of(context)!.enterPassword,
          Icon(Icons.lock),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (password) =>
            ValidationUtil().validatePassword(password, context));
  }

  TextFormField confirmPasswordForm(
      BuildContext context,
      TextEditingController passwordController,
      TextEditingController confirmPasswordController) {
    return TextFormField(
        controller: confirmPasswordController,
        obscureText: true,
        decoration: Decorations().textInputDecoration(
            AppLocalizations.of(context)!.confirmPassword,
            AppLocalizations.of(context)!.confirmYourPassword,
            Icon(Icons.lock)),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (password) {
          if (passwordController.text.trim() != password) {
            return AppLocalizations.of(context)!.passwordsDontMatch;
          } else {
            ValidationUtil().validatePassword(password, context);
          }
          return null;
        });
  }
}
