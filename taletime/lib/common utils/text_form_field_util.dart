import "package:flutter/material.dart";
import "package:taletime/common%20utils/decoration_util.dart";
import "package:taletime/login%20and%20registration/utils/validation_util.dart";

import "../internationalization/localizations_ext.dart";

/// contains TextFormFields with the belonging validation
class TextFormFieldUtil {
  /// TextFormField to enter a username
  ///
  /// [nameController] --> catches the user input for the username
  TextFormField enterUserNameForm(
      BuildContext context, TextEditingController nameController) {
    return TextFormField(
        controller: nameController,
        decoration: Decorations().textInputDecoration(
            AppLocalizations.of(context)!.username,
            "",
            const Icon(Icons.person)),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (name) => ValidationUtil().validateUserName(name, context));
  }

  /// TextFormField to enter a email-adress
  ///
  /// [emailController] --> catches the user input for the email-adress
  TextFormField enterEmailForm(
      BuildContext context, TextEditingController emailController) {
    return TextFormField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        decoration: Decorations().textInputDecoration(
          AppLocalizations.of(context)!.email,
          "",
          const Icon(Icons.mail),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (email) => ValidationUtil().validateEmail(email, context));
  }

  /// TextFormField to enter the old password (ChangePassword-Class)
  ///
  /// [oldPasswordController] --> catches the user input for the old password
  TextFormField enterOldPasswordForm(
      BuildContext context, TextEditingController oldPasswordController) {
    return TextFormField(
        controller: oldPasswordController,
        obscureText: true,
        decoration: Decorations().textInputDecoration(
          AppLocalizations.of(context)!.oldPassword,
          AppLocalizations.of(context)!.enterOldPassword,
          const Icon(Icons.lock),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (password) =>
            ValidationUtil().validatePassword(password, context));
  }

  /// TextFormField to enter a password
  ///
  /// [passwordController] --> catches the user input for the password
  TextFormField enterPasswordForm(
      BuildContext context, TextEditingController passwordController) {
    return TextFormField(
        controller: passwordController,
        obscureText: true,
        textInputAction: TextInputAction.done,
        decoration: Decorations().textInputDecoration(
          AppLocalizations.of(context)!.password,
          "",
          const Icon(Icons.lock),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (password) =>
            ValidationUtil().validatePassword(password, context));
  }

  /// TextFormField to enter the confirmation password
  ///
  /// compares the input in the [passwordController] with the input from the [confirmPasswordController]
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
            const Icon(Icons.lock)),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (password) => ValidationUtil().validatePasswordConfirmation(
            password, passwordController.text, context));
  }
}
