import 'package:flutter/material.dart';
import 'package:one/constents/supabsekey.dart';
import 'package:one/services/loginServices/loginservices.dart';
import 'package:one/view/AuthWrapper/authwrapper.dart';
import 'package:one/view_model/imageprovider.dart';
import 'package:one/view_model/userproivder.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    anonKey: Supabsekey.supaKey,
    url: 'https://aacxepatckynoxgijxsn.supabase.co',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Userproivder()),
        ChangeNotifierProvider(create: (context) => ImageProviders()),
        ChangeNotifierProvider(create: (context) => Loginservices()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GameVault',
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF0A0E21),
          primaryColor: const Color(0xFF00E5FF),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF00E5FF),
            secondary: Color(0xFFBB86FC),
            surface: Color(0xFF1A1A2E),
            error: Color(0xFFFF5252),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF0A0E21),
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              color: Color(0xFF00E5FF),
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
            iconTheme: IconThemeData(color: Color(0xFF00E5FF)),
          ),
          cardTheme: CardThemeData(
            color: const Color(0xFF16213E),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFF16213E),
            hintStyle: const TextStyle(color: Colors.white38),
            prefixIconColor: const Color(0xFF00E5FF),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF00E5FF), width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1A1A2E), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF00E5FF), width: 2),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00E5FF),
              foregroundColor: const Color(0xFF0A0E21),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}
