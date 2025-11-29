import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobil_proje/product/widget/log_in_appbar.dart';
import 'package:mobil_proje/product/widget/general_text_widget.dart';
import 'package:mobil_proje/product/widget/input_widget.dart';
import 'package:mobil_proje/product/widget/global_elevated_button.dart';
import 'package:mobil_proje/product/constant/paddings.dart';
import 'package:mobil_proje/product/constant/colors.dart';
import 'package:mobil_proje/product/enum/text_sizes.dart';
import 'package:mobil_proje/product/constant/icons.dart';
import 'package:mobil_proje/product/constant/validators.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LogInAppbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: Paddings.paddingInstance.generalHorizontalPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                GeneralTextWidget(
                  color: ColorName.whiteColor,
                  size: TextSizesEnum.googleSize.value,
                  text: 'Forgot Password?',
                ),
                const SizedBox(height: 16),
                // Description
                Text(
                  'Enter your email address, we will send you a password reset link',
                  style: TextStyle(
                    color: ColorName.loginGreyTextColor,
                    fontSize: 14,
                  ),
                ),
                // Email label
                Padding(
                  padding: Paddings.paddingInstance.loginVerticalPadding,
                  child: GeneralTextWidget(
                    color: ColorName.loginGreyTextColor,
                    size: TextSizesEnum.generalSize.value,
                    text: 'Email Address',
                  ),
                ),
                // Email input
                InputWidget(
                  controller: _emailController,
                  hintText: 'demo@gmail.com',
                  prefixIcon: IconConstants.iconConstants.emailIcon,
                  keyboardType: TextInputType.emailAddress,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      Validators.validatorsInstance.emailRegex,
                    ),
                  ],
                  validator: Validators.validatorsInstance.validateEmail,
                ),
                // Send button
                Padding(
                  padding: Paddings.paddingInstance.splashButtonVerticalPadding,
                  child: GlobalElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        // TODO: Implement password reset
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Password reset link sent to your email'),
                          ),
                        );
                      }
                    },
                    text: 'Send',
                    loading: false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

