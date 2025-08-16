import 'package:flutter/material.dart';
import '../services/citizen_service.dart';
import '../models/citizen_model.dart';
import '../widgets/SQlite/asgard_app_bar.dart';
import '../widgets/SQlite/citizen_card.dart';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  final CitizenService _citizenService = CitizenService();
  List<Citizen> citizens = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCitizens(); // Vatandaşları yükle
  }

  // Vatandaşları veritabanından yükle
  Future<void> _loadCitizens() async {
    setState(() {
      isLoading = true;
    });

    try {
      final citizensList = await _citizenService.getAllCitizens();
      setState(() {
        citizens = citizensList;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Vatandaş silme fonksiyonu
  Future<void> _deleteCitizen(int id, String name) async {
    // Silme onayı al
    bool? shouldDelete = await _showDeleteConfirmDialog(name);
    
    if (shouldDelete == true) {
      try {
        await _citizenService.deleteCitizen(id);
        _showSuccessMessage('Citizen deleted successfully!'); // Vatandaş başarıyla silindi!
        _loadCitizens(); // Listeyi yenile
      } catch (e) {
        _showErrorMessage('Error deleting citizen!'); // Vatandaş silinirken hata oluştu!
      }
    }
  }

  // Silme onay dialogu
  Future<bool?> _showDeleteConfirmDialog(String citizenName) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.indigo[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.amber.shade600, width: 2),
        ),
        title: const Text(
          'Delete Citizen', // Vatandaş Sil
          style: TextStyle(color: Colors.amber),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.warning, color: Colors.orange[300], size: 60),
            const SizedBox(height: 20),
            Text(
              'Are you sure you want to delete $citizenName from Asgard Archives?', // $citizenName'i Asgard Arşivlerinden silmek istediğinizden emin misiniz?
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Cancel', style: TextStyle(color: Colors.white)), // İptal
                onPressed: () => Navigator.of(context).pop(false),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Delete', style: TextStyle(color: Colors.white)), // Sil
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Başarı mesajı göster
  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Hata mesajı göster
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AsgardAppBar(title: 'Citizens'),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade900, Colors.purple.shade900],
          ),
        ),
        child: RefreshIndicator(
          onRefresh: _loadCitizens, // Aşağı çekerek yenile
          color: Colors.amber,
          child: _buildBody(),
        ),
      ),
      // Tüm kayıtları silme butonu (FAB)
      floatingActionButton: citizens.isNotEmpty
          ? FloatingActionButton(
              backgroundColor: Colors.red[700],
              onPressed: _deleteAllCitizens,
              tooltip: 'Delete All Citizens',
              child: const Icon(Icons.delete_sweep, color: Colors.white),
              // Tüm Vatandaşları Sil
            )
          : null,
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.amber),
      );
    } else if (citizens.isEmpty) {
      return const Center(
        child: Text(
          'No citizens registered yet', // Henüz kayıtlı vatandaş yok
          style: TextStyle(
            color: Colors.amber,
            fontSize: 18,
          ),
        ),
      );
    } else {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: citizens.length,
        itemBuilder: (context, index) {
          final citizen = citizens[index];
          return CitizenCard(
            citizen: citizen,
            onDelete: () => _deleteCitizen(citizen.id!, '${citizen.name} ${citizen.surname}'),
          );
        },
      );
    }
  }

  // Tüm vatandaşları sil
  Future<void> _deleteAllCitizens() async {
    bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.indigo[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.red.shade600, width: 2),
        ),
        title: const Text(
          'Delete All Citizens', // Tüm Vatandaşları Sil
          style: TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.warning_amber, color: Colors.red[300], size: 60),
            const SizedBox(height: 20),
            const Text(
              'This will delete ALL citizens from Asgard Archives. This action cannot be undone!', // Bu işlem TÜM vatandaşları Asgard Arşivlerinden silecek. Bu işlem geri alınamaz!
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Cancel', style: TextStyle(color: Colors.white)), // İptal
                onPressed: () => Navigator.of(context).pop(false),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Delete All', style: TextStyle(color: Colors.white)), // Hepsini Sil
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      try {
        await _citizenService.deleteAllCitizens();
        _showSuccessMessage('All citizens deleted successfully!'); // Tüm vatandaşlar başarıyla silindi!
        _loadCitizens(); // Listeyi yenile
      } catch (e) {
        _showErrorMessage('Error deleting all citizens!'); // Tüm vatandaşlar silinirken hata oluştu!
      }
    }
  }
}