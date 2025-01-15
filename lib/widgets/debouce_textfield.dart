import 'dart:async';
import 'package:flutter/material.dart';

class TreeuseDebounceTextField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final Duration debounceDuration;
  final InputDecoration? decoration;
  final TextStyle? style;

  const TreeuseDebounceTextField({
    super.key,
    required this.onChanged,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.decoration,
    this.style,
  });

  @override
  _TreeuseDebounceTextFieldState createState() =>
      _TreeuseDebounceTextFieldState();
}

class _TreeuseDebounceTextFieldState extends State<TreeuseDebounceTextField> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged(String text) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(widget.debounceDuration, () {
      widget.onChanged(text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: widget.decoration,
      style: widget.style,
      onChanged: _onTextChanged,
    );
  }
}
