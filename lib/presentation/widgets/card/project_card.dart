import 'package:flutter/material.dart';
import 'package:gaming_ia/domain/models/project.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleFavorite;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;
    return Card(
      elevation: 0,
      color: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colors.outlineVariant)
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: colors.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.sports_esports_rounded,
                      color: colors.onPrimaryContainer,
                      size: 25,
                    ),
                  ),

                  PopupMenuButton<String>(
                    tooltip: 'Opciones del juego',
                    icon: Icon(Icons.more_vert, color: colors.onSurfaceVariant),
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          onEdit();
                          break;
                        case 'favorite':
                          onToggleFavorite();
                          break;
                        case 'delete':
                          onDelete();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined),
                            SizedBox(width: 10),
                            Text('Editar'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'favorite',
                        child: Row(
                          children: [
                            Icon(
                              project.isFavorite
                                  ? Icons.favorite_border
                                  : Icons.favorite_outline,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              project.isFavorite
                                  ? 'Quitar de favoritos'
                                  : 'Añadir a favoritos',
                            ),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline,
                              color: colors.error,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Eliminar',
                              style: TextStyle(color: colors.error),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Text(
                project.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                project.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),

              const Spacer(),

              Row(
                children: [
                  Icon(
                    Icons.play_circle_outline,
                    size: 16,
                    color: colors.onSurfaceVariant,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${project.playCount} partidas',
                    style: textTheme.labelMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),

                  const Spacer(),

                  if (project.isFavorite)
                    Icon(
                      Icons.favorite,
                      size: 18,
                      color: colors.error,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}