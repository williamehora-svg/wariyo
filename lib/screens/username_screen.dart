import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class UsernameScreen extends StatefulWidget {
  const UsernameScreen({super.key});

  @override
  State<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  final _usernameController = TextEditingController();
  String _selectedCountry = 'CI';
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  final List<Map<String, String>> _countries = [
    {'code': 'CI', 'flag': '🇨🇮', 'name': 'Côte d\'Ivoire'},
    {'code': 'SN', 'flag': '🇸🇳', 'name': 'Sénégal'},
    {'code': 'ML', 'flag': '🇲🇱', 'name': 'Mali'},
    {'code': 'BF', 'flag': '🇧🇫', 'name': 'Burkina Faso'},
    {'code': 'TG', 'flag': '🇹🇬', 'name': 'Togo'},
    {'code': 'BJ', 'flag': '🇧🇯', 'name': 'Bénin'},
    {'code': 'GN', 'flag': '🇬🇳', 'name': 'Guinée'},
    {'code': 'GH', 'flag': '🇬🇭', 'name': 'Ghana'},
    {'code': 'NG', 'flag': '🇳🇬', 'name': 'Nigeria'},
    {'code': 'MA', 'flag': '🇲🇦', 'name': 'Maroc'},
    {'code': 'DZ', 'flag': '🇩🇿', 'name': 'Algérie'},
    {'code': 'TN', 'flag': '🇹🇳', 'name': 'Tunisie'},
    {'code': 'FR', 'flag': '🇫🇷', 'name': 'France'},
    {'code': 'US', 'flag': '🇺🇸', 'name': 'États-Unis'},
    {'code': 'GB', 'flag': '🇬🇧', 'name': 'Royaume-Uni'},
  ];

  void _createProfile() async {
    final username = _usernameController.text.trim();
    if (username.isEmpty || username.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le pseudo doit avoir au moins 3 caractères')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.createUserProfile(
        username: username,
        countryCode: _selectedCountry,
      );

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (_) => false,
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
      backgroundColor: const Color(0xFF1E40AF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🌍', style: TextStyle(fontSize: 60)),
              const SizedBox(height: 12),
              const Text(
                'Wariyo',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bienvenue ! 👋',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E40AF),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Choisissez votre pseudo et votre pays',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    // Champ pseudo
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Pseudo *',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF1E40AF)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Sélecteur pays
                    DropdownButtonFormField<String>(
                      value: _selectedCountry,
                      decoration: InputDecoration(
                        labelText: 'Pays *',
                        prefixIcon: const Icon(Icons.flag_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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
                      onChanged: (val) => setState(() => _selectedCountry = val!),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _createProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF22C55E),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'Commencer !',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
