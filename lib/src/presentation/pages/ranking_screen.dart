import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../../core/patterns/command.dart';
import '../../domain/entities/ranking_entry.dart';
import '../viewmodels/ranking_viewmodel.dart';
import '../widgets/ranking_position_badge.dart';

class RankingScreen extends StatefulWidget {
  final RankingViewModel viewModel;

  const RankingScreen({required this.viewModel, super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.loadPersonal();
    widget.viewModel.loadGlobal();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Rankings'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pessoal'),
              Tab(text: 'Global'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _rankingTab(
              command: widget.viewModel.personalCommand,
              reload: widget.viewModel.loadPersonal,
              global: false,
            ),
            _rankingTab(
              command: widget.viewModel.globalCommand,
              reload: widget.viewModel.loadGlobal,
              global: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _rankingTab({
    required CommandNotifier<List<RankingEntry>> command,
    required Future<void> Function() reload,
    required bool global,
  }) {
    return SignalBuilder(
      builder: (_) {
        final state = command.state.value;
        if (state.isLoading || state.isIdle) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ErrorCommandState<List<RankingEntry>>) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(state.message, textAlign: TextAlign.center),
                const SizedBox(height: 12),
                OutlinedButton(onPressed: reload, child: const Text('Tentar novamente')),
              ],
            ),
          );
        }
        final entries = (state as SuccessCommandState<List<RankingEntry>>).data;
        if (entries.isEmpty) {
          return Center(
            child: Text(global
                ? 'Ainda não há avaliações para o ranking global.'
                : 'Avalie pessoas para montar seu ranking pessoal.'),
          );
        }
        return RefreshIndicator(
          onRefresh: reload,
          child: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: entries.length,
            separatorBuilder: (_, index) => const SizedBox(height: 4),
            itemBuilder: (context, index) => _entryTile(entries[index], index, global),
          ),
        );
      },
    );
  }

  Widget _entryTile(RankingEntry entry, int index, bool global) {
    return ListTile(
      leading: RankingPositionBadge(position: index + 1),
      title: Text(entry.person.name),
      subtitle: Text(
        '${entry.person.course} - ${entry.person.year}'
        '${global ? ' · ${entry.assessmentCount} avaliações' : ''}',
      ),
      trailing: Text(
        entry.averageScore.toStringAsFixed(1),
        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      onTap: () => context.push('/student-detail', extra: entry.person.id),
    );
  }
}
