import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/alquran_viewmodel.dart';
import 'viewmodels/doa_viewmodel.dart';
import 'viewmodels/jadwal_viewmodel.dart';
import 'viewmodels/ramadhan_viewmodel.dart';
import 'viewmodels/asmaul_viewmodel.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/qiblat_view_model.dart';
import 'viewmodels/chatbot_viewmodel.dart';
import 'repositories/qiblat_repository.dart';
import 'services/qiblat_service.dart';
import 'views/splash_screen.dart';
import 'views/login_screen.dart';
import 'views/home_screen.dart';
import 'views/profile_screen.dart';
import 'views/alquran_screen.dart';
import 'views/doa_screen.dart';
import 'views/jadwal_screen.dart';
import 'views/ramadhan_screen.dart';
import 'views/asmaul_screen.dart';
import 'views/qiblat_screen.dart';
import 'views/chatbot_screen.dart';

import 'dart:io' show Platform;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

 

  runApp(const MuslimApp());
}

class MuslimApp extends StatelessWidget {
  const MuslimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => AlQuranViewModel()),
        ChangeNotifierProvider(create: (_) => DoaViewModel()),
        ChangeNotifierProvider(create: (_) => JadwalViewModel()),
        ChangeNotifierProvider(create: (_) => RamadhanViewModel()),
        ChangeNotifierProvider(create: (_) => AsmaulViewModel()),
        ChangeNotifierProvider(
          create: (_) => QiblatViewModel(
            QiblatRepository(QiblatService()),
          ),
        ),
        ChangeNotifierProvider(create: (_) => ChatBotViewModel()),
      ],
      child: MaterialApp(
        title: 'Spiritual Companion',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF0FFFE),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/jadwal': (context) => const JadwalScreen(),
          '/quran': (context) => const AlQuranScreen(),
          '/doa': (context) => const DoaScreen(),
          '/ramadhan': (context) => const RamadhanScreen(),
          '/asmaul': (context) => const AsmaulScreen(),
          '/qiblat': (context) => const QiblatScreen(),
          '/chatbot': (context) => const ChatBotScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
