import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_notes/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';


part 'note_detail_event.dart';
part 'note_detail_state.dart';

class NoteDetailBloc extends Bloc<NoteDetailEvent, NoteDetailState> {
  NoteDetailBloc() : super(NoteDetailInitial());

  @override
  Stream<NoteDetailState> mapEventToState(
    NoteDetailEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
