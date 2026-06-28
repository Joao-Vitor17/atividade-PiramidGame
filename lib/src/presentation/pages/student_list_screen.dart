import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../viewmodels/student_list_viewmodel.dart';
import '../widgets/student_card.dart';

class StudentListScreen extends StatefulWidget {
  final StudentListViewModel viewModel;

  const StudentListScreen({
    required this.viewModel,
    super.key,
  });

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.loadStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alunos Cadastrados'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => widget.viewModel.loadStudents(),
          ),
        ],
      ),
      body: SignalBuilder(
        builder: (_) {
          final state = widget.viewModel.loadStudentsCommand.state.value;

          if (state.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state.isError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Erro ao carregar alunos'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => widget.viewModel.loadStudents(),
                    child: Text('Tentar Novamente'),
                  ),
                ],
              ),
            );
          }

          final students = widget.viewModel.students;

          if (students.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_add,
                    size: 60,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text('Nenhum aluno cadastrado'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.push('/student-form'),
                    child: Text('Cadastrar Primeiro Aluno'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return StudentCard(
                student: student,
                onTap: () => context.push(
                  '/student-detail',
                  extra: student.id,
                ),
                onDelete: () {
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
                            widget.viewModel.deleteStudent(student.id!);
                            context.pop();
                          },
                          child: Text('Remover', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/student-form'),
        child: Icon(Icons.add),
      ),
    );
  }
}
