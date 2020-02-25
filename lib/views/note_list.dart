import 'package:crud_app/models/api_response.dart';
import 'package:crud_app/services/notes_service.dart';
import 'package:flutter/material.dart';
import 'package:crud_app/models/note_for_listing.dart';
import 'package:crud_app/views/note_modify.dart';
import 'package:crud_app/views/note_delete.dart';
import 'package:get_it/get_it.dart';

class NoteList extends StatefulWidget {


  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {

 NotesService get service=>  GetIt.instance<NotesService>();
 APIResponse<List<NoteForListing>>_apiResponse;
 bool _isLoading = false;


  String formatDateTime(DateTime dateTime){
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

// overwriting the method that get calls when we first load this page
  @override 
  void initState(){

    // on loading of the widget, it runs fetch notes method

    _fetchNotes();

    super.initState();
  }

  // methods

  // this method sets isLoading to true

  _fetchNotes()async{
    setState(() {
      _isLoading = true;
    });

// then fetches our data
    _apiResponse= await service.getNoteList();

// sets the state of isLoading back to false
    setState((){
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("List of notes")),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context)
          .push(MaterialPageRoute(builder: (_)=>NoteModify()))
          // fetch notes again to get all new changes incase a user has posted, updated or deleted a note
         .then((_){
            _fetchNotes();
         });
        },
        child:Icon (Icons.add),
        ),
        body: Builder(
          // builder helps us return more complex logic like the below 3 if statements rather than writing them inline in our code
          builder:(_){

            // if loading
            if (_isLoading){
              return Center(child: CircularProgressIndicator());
            }

            // if errors are received on fetching display error message
            if (_apiResponse.error){
             return Center(child: Text(_apiResponse.errorMessage));
            }
          return
            // if successful

            ListView.separated(
          separatorBuilder: (_,__)=>Divider(height:1, color:Colors.green),
          itemBuilder: (_,index){

            // dismissible widget will allow us to delete on swipe 
            return Dismissible(

              // dismissible must have a unique key and dismiss direction and an onDismissedmethod
              key:ValueKey(_apiResponse.data[index].noteID),
              direction:DismissDirection.startToEnd,
              onDismissed: (direction){

              },
              // confirm dismiss throws a warning dialog to user to confirm before deleting
              confirmDismiss: (direction)async{
                  final result = await showDialog(
                    context: context,
                  builder:(_)=>NoteDelete()
                  ); 

                  if (result){
                   final deleteResult = await service.deleteNote(_apiResponse.data[index].noteID);
                    var message;
                    // checking if it was deleted successfully
                  if (deleteResult != null && deleteResult.data==true){
                    message = "The note was deleted successfully";
                  } else{
                     message= deleteResult ?.errorMessage ?? 'An error occured';
                  }

                  showDialog(
                    context: context, builder:(_)=>AlertDialog(
                      title: Text('Done'),
                      content: Text(message),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: (){
                            Navigator.of(context).pop();
                          }, 
                          child: Text('OK'))
                      ],
                      )
                  );

                  return deleteResult?.data?? false;
                  }

                 
                  print (result);
                  return result;         
              },
              // background that displays as user swipes to delete a note
              background:Container(
                color:Colors.red,
                padding:EdgeInsets.only(left:16),
                child:Align(child:Icon(Icons.delete, color:Colors.white),alignment:Alignment.centerLeft),
              ),
                child: ListTile(
                title: Text(_apiResponse.data[index].noteTitle,
                style: TextStyle(color:Theme.of(context).primaryColor)),
                  subtitle:Text('Last edited on ${formatDateTime(_apiResponse.data[index].latestEditedDateTime ?? _apiResponse.data[index].createDateTime)}'),

                  // on tap of a single note takes us to modify page
                  onTap: (){
                      Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_)=>NoteModify(noteID:_apiResponse.data[index].noteID)))
                      // fetch notes to get any updated notes
                      .then((data){
                        _fetchNotes();
                      });
                  },
              ),
            );
          
            
          },
          itemCount: _apiResponse.data.length,
        );
          })
      
    );
  }
}