import 'package:crud_app/models/new_note.dart';
import 'package:crud_app/models/note.dart';
import 'package:crud_app/models/note_update.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:crud_app/services/notes_service.dart';
import 'package:get_it/get_it.dart';

class NoteModify extends StatefulWidget {

  // we will make let the note modify take in an id so that when its  null the title of appbar is cretae note, when not it displays update note
  
  final String noteID;

  // boolean to check if id is null or not
  NoteModify({this.noteID});

  @override
  _NoteModifyState createState() => _NoteModifyState();
}

class _NoteModifyState extends State<NoteModify> {

  bool get isEditing=>widget.noteID!=null;

  NotesService get notesService => GetIt.instance<NotesService>();
  String errorMessage;
  Note note;

  // TextEditing controller helps us to capture the data in a textfield, much more like handleChange in react
TextEditingController _titleController = TextEditingController();
TextEditingController _contentController = TextEditingController();
bool _isLoading = false;

  @override

  void initState(){
    super.initState();

    // we can only retrieve a note when isEditing is true as that will mean we have a noteID, otherwise if no noteID that means we are creating a new note
    if (isEditing){
      setState(() {
      _isLoading = true;
    });
  
    notesService.getNote(widget.noteID)
    .then((response){

       setState(() {
      _isLoading = false;
    });
      if (response.error){

        // if we got an error message we display the message from the response or display our own error message
        errorMessage= response.errorMessage ?? 'An error occured';
      }
      note = response.data;
      _titleController.text= note.noteTitle;
      _contentController.text= note.noteContent;
    });
     
  }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit note' : 'Create note')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _isLoading ? Center(child: CircularProgressIndicator()) : Column(
          children:<Widget>[
              TextField(
                controller:_titleController,
                decoration: InputDecoration(
                  hintText:'Note Title'
                )
              ),
              Container(height: 8),
              TextField(
                controller:_contentController,
                decoration: InputDecoration(
                  hintText:'Note Content'
                )
              ),

              Container(height:20),
              SizedBox(

                // to make submit button stretch to full width
                width:double.infinity,
                height:35,
                  child: RaisedButton(
                  onPressed: ()async{
                   
                  //  Tthe submit button has two context, if one is editing a note or one is posting a new note,and we need to check each instance to do the required either post or put to the api
                  if (isEditing){
                    // update note

                    // setLoading to true to show Loader
                    setState(() {
                      _isLoading = true;
                    });
                    // modify  note
                    final note = NoteUpdate(
                      noteContent: _titleController.text,
                      noteTitle:  _contentController.text );

                    // send the modified note to the api
                    final result= await notesService.updateNote(widget.noteID,note);

                    // once posting is done dismiss loader
                          
                    setState(() {
                      _isLoading = false;
                    });

                    // show dialog with either error message or "OK TEXT" depending if failed or successful

                    final title ="Done";
                    final text = result.error ? result.errorMessage ?? 'An error occurred': 'Your note was updated';

                    showDialog(
                      context: context,
                      builder: (_)=>AlertDialog(
                        title: Text(title),
                        content: Text(text),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: (){
                              // route to  somewhere else
                              Navigator.of(context).pop();
                            }, 
                            child: Text('OK'))
                        ],
                        )
                        )
                         // still on the showDialog method it, if post was created successfully, route to note_list page,
                        // if it was not stay on same page so user can maybe correct an error
                        .then((data){
                            if (result.data){
                              Navigator.of(context).pop();
                            }
                        }
                     
                        );

                  } else{

                    // setLoading to true to show Loader
                    setState(() {
                      _isLoading = true;
                    });
                    // create new note
                    final note = NewNote(
                      noteContent: _titleController.text,
                      noteTitle:  _contentController.text );

                    // send the created note to the api
                    final result= await notesService.createNote(note);

                    // once posting is done dismiss loader
                          
                    setState(() {
                      _isLoading = false;
                    });

                    // show dialog with either error message or "OK TEXT" depending if failed or successful

                    final title ="Done";
                    final text = result.error ? result.errorMessage ?? 'An error occurred': 'Your note was created';

                    showDialog(
                      context: context,
                      builder: (_)=>AlertDialog(
                        title: Text(title),
                        content: Text(text),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: (){
                              // route to  somewhere else
                              Navigator.of(context).pop();
                            }, 
                            child: Text('OK'))
                        ],
                        )
                        )
                         // still on the showDialog method it, if post was created successfully, route to note_list page,
                        // if it was not stay on same page so user can maybe correct an error
                        .then((data){
                            if (result.data){
                              Navigator.of(context).pop();
                            }
                        }
                     
                        );

                  }
                  },
                  color:Theme.of(context).primaryColor,
                  child:Text('Submit', style:(TextStyle(color:Colors.white)))),
              )
          ]
        ),
      )
      
    );
  }
}