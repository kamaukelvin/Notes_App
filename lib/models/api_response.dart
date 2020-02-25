// APIResponse class takes a generic type parameter<T> which just shows the type of body we get from the Api

class APIResponse<T>{

  // from the api we expeect: the data itself, a boolean which checks if an error was returned or not, and an error message in case an error was  returned
  T data;
  bool error;
  String errorMessage;

  // constructor
  APIResponse({this.data, this.errorMessage,this.error=false});
}

