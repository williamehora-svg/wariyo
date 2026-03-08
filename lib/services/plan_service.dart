import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/plan.dart';

class PlanService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Récupérer les plans (fil d'actualité)
  Stream<List<Plan>> getPlans({String? filterType, String? sortBy}) {
    Query query = _db.collection('plans').where('is_hidden', isEqualTo: false);

    if (filterType != null && filterType != 'tous') {
      query = query.where('type', isEqualTo: filterType);
    }

    if (sortBy == 'populaires') {
      query = query.orderBy('vote_score', descending: true);
    } else {
      query = query.orderBy('created_at', descending: true);
    }

    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Plan.fromFirestore(doc)).toList());
  }

  // Publier un plan
  Future<void> publishPlan({
    required String type,
    required String product,
    required String place,
    required String countryCode,
    required double price,
    required String currency,
    required String description,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    // Récupérer le pseudo de l'utilisateur
    final userDoc = await _db.collection('users').doc(user.uid).get();
    final username = userDoc.data()?['username'] ?? 'Anonyme';

    await _db.collection('plans').add({
      'user_id': user.uid,
      'username': username,
      'type': type,
      'product': product,
      'place': place,
      'country_code': countryCode,
      'price': price,
      'currency': currency,
      'description': description,
      'vote_score': 0,
      'is_hidden': false,
      'created_at': Timestamp.now(),
    });
  }

  // Voter pour un plan
  Future<void> vote(String planId, String voteType) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final voteRef = _db.collection('votes').doc('${planId}_${user.uid}');
    final voteDoc = await voteRef.get();
    final planRef = _db.collection('plans').doc(planId);
    final planDoc = await planRef.get();
    final planData = planDoc.data();
    if (planData == null) return;

    final posterId = planData['user_id'];

    if (voteDoc.exists) {
      final existingVote = voteDoc.data()?['vote_type'];
      if (existingVote == voteType) {
        // Annuler le vote
        await voteRef.delete();
        int delta = voteType == 'up' ? -1 : 1;
        await planRef.update({'vote_score': FieldValue.increment(delta)});
        // Enlever les points au posteur si c'était un upvote
        if (voteType == 'up' && posterId != user.uid) {
          await _db.collection('users').doc(posterId).update({
            'points': FieldValue.increment(-10),
          });
        }
      } else {
        // Changer le vote
        await voteRef.update({'vote_type': voteType});
        int delta = voteType == 'up' ? 2 : -2;
        await planRef.update({'vote_score': FieldValue.increment(delta)});
      }
    } else {
      // Nouveau vote
      await voteRef.set({
        'plan_id': planId,
        'user_id': user.uid,
        'vote_type': voteType,
        'created_at': Timestamp.now(),
      });
      int delta = voteType == 'up' ? 1 : -1;
      await planRef.update({'vote_score': FieldValue.increment(delta)});

      // +10 points au posteur si upvote
      if (voteType == 'up' && posterId != user.uid) {
        await _db.collection('users').doc(posterId).update({
          'points': FieldValue.increment(10),
        });
      }

      // Masquer automatiquement si score < -5
      final newScore = (planData['vote_score'] ?? 0) + delta;
      if (newScore <= -5) {
        await planRef.update({'is_hidden': true});
      }
    }
  }

  // Récupérer les plans de l'utilisateur connecté
  Stream<List<Plan>> getMyPlans() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);
    return _db
        .collection('plans')
        .where('user_id', isEqualTo: user.uid)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => Plan.fromFirestore(doc)).toList());
  }
}
