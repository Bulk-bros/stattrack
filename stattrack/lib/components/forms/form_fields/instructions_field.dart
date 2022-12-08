import 'package:flutter/material.dart';
import 'package:stattrack/components/forms/form_fields/bordered_text_input.dart';

class InstructionsField extends StatefulWidget {
  const InstructionsField(
      {Key? key,
      required this.index,
      required this.onChange,
      required this.delete})
      : super(key: key);

  final num index;
  final void Function(num, String) onChange;
  final void Function(num) delete;

  @override
  State<InstructionsField> createState() => _InstructionsFieldState();
}

class _InstructionsFieldState extends State<InstructionsField> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: <Widget>[
            Flexible(
              child: BorderedTextInput(
                controller: _controller,
                hintText: 'Instruction',
                textInputAction: TextInputAction.done,
                onEditingComplete: () => FocusScope.of(context).unfocus(),
                onChanged: (value) => widget.onChange(widget.index, value),
              ),
            ),
            IconButton(
              onPressed: () => widget.delete(widget.index),
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        const SizedBox(
          height: 10.0,
        ),
      ],
    );
  }
}
