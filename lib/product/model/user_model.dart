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

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      fullName: map['fullname'] as String? ?? '',
      email: map['email'] as String? ?? '',
      role: map['role'] == 'admin' ? UserRole.admin : UserRole.user,
      unit: map['unit'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullname': fullName,
      'email': email,
      'role': role == UserRole.admin ? 'admin' : 'user',
      if (unit != null) 'unit': unit,
    };
  }
}