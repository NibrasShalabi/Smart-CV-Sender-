import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smart_cv/features/compose/domain/compose_usecase.dart';
import 'package:smart_cv/features/profile/domain/profile_entity.dart';

// Events
abstract class ComposeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GenerateLetterEvent extends ComposeEvent {
  final String companyName;
  final String jobTitle;
  final ProfileEntity profile;

  GenerateLetterEvent({
    required this.companyName,
    required this.jobTitle,
    required this.profile,
  });

  @override
  List<Object?> get props => [companyName, jobTitle, profile];
}

class SendEmailEvent extends ComposeEvent {
  final String to;
  final String subject;
  final String body;
  final ProfileEntity profile;

  SendEmailEvent({
    required this.to,
    required this.subject,
    required this.body,
    required this.profile,
  });

  @override
  List<Object?> get props => [to, subject, body, profile];
}

// States
abstract class ComposeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ComposeInitial extends ComposeState {}
class ComposeGenerating extends ComposeState {}
class ComposeGenerated extends ComposeState {
  final String letter;
  ComposeGenerated(this.letter);
  @override
  List<Object?> get props => [letter];
}
class ComposeSending extends ComposeState {}
class ComposeSent extends ComposeState {}
class ComposeError extends ComposeState {
  final String message;
  ComposeError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class ComposeBloc extends Bloc<ComposeEvent, ComposeState> {
  final ComposeUseCase _useCase;

  ComposeBloc(this._useCase) : super(ComposeInitial()) {
    on<GenerateLetterEvent>(_onGenerate);
    on<SendEmailEvent>(_onSend);
  }

  Future<void> _onGenerate(GenerateLetterEvent event, Emitter<ComposeState> emit) async {
    emit(ComposeGenerating());
    try {
      final letter = await _useCase.generateLetter(
        companyName: event.companyName,
        jobTitle: event.jobTitle,
        profile: event.profile,
      );
      emit(ComposeGenerated(letter));
    } catch (e) {
      emit(ComposeError(e.toString()));
    }
  }

  Future<void> _onSend(SendEmailEvent event, Emitter<ComposeState> emit) async {
    emit(ComposeSending());
    try {
      await _useCase.sendEmail(
        to: event.to,
        subject: event.subject,
        body: event.body,
        profile: event.profile,
      );
      emit(ComposeSent());
    } catch (e) {
      emit(ComposeError(e.toString()));
    }
  }
}