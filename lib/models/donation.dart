/// Represents a donation made by a user.
///
/// This model contains donation details such as
/// the donation category, payment method,
/// amount, and optional notes.
class Donation {

  /// Unique identifier of the donation.
  final int id;

  /// Identifier of the user who made the donation.
  final int userId;

  /// Date when the donation was made.
  final DateTime date;

  /// Donation category.
  ///
  /// Example values:
  /// - Food
  /// - Medical
  /// - Shelter
  /// - General Support
  final String category;

  /// Payment or donation method used.
  ///
  /// Example values:
  /// - Credit Card
  /// - PayPal
  /// - Bank Transfer
  /// - Cash
  final String method;

  /// Donation amount.
  final int amount;

  /// Additional notes or comments related to the donation.
  final String notes;

  /// Creates a new [Donation] instance.
  Donation({
    required this.id,
    required this.userId,
    required this.date,
    required this.category,
    required this.method,
    required this.amount,
    required this.notes,
  });

  /// Converts this object into JSON format.
  ///
  /// Used for sending donation data to the backend API.
  ///
  /// The [id] field is only included if its value
  /// is different from `0`.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'userId': userId,
      'date': date.toIso8601String(),
      'category': category,
      'method': method,
      'amount': amount,
      'notes': notes,
    };

    if (id != 0) {
      map['id'] = id;
    }

    return map;
  }

  /// Creates a [Donation] instance from JSON data.
  ///
  /// Typically used when parsing API responses.
  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      id: json['id'] as int,
      userId: json['userId'] as int,
      date: DateTime.parse(json['date'] as String),
      category: json['category'] as String,
      method: json['method'] as String,
      amount: json['amount'] as int,
      notes: json['notes'] as String,
    );
  }
}