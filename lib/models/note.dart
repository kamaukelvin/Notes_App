class Note{
  String noteID;
  String noteTitle;
  String noteContent;
  DateTime createDateTime;
  DateTime latestEditedDateTime;


  Note({this.noteID, this.noteTitle, this.noteContent, this.createDateTime, this.latestEditedDateTime});

    // factory constructor

  factory Note.fromJson(Map<String, dynamic> item){

        return Note(
              noteID: item['noteID'],
              noteTitle: item['noteTitle'],
              noteContent: item['noteContent'],

              // FOR the created dateTime we have declared the type in our note_for_listing.dart as a DateTime but from the api it comes as string
              // we have to convert from string to a dateTime type
              createDateTime: DateTime.parse(item['createDateTime']),
            latestEditedDateTime: item['latestEditDateTime'] != null ? DateTime.parse(item['latestEditDateTime']): null,  
            );

  }
}
