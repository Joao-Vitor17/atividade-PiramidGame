import 'package:flutter/material.dart';

class RankingPositionBadge extends StatelessWidget {
  final int position;

  const RankingPositionBadge({
    required this.position,
    super.key,
  });

  Color _getBackgroundColor() {
    switch (position) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey[400]!;
      case 3:
        return Colors.orange[700]!;
      default:
        return Colors.deepPurple;
    }
  }

  String _getMedalEmoji() {
    switch (position) {
      case 1:
        return '🥇';
      case 2:
        return '🥈';
      case 3:
        return '🥉';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: position <= 3
            ? Text(
                _getMedalEmoji(),
                style: TextStyle(fontSize: 24),
              )
            : Text(
                '$position',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
      ),
    );
  }
}
