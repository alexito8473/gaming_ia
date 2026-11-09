import 'package:gaming_ia/domain/models/project.dart';

abstract class GameRepository {
  Future<Project> generateGame({
    required String prompt,
  });
}
