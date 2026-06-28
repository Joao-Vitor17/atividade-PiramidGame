import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../viewmodels/student_form_viewmodel.dart';
import '../widgets/rating_stars.dart';

class StudentFormScreen extends StatefulWidget {
  final StudentFormViewModel viewModel;

  const StudentFormScreen({
    required this.viewModel,
    super.key,
  });

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  late TextEditingController _nameController;
  late TextEditingController _nicknameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.viewModel.name.value);
    _nicknameController = TextEditingController(text: widget.viewModel.nickname.value);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.viewModel.editingStudent == null ? 'Novo Aluno' : 'Editar Aluno'),
      ),
      body: SignalBuilder(
        builder: (_) {
          if (widget.viewModel.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nome
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nome *',
                    hintText: 'Digite o nome completo',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => widget.viewModel.name.value = value,
                ),
                SizedBox(height: 16),

                // Apelido
                TextField(
                  controller: _nicknameController,
                  decoration: InputDecoration(
                    labelText: 'Apelido',
                    hintText: 'Digite o apelido (opcional)',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => widget.viewModel.nickname.value = value,
                ),
                SizedBox(height: 16),

                // Curso
                Text('Curso *', style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 8),
                SignalBuilder(
                  builder: (_) => DropdownButton<String>(
                    value: widget.viewModel.course.value,
                    isExpanded: true,
                    items: AppConstants.courses
                        .map((course) => DropdownMenuItem(
                              value: course,
                              child: Text(course),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        widget.viewModel.course.value = value;
                      }
                    },
                  ),
                ),
                SizedBox(height: 16),

                // Ano/Turma
                Text('Turma/Ano *', style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 8),
                SignalBuilder(
                  builder: (_) => DropdownButton<int>(
                    value: widget.viewModel.year.value,
                    isExpanded: true,
                    items: List.generate(
                      AppConstants.maxYear - AppConstants.minYear + 1,
                      (index) {
                        final year = AppConstants.maxYear - index;
                        return DropdownMenuItem(
                          value: year,
                          child: Text(year.toString()),
                        );
                      },
                    ),
                    onChanged: (value) {
                      if (value != null) {
                        widget.viewModel.year.value = value;
                      }
                    },
                  ),
                ),
                SizedBox(height: 16),

                // Data de Nascimento
                Text('Data de Nascimento *', style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 8),
                SignalBuilder(
                  builder: (_) => InkWell(
                    onTap: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: widget.viewModel.birthDate.value,
                        firstDate: DateTime(1980),
                        lastDate: DateTime.now(),
                      );
                      if (selectedDate != null) {
                        widget.viewModel.birthDate.value = selectedDate;
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${widget.viewModel.birthDate.value.day}/${widget.viewModel.birthDate.value.month}/${widget.viewModel.birthDate.value.year}',
                          ),
                          Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // Rating Criteria
                Text(
                  'Critérios de Popularidade *',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 12),
                SignalBuilder(
                  builder: (_) => Column(
                    children: List.generate(
                      AppConstants.ratingCriteria.length,
                      (index) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${index + 1}. ${AppConstants.ratingCriteria[index]}',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              AppConstants.ratingDescriptions[index],
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 8),
                            RatingStars(
                              initialRating: widget.viewModel.ratings.value[index],
                              onRatingChanged: (rating) {
                                widget.viewModel.updateRating(index, rating);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // Total Points
                SignalBuilder(
                  builder: (_) => Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.deepPurple),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Nível Lenda Total:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          '${widget.viewModel.totalPoints} / ${AppConstants.maxPoints}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: widget.viewModel.isFormValid
                        ? () async {
                            final result = await widget.viewModel.submit();
                            if (mounted) {
                              if (result.valueOrNull != null) {
                                context.pop();
                              } else if (result.failureOrNull != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(result.failureOrNull!.message),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          }
                        : null,
                    child: Text(
                      widget.viewModel.editingStudent == null
                          ? 'Cadastrar Aluno'
                          : 'Salvar Alterações',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}
