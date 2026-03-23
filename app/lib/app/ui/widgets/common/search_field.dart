// Flutter imports:
import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  final void Function(String) onSearch;
  final String? hintText;
  final bool autofocus;

  const SearchField({
    super.key,
    required this.onSearch,
    this.hintText,
    this.autofocus = false,
  });

  @override
  SearchFieldState createState() => SearchFieldState();
}

class SearchFieldState extends State<SearchField> {
  bool _textNotEmpty = false;
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      onChanged: (value) => setState(() => _textNotEmpty = value.isNotEmpty),
      onEditingComplete: () => widget.onSearch(_textController.text),
      autofocus: widget.autofocus,
      decoration: InputDecoration(
        hintText: widget.hintText,
        suffixIcon: _showClearButtonIfTextIsNotEmpty(),
      ),
    );
  }

  void _resetSearchText() {
    FocusScope.of(context).unfocus();
    _textController.clear();
    setState(() => _textNotEmpty = false);
    widget.onSearch('');
  }

  Widget? _showClearButtonIfTextIsNotEmpty() {
    if (_textNotEmpty) {
      return IconButton(
        onPressed: _resetSearchText,
        icon: const Icon(Icons.clear),
      );
    } else {
      return null;
    }
  }
}

class SearchFieldButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;

  const SearchFieldButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: SizedBox(width: double.infinity, child: Text(text)),
    );
  }
}
