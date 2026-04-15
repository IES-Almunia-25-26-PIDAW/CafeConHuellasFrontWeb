class User {
    final int id;
    final String firstName;
    final String lastName1;
    final String lastName2;
    final String password;
    final String email;
    final String phone;
    final String role;
    final String imageUrl;

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

    factory User.fromJson(Map<String, dynamic> json) {
        return User(
            id: (json['id'] as num?)?.toInt() ?? 0,
            firstName: (json['firstName'] ?? json['first_name'] ?? '').toString(),
            lastName1: (json['lastName1'] ?? json['last_name1'] ?? '').toString(),
            lastName2: (json['lastName2'] ?? json['last_name2'] ?? '').toString(),
            password: (json['password'] ?? '').toString(),
            email: (json['email'] ?? '').toString(),
            phone: (json['phone'] ?? '').toString(),
            role: (json['role'] ?? '').toString(),
            imageUrl: (json['imageUrl'] ?? json['image_url'] ?? '').toString(),
        );
    }

    Map <String, dynamic> toJson() {
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

class UserWithoutPassword {
    final int id;
    final String firstName;
    final String lastName1;
    final String lastName2;
    final String email;
    final String phone;
    final String role;
    final String imageUrl;

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

    factory UserWithoutPassword.fromJson(Map<String, dynamic> json) {
        return UserWithoutPassword(
            id: (json['id'] as num?)?.toInt() ?? 0,
            firstName: (json['firstName'] ?? json['first_name'] ?? '').toString(),
            lastName1: (json['lastName1'] ?? json['last_name1'] ?? '').toString(),
            lastName2: (json['lastName2'] ?? json['last_name2'] ?? '').toString(),
            email: (json['email'] ?? '').toString(),
            phone: (json['phone'] ?? '').toString(),
            role: (json['role'] ?? '').toString(),
            imageUrl: (json['imageUrl'] ?? json['image_url'] ?? '').toString(),
        );
    }
    Map <String, dynamic> toJson() {
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
}