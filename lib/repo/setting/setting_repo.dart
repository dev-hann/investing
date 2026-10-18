library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:investing/repo/repo.dart';

part 'setting_impl.dart';

abstract class SettingRepo extends Repo {}

final settingRepoProvider = Provider<SettingRepo>((ref) => SettingImpl());
