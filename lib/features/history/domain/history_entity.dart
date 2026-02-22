import 'package:equatable/equatable.dart';

class HistoryEntity extends Equatable {
  final int? id;
  final String companyName;
  final String jobTitle;
  final String recipientEmail;
  final String sentAt;
  final String status;

  const HistoryEntity({
    this.id,
    required this.companyName,
    required this.jobTitle,
    required this.recipientEmail,
    required this.sentAt,
    required this.status,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'company_name': companyName,
    'job_title': jobTitle,
    'recipient_email': recipientEmail,
    'sent_at': sentAt,
    'status': status,
  };

  factory HistoryEntity.fromMap(Map<String, dynamic> map) => HistoryEntity(
    id: map['id'],
    companyName: map['company_name'],
    jobTitle: map['job_title'],
    recipientEmail: map['recipient_email'],
    sentAt: map['sent_at'],
    status: map['status'],
  );

  @override
  List<Object?> get props => [id, companyName, jobTitle, recipientEmail, sentAt, status];
}