import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cv/features/compose/presentation/compose_bloc.dart';
import 'package:smart_cv/features/profile/domain/profile_entity.dart';
import 'package:smart_cv/features/profile/presentation/profile_bloc.dart';

import '../../history/domain/history_entity.dart';
import '../../history/presentation/history_bloc.dart';

class ComposeScreen extends StatefulWidget {
  const ComposeScreen({super.key});

  @override
  State<ComposeScreen> createState() => _ComposeScreenState();
}

class _ComposeScreenState extends State<ComposeScreen> {
  final _companyController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _emailController = TextEditingController();
  final _letterController = TextEditingController();

  ProfileEntity? _profile;

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadProfileEvent());
  }

  void _generate() {
    if (_profile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete your profile first!')),
      );
      return;
    }
    if (_companyController.text.isEmpty || _jobTitleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter company name and job title!')),
      );
      return;
    }
    context.read<ComposeBloc>().add(GenerateLetterEvent(
      companyName: _companyController.text,
      jobTitle: _jobTitleController.text,
      profile: _profile!,
    ));
  }

  void _send() {
    if (_emailController.text.isEmpty || _letterController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields!')),
      );
      return;
    }
    context.read<ComposeBloc>().add(SendEmailEvent(
      to: _emailController.text,
      subject: 'Application for ${_jobTitleController.text} at ${_companyController.text}',
      body: _letterController.text,
      profile: _profile!,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Compose Email')),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            setState(() => _profile = state.profile);
          }
        },
        child: BlocConsumer<ComposeBloc, ComposeState>(
          listener: (context, state) {
            if (state is ComposeGenerated) {
              _letterController.text = state.letter;
            }
            if (state is ComposeSent) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Email sent successfully! ✅')),
              );
              context.read<HistoryBloc>().add(AddHistoryEvent(
                HistoryEntity(
                  companyName: _companyController.text,
                  jobTitle: _jobTitleController.text,
                  recipientEmail: _emailController.text,
                  sentAt: DateTime.now().toString(),
                  status: 'Sent',
                ),
              ));
            }
            if (state is ComposeError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _companyController,
                    decoration: const InputDecoration(
                      labelText: 'Company Name',
                      prefixIcon: Icon(Icons.business),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _jobTitleController,
                    decoration: const InputDecoration(
                      labelText: 'Job Title',
                      prefixIcon: Icon(Icons.work),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Company Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: state is ComposeGenerating ? null : _generate,
                      icon: state is ComposeGenerating
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.auto_awesome),
                      label: Text(state is ComposeGenerating ? 'Generating...' : 'Generate Letter'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _letterController,
                    maxLines: 12,
                    decoration: const InputDecoration(
                      labelText: 'Cover Letter',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: state is ComposeSending ? null : _send,
                      icon: state is ComposeSending
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.send),
                      label: Text(state is ComposeSending ? 'Sending...' : 'Send Email'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _companyController.dispose();
    _jobTitleController.dispose();
    _emailController.dispose();
    _letterController.dispose();
    super.dispose();
  }
}