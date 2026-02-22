import 'package:smart_cv/features/profile/data/profile_repository.dart';
import 'package:smart_cv/features/profile/domain/profile_entity.dart';

class ProfileUseCase {
  final ProfileRepository _repository;

  ProfileUseCase(this._repository);

  Future<ProfileEntity?> getProfile() async {
    return await _repository.getProfile();
  }

  Future<void> saveProfile(ProfileEntity profile) async {
    await _repository.saveProfile(profile);
  }
}