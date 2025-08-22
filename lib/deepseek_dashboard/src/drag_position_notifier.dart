import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DragPositionNotifier with ChangeNotifier implements ValueListenable<Offset> {
  Offset _position = Offset.zero;

  @override
  Offset get value => _position;

  Offset get position => _position;

  void updatePosition(Offset newPosition) {
    _position = newPosition;
    notifyListeners();
  }

  void reset() {
    _position = Offset.zero;
    notifyListeners();
  }

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    super.removeListener(listener);
  }
}