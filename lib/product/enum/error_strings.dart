enum ErrorStringsEnum {
  loginSuccess('Giriş başarılı'),
  loginFailed('Giriş başarısız'),
  createAccountSuccess('Hesap oluşturma başarılı'),
  createAccountFailed('Hesap oluşturma başarısız'),
  internetConnectionError('İnternet bağlantısı yok'),
  emailEmptyError('Email boş olamaz'),
  passwordEmptyError('Şifre boş olamaz'),
  invalidEmailError('Geçersiz email'),
  emailAlreadyInUseError('Email zaten kullanılıyor'),
  weakPasswordError('Şifre çok zayıf'),
  operationNotAllowedError('İşlem izin verilmedi'),
  unexpectedError('Beklenmeyen hata'),
  invalidCredentialError('Geçersiz kimlik bilgileri'),
  googleLoginCanceled('Google girişi iptal edildi'),
  urlLaunchError('URL açılamadı');

  final String value;
  const ErrorStringsEnum(this.value);
}
