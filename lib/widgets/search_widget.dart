import 'dart:async';

import 'package:flutter/cupertino.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key, required this.onChanged});

  final Function(String) onChanged;

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    return CupertinoSearchTextField(
      onChanged: (value) {
        if (_debounce?.isActive ?? false) _debounce?.cancel();
        _debounce = Timer(const Duration(milliseconds: 800), () {
          widget.onChanged(value);
        });
      },
      placeholder: 'Search',
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
