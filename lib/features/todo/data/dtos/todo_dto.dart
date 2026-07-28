import '../../../../core/utils/safe_value_parser.dart';
import '../../domain/entities/todo.dart';

class TodoDto {
  final int id;
  final String title;
  final String description;
  final bool completed;

  const TodoDto({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
  });

  factory TodoDto.fromJson(Map<String, dynamic> json) {
    return TodoDto(
      id: SafeValueParser.readInt(json['id']),
      title: SafeValueParser.readString(json['title']),
      description: SafeValueParser.readString(json['description']),
      completed: SafeValueParser.readBool(json['completed']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'completed': completed,
  };

  Todo toEntity() => Todo(
    id: id.toString(),
    title: title,
    description: description,
    isCompleted: completed,
  );
}
