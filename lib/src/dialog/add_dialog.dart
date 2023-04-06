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
        Icon(Icons.dashboard_customize,
            size: 15, color: Theme.of(context).colorScheme.primaryContainer),
        SizedBox(width: MediaQuery.of(context).size.width * 0.02),
        Container(
            constraints: const BoxConstraints(maxWidth: 300),
            width: MediaQuery.of(context).size.width * 0.6,
            child: FittedBox(
                fit: BoxFit.contain,
                child: Text(LocalizationChecker.setSpeedTitle,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.02,
                        color:
                            Theme.of(context).colorScheme.primaryContainer))))
      ]),
      content: Form(
          key: _formKey,
          child: TextFormField(
            style: TextStyle(
                color: Theme.of(context).colorScheme.primaryContainer),
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

              if (valueInt < 80) {
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
          child: Text(
            LocalizationChecker.ok,
            style: const TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }
}
