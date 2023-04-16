import 'dart:math';

import 'package:abacus_simple_anzan/src/model/save_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../const/color.dart';

class CustomPresetFormDialog extends StatefulWidget {
  const CustomPresetFormDialog(
      {super.key, required this.title, required this.hintWord});
  final String title;
  final String hintWord;

  @override
  State<CustomPresetFormDialog> createState() => _CustomPresetFormDialogState();
}

class _CustomPresetFormDialogState extends State<CustomPresetFormDialog> {
  final _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Color savedColor = Color(int.parse(
      backgroundColors[Random().nextInt(backgroundColors.length)]
          .replaceAll('#', '0xff')));
  Color currentColor = Colors.white;

  @override
  void initState() {
    super.initState();
    currentColor = savedColor;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(children: [
        Icon(CupertinoIcons.bag,
            size: MediaQuery.of(context).size.height * 0.0190,
            color: Theme.of(context).colorScheme.primaryContainer),
        SizedBox(width: MediaQuery.of(context).size.width * 0.015),
        Container(
            constraints: const BoxConstraints(maxWidth: 300),
            width: MediaQuery.of(context).size.width * 0.6,
            child: Text(widget.title,
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: MediaQuery.of(context).size.height * 0.0190,
                    color: Theme.of(context).colorScheme.primaryContainer)))
      ]),
      content: Form(
          key: _formKey,
          child: TextFormField(
            controller: _textController,
            style: TextStyle(
                color: Theme.of(context).colorScheme.primaryContainer),
            decoration: InputDecoration(
              hintText: widget.hintWord,
              hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  fontSize: MediaQuery.of(context).size.height * 0.0180),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primaryContainer)),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primaryContainer)),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r"^[^'\\]*$")),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '값을 입력하세요.';
              }

              return null;
            },
          )),
      actions: [
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiaryContainer,
                          title: Text(
                            '배경 색을 고르세요.',
                            style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer)
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          content: SingleChildScrollView(
                            child: BlockPicker(
                              availableColors: backgroundColors
                                  .map((color) => Color(int.parse(
                                          color.replaceAll('#', '0xFF')))
                                      .withOpacity(0.95))
                                  .toList(),
                              pickerColor: currentColor,
                              onColorChanged: (Color color) {
                                currentColor = color;
                              },
                            ),
                          ),
                          actions: [
                            Padding(
                                padding: const EdgeInsets.all(5),
                                child: TextButton(
                                  onPressed: () {
                                    currentColor = savedColor;
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    '취소',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer),
                                  ),
                                )),
                            Padding(
                                padding: const EdgeInsets.all(5),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    savedColor = currentColor;
                                  },
                                  child: Text(
                                    '확인',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer),
                                  ),
                                ))
                          ]);
                    });
              },
              child: Text(
                '배경 설정',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.02,
                    color: Theme.of(context).colorScheme.primaryContainer),
              ),
            )),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                '취소',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.02,
                    color: Theme.of(context).colorScheme.primaryContainer),
              ),
            )),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: TextButton(
              onPressed: () {
                var result = _formKey.currentState?.validate();

                if (result != null && result) {
                  Navigator.of(context).pop(SaveInfo(
                      colorCode:
                          '0xff${savedColor.value.toRadixString(16).substring(2)}',
                      textColorCode:
                          '0xff${Colors.white.value.toRadixString(16).substring(2)}',
                      name: _textController.text));
                }
              },
              child: Text(
                '저장',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.02,
                    color: Theme.of(context).colorScheme.primaryContainer),
              ),
            ))
      ],
    );
  }
}
