part of 'page_toggle_bloc.dart';

@immutable
abstract class PageToggleEvent {}

class ToggleLoginPage extends PageToggleEvent {}

class ToggleRegisterPage extends PageToggleEvent {}