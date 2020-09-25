part of 'note_detail_bloc.dart';

abstract class NoteDetailEvent extends Equatable {
  const NoteDetailEvent();

  @override
  List<Object> get props => [];
}

class NoteLoaded extends NoteDetailEvent {
  final Note note;
  const NoteLoaded({@required this.note});
  List<Object> get props => [note];

  @override
  String toString() => 'NoteLoaded { note: $note }';
}

class NoteContentUpdated extends NoteDetailEvent {
  final String content;

  NoteContentUpdated({@required this.content});
  List<Object> get props => [content];

  @override
  String toString() => 'NoteContentUpdated { content: $content }';
}

class NoteColorUpdated extends NoteDetailEvent {
  final Color color;

  NoteColorUpdated({@required this.color});
  List<Object> get props => [color];

  @override
  String toString() => 'NoteContentUpdated { color: $color }';
}

class NoteAdded extends NoteDetailEvent {}

class NoteSaved extends NoteDetailEvent {}

class NoteDeleted extends NoteDetailEvent {}
