import 'package:equatable/equatable.dart';

class FinViz extends Equatable {
  const FinViz({
    required this.imageURL,
    required this.shareURL,
  });
  final String imageURL;
  final String shareURL;

  static const empty = FinViz(
    imageURL: "",
    shareURL: "",
  );

  @override
  List<Object?> get props => [
        imageURL,
        shareURL,
      ];

  factory FinViz.fromMap(Map<String, dynamic> map) {
    return FinViz(
      imageURL: map['imgUrl'] as String,
      shareURL: map['shareUrl'] as String,
    );
  }
}
