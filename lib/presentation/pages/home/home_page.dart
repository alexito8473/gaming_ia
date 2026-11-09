import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_ia/domain/enum/sort.dart';
import 'package:gaming_ia/domain/models/project.dart';
import 'package:gaming_ia/presentation/bloc/projects/project_bloc.dart';
import 'package:gaming_ia/presentation/pages/game_player/game_player.dart';
import 'package:gaming_ia/presentation/pages/setting/setting_page.dart';
import 'package:gaming_ia/presentation/widgets/card/project_card.dart';
import 'package:gaming_ia/presentation/widgets/dialog/create_game_dialog.dart';
import 'package:gaming_ia/presentation/widgets/dialog/project_edit_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController =
  TextEditingController();

  Sort _sortBy = Sort.recent;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    context.read<ProjectBloc>().add(ProjectSearchEvent(query: value));
  }

  void _onSortChanged(Sort? value) {
    if (value == null) return;

    setState(() {
      _sortBy = value;
    });

    context.read<ProjectBloc>().add(ProjectSortEvent(sortBy: value));
  }
  Future<void> _deleteProject(Project project) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);

        return AlertDialog(
          title: const Text('Eliminar juego'),
          content: Text(
            '¿Quieres eliminar "${project.title}"? Esta acción no se puede deshacer.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true) return;

    context.read<ProjectBloc>().add(
      ProjectDeleteEvent(projectId: project.id),
    );
  }
  Future<void> _editProject(Project project) async {
    final updatedProject = await showDialog<Project>(
      context: context,
      builder: (context) {
        return ProjectEditDialog(project: project);
      },
    );

    if (!mounted || updatedProject == null) return;

    context.read<ProjectBloc>().add(
      ProjectUpdateEvent(project: updatedProject),
    );
  }
  Widget _buildProjectCard(Project project) {
    return ProjectCard(
      project: project,
      onTap: () => _openGame(project),
      onEdit: () => _editProject(project),
      onDelete: () => _deleteProject(project),
      onToggleFavorite: () {
        context.read<ProjectBloc>().add(
          ProjectToggleFavoriteEvent(projectId: project.id),
        );
      },
    );
  }
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.videogame_asset_outlined,
            size: 65,
          ),
          const SizedBox(height: 16),
          const Text(
            'Todavía no tienes juegos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '¡Crea tu primer juego con IA!',
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
  void _createGame() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return CreateGameDialog(
          onGenerate: (prompt) {
            context.read<ProjectBloc>().add(ProjectGenerateEvent(prompt: prompt));
          },
        );
      },
    );
  }
  void _openGame(Project project) {
    context.read<ProjectBloc>().add(
      ProjectMarkAsPlayedEvent(projectId: project.id),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GamePlayer(project: project),
      ),
    );
  }
  void _showErrorDialog(BuildContext context, String error) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          icon: Icon(
            Icons.error_outline_rounded,
            color: colors.error,
            size: 42,
          ),
          title: const Text('Ha ocurrido un error'),
          content: SingleChildScrollView(
            child: SelectableText(
              error,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Entendido'),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<ProjectBloc, ProjectState>(
        listenWhen: (previous, current) {
          return current.error != null &&
              current.error != previous.error;
        },
        listener: (context, state) {
          _showErrorDialog(context, state.error!);
        },
        child:  Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Gaming IA',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Configuración',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            // CABECERA
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tu biblioteca',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Tus juegos creados con inteligencia artificial.',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 22),

                  // BUSCADOR
                  TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Buscar juegos...',

                      prefixIcon: const Icon(
                        Icons.search,
                      ),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ORDENAMIENTO
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Mis juegos',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DropdownButton<Sort>(
                        value: _sortBy,
                        underline: const SizedBox(),
                        items: const [
                          DropdownMenuItem(
                            value: Sort.recent,
                            child: Text('Más recientes'),
                          ),
                          DropdownMenuItem(
                            value:  Sort.oldest,
                            child: Text('Más antiguos'),
                          ),
                          DropdownMenuItem(
                            value:  Sort.alphabetical,
                            child: Text('Nombre'),
                          ),
                          DropdownMenuItem(
                            value: Sort.mostPlayed,
                            child: Text('Más jugados'),
                          ),
                        ],
                        onChanged: _onSortChanged,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // LISTADO
            Expanded(
              child: BlocBuilder<ProjectBloc, ProjectState>(
                builder: (context, state) {
                  final projects = state.filteredProjects;

                  if (state.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (projects.isEmpty) {
                    return _buildEmptyState();
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.78,
                    ),
                    itemCount: projects.length,
                    itemBuilder: (context, index) {
                      final project = projects[index];

                      return _buildProjectCard(project);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // BOTÓN CREAR JUEGO
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createGame,
        icon: const Icon(Icons.add),
        label: const Text(
          'Crear juego',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ));
  }

}
