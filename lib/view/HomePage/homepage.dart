import 'package:flutter/material.dart';
import 'package:one/view/GamerPhotoGallery/gamerphotogallery.dart';
import 'package:one/view_model/imageprovider.dart';
import 'package:one/view_model/userproivder.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  int _getCrossAxisCount(double width) {
    if (width > 1200) return 4;
    if (width > 800) return 3;
    if (width > 500) return 2;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00E5FF).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.sports_esports,
                    color: Color(0xFF00E5FF),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'KOOAMPARA PES',
                  style: TextStyle(
                    color: Color(0xFF00E5FF),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Provider.of<Userproivder>(context, listen: false)
                        .getalldat();
                    Provider.of<ImageProviders>(context, listen: false)
                        .getImage();
                  },
                  icon: const Icon(Icons.refresh, color: Color(0xFF00E5FF)),
                ),
              ],
            ),
          ),

          // Subtitle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Game Players',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 14,
                letterSpacing: 1,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Grid View
          Expanded(
            child: Consumer2<Userproivder, ImageProviders>(
              builder: (context, userProvider, imageProvider, child) {
                if (userProvider.listData.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.videogame_asset_off,
                          size: 80,
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No gamers yet',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.3),
                            fontSize: 18,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap ADD to add a new gamer',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.2),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount =
                        _getCrossAxisCount(constraints.maxWidth);
                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: userProvider.listData.length,
                      itemBuilder: (context, index) {
                        final user = userProvider.listData[index];
                    

                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GamerPhotoGallery(
                                username: user.username ?? 'Unknown',
                                userId: user.id ?? 0,
                              ),
                            ),
                          ),
                          child: _GamerCard(
                            username: user.username ?? 'Unknown',
                            imageUrl: user.imageUrl,

                            onDelete: user.id != null
                                ? () => userProvider.deleteData(user.id!)
                                : null,
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _GamerCard extends StatelessWidget {
  final String username;
  final String? imageUrl;
  final VoidCallback? onDelete;

  const _GamerCard({
    required this.username,
    this.imageUrl,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF00E5FF).withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00E5FF).withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Image section
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF0E4D92).withValues(alpha: 0.5),
                    const Color(0xFF6C3483).withValues(alpha: 0.3),
                  ],
                ),
              ),
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: imageUrl != null
                    ? Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholder();
                        },
                      )
                    : _buildPlaceholder(),
              ),
            ),
          ),

          // Name section
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  // Online indicator dot
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF00E676),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // if (onDelete != null )
                    // InkWell(
                    //   onTap: onDelete,
                    //   child: Icon(
                    //     Icons.delete_outline,
                    //     size: 18,
                    //     color: Colors.white.withValues(alpha: 0.4),
                    //   ),
                    // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Icon(
        Icons.videogame_asset,
        size: 48,
        color: Colors.white.withValues(alpha: 0.2),
      ),
    );
  }
}
