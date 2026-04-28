class Donation {
  final int id;
  final int userId;
  final DateTime date;
  final String category;
  final String method;
  final int amount;
  final String notes;
  Donation({
    required this.id,
    required this.userId,
    required this.date,
    required this.category,
    required this.method,
    required this.amount,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'category': category,
      'method': method,
      'amount': amount,
      'notes': notes,
    };
  }
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


