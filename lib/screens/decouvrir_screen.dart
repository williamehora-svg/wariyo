import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/plan.dart';
import '../services/plan_service.dart';

class DecouvrirScreen extends StatefulWidget {
  const DecouvrirScreen({super.key});

  @override
  State<DecouvrirScreen> createState() => _DecouvrirScreenState();
}

class _DecouvrirScreenState extends State<DecouvrirScreen> {
  String _filterType = 'tous';
  String _sortBy = 'recents';
  final PlanService _planService = PlanService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E40AF),
        title: const Text(
          '🌍 Wariyo',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtres
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                _filterChip('tous', 'Tous'),
                const SizedBox(width: 8),
                _filterChip('bon', '✅ Bons Plans'),
                const SizedBox(width: 8),
                _filterChip('mauvais', '❌ Mauvais Plans'),
              ],
            ),
          ),
          // Tri
          Container(
            color: Colors.grey[50],
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _sortBy = 'recents'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: _sortBy == 'recents' ? const Color(0xFF1E40AF) : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Text(
                        'Plus récents',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _sortBy == 'recents' ? Colors.white : Colors.grey[700],
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _sortBy = 'populaires'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: _sortBy == 'populaires' ? const Color(0xFF1E40AF) : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Text(
                        'Plus populaires',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _sortBy == 'populaires' ? Colors.white : Colors.grey[700],
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Liste des plans
          Expanded(
            child: StreamBuilder<List<Plan>>(
              stream: _planService.getPlans(
                filterType: _filterType,
                sortBy: _sortBy,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('🔍', style: TextStyle(fontSize: 50)),
                        SizedBox(height: 16),
                        Text(
                          'Aucun plan pour l\'instant',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        Text(
                          'Soyez le premier à partager !',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return _PlanCard(plan: snapshot.data![index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String value, String label) {
    final isSelected = _filterType == value;
    Color bgColor = isSelected ? const Color(0xFF1E40AF) : Colors.white;
    Color textColor = isSelected ? Colors.white : Colors.grey[700]!;
    Color borderColor = value == 'bon'
        ? const Color(0xFF22C55E)
        : value == 'mauvais'
            ? const Color(0xFFEF4444)
            : const Color(0xFF1E40AF);

    return GestureDetector(
      onTap: () => setState(() => _filterType = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? borderColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : borderColor,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final Plan plan;
  const _PlanCard({required this.plan});

  @override
  Widget build(BuildContext context) {
    final isBon = plan.type == 'bon';
    final color = isBon ? const Color(0xFF22C55E) : const Color(0xFFEF4444);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge + date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isBon ? '✅ BON PLAN' : '❌ MAUVAIS PLAN',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                Text(
                  timeago.format(plan.createdAt, locale: 'fr'),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Produit
            Text(
              plan.product,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            // Lieu
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    plan.place,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Prix
            Text(
              '${plan.price.toStringAsFixed(0)} ${plan.currency}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            // Description
            Text(
              plan.description,
              style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
            ),
            const Divider(height: 20),
            // Auteur + votes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'par ${plan.username}',
                  style: const TextStyle(
                    color: Color(0xFF1E40AF),
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                Row(
                  children: [
                    _VoteButton(
                      planId: plan.id,
                      voteType: 'up',
                      count: plan.voteScore > 0 ? plan.voteScore : 0,
                    ),
                    const SizedBox(width: 8),
                    _VoteButton(
                      planId: plan.id,
                      voteType: 'down',
                      count: plan.voteScore < 0 ? plan.voteScore.abs() : 0,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _VoteButton extends StatelessWidget {
  final String planId;
  final String voteType;
  final int count;
  const _VoteButton({required this.planId, required this.voteType, required this.count});

  @override
  Widget build(BuildContext context) {
    final isUp = voteType == 'up';
    return GestureDetector(
      onTap: () {
        PlanService().vote(planId, voteType);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isUp ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Text(isUp ? '👍' : '👎', style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            Text(
              '$count',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isUp ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
