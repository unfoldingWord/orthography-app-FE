class SoundGroupImage {
  final String id;
  final String imageUrl;
  final List<SoundGroupsImageList> imageList;

  SoundGroupImage({
    required this.id,
    required this.imageUrl,
    required this.imageList,
  });

  factory SoundGroupImage.fromJson(Map<String, dynamic> json) {
    return SoundGroupImage(
      id: json['_id'],
      imageUrl: json['SGImageUrl'],
      imageList: List<SoundGroupsImageList>.from(
        json['SGImageList'].map((imageJson) => SoundGroupsImageList.fromJson(imageJson)),
      ),
    );
  }
}

class SoundGroupsImageList {
  final String id;
  final String imageId;
  final String imageObjectUrl;
  final dynamic assignLetterCompleted;
  final String syllableType;

  SoundGroupsImageList({
    required this.id,
    required this.imageId,
    required this.imageObjectUrl,
    required this.assignLetterCompleted,
    required this.syllableType
  });

  factory SoundGroupsImageList.fromJson(Map<String, dynamic> json) {
    return SoundGroupsImageList(
      id: json['id'],
      imageId: json['imageId'],
      imageObjectUrl: json['imageObjectUrl'],
      assignLetterCompleted: json['assignLetterCompleted'],
      syllableType: json['syllableType']
    );
  }
}

