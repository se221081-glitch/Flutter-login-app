/// Model class to represent user data
class User {
  final String id;
  final String fullName;
  final String email;
  final String? gender;
  final DateTime loginTime;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    this.gender,
    DateTime? loginTime,
  }) : loginTime = loginTime ?? DateTime.now();

  /// Create a copy of User with modified fields
  User copyWith({
    String? id,
    String? fullName,
    String? email,
    String? gender,
    DateTime? loginTime,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      loginTime: loginTime ?? this.loginTime,
    );
  }

  @override
  String toString() =>
      'User(id: $id, fullName: $fullName, email: $email, gender: $gender)';
}
