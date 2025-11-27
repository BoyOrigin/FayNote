class Note {
  int? id;
  String title;
  String content;

  Note({this.id, required this.title, required this.content});

  // Konversi dari Note ke Map (untuk disimpan ke SQFlite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
    };
  }

  // Konversi dari Map ke Note (saat mengambil data dari SQFlite)
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
    );
  }
}