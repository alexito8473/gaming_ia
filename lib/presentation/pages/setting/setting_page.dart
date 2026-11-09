import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_ia/presentation/bloc/theme/theme_cubit.dart';
import 'package:gaming_ia/presentation/bloc/theme/theme_state.dart';
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Apariencia',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Selecciona cómo quieres visualizar la aplicación.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),

              _ThemeOption(
                title: 'Sistema',
                subtitle: 'Utilizar la configuración de Android',
                icon: Icons.settings_brightness,
                themeMode: ThemeMode.system,
                selectedMode: state.themeMode,
              ),

              const SizedBox(height: 10),

              _ThemeOption(
                title: 'Claro',
                subtitle: 'Utilizar siempre el modo claro',
                icon: Icons.light_mode,
                themeMode: ThemeMode.light,
                selectedMode: state.themeMode,
              ),

              const SizedBox(height: 10),

              _ThemeOption(
                title: 'Oscuro',
                subtitle: 'Utilizar siempre el modo oscuro',
                icon: Icons.dark_mode,
                themeMode: ThemeMode.dark,
                selectedMode: state.themeMode,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final ThemeMode themeMode;
  final ThemeMode selectedMode;

  const _ThemeOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.themeMode,
    required this.selectedMode,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isSelected = themeMode == selectedMode;

    return Card(
      color: isSelected ? colors.primaryContainer : colors.surface,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: Icon(
          icon,
          color: isSelected
              ? colors.onPrimaryContainer
              : colors.onSurfaceVariant,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isSelected
                ? colors.onPrimaryContainer
                : colors.onSurface,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: isSelected
                ? colors.onPrimaryContainer
                : colors.onSurfaceVariant,
          ),
        ),
        trailing: isSelected
            ? Icon(
          Icons.check_circle,
          color: colors.primary,
        )
            : Icon(
          Icons.circle_outlined,
          color: colors.onSurfaceVariant,
        ),
        onTap: () {
          context.read<ThemeCubit>().setThemeMode(themeMode);
        },
      ),
    );
  }
}