part of 'todo_bloc.dart';

@immutable
abstract class TodoState {
  const TodoState();
}

class TodoInitial extends TodoState {
  const TodoInitial();
}

class TodoLoading extends TodoState {
  const TodoLoading();
}

class TodoLoaded extends TodoState {
  final List<Todo> todos;
  const TodoLoaded(this.todos);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is TodoLoaded && o.todos == todos;
  }

  @override
  int get hashCode => super.hashCode;
}

class TodoSuccess extends TodoState {
  const TodoSuccess();
}

class TodoError extends TodoState {
  final String message;
  const TodoError(this.message);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is TodoError && o.message == message;
  }

  @override
  int get hashCode => super.hashCode;
}
