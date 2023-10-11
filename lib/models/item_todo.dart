class TodoItem {
  int? id;
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
      'isDone': isDone ? 1 : 0,
    };
    if (id != null) {
      map['_id'] = id!;
    }
    return map;
  }

  // Converter um Map em um TodoItem
  factory TodoItem.fromMap(Map<String, dynamic> map) {
    return TodoItem(
      id: map['_id'],
      title: map['title'],
      isDone: map['isDone'] == 1,
    );
  }
}
