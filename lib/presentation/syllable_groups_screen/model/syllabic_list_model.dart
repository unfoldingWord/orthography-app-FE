
class SyllabicData {
  String? id;
  String? imageId;
  String? imageObjectUrl;
  String? languageId;
  String? userId;
  String? syllableType;
  String? fileName;
  late bool soundGroupingCompleted;

  /// Constructor for SyllabicData class
  SyllabicData({
    this.id,
    this.imageId,
    this.imageObjectUrl,
    this.languageId,
    this.fileName,
    this.userId,
    this.syllableType,
    this.soundGroupingCompleted = false, // Default value for soundGroupingCompleted
  });

  /// Deserialize JSON data into a SyllabicData object
  SyllabicData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageId = json['imageId'];
    fileName = json['fileName'];
    imageObjectUrl = json['imageObjectUrl'];
    languageId = json['languageId'];
    userId = json['userId'];
    syllableType = json['syllableType'];
    soundGroupingCompleted = json['soundGroupingCompleted'];
  }

  /// Serialize SyllabicData object into JSON data
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['imageId'] = imageId;
    data['imageObjectUrl'] = imageObjectUrl;
    data['languageId'] = languageId;
    data['userId'] = userId;
    data['syllableType'] = syllableType;
    data['fileName'] = fileName;
    data['soundGroupingCompleted'] = soundGroupingCompleted;
    return data;
  }
}

class SyllabicDataResponse {
  String? message;
  List<SyllabicData>? data;

  /// Constructor for SyllabicDataResponse class
  SyllabicDataResponse({this.message, this.data});

  /// Deserialize JSON data into a SyllabicDataResponse object
  SyllabicDataResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <SyllabicData>[]; /// Initialize data list
      json['data'].forEach((v) {
        data!.add(SyllabicData.fromJson(v)); /// Deserialize each item in the data list
      });
    }
  }
}
