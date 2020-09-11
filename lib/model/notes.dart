class Notes {
  int id;
  String title;
  String description;

  Notes({this.id, this.title, this.description});

  factory Notes.fromDatabaseJson(Map<String, dynamic> data) => Notes(
      id: data['id'] ?? 0,
      title: data['title'] ?? '',
      description: data['description'] ?? ''
  );

  Map<String, dynamic> toDatabaseJson() {
    var map = {
      "title": this.title ?? '',
      "description": this.description ?? ''
    };

    if (map['id'] != null) map['id'] = this.id ?? '';

    return map;
  }
}
