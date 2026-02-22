import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cv/features/profile/domain/profile_entity.dart';
import 'package:smart_cv/features/profile/presentation/profile_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _linkedinController = TextEditingController();
  final _githubController = TextEditingController();
  final _skillsController = TextEditingController();
  final _experienceController = TextEditingController();
  final _cvPathController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadProfileEvent());
  }

  void _fillForm(ProfileEntity profile) {
    _nameController.text = profile.fullName;
    _emailController.text = profile.email;
    _phoneController.text = profile.phone;
    _linkedinController.text = profile.linkedin;
    _githubController.text = profile.github;
    _skillsController.text = profile.skills;
    _experienceController.text = profile.experience;
    _cvPathController.text = profile.cvPath ?? '';
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final profile = ProfileEntity(
        fullName: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        linkedin: _linkedinController.text,
        github: _githubController.text,
        skills: _skillsController.text,
        experience: _experienceController.text,
        cvPath: _cvPathController.text.isEmpty ? null : _cvPathController.text,
      );
      context.read<ProfileBloc>().add(SaveProfileEvent(profile));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded && state.profile != null) {
            _fillForm(state.profile!);
          }
          if (state is ProfileSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile saved successfully!')),
            );
          }
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildField(_nameController, 'Full Name', Icons.person),
                  _buildField(_emailController, 'Email', Icons.email),
                  _buildField(_phoneController, 'Phone', Icons.phone),
                  _buildField(_linkedinController, 'LinkedIn URL', Icons.link),
                  _buildField(_githubController, 'GitHub URL', Icons.code),
                  _buildField(_skillsController, 'Skills', Icons.star, maxLines: 3),
                  _buildField(_experienceController, 'Experience', Icons.work, maxLines: 4),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _cvPathController,
                    decoration: InputDecoration(
                      labelText: 'CV Path',
                      prefixIcon: const Icon(Icons.picture_as_pdf),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: _cvPathController.text));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Path copied!')),
                          );
                        },
                      ),
                    ),
                    // hint: 'e.g. /storage/emulated/0/Download/my_cv.pdf',
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _save,
                      child: const Text('Save Profile'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label, IconData icon, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _linkedinController.dispose();
    _githubController.dispose();
    _skillsController.dispose();
    _experienceController.dispose();
    _cvPathController.dispose();
    super.dispose();
  }
}