class NoteForListing{
  String noteID;
  String noteTitle;
  DateTime createDateTime;
  DateTime latestEditedDateTime;


  NoteForListing({this.noteID, this.noteTitle, this.createDateTime, this.latestEditedDateTime});


  // factory constructor

  factory NoteForListing.fromJson(Map<String, dynamic> item){

        return NoteForListing(
              noteID: item['noteID'],
              noteTitle: item['noteTitle'],

              // FOR the created dateTime we have declared the type in our note_for_listing.dart as a DateTime but from the api it comes as string
              // we have to convert from string to a dateTime type
              createDateTime: DateTime.parse(item['createDateTime']),
            latestEditedDateTime: item['latestEditDateTime'] != null ? DateTime.parse(item['latestEditDateTime']): null,  
            );

  }
}


