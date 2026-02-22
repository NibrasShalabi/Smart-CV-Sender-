import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smart_cv/features/profile/domain/profile_entity.dart';
import 'package:smart_cv/features/profile/domain/profile_usecase.dart';

// Events
abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProfileEvent extends ProfileEvent {}

class SaveProfileEvent extends ProfileEvent {
  final ProfileEntity profile;
  SaveProfileEvent(this.profile);
  @override
  List<Object?> get props => [profile];
}

// States
abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}
class ProfileLoading extends ProfileState {}
class ProfileLoaded extends ProfileState {
  final ProfileEntity? profile;
  ProfileLoaded(this.profile);
  @override
  List<Object?> get props => [profile];
}
class ProfileSaved extends ProfileState {}
class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileUseCase _useCase;

  ProfileBloc(this._useCase) : super(ProfileInitial()) {
    on<LoadProfileEvent>(_onLoad);
    on<SaveProfileEvent>(_onSave);
  }

  Future<void> _onLoad(LoadProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final profile = await _useCase.getProfile();
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onSave(SaveProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      await _useCase.saveProfile(event.profile);
      emit(ProfileSaved());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}