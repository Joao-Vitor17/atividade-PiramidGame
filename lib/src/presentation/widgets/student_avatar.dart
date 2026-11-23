import 'package:flutter/material.dart';

class StudentAvatar extends StatelessWidget {
  final String name;
  final String? photoUrl;
  final double radius;
  final bool editable;
  final bool isLoading;
  final VoidCallback? onTap;

  const StudentAvatar({
    required this.name,
    required this.photoUrl,
    required this.radius,
    this.editable = false,
    this.isLoading = false,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final diameter = radius * 2;
    final image = photoUrl == null || photoUrl!.isEmpty
        ? _fallback(context)
        : Image.network(
            photoUrl!,
            width: diameter,
            height: diameter,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _fallback(context),
          );
    final avatar = CircleAvatar(
      radius: radius,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: ClipOval(
        child: SizedBox(
          width: diameter,
          height: diameter,
          child: image,
        ),
      ),
    );

    if (!editable) return avatar;

    return Semantics(
      button: true,
      label: 'Alterar foto de $name',
      child: GestureDetector(
        onTap: isLoading ? null : onTap,
        child: Stack(
          children: [
            avatar,
            if (isLoading)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    color: Colors.black45,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(radius * 0.65),
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
            else
              Positioned(
                right: 0,
                bottom: 0,
                child: CircleAvatar(
                  radius: radius * 0.36,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  child: Icon(
                    Icons.camera_alt,
                    size: radius * 0.4,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _fallback(BuildContext context) => Center(
        child: Text(
          name.isEmpty ? '?' : name[0].toUpperCase(),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      );
}
