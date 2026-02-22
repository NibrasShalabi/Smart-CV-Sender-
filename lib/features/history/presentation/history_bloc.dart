import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smart_cv/features/history/domain/history_entity.dart';
import 'package:smart_cv/features/history/domain/history_usecase.dart';

// Events
abstract class HistoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadHistoryEvent extends HistoryEvent {}

class AddHistoryEvent extends HistoryEvent {
  final HistoryEntity history;
  AddHistoryEvent(this.history);
  @override
  List<Object?> get props => [history];
}

class DeleteHistoryEvent extends HistoryEvent {
  final int id;
  DeleteHistoryEvent(this.id);
  @override
  List<Object?> get props => [id];
}

// States
abstract class HistoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {}
class HistoryLoading extends HistoryState {}
class HistoryLoaded extends HistoryState {
  final List<HistoryEntity> history;
  HistoryLoaded(this.history);
  @override
  List<Object?> get props => [history];
}
class HistoryError extends HistoryState {
  final String message;
  HistoryError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final HistoryUseCase _useCase;

  HistoryBloc(this._useCase) : super(HistoryInitial()) {
    on<LoadHistoryEvent>(_onLoad);
    on<AddHistoryEvent>(_onAdd);
    on<DeleteHistoryEvent>(_onDelete);
  }

  Future<void> _onLoad(LoadHistoryEvent event, Emitter<HistoryState> emit) async {
    emit(HistoryLoading());
    try {
      final history = await _useCase.getHistory();
      emit(HistoryLoaded(history));
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }

  Future<void> _onAdd(AddHistoryEvent event, Emitter<HistoryState> emit) async {
    try {
      await _useCase.addHistory(event.history);
      add(LoadHistoryEvent());
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }

  Future<void> _onDelete(DeleteHistoryEvent event, Emitter<HistoryState> emit) async {
    try {
      await _useCase.deleteHistory(event.id);
      add(LoadHistoryEvent());
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }
}