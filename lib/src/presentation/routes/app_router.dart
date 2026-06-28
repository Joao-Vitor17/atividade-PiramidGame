import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../pages/splash_screen.dart';
import '../pages/about_screen.dart';
import '../pages/student_list_screen.dart';
import '../pages/student_form_screen.dart';
import '../pages/student_detail_screen.dart';
import '../pages/ranking_screen.dart';
import '../pages/home_screen.dart';
import '../viewmodels/student_list_viewmodel.dart';
import '../viewmodels/student_form_viewmodel.dart';
import '../viewmodels/student_detail_viewmodel.dart';
import '../viewmodels/ranking_viewmodel.dart';
import '../viewmodels/theme_viewmodel.dart';
import '../../domain/facades/student_facade.dart';
import '../../domain/entities/student.dart';

class AppRouter {
  static GoRouter createRouter({
    required StudentFacade studentFacade,
    required ThemeViewModel themeViewModel,
  }) {
    return GoRouter(
      initialLocation: '/splash',
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => HomeScreen(
            themeViewModel: themeViewModel,
            studentFacade: studentFacade,
          ),
        ),
        GoRoute(
          path: '/about',
          builder: (context, state) => const AboutScreen(),
        ),
        GoRoute(
          path: '/student-list',
          builder: (context, state) {
            final viewModel = StudentListViewModel(facade: studentFacade);
            return StudentListScreen(viewModel: viewModel);
          },
        ),
        GoRoute(
          path: '/student-form',
          builder: (context, state) {
            final editingStudent = state.extra as Student?;
            final viewModel = StudentFormViewModel(
              facade: studentFacade,
              editingStudent: editingStudent,
            );
            return StudentFormScreen(viewModel: viewModel);
          },
        ),
        GoRoute(
          path: '/student-detail',
          builder: (context, state) {
            final studentId = state.extra as String?;
            if (studentId == null) {
              return Scaffold(
                appBar: AppBar(title: Text('Erro')),
                body: Center(child: Text('Erro ao carregar aluno')),
              );
            }
            final viewModel = StudentDetailViewModel(
              facade: studentFacade,
              studentId: studentId,
            );
            return StudentDetailScreen(viewModel: viewModel);
          },
        ),
        GoRoute(
          path: '/ranking',
          builder: (context, state) {
            final viewModel = RankingViewModel(facade: studentFacade);
            return RankingScreen(viewModel: viewModel);
          },
        ),
      ],
    );
  }
}
