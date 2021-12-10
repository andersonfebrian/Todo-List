import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'page_toggle_event.dart';
part 'page_toggle_state.dart';

class PageToggleBloc extends Bloc<PageToggleEvent, PageToggleState> {
  PageToggleBloc() : super(PageToggleInitial());

  @override
  Stream<PageToggleState> mapEventToState(
    PageToggleEvent event,
  ) async* {
    if(event is ToggleLoginPage) {
      yield LoginPageToggled();
    }

    if(event is ToggleRegisterPage) {
      yield RegisterPageToggled();
    }
  }
}
