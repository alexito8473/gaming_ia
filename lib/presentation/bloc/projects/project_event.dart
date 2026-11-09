part of 'project_bloc.dart';

sealed class ProjectEvent extends Equatable {
  const ProjectEvent();

  @override
  List<Object?> get props => [];
}

final class ProjectAddNewEvent extends ProjectEvent {
  final Project project;

  const ProjectAddNewEvent({
    required this.project,
  });

  @override
  List<Object?> get props => [project];
}

final class ProjectDeleteEvent extends ProjectEvent {
  final String projectId;

  const ProjectDeleteEvent({
    required this.projectId,
  });

  @override
  List<Object?> get props => [projectId];
}

final class ProjectUpdateEvent extends ProjectEvent {
  final Project project;

  const ProjectUpdateEvent({
    required this.project,
  });

  @override
  List<Object?> get props => [project];
}

final class ProjectToggleFavoriteEvent extends ProjectEvent {
  final String projectId;

  const ProjectToggleFavoriteEvent({
    required this.projectId,
  });

  @override
  List<Object?> get props => [projectId];
}

final class ProjectMarkAsPlayedEvent extends ProjectEvent {
  final String projectId;

  const ProjectMarkAsPlayedEvent({
    required this.projectId,
  });

  @override
  List<Object?> get props => [projectId];
}
final class ProjectSearchEvent extends ProjectEvent {
  final String query;

  const ProjectSearchEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

final class ProjectSortEvent extends ProjectEvent {
  final Sort sortBy;

  const ProjectSortEvent({required this.sortBy});

  @override
  List<Object?> get props => [sortBy];
}
final class ProjectGenerateEvent extends ProjectEvent {
  final String prompt;

  const ProjectGenerateEvent({
    required this.prompt,
  });

  @override
  List<Object?> get props => [prompt];
}