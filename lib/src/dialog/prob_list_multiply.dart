import 'package:abacus_simple_anzan/src/const/localization.dart';
import 'package:abacus_simple_anzan/src/settings/multiply_prefs/prefs/calculation_mode_multiply.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../functions/tuple.dart';

class ProbMultiplyList extends StatefulWidget {
  const ProbMultiplyList(
      {super.key, required this.numList, required this.mode});
  final List<Tuple<int, int>> numList;
  final CalCulationMultiplyMode mode;

  @override
  State<ProbMultiplyList> createState() => _ProbMultiplyListState();
}

class _ProbMultiplyListState extends State<ProbMultiplyList> {
  var formattter = NumberFormat('#,##0');

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: FractionallySizedBox(
                heightFactor: 0.7,
                child: CustomScrollView(
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
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.question_answer,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground,
                                              size: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.026,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              widget.mode ==
                                                      CalCulationMultiplyMode
                                                          .multiply
                                                  ? '${LocalizationChecker.problem} : ${formattter.format(widget.numList[index].item1)} × ${formattter.format(widget.numList[index].item2)}'
                                                  : '${LocalizationChecker.problem} : ${formattter.format(widget.numList[index].item1)} ÷ ${formattter.format(widget.numList[index].item2)}',
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
                                                  widget.mode ==
                                                          CalCulationMultiplyMode
                                                              .multiply
                                                      ? '${LocalizationChecker.answer} : ${formattter.format(widget.numList[index].item1 * widget.numList[index].item2)}'
                                                      : '${LocalizationChecker.answer} : ${formattter.format(widget.numList[index].item1 / widget.numList[index].item2)}',
                                                  style: getTextStyle(),
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
