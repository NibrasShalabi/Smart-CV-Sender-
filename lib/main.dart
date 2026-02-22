import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cv/core/services/gemini_service.dart';
import 'package:smart_cv/core/services/gmail_data_source.dart';
import 'package:smart_cv/features/compose/domain/compose_usecase.dart';
import 'package:smart_cv/features/compose/presentation/compose_bloc.dart';
import 'package:smart_cv/features/compose/presentation/compose_screen.dart';
import 'package:smart_cv/features/history/data/history_repository.dart';
import 'package:smart_cv/features/history/domain/history_usecase.dart';
import 'package:smart_cv/features/history/presentation/history_bloc.dart';
import 'package:smart_cv/features/history/presentation/history_screen.dart';
import 'package:smart_cv/features/profile/data/profile_repository.dart';
import 'package:smart_cv/features/profile/domain/profile_usecase.dart';
import 'package:smart_cv/features/profile/presentation/profile_bloc.dart';
import 'package:smart_cv/features/profile/presentation/profile_screen.dart';

void main() {
  runApp(const SmartCVApp());
}

class SmartCVApp extends StatelessWidget {
  const SmartCVApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => GmailDataSource()),
        RepositoryProvider(create: (_) => GeminiService()),
        RepositoryProvider(create: (_) => ProfileRepository()),
        RepositoryProvider(create: (_) => HistoryRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (ctx) => ProfileBloc(ProfileUseCase(ctx.read<ProfileRepository>()))),
          BlocProvider(create: (ctx) => ComposeBloc(ComposeUseCase(ctx.read<GeminiService>(), ctx.read<GmailDataSource>()))),
          BlocProvider(create: (ctx) => HistoryBloc(HistoryUseCase(ctx.read<HistoryRepository>()))),
        ],
        child: MaterialApp(
          title: 'Smart CV',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          home: const MainScreen(),
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    ComposeScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.send), label: 'Compose'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}