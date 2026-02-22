import 'package:smart_cv/core/database/database_helper.dart';
import 'package:smart_cv/features/history/domain/history_entity.dart';

class HistoryRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;

  Future<void> addHistory(HistoryEntity history) async {
    final db = await _db.database;
    await db.insert('history', history.toMap());
  }

  Future<List<HistoryEntity>> getHistory() async {
    final db = await _db.database;
    final result = await db.query('history', orderBy: 'sent_at DESC');
    return result.map((e) => HistoryEntity.fromMap(e)).toList();
  }

  Future<void> deleteHistory(int id) async {
    final db = await _db.database;
    await db.delete('history', where: 'id = ?', whereArgs: [id]);
  }
}