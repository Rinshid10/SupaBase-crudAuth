import 'package:flutter/material.dart';
import 'package:one/model/UserModel/usermodel.dart';
import 'package:one/view_model/userproivder.dart';
import 'package:provider/provider.dart';

class Editpage extends StatelessWidget {
  final String? username;
  final String? password;
  final int id;

  Editpage({
    super.key,
    required this.password,
    required this.username,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController name = TextEditingController(text: username);
    final TextEditingController passwords =
        TextEditingController(text: password);
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 600;
    final contentWidth = isWide ? 500.0 : screenWidth;

    return Consumer<Userproivder>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: const Text('EDIT GAMER'),
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                width: contentWidth,
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Avatar placeholder
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF16213E),
                        border: Border.all(
                          color: const Color(0xFFBB86FC).withValues(alpha: 0.5),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFBB86FC)
                                .withValues(alpha: 0.2),
                            blurRadius: 15,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          (username ?? '?')[0].toUpperCase(),
                          style: const TextStyle(
                            color: Color(0xFFBB86FC),
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    TextField(
                      controller: name,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Gamer Name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: passwords,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                    ),

                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFBB86FC),
                        ),
                        onPressed: () {
                          final save = Usermodel(
                              password: passwords.text, username: name.text);
                          value.updateData(id, save);
                          Navigator.pop(context);
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save),
                            SizedBox(width: 8),
                            Text('UPDATE'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
