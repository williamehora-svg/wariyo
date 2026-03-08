import 'package:cloud_firestore/cloud_firestore.dart';

class Plan {
  final String id;
  final String userId;
  final String username;
  final String type; // 'bon' ou 'mauvais'
  final String product;
  final String place;
  final String countryCode;
  final double price;
  final String currency;
  final String description;
  final int voteScore;
  final bool isHidden;
  final DateTime createdAt;

  Plan({
    required this.id,
    required this.userId,
    required this.username,
    required this.type,
    required this.product,
    required this.place,
    required this.countryCode,
    required this.price,
    required this.currency,
    required this.description,
    required this.voteScore,
    required this.isHidden,
    required this.createdAt,
  });

  factory Plan.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Plan(
      id: doc.id,
      userId: data['user_id'] ?? '',
      username: data['username'] ?? 'Anonyme',
      type: data['type'] ?? 'bon',
      product: data['product'] ?? '',
      place: data['place'] ?? '',
      countryCode: data['country_code'] ?? 'CI',
      price: (data['price'] ?? 0).toDouble(),
      currency: data['currency'] ?? 'FCFA',
      description: data['description'] ?? '',
      voteScore: data['vote_score'] ?? 0,
      isHidden: data['is_hidden'] ?? false,
      createdAt: (data['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'username': username,
      'type': type,
      'product': product,
      'place': place,
      'country_code': countryCode,
      'price': price,
      'currency': currency,
      'description': description,
      'vote_score': voteScore,
      'is_hidden': isHidden,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }
}
