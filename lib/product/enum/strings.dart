enum StringsEnum {
  welcomeBack('Hoş Geldiniz'),
  emailAddress('Email Adresi'),
  password('Şifre'),
  demoEmail('ornek@email.com'),
  forgotPassword('Şifremi Unuttum'),
  logIn('Giriş Yap'),
  dontHaveAnAccount('Hesabınız yok mu?'),
  signUp('Kayıt Ol'),
  createYourAccount('Hesabınızı Oluşturun'),
  createAccount('Hesap Oluştur'),
  alreadyHaveAnAccount('Zaten hesabınız var mı?'),
  privacyPolicyFirstPart('Devam ederek'),
  privacyPolicySecondPart('Gizlilik Politikası'),
  privacyPolicyUrl('https://example.com/privacy');

  final String value;
  const StringsEnum(this.value);
}

