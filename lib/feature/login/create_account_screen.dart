import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobil_proje/feature/login/view_model/create_account_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mobil_proje/product/widget/general_text_widget.dart';
import 'package:mobil_proje/product/widget/input_widget.dart';
import 'package:mobil_proje/product/widget/global_elevated_button.dart';
import 'package:mobil_proje/product/widget/global_outlined_icon_button.dart';
import 'package:mobil_proje/product/widget/or_continue_with_row.dart';
import 'package:mobil_proje/product/widget/text_and_sign_up_log_in_row_widget.dart';
import 'package:mobil_proje/product/widget/log_in_appbar.dart';
import 'package:mobil_proje/product/constant/paddings.dart';
import 'package:mobil_proje/product/constant/colors.dart';
import 'package:mobil_proje/product/enum/text_sizes.dart';
import 'package:mobil_proje/product/enum/strings.dart';
import 'package:mobil_proje/product/constant/icons.dart';
import 'package:mobil_proje/product/constant/validators.dart';
import 'package:mobil_proje/product/mixin/navigation_mixin.dart';
import 'package:mobil_proje/feature/login/login_screen.dart';
import 'package:flutter/gestures.dart';

class CreateAccountView extends ConsumerStatefulWidget {
  const CreateAccountView({super.key});

  @override
  ConsumerState<CreateAccountView> createState() => _CreateAccountViewState();
}

class _CreateAccountViewState extends CreateAccountViewModel {
  final Alignment alignment = Alignment.centerRight;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    setupListeners();
    return Scaffold(
      //Login appbar
      appBar: LogInAppbar(),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: Paddings.paddingInstance.generalHorizontalPadding,
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                GeneralTextWidget(
                  color: ColorName.whiteColor,
                  size: TextSizesEnum.googleSize.value,
                  text: StringsEnum.createYourAccount.value,
                ),
                //full name text
                Padding(
                  padding: Paddings.paddingInstance.loginVerticalPadding,
                  child: GeneralTextWidget(
                    color: ColorName.loginGreyTextColor,
                    size: TextSizesEnum.generalSize.value,
                    text: 'Full Name',
                  ),
                ),
                //full name input
                InputWidget(
                  controller: readFullNameController(),
                  hintText: 'Full Name',
                  prefixIcon: IconConstants.iconConstants.personIcon,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'full name is empty';
                    }
                    return null;
                  },
                ),
                //email address text
                Padding(
                  padding: Paddings.paddingInstance.loginVerticalPadding,
                  child: GeneralTextWidget(
                    color: ColorName.loginGreyTextColor,
                    size: TextSizesEnum.generalSize.value,
                    text: StringsEnum.emailAddress.value,
                  ),
                ),
                //email address input
                InputWidget(
                  controller: readEmailController(),
                  hintText: StringsEnum.demoEmail.value,
                  prefixIcon: IconConstants.iconConstants.emailIcon,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'email is empty';
                    }
                    if (!Validators.validatorsInstance.emailRegex.hasMatch(
                      value,
                    )) {
                      return 'invalid email';
                    }
                    return null;
                  },
                ),
                //password text
                Padding(
                  padding:
                      Paddings.paddingInstance.loginPasswordVerticalPadding,
                  child: GeneralTextWidget(
                    color: ColorName.loginGreyTextColor,
                    size: TextSizesEnum.generalSize.value,
                    text: StringsEnum.password.value,
                  ),
                ),
                InputWidget(
                  controller: readPasswordController(),
                  hintText: StringsEnum.password.value,
                  prefixIcon: IconConstants.iconConstants.lockIcon,
                  suffixIcon: IconConstants.iconConstants.visibilityIcon,
                  keyboardType: TextInputType.visiblePassword,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(
                      Validators.validatorsInstance.passwordLength,
                    ), // Max 6 karakter
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'password is empty';
                    }
                    if (value.length <
                        Validators.validatorsInstance.passwordLength) {
                      return 'password too short';
                    }
                    return null;
                  },
                  obscureText: watchPasswordObscure(),
                  onSuffixIconPressed: togglePasswordVisibility,
                ),
                //password input
                //privacy policy text
                Padding(
                  padding:
                      Paddings.paddingInstance.loginForgotPasswordTopPadding,
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      children: [
                        const TextSpan(text: 'I have read & agreed to '),
                        TextSpan(
                          text: 'Mindmate Privacy Policy, Terms & Condition',
                          style: const TextStyle(
                            color: Color(0xFFFFD700),
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              try {
                                final url = Uri.parse(
                                  StringsEnum.privacyPolicyUrl.value,
                                );
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(
                                    url,
                                    mode: LaunchMode.externalApplication,
                                  );
                                } else {
                                  // Fallback: try to open in browser
                                  await launchUrl(
                                    url,
                                    mode: LaunchMode.platformDefault,
                                  );
                                }
                              } catch (e) {
                                // If URL launch fails, show error
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'URL açılamadı: ${e.toString()}',
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: Paddings.paddingInstance.splashButtonVerticalPadding,
                  child: GlobalElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState?.validate() ?? false) {
                        await createAccount();
                      }
                    },
                    text: StringsEnum.createAccount.value,
                    loading: loadingWatch(),
                  ),
                ),

                OrContinueWithRow(),

                Padding(
                  padding: Paddings
                      .paddingInstance
                      .loginTextAndSignUpVerticalPadding,
                  child: GlobalOutlinedIconButton(
                    onPressed: () async {
                      await googleCreateAccount();
                    },
                  ),
                ),

                TextAndSignUpLogInRowWidget(
                  firstText: StringsEnum.alreadyHaveAnAccount.value,
                  secondText: StringsEnum.logIn.value,
                  onPressed: () {
                    context.navigateTo(const LogInView());
                    clearFullNameAndEmailAndPassword();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
