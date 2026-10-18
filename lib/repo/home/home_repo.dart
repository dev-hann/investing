library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:investing/repo/repo.dart';
part 'home_impl.dart';

abstract class HomeRepo extends Repo {}

final homeRepoProvider = Provider<HomeRepo>((ref) => HomeImpl());
