
import 'package:equatable/equatable.dart';

class Project extends Equatable {
  // Identificación
  final String id;
  final String title;
  final String description;

  // Generación del juego
  final String prompt;
  final String gameCode;
  final String? thumbnail;
  final String category;
  final List<String> tags;

  // Fechas
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastPlayedAt;

  // Estadísticas
  final int playCount;
  final int version;
  final int fileSize;
  final int? generationTime;

  // Configuración
  final bool isFavorite;
  final bool isCompleted;
  final bool isPublic;

  // Información técnica
  final String status;
  final String gameEngine;
  final String aiModel;

  const Project({
    required this.id,
    required this.title,
    this.description = '',
    required this.prompt,
    required this.gameCode,
    this.thumbnail,
    this.category = 'Arcade',
    this.tags = const [],
    required this.createdAt,
    required this.updatedAt,
    this.lastPlayedAt,
    this.playCount = 0,
    this.version = 1,
    this.fileSize = 0,
    this.generationTime,
    this.isFavorite = false,
    this.isCompleted = false,
    this.isPublic = false,
    this.status = 'ready',
    this.gameEngine = 'HTML/CSS/JavaScript',
    this.aiModel = '',
  });

  // Crear una copia modificando determinados campos.
  Project copyWith({
    String? title,
    String? description,
    String? prompt,
    String? gameCode,
    String? thumbnail,
    String? category,
    List<String>? tags,
    DateTime? updatedAt,
    DateTime? lastPlayedAt,
    int? playCount,
    int? version,
    int? fileSize,
    int? generationTime,
    bool? isFavorite,
    bool? isCompleted,
    bool? isPublic,
    String? status,
    String? gameEngine,
    String? aiModel,
  }) {
    return Project(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      prompt: prompt ?? this.prompt,
      gameCode: gameCode ?? this.gameCode,
      thumbnail: thumbnail ?? this.thumbnail,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
      playCount: playCount ?? this.playCount,
      version: version ?? this.version,
      fileSize: fileSize ?? this.fileSize,
      generationTime: generationTime ?? this.generationTime,
      isFavorite: isFavorite ?? this.isFavorite,
      isCompleted: isCompleted ?? this.isCompleted,
      isPublic: isPublic ?? this.isPublic,
      status: status ?? this.status,
      gameEngine: gameEngine ?? this.gameEngine,
      aiModel: aiModel ?? this.aiModel,
    );
  }

  // Convertir el proyecto a JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'prompt': prompt,
      'gameCode': gameCode,
      'thumbnail': thumbnail,
      'category': category,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lastPlayedAt': lastPlayedAt?.toIso8601String(),
      'playCount': playCount,
      'version': version,
      'fileSize': fileSize,
      'generationTime': generationTime,
      'isFavorite': isFavorite,
      'isCompleted': isCompleted,
      'isPublic': isPublic,
      'status': status,
      'gameEngine': gameEngine,
      'aiModel': aiModel,
    };
  }

  // Recuperar un proyecto desde JSON.
  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      prompt: json['prompt'] as String? ?? '',
      gameCode: json['gameCode'] as String? ?? '',
      thumbnail: json['thumbnail'] as String?,
      category: json['category'] as String? ?? 'Arcade',
      tags: List<String>.from(json['tags'] ?? []),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      lastPlayedAt: json['lastPlayedAt'] == null
          ? null
          : DateTime.parse(json['lastPlayedAt'] as String),
      playCount: json['playCount'] as int? ?? 0,
      version: json['version'] as int? ?? 1,
      fileSize: json['fileSize'] as int? ?? 0,
      generationTime: json['generationTime'] as int?,
      isFavorite: json['isFavorite'] as bool? ?? false,
      isCompleted: json['isCompleted'] as bool? ?? false,
      isPublic: json['isPublic'] as bool? ?? false,
      status: json['status'] as String? ?? 'ready',
      gameEngine: json['gameEngine'] as String? ??
          'HTML/CSS/JavaScript',
      aiModel: json['aiModel'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    prompt,
    gameCode,
    thumbnail,
    category,
    tags,
    createdAt,
    updatedAt,
    lastPlayedAt,
    playCount,
    version,
    fileSize,
    generationTime,
    isFavorite,
    isCompleted,
    isPublic,
    status,
    gameEngine,
    aiModel,
  ];
}
