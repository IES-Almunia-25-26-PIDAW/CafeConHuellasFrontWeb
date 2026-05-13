/// Represents a system user.
///
/// This model contains all user-related information,
/// including personal data, authentication details,
/// and profile metadata.
class User {

  /// Unique identifier of the user.
  final int id;

  /// User's first name.
  final String firstName;

  /// User's first last name.
  final String lastName1;

  /// User's second last name.
  final String lastName2;

  /// User's account password.
  ///
  /// This field is typically only used during
  /// authentication or registration processes.
  final String password;

  /// User's email address.
  final String email;

  /// User's phone number.
  final String phone;

  /// User role within the system.
  ///
  /// Example values:
  /// - admin
  /// - user

  final String role;

  /// URL of the user's profile image.
  final String imageUrl;

  /// Creates a new [User] instance.
  User({
    required this.id,
    required this.firstName,
    required this.lastName1,
    required this.lastName2,
    required this.password,
    required this.email,
    required this.phone,
    required this.role,
    required this.imageUrl,
  });

  /// Creates a [User] instance from JSON data.
  ///
  /// Includes compatibility handling for
  /// snake_case and camelCase API responses.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: (json['id'] as num?)?.toInt() ?? 0,
      firstName:
          (json['firstName'] ??
          json['first_name'] ??
          '').toString(),
      lastName1:
          (json['lastName1'] ??
          json['last_name1'] ??
          '').toString(),
      lastName2:
          (json['lastName2'] ??
          json['last_name2'] ??
          '').toString(),
      password: (json['password'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      role: (json['role'] ?? '').toString(),
      imageUrl:
          (json['imageUrl'] ??
          json['image_url'] ??
          '').toString(),
    );
  }

  /// Converts this object into JSON format.
  ///
  /// Used for API requests and local persistence.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName1': lastName1,
      'lastName2': lastName2,
      'password': password,
      'email': email,
      'phone': phone,
      'role': role,
      'imageUrl': imageUrl,
    };
  }

  /// Creates a copy of this user with updated values.
  ///
  /// Only the provided parameters are replaced.
  User copyWith({
    int? id,
    String? firstName,
    String? lastName1,
    String? lastName2,
    String? password,
    String? email,
    String? phone,
    String? role,
    String? imageUrl,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName1: lastName1 ?? this.lastName1,
      lastName2: lastName2 ?? this.lastName2,
      password: password ?? this.password,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
/// Represents a public user model without password information.
///
/// This model is commonly used when exposing user data
/// to the frontend or API responses where sensitive
/// authentication information should not be included.
class UserWithoutPassword {

  /// Unique identifier of the user.
  final int id;

  /// User's first name.
  final String firstName;

  /// User's first last name.
  final String lastName1;

  /// User's second last name.
  final String lastName2;

  /// User's email address.
  final String email;

  /// User's phone number.
  final String phone;

  /// User role within the system.
  ///
  /// Example values:
  /// - admin
  /// - volunteer
  /// - adopter
  final String role;

  /// URL of the user's profile image.
  final String imageUrl;

  /// Creates a new [UserWithoutPassword] instance.
  UserWithoutPassword({
    required this.id,
    required this.firstName,
    required this.lastName1,
    required this.lastName2,
    required this.email,
    required this.phone,
    required this.role,
    required this.imageUrl,
  });

  /// Creates a [UserWithoutPassword] instance from JSON data.
  ///
  /// Includes compatibility support for
  /// snake_case and camelCase field names.
  factory UserWithoutPassword.fromJson(
    Map<String, dynamic> json,
  ) {
    return UserWithoutPassword(
      id: (json['id'] as num?)?.toInt() ?? 0,
      firstName:
          (json['firstName'] ??
          json['first_name'] ??
          '').toString(),
      lastName1:
          (json['lastName1'] ??
          json['last_name1'] ??
          '').toString(),
      lastName2:
          (json['lastName2'] ??
          json['last_name2'] ??
          '').toString(),
      email: (json['email'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      role: (json['role'] ?? '').toString(),
      imageUrl:
          (json['imageUrl'] ??
          json['image_url'] ??
          '').toString(),
    );
  }

  /// Converts this object into JSON format.
  ///
  /// Used for API responses and data transfer.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName1': lastName1,
      'lastName2': lastName2,
      'email': email,
      'phone': phone,
      'role': role,
      'imageUrl': imageUrl,
    };
  }

  /// Creates a copy of this object with updated values.
  ///
  /// Only the provided parameters are replaced.
  UserWithoutPassword copyWith({
    int? id,
    String? firstName,
    String? lastName1,
    String? lastName2,
    String? email,
    String? phone,
    String? role,
    String? imageUrl,
  }) {
    return UserWithoutPassword(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName1: lastName1 ?? this.lastName1,
      lastName2: lastName2 ?? this.lastName2,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}