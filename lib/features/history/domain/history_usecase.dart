import 'package:smart_cv/features/history/data/history_repository.dart';
import 'package:smart_cv/features/history/domain/history_entity.dart';

class HistoryUseCase {
  final HistoryRepository _repository;

  HistoryUseCase(this._repository);

  Future<void> addHistory(HistoryEntity history) async {
    await _repository.addHistory(history);
  }

  Future<List<HistoryEntity>> getHistory() async {
    return await _repository.getHistory();
  }

  Future<void> deleteHistory(int id) async {
    await _repository.deleteHistory(id);
  }
}