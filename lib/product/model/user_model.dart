enum UserRole {
  user('Kullanıcı'),
  admin('Yönetici');

  final String label;
  const UserRole(this.label);
}

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final UserRole role;
  final String? unit;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    this.unit,
  });
}
