import 'package:flutter/material.dart';

abstract class LoadableState<T extends StatefulWidget> extends State<T> {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool loading) {
    setState(() {
      this._isLoading = loading;
    });
  }
}