import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../viewmodels/student_detail_viewmodel.dart';

class StudentDetailScreen extends StatefulWidget {
  final StudentDetailViewModel viewModel;

  const StudentDetailScreen({
    required this.viewModel,
    super.key,
  });

  @override
  State<StudentDetailScreen> createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Aluno'),
        actions: [
          SignalBuilder(
            builder: (_) {
              final student = widget.viewModel.student;
              if (student == null) return SizedBox();

              return PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Text('Editar'),
                    value: 'edit',
                  ),
                  PopupMenuItem(
                    child: Text('Deletar'),
                    value: 'delete',
                  ),
                ],
                onSelected: (value) {
                  if (value == 'edit') {
                    context.push(
                      '/student-form',
                      extra: student,
                    );
                  } else if (value == 'delete') {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Confirmar exclusão'),
                        content: Text('Deseja realmente remover ${student.name}?'),
                        actions: [
                          TextButton(
                            onPressed: () => context.pop(),
                            child: Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              context.pop();
                              context.pop();
                            },
                            child: Text('Remover', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
      body: SignalBuilder(
        builder: (_) {
          if (widget.viewModel.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (widget.viewModel.isError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 60, color: Colors.red),
                  SizedBox(height: 16),
                  Text('Erro ao carregar aluno'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    child: Text('Voltar'),
                  ),
                ],
              ),
            );
          }

          final student = widget.viewModel.student;
          if (student == null) {
            return Center(
              child: Text('Aluno não encontrado'),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cabeçalho com informações básicas
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.deepPurple),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (student.nickname.isNotEmpty) ...[
                        SizedBox(height: 4),
                        Text(
                          '"${student.nickname}"',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[600],
                              ),
                        ),
                      ],
                      SizedBox(height: 12),
                      Divider(),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Curso',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                student.course,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Turma/Ano',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                student.year.toString(),
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Data de Nascimento',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                '${student.birthDate.day}/${student.birthDate.month}/${student.birthDate.year}',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Nível Lenda',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${student.totalPoints}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                // Critérios de Popularidade
                Text(
                  'Critérios de Popularidade',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: AppConstants.ratingCriteria.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${index + 1}. ${AppConstants.ratingCriteria[index]}',
                                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        AppConstants.ratingDescriptions[index],
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: Colors.grey[600],
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 12),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.star, color: Colors.white, size: 16),
                                      SizedBox(width: 4),
                                      Text(
                                        '${student.ratings[index]}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
