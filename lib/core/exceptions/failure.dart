class Failure {

  String message;// error or success

  Failure( this.message);
factory Failure.handle(dynamic error){
  return Failure(error.response?.data['message'] ?? 'Please check your internet');
}

}

