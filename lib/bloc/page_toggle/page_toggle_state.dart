part of 'page_toggle_bloc.dart';

@immutable
abstract class PageToggleState {}

class PageToggleInitial extends PageToggleState {}

class LoginPageToggled extends PageToggleState {}

class RegisterPageToggled extends PageToggleState {}