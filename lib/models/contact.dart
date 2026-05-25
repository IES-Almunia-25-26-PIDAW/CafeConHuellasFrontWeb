/// Represents a contact message submitted by a user.
///
/// This model contains the information required
/// to send a contact request through the application
/// before it is delivered to the backend API.
class Contact {

  /// Full name of the person sending the message.
  final String name;

  /// Email address of the sender.
  final String email;

  /// Content of the contact message.
  final String message;

  /// Creates a new [Contact] instance.
  Contact({
    required this.name,
    required this.email,
    required this.message,
  });

  /// Converts this object into a JSON map.
  ///
  /// Used when sending contact message data to the API.
  Map<String, dynamic> toJson() {
    return {
      'nombre': name,
      'email': email,
      'mensaje': message,
    };
  }

  /// Creates a [Contact] instance from JSON data.
  ///
  /// Typically used when parsing API responses.
  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      name: json['nombre'],
      email: json['email'],
      message: json['mensaje'],
    );
  }
}