import 'package:investing/repo/repo.dart';

abstract class UseCase<T extends Repo> {
  UseCase(this.repo);
  final T repo;

  Future<void> init() {
    return repo.init();
  }
}
