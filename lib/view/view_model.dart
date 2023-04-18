part of view;

typedef OverlayLoadingFunc = VoidFutureCallBack;

abstract class ViewModel<T extends Controller> {
  final T controller = Get.find<T>();
  int get viewID => hashCode;

  bool get isLoading => _loading;
  bool _loading = true;

  Future _init() async {
    await controller.loading;
    controller.addViewID(viewID);
    init();
  }

  @mustCallSuper
  Future init() async {
    _loading = false;
    updateViewByID();
  }

  @mustCallSuper
  Future dispose() async {
    controller.removeViewID(viewID);
  }

  bool _overlayLoading = false;
  bool get isOverlayLoading => _overlayLoading;

  Future overlayLoading(VoidFutureCallBack voidFutureCallBack) async {
    initOverlayLoading();
    await voidFutureCallBack();
    completedOverlayLoading();
  }

  void initOverlayLoading() {
    _overlayLoading = true;
    updateViewByID();
  }

  void completedOverlayLoading() {
    _overlayLoading = false;
    updateViewByID();
  }

  void updateView() {
    controller.updateView();
  }

  void updateViewByID() {
    controller.update([viewID]);
  }
}
