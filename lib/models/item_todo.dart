class TodoItem {
  String? id;
  String title;
  bool isDone;

  TodoItem({
    this.id,
    required this.title,
    this.isDone = false,
  });

  // Converter um TodoItem em um Map
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'title': title,
      'isDone': isDone, // Usando o booleano diretamente
    };
    if (id != null) {
      map['id'] = id; // Usando 'id' em vez de '_id'
    }
    return map;
  }

  // Converter um Map em um TodoItem
  factory TodoItem.fromMap(Map<String, dynamic> map) {
    return TodoItem(
      id: map['id'],
      title: map['title'],
      isDone: map['isDone'] as bool, // Tratando isDone como booleano
    );
  }
}
