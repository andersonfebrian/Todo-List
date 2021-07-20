import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'todo.g.dart';

@JsonSerializable()
class Todo {
  String body;
  bool? isDone;
  String? id;

  @TimestampConverter()
  DateTime? createdAt, updatedAt;

  Todo(this.body) {
    this.isDone = false;
    createdAt = updatedAt = DateTime.now();
  }

  Todo.fromDocRef(QueryDocumentSnapshot<Map<String, dynamic>> doc)
      : this.body = doc["body"],
        this.isDone = doc["isDone"],
        this.createdAt = DateTime.tryParse(doc["createdAt"]),
        this.updatedAt = DateTime.tryParse(doc["updatedAt"]),
        this.id = doc.id;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  Map<String, dynamic> toJson() => _$TodoToJson(this);

  Map<String, Object> toDocument() {
    return {
      "body" : body,
      "isDone" : isDone ?? false,
      "createdAt" : createdAt.toString(),
      "updatedAt" : updatedAt.toString(),
    };
  }
}

// https://stackoverflow.com/questions/60793441/how-do-i-resolve-type-timestamp-is-not-a-subtype-of-type-string-in-type-cast
class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}
