import 'package:flutter/material.dart';
import 'package:stattrack/components/buttons/main_button.dart';
import 'package:stattrack/components/forms/form_fields/bordered_text_input.dart';
import 'package:stattrack/styles/font_styles.dart';
import 'package:stattrack/styles/palette.dart';

class CreateMealInstructions extends StatefulWidget {
  const CreateMealInstructions({
    Key? key,
    required this.navPrev,
    required this.onComplete,
  }) : super(key: key);

  final void Function() navPrev;
  final void Function(List<String>) onComplete;

  @override
  _CreateMealInstructionsState createState() => _CreateMealInstructionsState();
}

class _CreateMealInstructionsState extends State<CreateMealInstructions> {
  final TextEditingController _controller = TextEditingController();

  String get _instruction => _controller.text;

  bool get _isValidInstuction => _instruction.isNotEmpty;

  String _errorMsg = '';
  bool _showError = false;

  List<String> _instructions = [];

  void _handleComplete() {
    setState(() {
      _showError = false;
    });

    if (_instructions.isEmpty) {
      setState(() {
        _errorMsg = 'Need atleast one instruction!';
        _showError = true;
      });
    } else {
      widget.onComplete(_instructions);
    }
  }

  void _addInstruction() {
    setState(() {
      _showError = false;
    });
    if (!_isValidInstuction) {
      setState(() {
        _errorMsg = 'Cannot add empty instruction';
        _showError = true;
      });
    } else {
      _instructions = [..._instructions, _instruction];
      _controller.text = '';
    }
  }

  void _updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(
          height: 20.0,
        ),
        _buildHeader(),
        _buildForm(),
        const SizedBox(
          height: 20.0,
        ),
        _buildList(),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: widget.navPrev,
          icon: const Icon(Icons.navigate_before),
        ),
        const Text(
          'Instructions',
          style: TextStyle(
            fontSize: FontStyles.fsTitle1,
            fontWeight: FontStyles.fwTitle,
          ),
        ),
        TextButton(
          onPressed: _handleComplete,
          child: Text(
            'Next',
            style: TextStyle(
              color: Palette.accent[400],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BorderedTextInput(
          hintText: 'Instruction',
          controller: _controller,
          keyboardType: TextInputType.name,
          onChanged: (value) => _updateState,
        ),
        MainButton(
          callback: _addInstruction,
          label: 'Add instruction',
        ),
        _showError
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    _errorMsg,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red[700],
                    ),
                  ),
                ],
              )
            : const SizedBox(
                height: 0,
              ),
      ],
    );
  }

  Widget _buildList() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Instructions',
            style: TextStyle(fontWeight: FontStyles.fwTitle),
          ),
          Expanded(
            child: ReorderableListView(
              children: [
                for (int index = 0; index < _instructions.length; index++)
                  ListBody(
                    key: Key('$index. $index'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(child: Text(_instructions[index])),
                            const Icon(Icons.menu),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final String instructions = _instructions.removeAt(oldIndex);
                  _instructions.insert(newIndex, instructions);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
