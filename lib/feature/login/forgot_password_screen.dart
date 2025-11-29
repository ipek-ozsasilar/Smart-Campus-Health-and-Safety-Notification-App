import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_proje/product/widget/log_in_appbar.dart';
import 'package:mobil_proje/product/widget/general_text_widget.dart';
import 'package:mobil_proje/product/widget/input_widget.dart';
import 'package:mobil_proje/product/widget/global_elevated_button.dart';
import 'package:mobil_proje/product/constant/paddings.dart';
import 'package:mobil_proje/product/constant/colors.dart';
import 'package:mobil_proje/product/enum/text_sizes.dart';
import 'package:mobil_proje/product/constant/icons.dart';
import 'package:mobil_proje/product/constant/validators.dart';
import 'package:mobil_proje/feature/login/provider/log_in_provider.dart';
import 'package:mobil_proje/product/enum/error_strings.dart';

class ForgotPasswordView extends ConsumerStatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  ConsumerState<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends ConsumerState<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

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
                  validator: Validators.validatorsInstance.validateEmail,
                ),
                // Send button
                Padding(
                  padding: Paddings.paddingInstance.splashButtonVerticalPadding,
                  child: GlobalElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              setState(() {
                                _isLoading = true;
                              });

                              // İnternet bağlantısı kontrolü
                              final isConnected = await ref
                                  .read(loginProvider.notifier)
                                  .checkInternetConnection();
                              if (!isConnected) {
                                setState(() {
                                  _isLoading = false;
                                });
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        ErrorStringsEnum
                                            .internetConnectionError
                                            .value,
                                      ),
                                      backgroundColor: ColorName.errorRed,
                                    ),
                                  );
                                }
                                return;
                              }

                              // Şifre sıfırlama emaili gönder
                              final email = _emailController.text.trim();
                              final success = await ref
                                  .read(loginProvider.notifier)
                                  .sendPasswordResetEmail(email);

                              setState(() {
                                _isLoading = false;
                              });

                              if (mounted) {
                                final errorMsg = ref
                                    .read(loginProvider)
                                    .errorMessage;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      errorMsg ??
                                          (success
                                              ? ErrorStringsEnum
                                                    .passwordResetEmailSent
                                                    .value
                                              : ErrorStringsEnum
                                                    .unexpectedError
                                                    .value),
                                    ),
                                    backgroundColor: success
                                        ? Colors.green
                                        : ColorName.errorRed,
                                  ),
                                );
                              }
                            }
                          },
                    text: 'Gönder',
                    loading: _isLoading,
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
