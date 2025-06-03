class Note {
  final String id;
  final String title;
  final String description;
  final String section;
  final String references;


  Note({
    required this.id,
    required this.title,
    required this.description,
    required this.section,
    required this.references,
  });

  // Convert a Note instance into a Map
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'section': section,
      'references': references,
    };
  }

  // Convert a Map into a Note instance
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      section: json['section'] ?? '',
      references: json['references'] ?? '',
    );
  }
}
