import 'package:flutter/material.dart';
import 'package:one/view/LoginAndSignUp/Login/login.dart';
import 'package:one/view/MainScreen/mainscreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Use StreamBuilder to listen to auth state changes reactively
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      initialData: AuthState(
        AuthChangeEvent.initialSession,
        Supabase.instance.client.auth.currentSession,
      ),
      builder: (context, snapshot) {
        // Check current user session
        final currentUser = Supabase.instance.client.auth.currentUser;
        
        if (currentUser != null) {
          // User is logged in, show main screen
          return const MainScreen();
        } else {
          // User is not logged in, show login page
          return Loginpage();
        }
      },
    );
  }
}
