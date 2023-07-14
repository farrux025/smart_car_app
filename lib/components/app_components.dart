import 'package:flutter/cupertino.dart';

closeKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}
