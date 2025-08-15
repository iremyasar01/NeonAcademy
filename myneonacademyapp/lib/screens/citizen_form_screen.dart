import 'package:flutter/material.dart';
import 'package:myneonacademyapp/screens/record_screen.dart';
import '../services/citizen_service.dart';
import '../models/citizen_model.dart';
import '../widgets/SQlite/input_field.dart';
import '../widgets/SQlite/asgard_app_bar.dart';
import '../widgets/SQlite/success_dialog.dart';

class CitizenFormScreen extends StatefulWidget {
  const CitizenFormScreen({super.key});

  @override
  State<CitizenFormScreen> createState() => _CitizenFormScreenState();
}

class _CitizenFormScreenState extends State<CitizenFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  final _realmController = TextEditingController();
  final _abilityController = TextEditingController();

  final CitizenService _citizenService = CitizenService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AsgardAppBar(title: 'Register Form'),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade900, Colors.purple.shade900],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                _buildHeader(),
                InputField(
                  controller: _nameController,
                  label: 'Name',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter name'; // İsim giriniz
                    }
                    return null;
                  },
                ),
                InputField(
                  controller: _surnameController,
                  label: 'Surname',
                  icon: Icons.family_restroom,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter surname'; // Soyisim giriniz
                    }
                    return null;
                  },
                ),
                InputField(
                  controller: _ageController,
                  label: 'Age',
                  icon: Icons.cake,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter age'; // Yaş giriniz
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number'; // Geçerli bir sayı giriniz
                    }
                    return null;
                  },
                ),
                InputField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email'; // Email giriniz
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email address'; // Geçerli email adresi giriniz
                    }
                    return null;
                  },
                ),
                InputField(
                  controller: _realmController,
                  label: 'Realm (exp: Vanaheim)',
                  icon: Icons.public,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter realm'; // Bölge giriniz
                    }
                    return null;
                  },
                ),
                InputField(
                  controller: _abilityController,
                  label: 'Special Ability',
                  icon: Icons.auto_awesome,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter special ability'; // Özel yetenek giriniz
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildSubmitButton(),
                const SizedBox(height: 20),
                _buildViewRecordsButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      children: [
        SizedBox(height: 10),
        Text(
          'Enter Citizen Information', // Vatandaş Bilgilerini Girin
          style: TextStyle(fontSize: 18, color: Colors.white70)
        ),
        Divider(color: Colors.amber, thickness: 2, height: 30),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.save, color: Colors.amber),
      label: const Text('SAVE', style: TextStyle(color: Colors.black)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[800],
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          // Aynı email ile kayıt kontrolü
          bool emailExists = await _citizenService.checkEmailExists(_emailController.text);
          
          if (emailExists) {
            _showErrorDialog('This email is already registered!'); // Bu email zaten kayıtlı!
            return;
          }

          final newCitizen = Citizen(
            name: _nameController.text,
            surname: _surnameController.text,
            age: int.parse(_ageController.text),
            email: _emailController.text,
            realm: _realmController.text,
            specialAbility: _abilityController.text,
          );

          await _citizenService.addCitizen(newCitizen);
          _showSuccessDialog();
          _clearForm(); // Formu temizle
        }
      },
    );
  }

  Widget _buildViewRecordsButton() {
    return OutlinedButton.icon(
      icon: const Icon(Icons.list, color: Colors.amber),
      label: const Text('VIEW RECORDS', style: TextStyle(color: Colors.amber)), // Kayıtları Görüntüle
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.amber.shade600),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RecordsScreen()),
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => const SuccessDialog(),
    );
  }

  // Hata dialogu göster
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.indigo[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.red.shade600, width: 2),
        ),
        title: const Text(
          'Error!', // Hata!
          style: TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error, color: Colors.red[300], size: 60),
            const SizedBox(height: 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('OK', style: TextStyle(color: Colors.white)),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  // Formu temizle
  void _clearForm() {
    _nameController.clear();
    _surnameController.clear();
    _ageController.clear();
    _emailController.clear();
    _realmController.clear();
    _abilityController.clear();
  }

  @override
  void dispose() {
    // Controller'ları temizle
    _nameController.dispose();
    _surnameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _realmController.dispose();
    _abilityController.dispose();
    super.dispose();
  }
}