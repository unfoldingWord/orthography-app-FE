

class SingleSoundGroupModel {
  final String id;
  final String fileUrl;
  final String fileName;
  final String spokenLanguage;
  int onTap=0;
  bool isSubmitted=false;

  SingleSoundGroupModel({
    required this.id,
    required this.fileUrl,
    required this.fileName,
    required this.spokenLanguage,
    this.onTap = 0,
    this.isSubmitted=false
  });

  factory SingleSoundGroupModel.fromJson(Map<String, dynamic> json) {
    return SingleSoundGroupModel(
      id: json['_id'],
      fileUrl: json['fileUrl'],
      fileName: json['fileName'],
      spokenLanguage: json['spokenLanguage'],
    );
  }
}


class SoundGroup {
  final String soundGroupId;
  final String imageId;
  final String imageObjectUrl;
  final String fileName;

  SoundGroup({
    required this.soundGroupId,
    required this.imageId,
    required this.imageObjectUrl,
    required this.fileName,
  });

  factory SoundGroup.fromJson(Map<String, dynamic> json) {
    return SoundGroup(
      soundGroupId: json['soundGroupId'],
      imageId: json['imageId'],
      imageObjectUrl: json['imageObjectUrl'],
      fileName: json['fileName'],
    );
  }
}

class SoundGroupImageData {
  final String id;
  final String imageId;
  final String imageObjectUrl;
  final String languageId;
  final String? userId;
  // final String soundGroup;

  SoundGroupImageData({
    required this.id,
    required this.imageId,
    required this.imageObjectUrl,
    required this.languageId,
    required this.userId,
    // required this.soundGroup,
  });

  factory SoundGroupImageData.fromJson(Map<String, dynamic> json) {
    return SoundGroupImageData(
      id: json['id'],
      imageId: json['imageId'],
      imageObjectUrl: json['imageObjectUrl'],
      languageId: json['languageId'],
      userId: json['userId'],
      // soundGroup: json['soundGroup'],
    );
  }
}


class AssignSoundGroupImageData {
  final String id;
  final String imageId;
  final String imageObjectUrl;
  final String? syllableType;
  final bool? assignLetterCompleted;



  AssignSoundGroupImageData({
    required this.id,
    required this.imageId,
    required this.imageObjectUrl,
    required this.assignLetterCompleted,
    required this.syllableType
  });

  factory AssignSoundGroupImageData.fromJson(Map<String, dynamic> json) {
    return AssignSoundGroupImageData(
      id: json['id'],
      imageId: json['imageId'],
      imageObjectUrl: json['imageObjectUrl'],
      assignLetterCompleted: json['assignLetterCompleted'],
      syllableType: json['syllableType']
    );
  }
}