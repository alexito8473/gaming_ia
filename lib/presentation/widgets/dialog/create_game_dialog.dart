
import 'package:flutter/material.dart';

class CreateGameDialog extends StatefulWidget {
  final Function(String prompt) onGenerate;

  const CreateGameDialog({
    super.key,
    required this.onGenerate,
  });

  @override
  State<CreateGameDialog> createState() => _CreateGameDialogState();
}

class _CreateGameDialogState extends State<CreateGameDialog> {
  final TextEditingController _promptController =
  TextEditingController();

  final List<String> _examples = [
    'Un juego de plataformas con un personaje que salta obstáculos.',
    'Un Snake donde una serpiente recoge frutas.',
    'Un juego de carreras con coches y circuitos.',
    'Un juego de disparos espaciales con enemigos.',
  ];

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  void _generate() {
    final prompt = _promptController.text.trim();

    if (prompt.isEmpty) return;

    Navigator.pop(context);
    widget.onGenerate(prompt);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Crear nuevo juego',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Dale vida a tu imaginación con IA',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // PROMPT LABEL
            const Text(
              'Describe tu juego',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 10),

            // PROMPT INPUT
            TextField(
              controller: _promptController,
              minLines: 4,
              maxLines: 7,
              maxLength: 1000,
              style: const TextStyle(
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText:
                'Ejemplo: Quiero un juego de plataformas donde un '
                    'personaje tenga que superar obstáculos...',
                hintStyle: const TextStyle(

                  fontSize: 13,
                ),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    width: 1.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // EXAMPLES
            const Text(
              '¿Necesitas inspiración?',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _examples.map((example) {
                return InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    setState(() {
                      _promptController.text = example;
                      _promptController.selection =
                          TextSelection.fromPosition(
                            TextPosition(
                              offset: _promptController.text.length,
                            ),
                          );
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      example,
                      style: const TextStyle(
                        fontSize: 11,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 26),

            // ACTIONS
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('Cancelar'),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: _generate,
                    icon: const Icon(
                      Icons.auto_awesome,
                      size: 18,
                    ),
                    label: const Text('Generar juego'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
