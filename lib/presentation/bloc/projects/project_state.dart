part of 'project_bloc.dart';

class ProjectState extends Equatable {
  final List<Project> projects;
  final bool isLoading;
  final String? error;
  final String searchQuery;
  final String? selectedCategory;
  final Sort sortBy;

  factory ProjectState.init(){
    return ProjectState();
  }

  const ProjectState({
    this.projects = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
    this.selectedCategory,
    this.sortBy = Sort.recent,
  });

  List<Project> get filteredProjects {
    List<Project> result = List<Project>.from(projects);

    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();

      result = result.where((project) {
        return project.title.toLowerCase().contains(query) ||
            project.description.toLowerCase().contains(query) ||
            project.tags.any((tag) => tag.toLowerCase().contains(query));
      }).toList();
    }

    if (selectedCategory != null) {
      result = result.where((project) => project.category == selectedCategory).toList();
    }

    switch (sortBy) {
      case Sort.oldest:
        result.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;

      case Sort.alphabetical:
        result.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;

      case Sort.mostPlayed:
        result.sort((a, b) => b.playCount.compareTo(a.playCount));
        break;

      case Sort.recent:
        result.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    }

    return result;
  }

  List<Project> get favoriteProjects {
    return projects
        .where((project) => project.isFavorite)
        .toList();
  }

  int get totalProjects => projects.length;

  int get completedProjects =>
      projects.where((project) => project.isCompleted).length;

  int get pendingProjects =>
      projects.where((project) => project.status == 'draft').length;

  List<String> get categories {
    return projects
        .map((project) => project.category)
        .toSet()
        .toList()
      ..sort();
  }

  // Copiar estado.
  ProjectState copyWith({
    List<Project>? projects,
    bool? isLoading,
    String? error,
    bool clearError = false,
    String? searchQuery,
    String? selectedCategory,
    bool clearCategory = false,
    Sort? sortBy,
  }) {
    return ProjectState(
      projects: projects ?? this.projects,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: clearCategory
          ? null
          : selectedCategory ?? this.selectedCategory,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  // Guardar estado en JSON.
  Map<String, dynamic> toJson() {
    return {
      'projects': projects.map((project) => project.toJson()).toList(),
    };
  }

  // Recuperar estado desde JSON.
  factory ProjectState.fromJson(Map<String, dynamic> json) {
    return ProjectState(
      projects: (json['projects'] as List<dynamic>? ?? [])
          .map(
            (project) => Project.fromJson(
          Map<String, dynamic>.from(project as Map),
        ),
      )
          .toList(),
    );
  }

  @override
  List<Object?> get props => [
    projects,
    isLoading,
    error,
    searchQuery,
    selectedCategory,
    sortBy,
  ];
}


