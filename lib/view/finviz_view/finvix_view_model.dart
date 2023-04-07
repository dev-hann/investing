import 'package:flutter_inappwebview/flutter_inappwebview.dart';

const String _selectorList =
    ".banner, .banners, .ads, .ad, .advert, .header, .navbar, .map-sidebar, .items-center, .info, .my-3, .mx-auto, .footer, #ic_mobileadhesion";
const double _screenRatio = 798 / 443;

class FinVizViewModel {
  final Uri uri = Uri.parse("https://finviz.com/map.ashx?t=sec&st=d1");
  final screenRatio = _screenRatio;
  final List<ContentBlocker> contentBlockers = [
    ContentBlocker(
      trigger: ContentBlockerTrigger(
        urlFilter: ".*",
      ),
      action: ContentBlockerAction(
        type: ContentBlockerActionType.CSS_DISPLAY_NONE,
        selector: _selectorList,
      ),
    )
  ];
}
