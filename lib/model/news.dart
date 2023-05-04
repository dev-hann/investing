import 'package:equatable/equatable.dart';

class News extends Equatable {
  const News({
    required this.index,
    required this.title,
    required this.created,
    required this.publisher,
    required this.url,
    required this.imageDomain,
    required this.image,
  });
  final int index;
  final String title;
  final String? created;
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
        created,
        publisher,
        url,
        imageDomain,
        image,
      ];

  factory News.latest(Map<String, dynamic> map) {
    return News(
      index: map['id'] as int,
      title: map['title'] as String,
      created: map['ago'] as String,
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
      created: map["crdt"],
      publisher: map['publisher_name'] == null
          ? ""
          : List.from(map['publisher_name']).first as String,
      url: List.from(map['url']).first as String,
      // ignore: prefer_interpolation_to_compose_strings
      image: map['field_image_url'] == null
          ? ""
          : (List.from(map['field_image_url']).first as String)
              .split('//')
              .last,
      imageDomain: "https://www.nasdaq.com/sites/acquia.prod/files/",
    );
  }
}
