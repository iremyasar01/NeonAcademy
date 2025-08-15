import '../helpers/db_helper.dart';
import '../models/citizen_model.dart';

class CitizenService {
  final DBHelper _dbHelper = DBHelper();

  // Yeni vatandaş ekle
  Future<int> addCitizen(Citizen citizen) async {
    final db = await _dbHelper.database;
    return await db.insert('citizens', citizen.toMap());
  }

  // Tüm vatandaşları getir
  Future<List<Citizen>> getAllCitizens() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('citizens');
    return List.generate(maps.length, (i) => Citizen.fromMap(maps[i]));
  }

  // Vatandaş sil
  Future<int> deleteCitizen(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'citizens',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Email kontrolü - aynı email var mı diye kontrol et
  Future<bool> checkEmailExists(String email) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await db.query(
      'citizens',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty; // Eğer sonuç varsa true döndür
  }

  // ID'ye göre vatandaş getir
  Future<Citizen?> getCitizenById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'citizens',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (maps.isNotEmpty) {
      return Citizen.fromMap(maps.first);
    }
    return null;
  }

  // Vatandaş güncelle
  Future<int> updateCitizen(Citizen citizen) async {
    final db = await _dbHelper.database;
    return await db.update(
      'citizens',
      citizen.toMap(),
      where: 'id = ?',
      whereArgs: [citizen.id],
    );
  }

  // Belirli bir bölgedeki vatandaşları getir
  Future<List<Citizen>> getCitizensByRealm(String realm) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'citizens',
      where: 'realm = ?',
      whereArgs: [realm],
    );
    return List.generate(maps.length, (i) => Citizen.fromMap(maps[i]));
  }

  // Tüm kayıtları sil (Dikkatli kullanın!)
  Future<int> deleteAllCitizens() async {
    final db = await _dbHelper.database;
    return await db.delete('citizens');
  }
}