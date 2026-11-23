import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../viewmodels/student_detail_viewmodel.dart';
import '../widgets/student_avatar.dart';

class StudentDetailScreen extends StatelessWidget {
  final StudentDetailViewModel viewModel;

  const StudentDetailScreen({required this.viewModel, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil da pessoa'),
        actions: [
          SignalBuilder(
            builder: (_) {
              final person = viewModel.student;
              if (person == null) return const SizedBox.shrink();
              return IconButton(
                tooltip: 'Editar perfil',
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => context.push('/student-form', extra: person),
              );
            },
          ),
        ],
      ),
      body: SignalBuilder(
        builder: (_) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (viewModel.isError || viewModel.student == null) {
            return Center(child: Text(viewModel.errorMessage ?? 'Pessoa não encontrada'));
          }
          final person = viewModel.student!;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: SignalBuilder(
                  builder: (_) => StudentAvatar(
                    name: person.name,
                    photoUrl: person.photoUrl,
                    radius: 42,
                    editable: true,
                    isLoading: viewModel.isUploadingPhoto,
                    onTap: () => _changePhoto(context),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(person.name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall),
              if (person.nickname.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text('"${person.nickname}"', textAlign: TextAlign.center),
              ],
              const SizedBox(height: 24),
              Card(
                child: Column(
                  children: [
                    _detailRow(context, 'Curso', person.course),
                    const Divider(height: 1),
                    _detailRow(context, 'Turma/Ano', '${person.year}'),
                    const Divider(height: 1),
                    _detailRow(context, 'Data de nascimento',
                        '${person.birthDate.day}/${person.birthDate.month}/${person.birthDate.year}'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () => context.push('/assessment', extra: person),
                icon: const Icon(Icons.star_outline),
                label: const Text('Avaliar ou editar minha avaliação'),
              ),
              const SizedBox(height: 8),
              Text(
                'As notas são privadas por avaliador e alimentam os rankings pessoal e global.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _detailRow(BuildContext context, String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
            Text(value, style: Theme.of(context).textTheme.titleSmall),
          ],
        ),
      );

  Future<void> _changePhoto(BuildContext context) async {
    try {
      final result = await viewModel.changePhoto();
      final failure = result.failureOrNull;
      if (failure != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message)),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível salvar a foto: $error')),
        );
      }
    }
  }
}
