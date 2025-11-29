import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobil_proje/product/enum/error_strings.dart';

var loginProvider = StateNotifierProvider<LoginProvider, LoginState>(
  (ref) => LoginProvider(),
);

class LoginProvider extends StateNotifier<LoginState> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginProvider()
    : super(
        const LoginState(
          isLoading: false,
          email: '',
          password: '',
          isConnected: false,
          errorMessage: '',
          isPasswordObscure: false,
        ),
      );

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<bool> checkInternetConnection() async {
    try {
      final result = await Connectivity().checkConnectivity();
      if (result.contains(ConnectivityResult.none)) {
        changeStateIsConnected(false);
        changeStateErrorMessage(ErrorStringsEnum.internetConnectionError.value);
        return false;
      } else {
        changeStateIsConnected(true);
        return true;
      }
    } catch (e) {
      changeStateErrorMessage(e.toString());
      return false;
    }
  }

  Future<bool> checkEmailAndPassword() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Email boş mu kontrol et
    if (email.isEmpty) {
      changeStateErrorMessage(ErrorStringsEnum.emailEmptyError.value);
      return false;
    }

    // Password boş mu kontrol et
    if (password.isEmpty) {
      changeStateErrorMessage(ErrorStringsEnum.passwordEmptyError.value);
      return false;
    }

    // Email ve password geçerliyse state'e kaydet
    changeStateEmail(email);
    changeStatePassword(password);
    return true;
  }

  //Firebase login işlemini yapıyoruz
  Future<bool> EmailAndPasswordLogin() async {
    try {
      changeStateIsLoading(true);
      final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: state.email!,
        password: state.password!,
      );
      if (user.user != null) {
        //login başarılıysa success mesajını gösteriyoruz
        changeStateErrorMessage(ErrorStringsEnum.loginSuccess.value);
        changeStateIsLoading(false);
        clearEmailAndPassword();
        return true;
      } else {
        //login başarısızysa failed mesajını gösteriyoruz
        changeStateErrorMessage(ErrorStringsEnum.loginFailed.value);
        changeStateIsLoading(false);
        return false;
      }
    } on FirebaseAuthException catch (_) {
      // Firebase hatalarını Türkçe'ye çevir
      changeStateIsLoading(false);
      changeStateErrorMessage(ErrorStringsEnum.invalidCredentialError.value);
      return false;
    }
  }

  Future<bool> GoogleLogin() async {
    try {
      changeStateIsLoading(true);

      // Google Sign In
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // Kullanıcı iptal etti
        changeStateIsLoading(false);
        changeStateErrorMessage(ErrorStringsEnum.googleLoginCanceled.value);
        return false;
      }

      // Google Auth
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Firebase credential oluştur
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase'e giriş yap
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      if (userCredential.user != null) {
        changeStateErrorMessage(ErrorStringsEnum.loginSuccess.value);
        changeStateIsLoading(false);
        return true;
      } else {
        changeStateErrorMessage(ErrorStringsEnum.loginFailed.value);
        changeStateIsLoading(false);
        return false;
      }
    } on FirebaseAuthException catch (_) {
      changeStateIsLoading(false);
      changeStateErrorMessage(ErrorStringsEnum.invalidCredentialError.value);
      return false;
    } catch (_) {
      changeStateIsLoading(false);
      changeStateErrorMessage(ErrorStringsEnum.unexpectedError.value);
      return false;
    } finally {
      changeStateIsLoading(false);
    }
  }

  void changeStateIsLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void changeStateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void changeStatePassword(String password) {
    state = state.copyWith(password: password);
  }

  void changeStateIsConnected(bool isConnected) {
    state = state.copyWith(isConnected: isConnected);
  }

  void changeStateErrorMessage(String errorMessage) {
    state = state.copyWith(errorMessage: errorMessage);
  }

  void changeStateIsPasswordObscure(bool isPasswordObscure) {
    state = state.copyWith(isPasswordObscure: isPasswordObscure);
  }

  void clearEmailAndPassword() {
    emailController.clear();
    passwordController.clear();
  }

  // Şifre sıfırlama emaili gönder
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      changeStateIsLoading(true);
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      changeStateIsLoading(false);
      changeStateErrorMessage(ErrorStringsEnum.passwordResetEmailSent.value);
      return true;
    } on FirebaseAuthException catch (e) {
      changeStateIsLoading(false);
      // Firebase hatalarını kontrol et
      if (e.code == 'user-not-found') {
        changeStateErrorMessage(ErrorStringsEnum.userNotFoundError.value);
      } else if (e.code == 'invalid-email') {
        changeStateErrorMessage(ErrorStringsEnum.invalidEmailError.value);
      } else {
        changeStateErrorMessage(ErrorStringsEnum.unexpectedError.value);
      }
      return false;
    } catch (e) {
      changeStateIsLoading(false);
      changeStateErrorMessage(ErrorStringsEnum.unexpectedError.value);
      return false;
    }
  }
}

class LoginState extends Equatable {
  final bool isLoading;
  final String? email;
  final String? password;
  final bool isConnected;
  final String? errorMessage;
  final bool isPasswordObscure;

  const LoginState({
    required this.isLoading,
    required this.email,
    required this.password,
    required this.isConnected,
    required this.errorMessage,
    required this.isPasswordObscure,
  });

  @override
  List<Object?> get props => [
    isLoading,
    email,
    password,
    isConnected,
    errorMessage,
  ];

  LoginState copyWith({
    bool? isLoading,
    String? email,
    String? password,
    bool? isConnected,
    String? errorMessage,
    bool? isPasswordObscure,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      email: email ?? this.email,
      password: password ?? this.password,
      isConnected: isConnected ?? this.isConnected,
      errorMessage: errorMessage ?? this.errorMessage,
      isPasswordObscure: isPasswordObscure ?? this.isPasswordObscure,
    );
  }
}
