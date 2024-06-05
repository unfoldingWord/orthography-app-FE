
class HomePageResponse {
  final String message;
  final List<ModuleDetailsList> data;

  /// Constructor for HomePageResponse
  HomePageResponse({required this.message, required this.data});

  /// Factory method to parse JSON into HomePageResponse object
  factory HomePageResponse.fromJson(Map<String, dynamic> json) {
    /// Extract the list of module details from the JSON data
    var dataList = json['data'] as List;
    List<ModuleDetailsList> moduleDetailsList = dataList.map((e) => ModuleDetailsList.fromJson(e)).toList();

    /// Return a new instance of HomePageResponse with parsed data
    return HomePageResponse(
      message: json['message'],
      data: moduleDetailsList,
    );
  }
}

class ModuleDetailsList {
  final int totalImages;
  final int completedImages;
  final int incompletedImages;
  final double percentageComplete;
  final int skippedImages;
  final String module;
  final bool isOpen;

  /// Constructor for ModuleDetailsList
  ModuleDetailsList({
    required this.totalImages,
    required this.completedImages,
    required this.incompletedImages,
    required this.percentageComplete,
    required this.skippedImages,
    required this.module,
    required this.isOpen,
  });

  /// Factory method to parse JSON into ModuleDetailsList object
  factory ModuleDetailsList.fromJson(Map<String, dynamic> json) {
    /// Return a new instance of ModuleDetailsList with parsed data
    return ModuleDetailsList(
      totalImages: json['TotalImages'],
      completedImages: json['CompletedImages'],
      incompletedImages: json['IncompletedImages'],
      percentageComplete: json['PercentageComplete'],
      skippedImages: json['SkippedImages'],
      module: json['module'],
      isOpen: json['isOpen'],
    );
  }
}
