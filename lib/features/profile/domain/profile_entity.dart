import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final int? id;
  final String fullName;
  final String email;
  final String phone;
  final String linkedin;
  final String github;
  final String skills;
  final String experience;
  final String? cvPath;

  const ProfileEntity({
    this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.linkedin,
    required this.github,
    required this.skills,
    required this.experience,
    this.cvPath,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'full_name': fullName,
    'email': email,
    'phone': phone,
    'linkedin': linkedin,
    'github': github,
    'skills': skills,
    'experience': experience,
    'cv_path': cvPath,
  };

  factory ProfileEntity.fromMap(Map<String, dynamic> map) => ProfileEntity(
    id: map['id'],
    fullName: map['full_name'],
    email: map['email'],
    phone: map['phone'],
    linkedin: map['linkedin'],
    github: map['github'],
    skills: map['skills'],
    experience: map['experience'],
    cvPath: map['cv_path'],
  );

  @override
  List<Object?> get props => [id, fullName, email, phone, linkedin, github, skills, experience, cvPath];
}