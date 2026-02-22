import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/gmail/v1.dart' as gmail;
import 'package:http/http.dart' as http;

class GmailDataSource {
  static const List<String> _scopes = [
    'https://www.googleapis.com/auth/gmail.send',
  ];

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: _scopes);

  Future<GoogleSignInAccount?> signIn() async {
    return await _googleSignIn.signIn();
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

  Future<bool> isSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }

  Future<void> sendEmail({
    required String to,
    required String subject,
    required String body,
    List<int>? cvBytes,
    String? cvFileName,
  }) async {
    final account = await _googleSignIn.signInSilently() ?? await _googleSignIn.signIn();
    if (account == null) throw Exception('لم يتم تسجيل الدخول');

    final authHeaders = await account.authHeaders;
    final client = _GoogleAuthClient(authHeaders);
    final gmailApi = gmail.GmailApi(client);

    final message = _buildMimeMessage(
      to: to,
      from: account.email,
      subject: subject,
      body: body,
      cvBytes: cvBytes,
      cvFileName: cvFileName,
    );

    final encoded = base64Url.encode(utf8.encode(message));
    await gmailApi.users.messages.send(
      gmail.Message(raw: encoded),
      'me',
    );
  }

  String _buildMimeMessage({
    required String to,
    required String from,
    required String subject,
    required String body,
    List<int>? cvBytes,
    String? cvFileName,
  }) {
    if (cvBytes == null) {
      return 'To: $to\r\nFrom: $from\r\nSubject: $subject\r\nContent-Type: text/plain; charset=utf-8\r\n\r\n$body';
    }

    final boundary = 'boundary_${DateTime.now().millisecondsSinceEpoch}';
    final cvBase64 = base64.encode(cvBytes);

    return '''To: $to\r\nFrom: $from\r\nSubject: $subject\r\nMIME-Version: 1.0\r\nContent-Type: multipart/mixed; boundary="$boundary"\r\n\r\n--$boundary\r\nContent-Type: text/plain; charset=utf-8\r\n\r\n$body\r\n\r\n--$boundary\r\nContent-Type: application/pdf\r\nContent-Transfer-Encoding: base64\r\nContent-Disposition: attachment; filename="$cvFileName"\r\n\r\n$cvBase64\r\n\r\n--$boundary--''';
  }
}

class _GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  _GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}