/// Represents a model for the image gallery item.
class ImageGalleryItemModel {
  String message;
  int totalImages;
  int incompleteImagesCount;
  List<ImageGalleryItems> ImageGalleryItemList;

  ImageGalleryItemModel({
    required this.message,
    required this.totalImages,
    required this.incompleteImagesCount,
    required this.ImageGalleryItemList,
  });
}

/// Represents an individual image gallery item.
class ImageGalleryItems {
  String id;
  String fileUrl;
  String fileName;
  String baseLanguage;
  int v;
  bool skippedSyllable;
  bool completed;
  int onTap = 0; /// Default value for onTap attribute

  ImageGalleryItems({
    required this.id,
    required this.fileUrl,
    required this.fileName,
    required this.baseLanguage,
    required this.v,
    this.onTap = 0, // Assigning a default value to onTap
    required this.skippedSyllable,
    required this.completed,
  });

  /// Factory method to create an instance of ImageGallery Items from JSON.
  factory ImageGalleryItems.fromJson(Map<String, dynamic> json) {
    return ImageGalleryItems(
      id: json['_id'],
      fileUrl: json['fileUrl'],
      fileName: json['fileName'],
      baseLanguage: json['baseLanguage'],
      v: json['__v'],
      skippedSyllable: json['skippedSyllable'],
      completed: json['completed'],
    );
  }
}

