
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../domain/models/project.dart';

class GamePlayer extends StatefulWidget {
  final Project project;

  const GamePlayer({
    super.key,
    required this.project,
  });

  @override
  State<GamePlayer> createState() => _GamePlayerState();
}

class _GamePlayerState extends State<GamePlayer> {
  late final WebViewController _webViewController;

  bool _isLoading = true;
  bool _hasError = false;
  bool _isFullscreen = false;

  bool _showCode = false;
  bool _showConsole = false;

  final List<_GameConsoleMessage> _consoleMessages = [];

  int get _consoleErrorCount => _consoleMessages
      .where((message) => message.level == 'error')
      .length;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'FlutterConsole',
        onMessageReceived: (message) {
          _handleConsoleMessage(message.message);
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (!mounted) return;

            setState(() {
              _isLoading = true;
              _hasError = false;
            });
          },
          onPageFinished: (_) {
            if (!mounted) return;

            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (error) {
            if (error.isForMainFrame != true) return;

            if (!mounted) return;

            setState(() {
              _isLoading = false;
              _hasError = true;
            });

            _addConsoleMessage(
              'error',
              'WebView: ${error.description}',
            );
          },
        ),
      );

    _loadGame();
  }

  Future<void> _loadGame() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
      _showCode = false;
      _showConsole = false;
    });

    try {
      await _webViewController.loadHtmlString(
        _injectConsole(widget.project.gameCode),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _hasError = true;
      });

      _addConsoleMessage('error', 'Error cargando juego: $e');
    }
  }
  String _injectConsole(String html) {
    const bridge = r'''
<script>
(function () {
  if (window.__flutterConsoleInstalled) return;
  window.__flutterConsoleInstalled = true;

  function serialize(value) {
    if (value instanceof Error) {
      return value.stack || value.message;
    }

    if (typeof value === 'string') {
      return value;
    }

    try {
      const result = JSON.stringify(value);
      return result === undefined ? String(value) : result;
    } catch (_) {
      return String(value);
    }
  }

  function sendToFlutter(level, args) {
    try {
      const message = Array.from(args)
        .map(serialize)
        .join(' ');

      FlutterConsole.postMessage(JSON.stringify({
        level: level,
        message: message,
        time: new Date().toISOString()
      }));
    } catch (_) {}
  }

  ['log', 'info', 'warn', 'error', 'debug'].forEach(function(level) {
    const original = console[level].bind(console);

    console[level] = function() {
      sendToFlutter(level, arguments);
      original.apply(console, arguments);
    };
  });

  window.addEventListener('error', function(event) {
    sendToFlutter('error', [
      event.message + ' (' +
      event.filename + ':' +
      event.lineno + ':' +
      event.colno + ')'
    ]);
  });

  window.addEventListener('unhandledrejection', function(event) {
    sendToFlutter('error', [
      'Unhandled promise rejection: ' +
      (event.reason?.stack ||
       event.reason?.message ||
       event.reason)
    ]);
  });
})();
</script>
''';

    final head = RegExp(
      r'<head[^>]*>',
      caseSensitive: false,
    ).firstMatch(html);

    if (head != null) {
      return html.replaceRange(
        head.end,
        head.end,
        bridge,
      );
    }

    final htmlTag = RegExp(
      r'<html[^>]*>',
      caseSensitive: false,
    ).firstMatch(html);

    if (htmlTag != null) {
      return html.replaceRange(
        htmlTag.end,
        htmlTag.end,
        '<head>$bridge</head>',
      );
    }

    return '$bridge$html';
  }

  void _handleConsoleMessage(String rawMessage) {
    try {
      final data = jsonDecode(rawMessage) as Map<String, dynamic>;

      final message = _GameConsoleMessage.fromJson(data);

      if (!mounted) return;

      setState(() {
        _consoleMessages.add(message);

        if (_consoleMessages.length > 500) {
          _consoleMessages.removeAt(0);
        }
      });
    } catch (_) {
      _addConsoleMessage(
        'error',
        'No se pudo interpretar un mensaje de la consola.',
      );
    }
  }

  void _addConsoleMessage(String level, String message) {
    if (!mounted) return;

    setState(() {
      _consoleMessages.add(
        _GameConsoleMessage(
          level: level,
          message: message,
          time: DateTime.now(),
        ),
      );

      if (_consoleMessages.length > 500) {
        _consoleMessages.removeAt(0);
      }
    });
  }

  Future<void> _copyConsole() async {
    final text = _consoleMessages.map((message) {
      return '[${message.level.toUpperCase()}] '
          '${message.time.toIso8601String()} '
          '${message.message}';
    }).join('\n');

    await Clipboard.setData(
      ClipboardData(text: text),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Consola copiada correctamente'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _clearConsole() {
    setState(() {
      _consoleMessages.clear();
    });
  }

  // ============================================================
  // CÓDIGO HTML
  // ============================================================

  Future<void> _copyCode() async {
    await Clipboard.setData(
      ClipboardData(text: widget.project.gameCode),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Código copiado al portapapeles'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================
  // NAVEGACIÓN ENTRE MODOS
  // ============================================================

  void _showGame() {
    setState(() {
      _showCode = false;
      _showConsole = false;
    });
  }

  void _showCodeMode() {
    setState(() {
      _showCode = true;
      _showConsole = false;
    });
  }

  void _showConsoleMode() {
    setState(() {
      _showCode = false;
      _showConsole = true;
    });
  }

  // ============================================================
  // PANTALLA COMPLETA
  // ============================================================

  Future<void> _toggleFullscreen() async {
    if (_isFullscreen) {
      await _exitFullscreen();
    } else {
      await _enterFullscreen();
    }
  }

  Future<void> _enterFullscreen() async {
    setState(() {
      _isFullscreen = true;
    });

    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );
  }

  Future<void> _exitFullscreen() async {
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );

    if (!mounted) return;

    setState(() {
      _isFullscreen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return PopScope(
      canPop: !_isFullscreen,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _isFullscreen) {
          _exitFullscreen();
        }
      },
      child: Scaffold(
        backgroundColor: colors.surface,

        appBar: _isFullscreen
            ? null
            : AppBar(
          title: Text(
            _showCode
                ? 'Código del juego'
                : _showConsole
                ? 'Consola'
                : widget.project.title,
          ),
          actions: [
            IconButton(
              tooltip: 'Jugar',
              onPressed: _showGame,
              icon: Icon(
                Icons.sports_esports,
                color: !_showCode && !_showConsole
                    ? colors.primary
                    : null,
              ),
            ),

            IconButton(
              tooltip: 'Ver código',
              onPressed: _showCodeMode,
              icon: Icon(
                Icons.code,
                color: _showCode
                    ? colors.primary
                    : null,
              ),
            ),

            Stack(
              alignment: Alignment.topRight,
              children: [
                IconButton(
                  tooltip: 'Consola',
                  onPressed: _showConsoleMode,
                  icon: Icon(
                    Icons.terminal,
                    color: _showConsole
                        ? colors.primary
                        : null,
                  ),
                ),

                if (_consoleErrorCount > 0)
                  Positioned(
                    right: 5,
                    top: 5,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: colors.error,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$_consoleErrorCount',
                        style: TextStyle(
                          color: colors.onError,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            if (!_showCode && !_showConsole)
              IconButton(
                tooltip: 'Pantalla completa',
                onPressed: _toggleFullscreen,
                icon: const Icon(Icons.fullscreen),
              ),

            if (_showCode)
              IconButton(
                tooltip: 'Copiar código',
                onPressed: _copyCode,
                icon: const Icon(Icons.copy),
              ),
          ],
        ),

        body: _showConsole
            ? _buildConsoleViewer()
            : _showCode
            ? _buildCodeViewer()
            : _buildGameViewer(),
      ),
    );
  }

  // ============================================================
  // VISTA DEL JUEGO
  // ============================================================

  Widget _buildGameViewer() {
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              WebViewWidget(
                controller: _webViewController,
              ),

              if (_isLoading)
                Container(
                  color: colors.surface,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),

              if (_hasError)
                Container(
                  color: colors.surface,
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 52,
                          color: colors.error,
                        ),

                        const SizedBox(height: 12),

                        Text(
                          'No se pudo cargar el juego',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),

                        const SizedBox(height: 16),

                        FilledButton.icon(
                          onPressed: _loadGame,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reintentar'),
                        ),

                        TextButton.icon(
                          onPressed: _showConsoleMode,
                          icon: const Icon(Icons.terminal),
                          label: const Text('Ver errores'),
                        ),
                      ],
                    ),
                  ),
                ),

              if (_isFullscreen)
                Positioned(
                  top: 12,
                  right: 12,
                  child: SafeArea(
                    child: IconButton.filledTonal(
                      onPressed: _exitFullscreen,
                      icon: const Icon(Icons.fullscreen_exit),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // VISTA DEL CÓDIGO
  // ============================================================

  Widget _buildCodeViewer() {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(
                Icons.html,
                color: colors.primary,
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  'HTML / CSS / JavaScript',
                  style: theme.textTheme.titleSmall,
                ),
              ),

              Text(
                '${widget.project.gameCode.length} caracteres',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        Divider(
          height: 1,
          color: colors.outlineVariant,
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: SelectableText(
              widget.project.gameCode,
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
                height: 1.5,
              ),
            ),
          ),
        ),

        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _copyCode,
                icon: const Icon(Icons.copy),
                label: const Text('Copiar código completo'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // VISTA DE LA CONSOLA
  // ============================================================

  Widget _buildConsoleViewer() {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          child: Row(
            children: [
              Icon(
                Icons.terminal,
                color: colors.primary,
              ),

              const SizedBox(width: 8),

              Text(
                'Consola',
                style: theme.textTheme.titleMedium,
              ),

              const SizedBox(width: 10),

              Text(
                '${_consoleMessages.length} mensajes',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),

              const Spacer(),

              IconButton(
                tooltip: 'Limpiar consola',
                onPressed: _clearConsole,
                icon: const Icon(Icons.delete_sweep_outlined),
              ),

              IconButton(
                tooltip: 'Copiar consola',
                onPressed: _copyConsole,
                icon: const Icon(Icons.copy),
              ),
            ],
          ),
        ),

        Divider(
          height: 1,
          color: colors.outlineVariant,
        ),

        Expanded(
          child: _consoleMessages.isEmpty
              ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.terminal,
                  size: 48,
                  color: colors.onSurfaceVariant,
                ),

                const SizedBox(height: 12),

                Text(
                  'La consola está vacía',
                  style: theme.textTheme.titleMedium,
                ),

                const SizedBox(height: 5),

                Text(
                  'Los mensajes del juego aparecerán aquí.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: _consoleMessages.length,
            itemBuilder: (context, index) {
              final message = _consoleMessages[index];

              final Color messageColor;

              switch (message.level) {
                case 'error':
                  messageColor = colors.error;
                  break;
                case 'warn':
                  messageColor = colors.tertiary;
                  break;
                case 'info':
                  messageColor = colors.primary;
                  break;
                default:
                  messageColor = colors.onSurfaceVariant;
              }

              final time =
                  '${message.time.hour.toString().padLeft(2, '0')}:'
                  '${message.time.minute.toString().padLeft(2, '0')}:'
                  '${message.time.second.toString().padLeft(2, '0')}';

              return Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 9,
                  horizontal: 10,
                ),
                margin: const EdgeInsets.only(bottom: 6),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      time,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colors.onSurfaceVariant,
                        fontFamily: 'monospace',
                      ),
                    ),

                    const SizedBox(width: 10),

                    Icon(
                      message.level == 'error'
                          ? Icons.error_outline
                          : message.level == 'warn'
                          ? Icons.warning_amber_rounded
                          : Icons.info_outline,
                      size: 16,
                      color: messageColor,
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: SelectableText(
                        message.message,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: messageColor,
                          fontFamily: 'monospace',
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    if (_isFullscreen) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.edgeToEdge,
      );
    }

    super.dispose();
  }
}

class _GameConsoleMessage {
  final String level;
  final String message;
  final DateTime time;

  const _GameConsoleMessage({
    required this.level,
    required this.message,
    required this.time,
  });

  factory _GameConsoleMessage.fromJson(
      Map<String, dynamic> json,
      ) {
    return _GameConsoleMessage(
      level: json['level']?.toString() ?? 'log',
      message: json['message']?.toString() ?? '',
      time: DateTime.tryParse(
        json['time']?.toString() ?? '',
      ) ??
          DateTime.now(),
    );
  }
}
