// {
//     "className":"todo",
//     "objectId":"anl1T8kCE2",
//     "createdAt":"2023-10-28T08:02:22.183Z",
//     "updatedAt":"2023-10-28T08:02:22.183Z",
//     "title":"sample item",
//     "description":"this is a sample todo item"
// }
class TodoEntry {
  final String className;
  final String objectId;
  final String createdAt;
  final String updatedAt;
  final String title;
  final String description;
  final bool done;

  TodoEntry({
    required this.className,
    required this.objectId,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    required this.description,
    required this.done,
  });

  factory TodoEntry.fromMap(Map<String, dynamic> map) {
    return TodoEntry(
        className: map['className'],
        objectId: map['objectId'],
        createdAt: map['createdAt'],
        updatedAt: map['updatedAt'],
        title: map['title'],
        description: map['description'],
        done: map["done"]);
  }
}
