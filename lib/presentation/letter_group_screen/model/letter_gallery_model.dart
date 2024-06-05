
class LetterDataResponse {
  final String message;
  final List<LetterData> data;

  LetterDataResponse({required this.message, required this.data});

  factory LetterDataResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> dataList = json['data'];
    List<LetterData> letters = dataList.map((data) => LetterData.fromJson(data)).toList();

    return LetterDataResponse(
      message: json['message'],
      data: letters,
    );
  }
}

class LetterData {
  final String letter;
  final List<LetterImageData> images;

  LetterData({required this.letter, required this.images});

  factory LetterData.fromJson(Map<String, dynamic> json) {
    List<dynamic> imagesList = json['images'];
    List<LetterImageData> imagesData = imagesList.map((data) => LetterImageData.fromJson(data)).toList();

    return LetterData(
      letter: json['letter'],
      images: imagesData,
    );
  }
}

class LetterImageData {
  final String imageObjectUrl;
  final String fileName;
  final String syllableType;
  final bool assignLetterCompleted;

  LetterImageData({
    required this.imageObjectUrl,
    required this.fileName,
    required this.syllableType,
    required this.assignLetterCompleted,
  });

  factory LetterImageData.fromJson(Map<String, dynamic> json) {
    return LetterImageData(
      imageObjectUrl: json['imageObjectUrl'],
      fileName: json['fileName'],
      syllableType: json['syllableType'],
      assignLetterCompleted: json['assignLetterCompleted'],
    );
  }
}


class SingleLetterImageData {
  final String imageId;
  final String imageObjectUrl;
  final String grapheme;


  SingleLetterImageData({
    required this.imageId,
    required this.imageObjectUrl,
    required this.grapheme,
  });

  factory SingleLetterImageData.fromJson(Map<String, dynamic> json) {
    return SingleLetterImageData(
      imageId: json['imageId'],
      imageObjectUrl: json['imageObjectUrl'],
      grapheme: json['grapheme'],
    );
  }
}
