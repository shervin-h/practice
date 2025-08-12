

void main() async {
  Stream<int> stream = numberCreator();

  // stream.listen((event) {
  //   print(event);
  // });

  await for (var event in stream) {
    print(event);
  }
}


Stream<int> numberCreator() async* {
  int value = 1;
  while (true) {
    yield value++;
    await Future.delayed(const Duration(seconds: 1));
  }
}