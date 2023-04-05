import 'package:abacus_simple_anzan/src/words/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddDialog extends StatefulWidget {
  const AddDialog({super.key, required this.defaultValue});
  final String defaultValue;

  @override
  State<AddDialog> createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
  final _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _textController.text = widget.defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(children: [
        const Icon(Icons.dashboard_customize, size: 15),
        SizedBox(width: MediaQuery.of(context).size.width * 0.02),
        Text(LocalizationChecker.setSpeedTitle,
            style:
                TextStyle(fontSize: MediaQuery.of(context).size.height * 0.02))
      ]),
      content: Form(
          key: _formKey,
          child: TextFormField(
            decoration:
                InputDecoration(hintText: LocalizationChecker.rangeWord),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return LocalizationChecker.pleaseInsertValue;
              }

              var valueInt = int.tryParse(value);
              if (valueInt == null) {
                return null;
              }

              if (valueInt > 3000) {
                return LocalizationChecker.pleaseTooBigValue;
              }

              if (valueInt < 100) {
                return LocalizationChecker.pleaseTooSmallValue;
              }

              return null;
            },
            controller: _textController,
          )),
      actions: [
        ElevatedButton(
          onPressed: () {
            var result = _formKey.currentState?.validate();

            if (result != null && result) {
              Navigator.of(context).pop(_textController.text);
            }
          },
          child: const Text('확인'),
        )
      ],
    );
  }
}
