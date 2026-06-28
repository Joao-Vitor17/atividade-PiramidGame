import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../viewmodels/ranking_viewmodel.dart';
import '../widgets/ranking_position_badge.dart';

class RankingScreen extends StatefulWidget {
  final RankingViewModel viewModel;

  const RankingScreen({
    required this.viewModel,
    super.key,
  });

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.loadRanking();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ranking - Nível Lenda'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => widget.viewModel.loadRanking(),
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
                  Text('Erro ao carregar ranking'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => widget.viewModel.loadRanking(),
                    child: Text('Tentar Novamente'),
                  ),
                ],
              ),
            );
          }

          final ranking = widget.viewModel.ranking;

          if (ranking.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bar_chart,
                    size: 60,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text('Nenhum aluno cadastrado'),
                  SizedBox(height: 16),
                  Text(
                    'Cadastre alunos para gerar o ranking',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: ranking.length,
            itemBuilder: (context, index) {
              final student = ranking[index];
              final position = index + 1;

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                elevation: position <= 3 ? 8 : 2,
                child: Container(
                  decoration: position <= 3
                      ? BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: position == 1
                                  ? Colors.amber
                                  : position == 2
                                      ? Colors.grey[400]!
                                      : Colors.orange[700]!,
                              width: 4,
                            ),
                          ),
                        )
                      : null,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: InkWell(
                      onTap: () => context.push(
                        '/student-detail',
                        extra: student.id,
                      ),
                      child: Row(
                        children: [
                          RankingPositionBadge(position: position),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  student.name,
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${student.course} - ${student.year}',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                ),
                                if (student.nickname.isNotEmpty)
                                  Text(
                                    '"${student.nickname}"',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.grey[500],
                                        ),
                                  ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Nível Lenda',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${student.totalPoints}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
