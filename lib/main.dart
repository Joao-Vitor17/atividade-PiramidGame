import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'src/core/constants/app_constants.dart';
import 'src/data/services/storage_service.dart';
import 'src/data/repositories/student_repository.dart';
import 'src/domain/facades/student_facade.dart';
import 'src/presentation/routes/app_router.dart';
import 'src/presentation/theme/app_theme.dart';
import 'src/presentation/viewmodels/theme_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  final storageService = SharedPreferencesService();
  await storageService.initialize();

  // Setup dependencies
  final repository = StudentRepository(storageService);
  final facade = StudentFacade(repository);
  final themeViewModel = ThemeViewModel();

  runApp(MyApp(
    facade: facade,
    themeViewModel: themeViewModel,
  ));
}

class MyApp extends StatefulWidget {
  final StudentFacade facade;
  final ThemeViewModel themeViewModel;

  const MyApp({
    required this.facade,
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
      studentFacade: widget.facade,
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
