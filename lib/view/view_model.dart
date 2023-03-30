part of view;

abstract class ViewModel<T extends Controller> {
  final T controller = Get.find<T>();
  dynamic get viewID => hashCode;

  bool get isLoading => _loading;
  bool _loading = true;

  Future _init() async {
    await controller.loading;
    _loading = false;
    init();
  }

  @mustCallSuper
  Future init() async {
    updateView();
  }

  @mustCallSuper
  Future dispose() async {}

  bool _overlayLoading = false;
  bool get isOverlayLoading => _overlayLoading;
  void initOverlayLoading() {
    _overlayLoading = true;
    controller.update();
  }

  void completedOverlayLoading() {
    _overlayLoading = false;
    controller.update();
  }

  void updateView() {
    controller.update([viewID]);
  }
}
