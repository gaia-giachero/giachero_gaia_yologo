import 'package:flutter/material.dart';

class TripImage extends StatelessWidget {
  final String? imageUrl;
  final BoxFit fit;

  const TripImage({this.imageUrl, this.fit = BoxFit.cover, super.key});

  @override
  Widget build(BuildContext context) {
    final url = imageUrl?.trim();

    if (url == null || url.isEmpty) {
      return _buildPlaceholder(context);
    }

    return Image.network(
      url,
      width: double.infinity,
      height: double.infinity,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return _buildPlaceholder(context);
      },
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(Icons.image_outlined, color: colorScheme.onSurfaceVariant),
      ),
    );
  }
}
