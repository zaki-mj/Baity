import 'package:flutter/material.dart';
import 'package:baity/services/favorite_service.dart';

class YouthHouseCard extends StatefulWidget {
  final String? id;
  final String name;
  final String location;
  final String imageUrl;
  final VoidCallback? onTap;
  final Map<String, dynamic>? fullData;

  const YouthHouseCard({
    super.key,
    required this.name,
    required this.location,
    required this.imageUrl,
    this.onTap,
    this.id,
    this.fullData,
  });

  @override
  State<YouthHouseCard> createState() => _YouthHouseCardState();
}

class _YouthHouseCardState extends State<YouthHouseCard> {
  bool _isFavorite = false;

  void initState() {
    super.initState();
    _loadFavoriteStatus();
    FavoriteService.instance.addListener(_onFavoritesChanged);
  }

  void _loadFavoriteStatus() {
    setState(() {
      _isFavorite = FavoriteService.instance.isFavorite(widget.id);
    });
  }

  void _onFavoritesChanged() {
    if (!mounted) return;
    setState(() {
      _isFavorite = FavoriteService.instance.isFavorite(widget.id);
    });
  }

  Future<void> _toggleFavorite() async {
    if (widget.id == null) return;
    setState(() => _isFavorite = !_isFavorite);
    await FavoriteService.instance.toggleFavorite(widget.id!, widget.fullData);
  }

  @override
  void dispose() {
    FavoriteService.instance.removeListener(_onFavoritesChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasImage = widget.imageUrl.isNotEmpty;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: widget.onTap,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: hasImage
                  ? Image.network(
                      widget.imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image, size: 40),
                      ),
                    )
                  : Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, size: 40),
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.location,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[700],
                              ),
                        ),
                      ],
                    ),
                  ),

                  // Favorite button
                  Padding(
                    padding: const EdgeInsets.only(right: 8, top: 4),
                    child: IconButton(
                        icon: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: _isFavorite ? Colors.red : null,
                          size: 28,
                        ),
                        onPressed: _toggleFavorite),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
