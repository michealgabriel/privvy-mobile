class GenerationResponseModel {
  final String message;
  final List<String> colors;
  final List<String> images;
  final List<String> imageUrls;

  GenerationResponseModel(
      {required this.message,
      required this.colors,
      required this.images,
      required this.imageUrls});

  factory GenerationResponseModel.fromJson(Map<String, dynamic> json) {
    return GenerationResponseModel(
      message: json['message'],
      colors: List<String>.from(json['colors']),
      images: List<String>.from(json['images']),
      imageUrls: List<String>.from(json['imageUrls']),
    );
  }
}
