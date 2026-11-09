import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gaming_ia/core/storage/app_storage.dart';
import 'package:gaming_ia/core/theme/app_theme.dart';
import 'package:gaming_ia/domain/repositories/abstract/game_repository.dart';
import 'package:gaming_ia/domain/repositories/implement/gemini_game_repository.dart';
import 'package:gaming_ia/presentation/bloc/projects/project_bloc.dart';
import 'package:gaming_ia/presentation/bloc/theme/theme_cubit.dart';
import 'package:gaming_ia/presentation/bloc/theme/theme_state.dart';
import 'package:gaming_ia/presentation/pages/home/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  await AppStorage.init();

  runApp(const GamingIAApp());
}

class GamingIAApp extends StatelessWidget {
  const GamingIAApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<GameRepository>(
      create: (_) => GeminiGameRepository(),
      child: Builder(
        builder: (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => ThemeCubit()),
              BlocProvider(
                create: (context) => ProjectBloc(gameRepository: context.read<GameRepository>())),
            ],
            child: BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, state) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Gaming IA',
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: state.themeMode,
                  home: const HomePage(),
                );
              },
            ),
          );
        }
      )
    );
  }
}

