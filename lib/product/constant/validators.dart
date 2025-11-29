class Validators {
  static const Validators validatorsInstance = Validators._();
  const Validators._();

  RegExp get emailRegex => RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  int get passwordLength => 6;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email boş olamaz';
    }
    if (!emailRegex.hasMatch(value)) {
      return 'Geçerli bir email girin';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Şifre boş olamaz';
    }
    if (value.length < passwordLength) {
      return 'Şifre en az $passwordLength karakter olmalı';
    }
    return null;
  }
}
