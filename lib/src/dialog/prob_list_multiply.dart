import 'package:abacus_simple_anzan/src/const/localization.dart';
import 'package:flutter/material.dart';

import '../const/const.dart';
import '../functions/tuple.dart';

class ProbMultiplyList extends StatefulWidget {
  const ProbMultiplyList(
      {super.key, required this.numList, required this.mode});
  final List<Tuple<int, int>> numList;
  final List<bool> mode;

  @override
  State<ProbMultiplyList> createState() => _ProbMultiplyListState();
}

class _ProbMultiplyListState extends State<ProbMultiplyList> {
  final _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.animateTo(_controller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    });

    return Dialog(
        child: ConstrainedBox(
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
                          child: Text(LocalizationChecker.checkProb,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.026))),
                    ),
                    widget.numList.isNotEmpty
                        ? SliverList.builder(
                            itemCount: widget.numList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 1),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  height:
                                      MediaQuery.of(context).size.height * 0.14,
                                  width: double.infinity,
                                  color: index == widget.numList.length - 1
                                      ? Theme.of(context)
                                          .colorScheme
                                          .onTertiaryContainer
                                          .withGreen((Theme.of(context)
                                                      .colorScheme
                                                      .onTertiaryContainer
                                                      .green *
                                                  0.7)
                                              .toInt())
                                          .withRed((Theme.of(context)
                                                      .colorScheme
                                                      .onTertiaryContainer
                                                      .red *
                                                  0.7)
                                              .toInt())
                                          .withBlue((Theme.of(context)
                                                      .colorScheme
                                                      .onTertiaryContainer
                                                      .blue *
                                                  0.7)
                                              .toInt())
                                      : Theme.of(context)
                                          .colorScheme
                                          .onTertiaryContainer,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Row(
                                          children: [
                                            const SizedBox(width: 5),
                                            Text('$index.  ',
                                                style: getTextStyle()),
                                            Text(
                                              widget.mode[index]
                                                  ? '${formatter.format(widget.numList[index].item1)} × ${formatter.format(widget.numList[index].item2)}'
                                                  : '${formatter.format(widget.numList[index].item1)} ÷ ${formatter.format(widget.numList[index].item2)}',
                                              style: getTextStyle(),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.check,
                                                    size: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.026,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onBackground),
                                                const SizedBox(width: 5),
                                                Text(
                                                  widget.mode[index]
                                                      ? ' ${formatter.format(widget.numList[index].item1 * widget.numList[index].item2)}'
                                                      : ' ${formatter.format(widget.numList[index].item1 / widget.numList[index].item2)}',
                                                  style: getTextStyle()
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ]),
                                ),
                              );
                            })
                        : getWhenItemEmpty()
                  ],
                ))));
  }

  TextStyle getTextStyle() {
    return TextStyle(
        color: Theme.of(context).colorScheme.onBackground,
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
        Text(LocalizationChecker.noProbExecuted,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.034,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onBackground))
      ])),
    ));
  }
}
