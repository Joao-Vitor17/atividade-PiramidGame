import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:piramidgame/firebase_options.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'src/core/constants/app_constants.dart';
import 'src/data/repositories/assessment_repository.dart';
import 'src/data/repositories/auth_repository.dart';
import 'src/data/repositories/ranking_repository.dart';
import 'src/data/repositories/student_repository.dart';
import 'src/data/services/auth_service.dart';
import 'src/data/services/storage_service.dart';
import 'src/data/services/user_profile_service.dart';
import 'src/domain/facades/assessment_facade.dart';
import 'src/domain/facades/auth_facade.dart';
import 'src/domain/facades/student_facade.dart';
import 'src/presentation/routes/app_router.dart';
import 'src/presentation/theme/app_theme.dart';
import 'src/presentation/viewmodels/theme_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final storageService = SharedPreferencesService();
  await storageService.initialize();
  final themeViewModel = ThemeViewModel(storage: storageService);
  await themeViewModel.initialize();

  final authRepository = AuthRepository(AuthService(), UserProfileService());
  final authFacade = AuthFacade(authRepository);
  final peopleRepository = StudentRepository();
  final assessmentRepository = AssessmentRepository();
  final rankingRepository = RankingRepository(
    people: peopleRepository,
    assessments: assessmentRepository,
  );
  final studentFacade = StudentFacade(
    repository: peopleRepository,
    authFacade: authFacade,
  );
  final assessmentFacade = AssessmentFacade(
    assessmentRepository: assessmentRepository,
    rankingRepository: rankingRepository,
    authFacade: authFacade,
  );

  runApp(MyApp(
    authFacade: authFacade,
    studentFacade: studentFacade,
    assessmentFacade: assessmentFacade,
    themeViewModel: themeViewModel,
  ));
}

class MyApp extends StatefulWidget {
  final AuthFacade authFacade;
  final StudentFacade studentFacade;
  final AssessmentFacade assessmentFacade;
  final ThemeViewModel themeViewModel;

  const MyApp({
    required this.authFacade,
    required this.studentFacade,
    required this.assessmentFacade,
    required this.themeViewModel,
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouter.createRouter(
      authFacade: widget.authFacade,
      studentFacade: widget.studentFacade,
      assessmentFacade: widget.assessmentFacade,
      themeViewModel: widget.themeViewModel,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (_) => MaterialApp.router(
        title: AppConstants.appName,
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        themeMode: widget.themeViewModel.isDarkMode.value
            ? ThemeMode.dark
            : ThemeMode.light,
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
