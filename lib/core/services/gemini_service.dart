import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String _apiKey = String.fromEnvironment('GEMINI_API_KEY');
  static const String _url =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

  Future<String> generateCoverLetter({
    required String companyName,
    required String jobTitle,
    required String fullName,
    required String skills,
    required String experience,
  }) async {
    final prompt = '''
You are an expert tech recruiter who has reviewed thousands of applications at top software companies.

Write a cover letter for this Flutter developer:

Name: $fullName
Skills: $skills
Experience: $experience

Applying to: $companyName — $jobTitle

Rules:
- Sound like a real human wrote it, not AI
- Simple, clear language — no fancy words
- Show genuine interest in THIS specific company
- Highlight how the candidate solves problems, not just lists skills
- 3 short paragraphs maximum
- Confident but not arrogant tone
- No clichés like "I am writing to express my interest" or "I would be a great fit"
- Start directly with something that grabs attention
- End with: Best regards,\n$fullName
- Return only the letter, nothing else
''';

    final response = await http.post(
      Uri.parse('$_url?key=$_apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['candidates'][0]['content']['parts'][0]['text'];
    } else {
      throw Exception('Gemini error: ${response.body}');
    }
  }
}


// import 'package:google_generative_ai/google_generative_ai.dart';
//
// class GeminiService {
//   static const String _apiKey = String.fromEnvironment('GEMINI_API_KEY');
//
//   late final GenerativeModel _model;
//
//   GeminiService() {
//     _model = GenerativeModel(
//       model: 'gemini-1.5-flash-latest',
//       apiKey: _apiKey,
//     );
//   }
//
//   Future<String> generateCoverLetter({
//     required String companyName,
//     required String jobTitle,
//     required String fullName,
//     required String skills,
//     required String experience,
//   }) async {
//     final prompt = '''
// You are a professional career coach and expert cover letter writer with years of experience helping candidates land their dream jobs.
//
// Write a compelling, human, and personalized cover letter for the following candidate:
//
// Applicant:
// - Name: $fullName
// - Skills: $skills
// - Experience: $experience
//
// Applying for:
// - Company: $companyName
// - Position: $jobTitle
//
// Guidelines:
// - Write in a warm, confident, and authentic human tone — not robotic or generic
// - Show genuine enthusiasm for the company and role
// - Naturally weave in the applicant's skills and experience without just listing them
// - Make the company feel like it was specifically chosen, not randomly applied to
// - Keep it concise: 3 focused paragraphs
// - Start with: Dear Hiring Manager,
// - End with: Best regards,\\n$fullName
// - Return only the letter itself, no extra comments or formatting
// ''';
//
//     final content = [Content.text(prompt)];
//     final response = await _model.generateContent(content);
//     return response.text ?? 'Failed to generate letter';
//   }
// }
