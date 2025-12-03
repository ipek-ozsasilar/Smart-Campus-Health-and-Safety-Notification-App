import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobil_proje/product/enum/error_strings.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_sign_in/google_sign_in.dart';

var createAccountProvider =
    StateNotifierProvider<CreateAccountProvider, CreateAccountState>(
      (ref) => CreateAccountProvider(),
    );

class CreateAccountProvider extends StateNotifier<CreateAccountState> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  CreateAccountProvider()
    : super(
        const CreateAccountState(
          isLoading: false,
          fullName: '',
          email: '',
          password: '',
          isConnected: false,
          errorMessage: '',
          isPasswordObscure: false,
        ),
      );

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
    final fullName = fullNameController.text.trim();

    if (fullName.isEmpty) {
      changeStateErrorMessage('İsim boş olamaz');
      return false;
    }

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
    changeStateFullName(fullName);
    changeStateEmail(email);
    changeStatePassword(password);
    return true;
  }

  //Firebase login işlemini yapıyoruz
  Future<bool> emailAndPasswordCreateAccount() async {
    try {
      changeStateIsLoading(true);
      final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: state.email!,
        password: state.password!,
      );
      if (user.user != null) {
        await _createUserDocument(
          user.user!,
          fullName: state.fullName ?? fullNameController.text.trim(),
          email: state.email!,
        );
        changeStateErrorMessage(ErrorStringsEnum.createAccountSuccess.value);
        changeStateIsLoading(false);
        clearFullNameAndEmailAndPassword();
        return true;
      } else {
        changeStateErrorMessage(ErrorStringsEnum.createAccountFailed.value);
        changeStateIsLoading(false);
        return false;
      }
    } on FirebaseAuthException catch (e) {
      changeStateIsLoading(false);
      switch (e.code) {
        case 'invalid-email':
          changeStateErrorMessage(ErrorStringsEnum.invalidEmailError.value);
          break;
        case 'email-already-in-use':
          changeStateErrorMessage(
            ErrorStringsEnum.emailAlreadyInUseError.value,
          );
          break;
        case 'weak-password':
          changeStateErrorMessage(ErrorStringsEnum.weakPasswordError.value);
          break;
        case 'operation-not-allowed':
          changeStateErrorMessage(
            ErrorStringsEnum.operationNotAllowedError.value,
          );
          break;
        default:
          changeStateErrorMessage(ErrorStringsEnum.unexpectedError.value);
      }
      return false;
    } catch (e) {
      changeStateIsLoading(false);
      changeStateErrorMessage(ErrorStringsEnum.unexpectedError.value);
      return false;
    } finally {
      changeStateIsLoading(false);
    }
  }

  Future<bool> GoogleCreateAccount() async {
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
        await _createUserDocument(
          userCredential.user!,
          fullName: userCredential.user!.displayName,
          email: userCredential.user!.email,
        );
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

  void changeStateFullName(String fullName) {
    state = state.copyWith(fullName: fullName);
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

  void clearFullNameAndEmailAndPassword() {
    fullNameController.clear();
    emailController.clear();
    passwordController.clear();
    changeStateFullName('');
    changeStateEmail('');
    changeStatePassword('');
  }

  Future<void> _createUserDocument(
    User user, {
    String? fullName,
    String? email,
  }) async {
    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);
    final docSnapshot = await userDoc.get();
    final resolvedName = (fullName?.trim().isNotEmpty ?? false)
        ? fullName!.trim()
        : 'Kullanıcı';
    final resolvedEmail = email ?? user.email ?? '';

    if (docSnapshot.exists) {
      // Sadece eksik alanları tamamla
      await userDoc.set({
        'fullname': resolvedName,
        'email': resolvedEmail,
        'role': docSnapshot.data()?['role'] ?? 'user',
      }, SetOptions(merge: true));
    } else {
      await userDoc.set({
        'id': user.uid,
        'fullname': resolvedName,
        'email': resolvedEmail,
        'role': 'user',
        'unit': null,
        'notificationsEnabled': true,
        'emailNotifications': true,
        'pushNotifications': true,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }
}

class CreateAccountState extends Equatable {
  final bool isLoading;
  final String? email;
  final String? password;
  final bool isConnected;
  final String? errorMessage;
  final bool isPasswordObscure;
  final String? fullName;
  const CreateAccountState({
    required this.isLoading,
    required this.email,
    required this.password,
    required this.isConnected,
    required this.errorMessage,
    required this.isPasswordObscure,
    required this.fullName,
  });

  @override
  List<Object?> get props => [
    isLoading,
    email,
    password,
    isConnected,
    errorMessage,
    fullName,
  ];

  CreateAccountState copyWith({
    bool? isLoading,
    String? email,
    String? password,
    bool? isConnected,
    String? errorMessage,
    bool? isPasswordObscure,
    String? fullName,
  }) {
    return CreateAccountState(
      isLoading: isLoading ?? this.isLoading,
      email: email ?? this.email,
      password: password ?? this.password,
      isConnected: isConnected ?? this.isConnected,
      errorMessage: errorMessage ?? this.errorMessage,
      isPasswordObscure: isPasswordObscure ?? this.isPasswordObscure,
      fullName: fullName ?? this.fullName,
    );
  }
}