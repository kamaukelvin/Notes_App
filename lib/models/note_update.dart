import 'package:flutter/foundation.dart';

// to work with @required import foundation package
// we use @ required in the constructor to show the data is mandatory
class NoteUpdate{
  String noteTitle;
  String noteContent;

  NoteUpdate({@required this.noteTitle, @required this.noteContent});


// this method will be used in notes_service.dart to convert the note from user to a map of String and Json
  Map<String, dynamic>toJson() {
    return {
       "noteTitle": noteTitle,
      "noteContent": noteContent
    };
  }

}