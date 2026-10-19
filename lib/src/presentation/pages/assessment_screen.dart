import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/student.dart';
import '../viewmodels/assessment_viewmodel.dart';
import '../widgets/rating_stars.dart';

class AssessmentScreen extends StatefulWidget {
  final Student person;
  final AssessmentViewModel viewModel;

  const AssessmentScreen({required this.person, required this.viewModel, super.key});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Avaliar ${widget.person.name}')),
      body: SignalBuilder(
        builder: (_) => Column(
          children: [
            if (widget.viewModel.errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(widget.viewModel.errorMessage!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                itemCount: AppConstants.ratingCriteria.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${index + 1}. ${AppConstants.ratingCriteria[index]}',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(AppConstants.ratingDescriptions[index],
                          style: Theme.of(context).textTheme.bodySmall),
                      RatingStars(
                        key: ValueKey('rating-$index-${widget.viewModel.ratings.value[index]}'),
                        initialRating: widget.viewModel.ratings.value[index],
                        onRatingChanged: (value) => widget.viewModel.updateRating(index, value),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('Nível Lenda: ${widget.viewModel.totalPoints}/75'),
                    ),
                    FilledButton.icon(
                      onPressed: widget.viewModel.isLoading
                          ? null
                          : () async {
                              final result = await widget.viewModel.save();
                              if (!context.mounted) return;
                              if (result.valueOrNull != null) {
                                context.pop();
                              } else if (result.failureOrNull != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(result.failureOrNull!.message)),
                                );
                              }
                            },
                      icon: const Icon(Icons.save_outlined),
                      label: Text(widget.viewModel.hasExistingAssessment ? 'Atualizar' : 'Salvar'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}