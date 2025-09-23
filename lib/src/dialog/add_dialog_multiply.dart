import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddDialogMultiply extends StatefulWidget {
  const AddDialogMultiply({super.key, required this.defaultValue});
  final String defaultValue;

  @override
  State<AddDialogMultiply> createState() => _AddDialogMultiplyState();
}

class _AddDialogMultiplyState extends State<AddDialogMultiply> {
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
                  child: Text('customOptions.setSpeedTitle'.tr(),
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
              helperText: 'customOptions.rangeMultiplyWord'.tr(),
              helperStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
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
                return 'customOptions.pleaseInsertValue'.tr();
              }

              var valueInt = int.tryParse(value);
              if (valueInt == null) {
                return null;
              }

              if (valueInt > 30000) {
                return 'customOptions.pleaseTooBigValue'.tr();
              }

              if (valueInt < 100) {
                return 'customOptions.pleaseTooSmallValue'.tr();
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
                'buttons.ok'.tr(),
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.02,
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
            ))
      ],
    );
  }
}
