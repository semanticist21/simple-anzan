import 'package:abacus_simple_anzan/src/const/localization.dart';
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      title: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          Icon(Icons.forward_sharp,
              size: MediaQuery.of(context).size.height * 0.0190,
              color: Theme.of(context).colorScheme.onPrimaryContainer),
          SizedBox(width: MediaQuery.of(context).size.width * 0.015),
          Container(
              constraints: const BoxConstraints(maxWidth: 300),
              width: MediaQuery.of(context).size.width * 0.6,
              child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(LocalizationChecker.setSpeedTitle,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: MediaQuery.of(context).size.height * 0.0190,
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer))))
        ]),
      ),
      content: Form(
          key: _formKey,
          child: TextFormField(
            controller: _textController,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer),
            decoration: InputDecoration(
              hintText: LocalizationChecker.rangeWord,
              hintStyle:
                  TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primaryContainer)),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primaryContainer)),
            ),
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

              if (valueInt > 5000) {
                return LocalizationChecker.pleaseTooBigValue;
              }

              if (valueInt < 100) {
                return LocalizationChecker.pleaseTooSmallValue;
              }

              return null;
            },
          )),
      actions: [
        Padding(
            padding: const EdgeInsets.all(5),
            child: TextButton(
              onPressed: () {
                var result = _formKey.currentState?.validate();

                if (result != null && result) {
                  Navigator.of(context).pop(_textController.text);
                }
              },
              child: Text(
                LocalizationChecker.ok,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.02,
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
            ))
      ],
    );
  }
}
