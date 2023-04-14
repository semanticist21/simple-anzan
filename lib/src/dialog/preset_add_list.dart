import 'dart:async';

import 'package:abacus_simple_anzan/client.dart';
import 'package:abacus_simple_anzan/src/const/localization.dart';
import 'package:abacus_simple_anzan/src/model/preset_add_model.dart';
import 'package:abacus_simple_anzan/src/settings/plus_pref/prefs/digit_pref.dart';
import 'package:abacus_simple_anzan/src/settings/plus_pref/prefs/num_of_problems_pref.dart';
import 'package:abacus_simple_anzan/src/settings/plus_pref/prefs/speed.dart';
import 'package:abacus_simple_anzan/src/settings/plus_pref/settings_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PresetAddList extends StatefulWidget {
  const PresetAddList({super.key});

  @override
  State<PresetAddList> createState() => _PresetAddListState();
}

class _PresetAddListState extends State<PresetAddList> {
  final _controller = ScrollController();
  var itemList = List<PresetAddModel>.empty();
  final StreamController itemChangeStream = StreamController<PresetAddModel>();
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
        if (snapshot.hasData && snapshot.data is PresetAddModel) {
          itemList.remove((snapshot.data as PresetAddModel));
        }

        return ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: FractionallySizedBox(
                heightFactor: 0.7,
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
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
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
                                  fontSize: MediaQuery.of(context).size.height *
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
                              return AddItem(
                                item: itemList[index],
                                stream: itemChangeStream,
                              );
                            })
                        : getWhenItemEmpty(),
                  ],
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
      height: MediaQuery.of(context).size.height * 0.4,
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
    var result = await DbClient.getAddPresets();
    if (context.mounted) {
      setState(() {
        itemList = result;
      });
    }
  }
}

class AddItem extends StatefulWidget {
  const AddItem(
      {super.key,
      required PresetAddModel item,
      required StreamController<dynamic> stream})
      : _stream = stream,
        _item = item;
  final PresetAddModel _item;
  final StreamController _stream;

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  var _isHovering = false;
  final _manager = SettingsManager();

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
                  await DbClient.deleteAddPreset(item);
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // // 더하기모드
                              // Icon(Icons.calculate,
                              //     size: MediaQuery.of(context).size.height *
                              //         0.026,
                              //     color: Color(int.parse(item.textColorCode))),
                              // const SizedBox(width: 10),
                              // Text(
                              //     (_manager.enumToValue(CalculationMode
                              //             .values[item.onlyPlusesIndex]))
                              //         ? '더하기만'
                              //         : '빼기포함',
                              //     style: getTextStyle().copyWith()),
                              // const SizedBox(width: 20),
                              // // 셔플
                              // Icon(Icons.shuffle,
                              //     size: MediaQuery.of(context).size.height *
                              //         0.026,
                              //     color: Color(int.parse(item.textColorCode))),
                              // const SizedBox(width: 10),
                              // Text(
                              //     (_manager.enumToValue(ShuffleMode
                              //             .values[item.shuffleIndex]))
                              //         .toString(),
                              //     style: getTextStyle()
                              //         .copyWith(fontStyle: FontStyle.italic)),
                              // const SizedBox(width: 20),
                              // 스피드
                              Icon(Icons.speed,
                                  size: MediaQuery.of(context).size.height *
                                      0.026,
                                  color: Color(int.parse(item.textColorCode))),
                              const SizedBox(width: 10),
                              Text(
                                  ((_manager.enumToValue(Speed
                                                      .values[item.speedIndex])
                                                  as Duration)
                                              .inMilliseconds /
                                          1000)
                                      .toString(),
                                  style: getTextStyle()
                                      .copyWith(fontStyle: FontStyle.italic)),
                              const SizedBox(width: 5),
                              Text('초', style: getTextStyle()),
                              const SizedBox(width: 20),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: [
                        // 카운트 다운
                        // Icon(Icons.notifications,
                        //     size: MediaQuery.of(context).size.height * 0.026,
                        //     color: Color(int.parse(item.textColorCode))),
                        // const SizedBox(width: 10),
                        // Text(
                        //     ((_manager.enumToValue(
                        //             CountDownMode.values[item.notifyIndex])))
                        //         .toString(),
                        //     style: getTextStyle()
                        //         .copyWith(fontStyle: FontStyle.italic)),
                        // const SizedBox(width: 20),
                        // 자리 수
                        Icon(Icons.onetwothree,
                            size: MediaQuery.of(context).size.height * 0.026,
                            color: Color(int.parse(item.textColorCode))),
                        const SizedBox(width: 10),
                        Text(
                            ((_manager.enumToValue(
                                    Digit.values[item.digitIndex])))
                                .toString(),
                            style: getTextStyle()
                                .copyWith(fontStyle: FontStyle.italic)),
                        const SizedBox(width: 10),
                        Text('자리', style: getTextStyle().copyWith()),
                        const SizedBox(width: 20),
                        // 문제 수
                        Icon(Icons.check,
                            size: MediaQuery.of(context).size.height * 0.026,
                            color: Color(int.parse(item.textColorCode))),
                        const SizedBox(width: 10),
                        Text(
                            ((_manager.enumToValue(NumOfProblems
                                    .values[item.numOfProblemIndex])))
                                .toString(),
                            style: getTextStyle()
                                .copyWith(fontStyle: FontStyle.italic)),
                        const SizedBox(width: 10),
                        Text('문제', style: getTextStyle().copyWith()),
                        const SizedBox(width: 10),
                      ]),
                    )
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
