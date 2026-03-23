class API {
  Future<int> requestInt() async {
    await Future.delayed(Duration(milliseconds: 1));

    return 0;
  }
}
