import 'package:equatable/equatable.dart';
import 'package:investing/util/date_time_format.dart';

class News extends Equatable {
  const News({
    required this.index,
    required this.title,
    required this.ago,
    required this.createdAt,
    required this.publisher,
    required this.url,
    required this.imageDomain,
    required this.image,
  });
  final int index;
  final String title;
  final String? ago;
  final DateTime? createdAt;
  final String publisher;
  final String url;
  final String imageDomain;
  final String image;

  String get articleDetailURL {
    return "https://nasdaq.com$url";
  }

  String? get headPhoto {
    if (image.isEmpty) {
      return null;
    }
    return imageDomain + image;
  }

  @override
  List<Object?> get props => [
        index,
        title,
        ago,
        publisher,
        url,
        imageDomain,
        image,
      ];

  factory News.latest(Map<String, dynamic> map) {
    return News(
      index: map['id'] as int,
      title: map['title'] as String,
      ago: map['ago'] as String,
      createdAt: null,
      publisher: map['publisher'] as String,
      url: map['url'] as String,
      image: map['image'] as String,
      imageDomain: map["imagedomain"] as String,
    );
  }
  factory News.search(Map<String, dynamic> map) {
    return News(
      index: List.from(map['nid']).first as int,
      title: List.from(map['title']).first as String,
      ago: map['ago'] as String?,
      createdAt:
          DateTime.fromMillisecondsSinceEpoch(List.from(map["created"]).first),
      publisher: List.from(map['publisher_name']).first as String,
      url: List.from(map['url']).first as String,
      // ignore: prefer_interpolation_to_compose_strings
      image: map['field_image_url'] == null
          ? ""
          : List.from(map['field_image_url']).first as String,
      imageDomain: "https://nasdaq.com/",
    );
  }
}
