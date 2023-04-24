import 'package:equatable/equatable.dart';

class News extends Equatable {
  const News({
    required this.index,
    required this.title,
    required this.ago,
    required this.publisher,
    required this.url,
    required this.imageDomain,
    required this.image,
  });
  final int index;
  final String title;
  final String? ago;
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

  factory News.fromMap(Map<String, dynamic> map) {
    return News(
      index: map['id'] as int,
      title: map['title'] as String,
      ago: map['ago'] as String,
      publisher: map['publisher'] as String,
      url: map['url'] as String,
      image: map['image'] as String,
      imageDomain: map["imagedomain"] as String,
    );
  }
}
