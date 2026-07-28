import '../../../../core/utils/value_parsing/safe_value_parser.dart';

class UpdateTodoDto {
  final String title;
  final String description;
  final bool completed;

  const UpdateTodoDto({
    required this.title,
    required this.description,
    required this.completed,
  });

  factory UpdateTodoDto.fromJson(Map<String, dynamic> json) {
    return UpdateTodoDto(
      title: SafeValueParser.readString(json['title']),
      description: SafeValueParser.readString(json['description']),
      completed: SafeValueParser.readBool(json['completed']),
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'completed': completed,
  };
}
