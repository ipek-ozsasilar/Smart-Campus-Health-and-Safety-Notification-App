import 'package:flutter/material.dart';

class Paddings {
  static const Paddings paddingInstance = Paddings._();
  const Paddings._();

  EdgeInsets get generalHorizontalPadding =>
      const EdgeInsets.symmetric(horizontal: 16.0);
  EdgeInsets get loginVerticalPadding =>
      const EdgeInsets.only(top: 20.0, bottom: 10.0);
  EdgeInsets get loginPasswordVerticalPadding =>
      const EdgeInsets.only(top: 20.0, bottom: 10.0);
  EdgeInsets get loginForgotPasswordTopPadding =>
      const EdgeInsets.only(top: 10.0);
  EdgeInsets get splashButtonVerticalPadding =>
      const EdgeInsets.symmetric(vertical: 20.0);
  EdgeInsets get loginTextAndSignUpVerticalPadding =>
      const EdgeInsets.symmetric(vertical: 20.0);
}
