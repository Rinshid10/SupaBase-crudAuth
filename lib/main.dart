import 'package:flutter/material.dart';
import 'package:one/constents/supabsekey.dart';
import 'package:one/services/loginServices/loginservices.dart';
import 'package:one/view/HomePage/homepage.dart';
import 'package:one/view/LoginAndSignUp/Login/login.dart';
import 'package:one/view_model/imageprovider.dart';
import 'package:one/view_model/userproivder.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    anonKey: Supabsekey.supaKey,
    url: Supabsekey.supaUrl,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Userproivder(),
        ),
        ChangeNotifierProvider(
          create: (context) => ImageProviders(),
        ),
        ChangeNotifierProvider(
          create: (context) => Loginservices(),
        ),
      ],
      child: MaterialApp(
        home: HompePage(),
      ),
    );
  }
}
