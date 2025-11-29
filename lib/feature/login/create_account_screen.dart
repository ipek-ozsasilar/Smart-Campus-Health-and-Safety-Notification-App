/*
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mindmate_project/feature/login/view_model/create_account_view_model.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:url_launcher/url_launcher.dart';

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
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      Validators.validatorsInstance.emailRegex,
                    ),
                  ],
                  validator: Validators.validatorsInstance.validateEmail,
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
                  validator: Validators.validatorsInstance.validatePassword,
                  obscureText: watchPasswordObscure(),
                  onSuffixIconPressed: togglePasswordVisibility,
                ),
                //password input
                //forgot password text button
                Padding(
                  padding:
                      Paddings.paddingInstance.loginForgotPasswordTopPadding,
                  child: TextAndSignUpLogInRowWidget(
                    firstText: StringsEnum.privacyPolicyFirstPart.value,
                    secondText: StringsEnum.privacyPolicySecondPart.value,
                    wrapAlignment: WrapAlignment.start,
                    onPressed: () async {
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
                          showSnackBar(ErrorStringsEnum.urlLaunchError.value);
                        }
                      } catch (e) {
                        showSnackBar(ErrorStringsEnum.urlLaunchError.value);
                      }
                    },
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
 */