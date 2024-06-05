
/// Represents the response received from the image API.
class ImageResponse {
  String message;
  ImageData data;

  ImageResponse({required this.message, required this.data});

  /// Factory method to create an ImageResponse instance from JSON.
  factory ImageResponse.fromJson(Map<String, dynamic> json) {
    return ImageResponse(
      message: json['message'],
      data: ImageData.fromJson(json['data']),
    );
  }
}

/// Represents the data containing different types of images.
class ImageData {
  List<ImageItem> mono;
  List<ImageItem> bi;
  List<ImageItem> tri;
  List<ImageItem> poly;

  ImageData({required this.mono, required this.bi, required this.tri, required this.poly});

  /// Factory method to create an ImageData instance from JSON.
  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      mono: List<ImageItem>.from(json['MONO'].map((x) => ImageItem.fromJson(x))),
      bi: List<ImageItem>.from(json['BI'].map((x) => ImageItem.fromJson(x))),
      tri: List<ImageItem>.from(json['TRI'].map((x) => ImageItem.fromJson(x))),
      poly: List<ImageItem>.from(json['POLY'].map((x) => ImageItem.fromJson(x))),
    );
  }
}

/// Represents an individual image item.
class ImageItem {
  String id;
  String imageId;
  String imageObjectUrl;
  String languageId;
  String userId;
  String syllableType;
  bool soundGroupingCompleted;

  ImageItem({
    required this.id,
    required this.imageId,
    required this.imageObjectUrl,
    required this.languageId,
    required this.userId,
    required this.syllableType,
    required this.soundGroupingCompleted,
  });

  /// Factory method to create an ImageItem instance from JSON.
  factory ImageItem.fromJson(Map<String, dynamic> json) {
    return ImageItem(
      id: json['id'],
      imageId: json['imageId'],
      imageObjectUrl: json['imageObjectUrl'],
      languageId: json['languageId'],
      userId: json['userId'],
      syllableType: json['syllableType'],
      soundGroupingCompleted: json['soundGroupingCompleted'],
    );
  }
}
