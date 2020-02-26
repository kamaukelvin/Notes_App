import 'dart:convert';

import 'package:crud_app/models/new_note.dart';
import 'package:crud_app/models/note_update.dart';
import 'package:crud_app/models/note_for_listing.dart';
import 'package:crud_app/models/note.dart';
import 'package:crud_app/models/api_response.dart';
import 'package:http/http.dart' as http;

class NotesService{
  // consuming api

// baseURL
  static const API = 'http://api.notes.programmingaddict.com';

  // passing headers
  static const headers ={
    'apiKey': '08d7ba28-5331-286b-0923-c2f0b5e60f69',
      // passing content type> useful majorly due to posting data in api
      'content-Type': 'application/json'
  };






  // 1. FETCH AN ARRAY/LIST OF NOTES
  
  Future<APIResponse<List<NoteForListing>>> getNoteList(){
      return http.get(API + '/notes', headers: headers)
      .then((data){

          // first check if request was successfull
          if (data.statusCode==200){
          // converting the jsonData received into a list of maps that can be understood by dart
          // data.body is the body of our response
          final jsonData= json.decode(data.body);

          // convert our list of maps now into a lsit of objects

          final notes = <NoteForListing>[];
          // map over the notes

          for (var item in jsonData){
              NoteForListing.fromJson(item);
            notes.add( NoteForListing.fromJson(item));
          }
          return APIResponse<List<NoteForListing>>(data:notes);
          }
        // if status code is not 200
          return APIResponse<List<NoteForListing>>(error:true, errorMessage: 'An error occured');
      })

      // catching errors returned
      .catchError((_)=>APIResponse<List<NoteForListing>>(error:true, errorMessage: 'An error occured'));
  
  }

  //  2. FETCH A SINGLE NOTE
  // a note id has to be passed in this function to get the note in question


  Future<APIResponse<Note>> getNote(String noteID){
      return http.get(API + '/notes/' + noteID, headers: headers)
      .then((data){

          // first check if request was successfull
          if (data.statusCode==200){
          // converting the json Data received into a map that can be understood by dart
          // data.body is the body of our response
          final jsonData= json.decode(data.body);
           
          return APIResponse<Note>(data: Note.fromJson(jsonData));
          }
        // if status code is not 200
          return APIResponse<Note>(error:true, errorMessage: 'An error occured');
      })

      // catching errors returned
      .catchError((_)=>APIResponse<Note>(error:true, errorMessage: 'An error occured'));
  
  }

  // 3. CREATE A NEW NOTE
  // we pass a boolean (bool) just basically to let us know if our posting was successful or not
  // we need to pass in data from our user i.e Name of widget+a name of item from user=>a note: call it any name, mine is note
  Future<APIResponse<bool>> createNote(NewNote note){

    // remember to pass in the body in our API i.e. the note
    // json.encode will convert our data to what dart can  comprehend
    // remember to pass in a content type as application/json in the headers
      return http.post(API + '/notes', headers: headers, body: json.encode(note.toJson()))
      .then((data){

          // first check if request was successfull
          if (data.statusCode==201){
           
          return APIResponse<bool>(data: true);
          }
        // if status code is not 201
          return APIResponse<bool>(error:true, errorMessage: 'An error occured');
      })

      // catching errors returned
      .catchError((_)=>APIResponse<bool>(error:true, errorMessage: 'An error occured'));
  
  }

  // 4. UPDATE AN EXISTING NOTE
  // we pass a boolean (bool) just basically to let us know if our posting was successful or not
  // we need to pass in data from our user i.e Name of widget+a name of item from user=>a note: call it any name, mine is note
  Future<APIResponse<bool>> updateNote(String noteID, NoteUpdate note){

    // remember to pass in the body and noteID in our API  i.e. the note
    // json.encode will convert our data to what dart can  comprehend
    // remember to pass in a content type as application/json in the headers
      return http.put(API + '/notes/' + noteID, headers: headers, body: json.encode(note.toJson()))
      .then((data){

          // first check if request was successfull
          if (data.statusCode==204){
           
          return APIResponse<bool>(data: true);
          }
        // if status code is not 204
          return APIResponse<bool>(error:true, errorMessage: 'An error occured');
      })

      // catching errors returned
      .catchError((_)=>APIResponse<bool>(error:true, errorMessage: 'An error occured'));
  
  }

  // 5. DELETE A NOTE
  // we pass a boolean (bool) just basically to let us know if our deleting was successful or not
  // we need to pass in noteID
  Future<APIResponse<bool>> deleteNote(String noteID){

    // remember to pass in the body and noteID in our API  i.e. the note
    // json.encode will convert our data to what dart can  comprehend
    // remember to pass in a content type as application/json in the headers
      return http.delete(API + '/notes/' + noteID, headers: headers)
      .then((data){

          // first check if request was successfull
          if (data.statusCode==204){
           
          return APIResponse<bool>(data: true);
          }
        // if status code is not 204
          return APIResponse<bool>(error:true, errorMessage: 'An error occured');
      })

      // catching errors returned
      .catchError((_)=>APIResponse<bool>(error:true, errorMessage: 'An error occured'));
  
  }
}