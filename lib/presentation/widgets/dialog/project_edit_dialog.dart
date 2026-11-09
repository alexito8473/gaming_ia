import 'package:flutter/material.dart';
import 'package:gaming_ia/domain/models/project.dart';

class ProjectEditDialog extends StatefulWidget {
  final Project project;

  const ProjectEditDialog({
    super.key,
    required this.project,
  });

  @override
  State<ProjectEditDialog> createState() => _ProjectEditDialogState();
}

class _ProjectEditDialogState extends State<ProjectEditDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _categoryController;
  late final TextEditingController _tagsController;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(
      text: widget.project.title,
    );

    _descriptionController = TextEditingController(
      text: widget.project.description,
    );

    _categoryController = TextEditingController(
      text: widget.project.category,
    );

    _tagsController = TextEditingController(
      text: widget.project.tags.join(', '),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final updatedProject = widget.project.copyWith(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _categoryController.text.trim(),
      tags: _tagsController.text
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList(),
      updatedAt: DateTime.now(),
    );

    Navigator.pop(context, updatedProject);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return AlertDialog(
      backgroundColor: colors.surface,
      title: Text(
        'Editar juego',
        style: theme.textTheme.titleLarge,
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El título es obligatorio';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  prefixIcon: Icon(Icons.description_outlined),
                  alignLabelWithHint: true,
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _tagsController,
                decoration: const InputDecoration(
                  labelText: 'Etiquetas',
                  hintText: 'Acción, Aventura, Arcade',
                  prefixIcon: Icon(Icons.label_outline),
                  helperText: 'Separa las etiquetas con comas',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          onPressed: _save,
          icon: const Icon(Icons.save_outlined),
          label: const Text('Guardar'),
        ),
      ],
    );
  }
}