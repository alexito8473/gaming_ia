import 'package:equatable/equatable.dart';
import 'package:gaming_ia/domain/enum/sort.dart';
import 'package:gaming_ia/domain/models/project.dart';
import 'package:gaming_ia/domain/repositories/abstract/game_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'project_event.dart';
part 'project_state.dart';

class ProjectBloc extends HydratedBloc<ProjectEvent, ProjectState> {
  final GameRepository gameRepository;
  ProjectBloc({required this.gameRepository}) : super(ProjectState.init()) {
    on<ProjectAddNewEvent>((event, emit) {
      emit(
        state.copyWith(projects: [...state.projects, event.project], clearError: true,),
      );
    });

    on<ProjectDeleteEvent>((event, emit) {
      final projects = state.projects.where((project) => project.id != event.projectId).toList();
      emit(state.copyWith(projects: projects));
    });

    on<ProjectUpdateEvent>((event, emit) {
      final projects = state.projects.map((project) {
        return project.id == event.project.id
            ? event.project
            : project;
      }).toList();

      emit(state.copyWith(projects: projects));
    });

    on<ProjectToggleFavoriteEvent>((event, emit) {
      final projects = state.projects.map((project) {
        if (project.id == event.projectId) {
          return project.copyWith(isFavorite: !project.isFavorite);
        }

        return project;
      }).toList();

      emit(state.copyWith(projects: projects));
    });

    on<ProjectMarkAsPlayedEvent>((event, emit) {
      final projects = state.projects.map((project) {
        if (project.id == event.projectId) {
          return project.copyWith(
            playCount: project.playCount + 1,
            lastPlayedAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
        }

        return project;
      }).toList();

      emit(state.copyWith(projects: projects));
    });
    on<ProjectSearchEvent>((event, emit) {
      emit(
        state.copyWith(searchQuery: event.query),
      );
    });

    on<ProjectSortEvent>((event, emit) {
      emit(
        state.copyWith(sortBy: event.sortBy),
      );
    });
    on<ProjectGenerateEvent>((event, emit) async {
      emit(
        state.copyWith(
          isLoading: true,
          clearError: true,
        ),
      );

      try {
        final project = await gameRepository.generateGame(
          prompt: event.prompt,
        );

        emit(
          state.copyWith(
            projects: [...state.projects, project],
            isLoading: false,
            clearError: true,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            isLoading: false,
            error: e.toString(),
          ),
        );
      }
    });

  }

  @override
  ProjectState? fromJson(Map<String, dynamic> json) {
    try {
      return ProjectState.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(ProjectState state) {
    return state.toJson();
  }
}
