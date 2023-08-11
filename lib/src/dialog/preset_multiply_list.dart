import 'dart:async';

import 'package:abacus_simple_anzan/client.dart';
import 'package:abacus_simple_anzan/src/const/localization.dart';
import 'package:abacus_simple_anzan/src/model/preset_multiply_model.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/calculation_mode_multiply.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/d_big_digit_pref.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/d_small_digit_pref.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/speed_multiply.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/settings_manager_multiply.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PresetMultiplyList extends StatefulWidget {
  const PresetMultiplyList({super.key});

  @override
  State<PresetMultiplyList> createState() => _PresetMultiplyListState();
}

class _PresetMultiplyListState extends State<PresetMultiplyList> {
  final _controller = ScrollController();
  var itemList = List<PresetMultiplyModel>.empty();
  final StreamController itemChangeStream =
      StreamController<PresetMultiplyModel>();
  @override
  void initState() {
    super.initState();
    initList();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: StreamBuilder(
      initialData: true,
      stream: itemChangeStream.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data is PresetMultiplyModel) {
          itemList.remove((snapshot.data as PresetMultiplyModel));
        }

        return ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: FractionallySizedBox(
                heightFactor: 0.7,
                child: Container(
                  color: Theme.of(context).colorScheme.background,
                  child: CustomScrollView(
                    controller: _controller,
                    physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics()),
                    slivers: [
                      SliverAppBar(
                        pinned: true,
                        backgroundColor:
                            Theme.of(context).colorScheme.tertiaryContainer,
                        leading: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            size: MediaQuery.of(context).size.height * 0.03,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          splashRadius: 10,
                        ),
                        title: FittedBox(
                            child: Text(LocalizationChecker.preset,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.026))),
                      ),
                      itemList.isNotEmpty
                          ? SliverGrid.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 2,
                              ),
                              itemCount: itemList.length,
                              itemBuilder: (context, index) {
                                return MultiplyItem(
                                  item: itemList[index],
                                  stream: itemChangeStream,
                                );
                              })
                          : getWhenItemEmpty(),
                    ],
                  ),
                )));
      },
    ));
  }

  TextStyle getTextStyle(index) {
    return TextStyle(
        color: Color(int.parse(itemList[index].textColorCode)),
        fontSize: MediaQuery.of(context).size.height * 0.025);
  }

  Widget getWhenItemEmpty() {
    return SliverToBoxAdapter(
        child: Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.55,
      color: Theme.of(context).colorScheme.background,
      child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.no_sim_sharp,
            size: MediaQuery.of(context).size.height * 0.15),
        const SizedBox(height: 10),
        Text('아이템이 없습니다.',
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.034,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onBackground))
      ])),
    ));
  }

  Future<void> initList() async {
    var result = await DbClient.getMultiplyPresets();
    if (context.mounted) {
      setState(() {
        itemList = result;
      });
    }
  }
}

class MultiplyItem extends StatefulWidget {
  const MultiplyItem(
      {super.key,
      required PresetMultiplyModel item,
      required StreamController<dynamic> stream})
      : _stream = stream,
        _item = item;
  final PresetMultiplyModel _item;
  final StreamController _stream;

  @override
  State<MultiplyItem> createState() => _MultiplyItemState();
}

class _MultiplyItemState extends State<MultiplyItem> {
  var _isHovering = false;
  final _manager = SettingsMultiplyManager();

  @override
  Widget build(BuildContext context) {
    var item = widget._item;

    return GestureDetector(
      onTapDown: (details) {
        Navigator.of(context).pop(item);
      },
      onSecondaryTapDown: (details) {
        var position = details.globalPosition;
        final RenderBox overlay =
            Overlay.of(context).context.findRenderObject() as RenderBox;

        showMenu(
            context: context,
            position: RelativeRect.fromLTRB(
                position.dx,
                position.dy,
                overlay.size.width - position.dx,
                overlay.size.height - position.dy),
            items: [
              PopupMenuItem(
                value: 1,
                child: const Text('삭제'),
                onTap: () async {
                  await DbClient.deleteMultiplyPreset(item);
                  widget._stream.add(item);
                },
              )
            ]);
      },
      child: MouseRegion(
        onExit: (event) => setState(() {
          _isHovering = false;
        }),
        onHover: (event) => setState(() {
          _isHovering = true;
        }),
        child: Opacity(
          opacity: _isHovering ? 0.7 : 1,
          child: Container(
            padding: const EdgeInsets.fromLTRB(1, 1, 1, 1),
            child: Container(
              padding: const EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height * 0.14,
              width: double.infinity,
              color: Color(int.parse(item.colorCode)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Icon(CupertinoIcons.tag,
                              size: MediaQuery.of(context).size.height * 0.026,
                              color: Color(int.parse(item.textColorCode))),
                          const SizedBox(width: 10),
                          Text(item.name,
                              style: getTextStyle().copyWith(
                                  fontWeight: FontWeight.w900,
                                  fontStyle: FontStyle.normal)),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 2,
                      color: Colors.white30,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              // 나눗셈 여부
                              Icon(Icons.calculate,
                                  size: MediaQuery.of(context).size.height *
                                      0.026,
                                  color: Color(int.parse(item.textColorCode))),
                              const SizedBox(width: 10),
                              Text(
                                  ((_manager.enumToValue(CalCulationMultiplyMode
                                          .values[item.calculationMode])))
                                      ? '나눗셈'
                                      : '곱셈',
                                  style: getTextStyle()
                                      .copyWith(fontStyle: FontStyle.normal)),
                              const SizedBox(width: 20),
                              Icon(Icons.speed,
                                  size: MediaQuery.of(context).size.height *
                                      0.026,
                                  color: Color(int.parse(item.textColorCode))),
                              const SizedBox(width: 10),
                              Text(
                                  ((_manager.enumToValue(SpeedMultiply
                                                      .values[item.speedIndex])
                                                  as Duration)
                                              .inMilliseconds /
                                          1000)
                                      .toString(),
                                  style: getTextStyle()
                                      .copyWith(fontStyle: FontStyle.italic)),
                              const SizedBox(width: 5),
                              Text('초', style: getTextStyle()),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(CupertinoIcons.number_square,
                          size: MediaQuery.of(context).size.height * 0.026,
                          color: Color(int.parse(item.textColorCode))),
                      const SizedBox(width: 10),
                      Text(
                          ((_manager.enumToValue(
                                  SmallDigit.values[item.smallDigitIndex])))
                              .toString(),
                          style: getTextStyle()
                              .copyWith(fontStyle: FontStyle.italic)),
                      const SizedBox(width: 10),
                      Text('자리', style: getTextStyle().copyWith()),
                      const SizedBox(width: 20),
                      Icon(CupertinoIcons.number_square_fill,
                          size: MediaQuery.of(context).size.height * 0.026,
                          color: Color(int.parse(item.textColorCode))),
                      const SizedBox(width: 10),
                      Text(
                          ((_manager.enumToValue(
                                  BigDigit.values[item.bigDigitIndex])))
                              .toString(),
                          style: getTextStyle()
                              .copyWith(fontStyle: FontStyle.italic)),
                      const SizedBox(width: 10),
                      Text('자리', style: getTextStyle().copyWith()),
                    ])
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle getTextStyle() {
    return TextStyle(
        color: Color(int.parse(widget._item.textColorCode)),
        fontSize: MediaQuery.of(context).size.height * 0.025);
  }
}
