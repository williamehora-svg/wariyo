import 'package:flutter/material.dart';
import '../services/plan_service.dart';

class PublierScreen extends StatefulWidget {
  const PublierScreen({super.key});

  @override
  State<PublierScreen> createState() => _PublierScreenState();
}

class _PublierScreenState extends State<PublierScreen> {
  String _selectedType = 'bon';
  final _productController = TextEditingController();
  final _placeController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCountry = 'CI';
  String _selectedCurrency = 'FCFA';
  bool _isLoading = false;
  final PlanService _planService = PlanService();

  final List<Map<String, String>> _countries = [
    {'code': 'CI', 'flag': '🇨🇮', 'name': 'Côte d\'Ivoire', 'currency': 'FCFA'},
    {'code': 'SN', 'flag': '🇸🇳', 'name': 'Sénégal', 'currency': 'FCFA'},
    {'code': 'ML', 'flag': '🇲🇱', 'name': 'Mali', 'currency': 'FCFA'},
    {'code': 'BF', 'flag': '🇧🇫', 'name': 'Burkina Faso', 'currency': 'FCFA'},
    {'code': 'GH', 'flag': '🇬🇭', 'name': 'Ghana', 'currency': 'GHS'},
    {'code': 'NG', 'flag': '🇳🇬', 'name': 'Nigeria', 'currency': 'NGN'},
    {'code': 'MA', 'flag': '🇲🇦', 'name': 'Maroc', 'currency': 'MAD'},
    {'code': 'DZ', 'flag': '🇩🇿', 'name': 'Algérie', 'currency': 'DZD'},
    {'code': 'TN', 'flag': '🇹🇳', 'name': 'Tunisie', 'currency': 'TND'},
    {'code': 'FR', 'flag': '🇫🇷', 'name': 'France', 'currency': 'EUR'},
    {'code': 'GB', 'flag': '🇬🇧', 'name': 'Royaume-Uni', 'currency': 'GBP'},
    {'code': 'US', 'flag': '🇺🇸', 'name': 'États-Unis', 'currency': 'USD'},
  ];

  void _publish() async {
    if (_productController.text.isEmpty ||
        _placeController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs obligatoires')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _planService.publishPlan(
        type: _selectedType,
        product: _productController.text.trim(),
        place: _placeController.text.trim(),
        countryCode: _selectedCountry,
        price: double.tryParse(_priceController.text) ?? 0,
        currency: _selectedCurrency,
        description: _descriptionController.text.trim(),
      );

      if (mounted) {
        setState(() => _isLoading = false);
        _productController.clear();
        _placeController.clear();
        _priceController.clear();
        _descriptionController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Plan publié avec succès !'),
            backgroundColor: Color(0xFF22C55E),
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E40AF),
        title: const Text(
          'Publier un plan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sélection BON / MAUVAIS PLAN
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedType = 'bon'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: _selectedType == 'bon'
                            ? const Color(0xFF22C55E)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF22C55E), width: 2),
                        boxShadow: _selectedType == 'bon'
                            ? [BoxShadow(color: const Color(0xFF22C55E).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]
                            : [],
                      ),
                      child: Text(
                        '✅ BON PLAN',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _selectedType == 'bon' ? Colors.white : const Color(0xFF22C55E),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedType = 'mauvais'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: _selectedType == 'mauvais'
                            ? const Color(0xFFEF4444)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFEF4444), width: 2),
                        boxShadow: _selectedType == 'mauvais'
                            ? [BoxShadow(color: const Color(0xFFEF4444).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]
                            : [],
                      ),
                      child: Text(
                        '❌ MAUVAIS PLAN',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _selectedType == 'mauvais' ? Colors.white : const Color(0xFFEF4444),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Champs du formulaire
            _buildTextField(_productController, 'Nom du produit *', Icons.shopping_bag_outlined),
            const SizedBox(height: 14),
            _buildTextField(_placeController, 'Lieu / Boutique *', Icons.location_on_outlined),
            const SizedBox(height: 14),

            // Pays
            DropdownButtonFormField<String>(
              value: _selectedCountry,
              decoration: InputDecoration(
                labelText: 'Pays *',
                prefixIcon: const Icon(Icons.flag_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF1E40AF)),
                ),
              ),
              items: _countries.map((c) {
                return DropdownMenuItem(
                  value: c['code'],
                  child: Text('${c['flag']} ${c['name']}'),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedCountry = val!;
                  _selectedCurrency = _countries.firstWhere((c) => c['code'] == val)['currency']!;
                });
              },
            ),
            const SizedBox(height: 14),

            // Prix + devise
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Prix *',
                      prefixIcon: const Icon(Icons.attach_money),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF1E40AF)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[100],
                  ),
                  child: Text(
                    _selectedCurrency,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Description
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Description *',
                alignLabelWithHint: true,
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(bottom: 60),
                  child: Icon(Icons.description_outlined),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF1E40AF)),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Bouton publier
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _publish,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedType == 'bon'
                      ? const Color(0xFF22C55E)
                      : const Color(0xFFEF4444),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'PUBLIER',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1E40AF)),
        ),
      ),
    );
  }
}
