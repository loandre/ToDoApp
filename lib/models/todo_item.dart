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
    return {
      'title': title,
      'isDone': isDone ? 1 : 0,
    };
  }

  // Converter um Map em um TodoItem
  factory TodoItem.fromMap(Map<String, dynamic> map) {
    return TodoItem(
      id: map['id'],
      title: map['title'],
      isDone: map['isDone'] == 1,
    );
  }
}
