import 'package:smart_cv/core/database/database_helper.dart';
import 'package:smart_cv/features/profile/domain/profile_entity.dart';

class ProfileRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;

  Future<ProfileEntity?> getProfile() async {
    final db = await _db.database;
    final result = await db.query('profile', limit: 1);
    if (result.isEmpty) return null;
    return ProfileEntity.fromMap(result.first);
  }

  Future<void> saveProfile(ProfileEntity profile) async {
    final db = await _db.database;
    final existing = await db.query('profile', limit: 1);
    if (existing.isEmpty) {
      await db.insert('profile', profile.toMap());
    } else {
      await db.update('profile', profile.toMap(),
          where: 'id = ?', whereArgs: [existing.first['id']]);
    }
  }
}