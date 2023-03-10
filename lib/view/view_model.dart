part of view;

abstract class ViewModel<T extends Controller> {
  final T controller = Get.find<T>();

  bool isLoading = true;
  Future _init() async {
    await controller.loading;
    isLoading = false;
    init();
  }

  @mustCallSuper
  Future init() async {
    controller.update();
  }
}
