part of 'note_detail_bloc.dart';
// The reason we use an @immutable class for our NoteDetailBloc is because our NoteDetailScreen is a form. Data is constantly changing and has to stay consistent across states. For example, if there is an error adding a note, we need to display an error dialog, while maintaining the current content. To do this, all we have to do is yield the failure state with an error message. We don't need to pass in additional parameters such as content because the immutable values of the class stay consistent across states.

// If we were to use the original structure for the class, we would end up having to pass values like content every single time we want to yield new states. In addition, rendering UI would get messy because we would have to verify the state of our bloc to access variables. By using an immutable class, we always have access to all of our state's variables.

// A good rule of thumb is use imutable class whenevere you have a screen is going to end up to be a FORM
/// This allows you to display error messages using [errorMessage] while still been able to render a note or whatever you want to show
/// because when If we use not immutable class insted we will note going to be able to show the ui only the error. 
@immutable
class NoteDetailState {
  final Note note;
  final bool isSubmiting;
  final bool isSuccess;
  final bool isFailure;
  final String errorMessage;

  NoteDetailState({
    this.note,
    this.isSubmiting,
    this.isSuccess,
    this.isFailure,
    this.errorMessage,
  });

  factory NoteDetailState.empty() {
    return NoteDetailState(
      note: null,
      isSubmiting: false,
      isSuccess: false,
      isFailure: false,
      errorMessage: "",
    );
  }
  factory NoteDetailState.submitting({@required Note note}) {
    return NoteDetailState(
      note: note,
      isSubmiting: true,
      isSuccess: false,
      isFailure: false,
      errorMessage: "",
    );
  }
  factory NoteDetailState.success({@required Note note}) {
    return NoteDetailState(
      note: note,
      isSubmiting: false,
      isSuccess: true,
      isFailure: false,
      errorMessage: "",
    );
  }
  factory NoteDetailState.failure(
      {@required Note note, @required String errorMessage}) {
    return NoteDetailState(
      note: note,
      isSubmiting: false,
      isSuccess: false,
      isFailure: true,
      errorMessage: errorMessage,
    );
  }
  NoteDetailState update({
    Note note,
    bool isSubmiting,
    bool isSuccess,
    bool isFailure,
    String errorMessage,
  }) {
    return copyWith(
        note: note,
        isSubmiting: isSubmiting,
        isSuccess: isSuccess,
        isFailure: isFailure,
        errorMessage: errorMessage);
  }

  NoteDetailState copyWith({
    Note note,
    bool isSubmiting,
    bool isSuccess,
    bool isFailure,
    String errorMessage,
  }) {
    return NoteDetailState(
      note: note ?? this.note,
      isSubmiting: isSubmiting ?? this.isSubmiting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() => '''NoteDetailState
      note: $note, 
      isSubmiting: $isSubmiting,
      isSuccess: $isSuccess, 
      isFailure: $isFailure, 
      errorMessage: $errorMessage, 
  ''';
}
