import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../viewmodels/theme_viewmodel.dart';
import '../viewmodels/student_list_viewmodel.dart';
import '../viewmodels/ranking_viewmodel.dart';
import '../../domain/facades/student_facade.dart';
import 'student_list_screen.dart';
import 'ranking_screen.dart';

class HomeScreen extends StatefulWidget {
  final ThemeViewModel themeViewModel;
  final StudentFacade studentFacade;

  const HomeScreen({
    required this.themeViewModel,
    required this.studentFacade,
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late StudentListViewModel _studentListViewModel;
  late RankingViewModel _rankingViewModel;

  @override
  void initState() {
    super.initState();
    _studentListViewModel = StudentListViewModel(facade: widget.studentFacade);
    _rankingViewModel = RankingViewModel(facade: widget.studentFacade);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PirâmidGame IFPR-Pgua'),
        actions: [
          SignalBuilder(
            builder: (_) {
              return IconButton(
                icon: Icon(
                  widget.themeViewModel.isDarkMode.value ? Icons.light_mode : Icons.dark_mode,
                ),
                onPressed: () => widget.themeViewModel.toggleTheme(),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () => context.push('/about'),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          StudentListScreen(viewModel: _studentListViewModel),
          RankingScreen(viewModel: _rankingViewModel),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Alunos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Ranking',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () => context.push('/student-form'),
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}
