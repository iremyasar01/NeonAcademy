import 'package:flutter/material.dart';
import '../../models/citizen_model.dart';

class CitizenCard extends StatelessWidget {
  final Citizen citizen;
  final VoidCallback? onDelete; // Silme callback'i
  
  const CitizenCard({
    super.key, 
    required this.citizen,
    this.onDelete,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.indigo.withOpacity(0.4),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.amber.shade700, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Başlık ve silme butonu
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${citizen.name} ${citizen.surname}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[300],
                    ),
                  ),
                ),
                if (onDelete != null) // Eğer silme callback'i varsa butonu göster
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red[400],
                      size: 28,
                    ),
                    onPressed: onDelete,
                    tooltip: 'Delete Citizen', // Vatandaş Sil
                  ),
              ],
            ),
            const SizedBox(height: 10),
            _buildInfoRow('Age', '${citizen.age}'), // Yaş
            _buildInfoRow('Email', citizen.email),
            _buildInfoRow('Realm', citizen.realm), // Bölge
            _buildInfoRow('Special Ability', citizen.specialAbility), // Özel Yetenek
            
            // Citizen ID (Sadece geliştirici için görünür)
            if (citizen.id != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'ID: ${citizen.id}',
                    style: TextStyle(
                      color: Colors.amber[200],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                color: Colors.amber[200],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}