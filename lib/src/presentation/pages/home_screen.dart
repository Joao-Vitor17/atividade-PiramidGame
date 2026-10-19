import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../viewmodels/theme_viewmodel.dart';
import '../viewmodels/student_list_viewmodel.dart';
import '../viewmodels/ranking_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../../domain/facades/student_facade.dart';
import '../../domain/facades/auth_facade.dart';
import '../../domain/facades/assessment_facade.dart';
import '../../domain/entities/student.dart';
import 'student_list_screen.dart';
import 'ranking_screen.dart';

class HomeScreen extends StatefulWidget {
  final ThemeViewModel themeViewModel;
  final StudentFacade studentFacade;
  final AuthFacade authFacade;
  final AssessmentFacade assessmentFacade;

  const HomeScreen({
    required this.themeViewModel,
    required this.studentFacade,
    required this.authFacade,
    required this.assessmentFacade,
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late StudentListViewModel _studentListViewModel;
  late RankingViewModel _rankingViewModel;
  late AuthViewModel _authViewModel;

  @override
  void initState() {
    super.initState();
    _studentListViewModel = StudentListViewModel(facade: widget.studentFacade);
    _rankingViewModel = RankingViewModel(facade: widget.assessmentFacade);
    _authViewModel = AuthViewModel(facade: widget.authFacade);
  }

  Future<void> _logout() async {
    await _authViewModel.logout();
    if (!mounted) return;
    if (_authViewModel.logoutCommand.state.value.isSuccess) {
      context.go('/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível encerrar a sessão.')),
      );
    }
  }

  Future<void> _linkProfile() async {
    await _studentListViewModel.loadStudents();
    if (!mounted) return;
    final people = _studentListViewModel.students;
    if (people.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastre uma pessoa antes de vincular seu perfil.')),
      );
      return;
    }
    final person = await showDialog<Student>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Vincular meu perfil'),
        content: SizedBox(
          width: 360,
          height: 320,
          child: ListView.builder(
            itemCount: people.length,
            itemBuilder: (context, index) {
              final item = people[index];
              return ListTile(
                title: Text(item.name),
                subtitle: Text('${item.course} - ${item.year}'),
                onTap: () => Navigator.of(dialogContext).pop(item),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
    if (person?.id == null || !mounted) return;
    await _authViewModel.linkPerson(person!.id!);
    if (!mounted) return;
    final linkState = _authViewModel.linkPersonCommand.state.value;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(linkState.isError
            ? 'Não foi possível vincular o perfil.'
            : 'Perfil vinculado. A autoavaliação ficará bloqueada.'),
      ),
    );
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
          PopupMenuButton<String>(
            tooltip: 'Conta',
            onSelected: (value) {
              if (value == 'link') _linkProfile();
              if (value == 'logout') _logout();
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'link', child: Text('Vincular meu perfil')),
              PopupMenuItem(value: 'logout', child: Text('Sair')),
            ],
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
            label: 'Pessoas',
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
