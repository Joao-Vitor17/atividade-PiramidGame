import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class RatingStars extends StatefulWidget {
  final int initialRating;
  final Function(int) onRatingChanged;

  const RatingStars({
    required this.initialRating,
    required this.onRatingChanged,
    super.key,
  });

  @override
  State<RatingStars> createState() => _RatingStarsState();
}

class _RatingStarsState extends State<RatingStars> {
  late int _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(
        AppConstants.maxRating,
        (index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: InkWell(
            onTap: () {
              setState(() {
                _currentRating = index + 1;
              });
              widget.onRatingChanged(_currentRating);
            },
            child: Icon(
              Icons.star,
              color: index < _currentRating ? Colors.amber : Colors.grey,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
