class Response<T> {
  bool success;
  T object;
  int errorCode;
  String errorMessage;

  Response({
    this.success = false,
    this.object,
    this.errorCode = -1,
    this.errorMessage: "",
  });

  String toString() {
    return "{success: $success, object: ${object.toString()}, errorMessage: $errorMessage}";
  }
}
