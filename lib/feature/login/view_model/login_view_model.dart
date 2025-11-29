/*

import 'package:flutter/material.dart';
import 'package:flutter_mindmate_project/features/create_chat/create_chat_view.dart';
import 'package:flutter_mindmate_project/features/login/log_in_view.dart';
import 'package:flutter_mindmate_project/features/login/provider/login_provider.dart';
import 'package:flutter_mindmate_project/products/enums/error_strings.dart';
import 'package:flutter_mindmate_project/products/mixins/navigation_mixin.dart';
import 'package:flutter_mindmate_project/products/mixins/scaffold_message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class LoginViewModel extends ConsumerState<LogInView>
    with ScaffoldMessage<LogInView> {
  // Build içinde çağrılır - state değişikliklerini dinler
  void setupListeners() {
    ref.listen<LoginState>(loginProvider, (previous, next) {
      // Loading bitti, sonucu kontrol et
      if (previous != null && previous.isLoading && !next.isLoading) {
        if (next.errorMessage == ErrorStringsEnum.loginSuccess.value) {
          // Login başarılı, home'a git
          context.navigateTo(const CreateChatView());
          //email ve password'u temizle
          clearEmailAndPassword();
        } else if (next.errorMessage != null && next.errorMessage!.isNotEmpty) {
          // Hata mesajı göster
          showSnackBar(next.errorMessage!);
        }
      }
    });
  }

  // Button'dan çağrılır - login işlemini başlatır
  Future<void> loginUser() async {
    // Internet bağlantısı kontrolü
    final isConnected = await ref
        .read(loginProvider.notifier)
        .checkInternetConnection();
    if (!isConnected) {
      showSnackBar(ErrorStringsEnum.internetConnectionError.value);
      return;
    }

    // Email ve password kontrolü
    final emailAndPassword = await ref
        .read(loginProvider.notifier)
        .checkEmailAndPassword();
    if (!emailAndPassword) {
      final errorMsg = ref.read(loginProvider).errorMessage;
      if (errorMsg != null && errorMsg.isNotEmpty) {
        showSnackBar(errorMsg);
      }
      return;
    }

    // Login işlemini başlat (state değişir, setupListeners yakalar)
    await ref.read(loginProvider.notifier).EmailAndPasswordLogin();
  }

  bool loadingWatch() {
    //loading watch fonksiyonu
    return ref.watch(loginProvider).isLoading;
  }

  void togglePasswordVisibility() {
    ref
        .read(loginProvider.notifier)
        .changeStateIsPasswordObscure(
          !ref.read(loginProvider).isPasswordObscure,
        );
  }

  bool readPasswordObscure() {
    return ref.read(loginProvider).isPasswordObscure;
  }

  bool watchPasswordObscure() {
    return ref.watch(loginProvider).isPasswordObscure;
  }

  TextEditingController? readPasswordController() {
    return ref
        .read(loginProvider.notifier)
        .passwordController; //password controller'ı döndürüyoruz
  }

  Future<void> googleLogin() async {
    final result = await ref.read(loginProvider.notifier).GoogleLogin();
    if (result) {
      context.navigateTo(const CreateChatView());
      clearEmailAndPassword();
    } else {
      showSnackBar(ErrorStringsEnum.loginFailed.value);
      clearEmailAndPassword();
    }
  }

  void clearEmailAndPassword() {
    ref.read(loginProvider.notifier).clearEmailAndPassword();
  }
  TextEditingController? readEmailController() {
    return ref.read(loginProvider.notifier).emailController;
  }
}
 */