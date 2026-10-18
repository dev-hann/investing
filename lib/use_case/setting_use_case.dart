import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:investing/repo/setting/setting_repo.dart';
import 'package:investing/use_case/use_case.dart';

class SettingUseCase extends UseCase<SettingRepo> {
  SettingUseCase(super.repo);
}

final settingUseCaseProvider = Provider(
  (ref) => SettingUseCase(ref.watch(settingRepoProvider)),
);
