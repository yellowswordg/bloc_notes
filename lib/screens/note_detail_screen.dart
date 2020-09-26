import 'package:bloc_notes/blocs/blocs.dart';
import 'package:bloc_notes/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoteDetailScreen extends StatefulWidget {
  final Note note;
  const NoteDetailScreen({this.note});

  @override
  _NoteDetailScreenState createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  final FocusNode _contentFocusNode = FocusNode();
  final TextEditingController _contentController = TextEditingController();
  final List<HexColor> _colors = [
    
  ];

  /// When we push add button on the HomeScreen we don't send a note inside
  /// NotesDetaiScreeen so [note] will be empty
  bool get _isEditing => widget.note != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _contentController.text = widget.note.content;
    } else {
      // we are adding a new note here so we need a keyboard to popup.
      //When our state first loads  wait for the first build and than we request focus on our contentFocusNode;
      SchedulerBinding.instance.addPostFrameCallback(
          (_) => FocusScope.of(context).requestFocus(_contentFocusNode));
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    _contentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (_isEditing) {
          context.bloc<NoteDetailBloc>().add(NoteSaved());
        }
        return Future.value(true);
      },
      child: BlocConsumer<NoteDetailBloc, NoteDetailState>(
        listener: (context, state) {
          if (state.isSuccess) {
            Navigator.of(context).pop();
          } else if (state.isFailure) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Error '),
                  content: Text(state.errorMessage),
                  actions: [
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('OK'),
                    )
                  ],
                );
              },
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              actions: <Widget>[_buildAction(context)],
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                top: 10.0,
                bottom: 80.0,
              ),
              child: TextField(
                focusNode: _contentFocusNode,
                controller: _contentController,
                style: TextStyle(
                  fontSize: 18.0,
                  height: 1.2,
                ),
                decoration: const InputDecoration.collapsed(
                    hintText: 'Write about anything'),
                // Text will wrap endefinetly
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                // It will be trigered whenever we type text in to this field
                onChanged: (value) => context
                    .bloc<NoteDetailBloc>()
                    .add(NoteContentUpdated(content: value)),
              ),
            ),
            bottomSheet: ColorPicker(state: state, colors: _colors),
          );
        },
      ),
    );
  }

  // we check if the user is edetin the note
  FlatButton _buildAction(BuildContext context) {
    return _isEditing
        ? FlatButton(
            onPressed: () => context.bloc<NoteDetailBloc>().add(
                  NoteDeleted(),
                ),
            child: Text(
              'Delete',
              style: TextStyle(fontSize: 17.0, color: Colors.red),
            ),
          )
        : FlatButton(
            onPressed: () => context.bloc<NoteDetailBloc>().add(
                  NoteAdded(),
                ),
            child: Text(
              'add',
              style: TextStyle(fontSize: 17.0, color: Colors.green),
            ),
          );
  }
}
