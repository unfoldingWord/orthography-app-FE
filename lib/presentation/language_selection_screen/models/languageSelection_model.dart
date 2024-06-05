class LanguageModel {
  final String id;       /// Unique identifier for the language
  final String name;     /// Name of the language
  final String code;     /// Language code
  bool isSelected;      /// Indicates whether the language is selected

  /// Constructor with required parameters and optional parameter for isSelected
  LanguageModel({
    required this.id,
    required this.name,
    required this.code,
    this.isSelected = false,  /// Default value for isSelected is false
  });

  /// Factory method to create LanguageModel instance from JSON data
  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      id: json['_id'],    /// Extracting id from JSON
      name: json['name'], /// Extracting name from JSON
      code: json['code'], /// Extracting code from JSON
    );
  }
}
