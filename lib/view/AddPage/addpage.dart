import 'package:flutter/material.dart';
import 'package:one/model/UserModel/usermodel.dart';
import 'package:one/view_model/imageprovider.dart';
import 'package:one/view_model/userproivder.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddGameUser extends StatelessWidget {
  const AddGameUser({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AddGameUserBody();
  }
}

class _AddGameUserBody extends StatefulWidget {
  const _AddGameUserBody();

  @override
  State<_AddGameUserBody> createState() => _AddGameUserBodyState();
}

class _AddGameUserBodyState extends State<_AddGameUserBody> {
  final TextEditingController _nameController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 600;
    final contentWidth = isWide ? 500.0 : screenWidth;

    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: Container(
            width: contentWidth,
            padding: const EdgeInsets.all(24),
            child: Consumer2<Userproivder, ImageProviders>(
              builder: (context, userProvider, imageProvider, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    // Title
                    const Text(
                      'ADD GAMER',
                      style: TextStyle(
                        color: Color(0xFF00E5FF),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add a new player to the vault',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Avatar picker
                    GestureDetector(
                      onTap: () => imageProvider.pickImage(),
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF00E5FF).withValues(alpha: 0.3),
                              const Color(0xFFBB86FC).withValues(alpha: 0.3),
                            ],
                          ),
                          border: Border.all(
                            color:
                                const Color(0xFF00E5FF).withValues(alpha: 0.5),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00E5FF)
                                  .withValues(alpha: 0.2),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: imageProvider.imageBytes != null
                              ? Image.memory(
                                      imageProvider.imageBytes!,
                                      fit: BoxFit.cover,
                                      width: 140,
                                      height: 140,
                                    )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.camera_alt_outlined,
                                      size: 40,
                                      color:
                                          Colors.white.withValues(alpha: 0.5),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'UPLOAD',
                                      style: TextStyle(
                                        color:
                                            Colors.white.withValues(alpha: 0.5),
                                        fontSize: 12,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Name field
                    TextField(
                      controller: _nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Gamer Name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Save button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isSaving
                            ? null
                            : () => _saveGamer(
                                context, userProvider, imageProvider),
                        child: _isSaving
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFF0A0E21),
                                ),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.sports_esports),
                                  SizedBox(width: 8),
                                  Text('ADD GAMER'),
                                ],
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future _saveGamer(BuildContext context, Userproivder userProvider,
      ImageProviders imageProvider) async {
    var getImageUrl = '';
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a gamer name'),
          backgroundColor: Colors.red.shade700,
        ),
      );
      return;
    }

    final currentUser = Supabase.instance.client.auth.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please login first'),
          backgroundColor: Colors.red.shade700,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      if (imageProvider.imageBytes != null) {
        final response = await imageProvider.addImage();
        if (response != null) {
          final save = Usermodel(
            password: '',
            username: _nameController.text.trim(),
            userId: currentUser.id,
            imageUrl: response,
          );
          

          await userProvider.addDatas(save);
        }
      }

      if (context.mounted) {
        _nameController.clear();
        imageProvider.clearImage();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gamer added successfully!'),
            backgroundColor: Color(0xFF00E676),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
