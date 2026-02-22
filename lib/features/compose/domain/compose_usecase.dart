import 'package:smart_cv/core/services/gemini_service.dart';
import 'package:smart_cv/core/services/gmail_data_source.dart';
import 'package:smart_cv/features/profile/domain/profile_entity.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class ComposeUseCase {
  final GeminiService _gemini;
  final GmailDataSource _gmail;

  ComposeUseCase(this._gemini, this._gmail);

  Future<String> generateLetter({
    required String companyName,
    required String jobTitle,
    required ProfileEntity profile,
  }) async {
    return await _gemini.generateCoverLetter(
      companyName: companyName,
      jobTitle: jobTitle,
      fullName: profile.fullName,
      skills: profile.skills,
      experience: profile.experience,
    );
  }

  Future<void> sendEmail({
    required String to,
    required String subject,
    required String body,
    required ProfileEntity profile,
  }) async {
    List<int>? cvBytes;
    String? cvFileName;

    if (profile.cvPath != null) {
      final status = await Permission.manageExternalStorage.request();
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      final file = File(profile.cvPath!);
      cvBytes = await file.readAsBytes();
      cvFileName = file.path.split('/').last;
    }

    await _gmail.sendEmail(
      to: to,
      subject: subject,
      body: body,
      cvBytes: cvBytes,
      cvFileName: cvFileName,
    );
  }
}