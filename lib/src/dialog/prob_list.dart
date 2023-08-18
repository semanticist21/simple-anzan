import 'package:abacus_simple_anzan/src/const/localization.dart';
import 'package:flutter/material.dart';

import '../const/const.dart';

class ProbList extends StatefulWidget {
  const ProbList({super.key, required this.numList});
  final List<int> numList;

  @override
  State<ProbList> createState() => _ProbListState();
}

class _ProbListState extends State<ProbList> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Theme.of(context).colorScheme.background,
        child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: FractionallySizedBox(
                heightFactor: 0.7,
                child: Container(
                  color: Theme.of(context).colorScheme.background,
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
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            size: MediaQuery.of(context).size.height * 0.025,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          splashRadius: 10,
                        ),
                        title: FittedBox(
                            child: Text(
                          LocalizationChecker.checkProb,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.018,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer),
                        )),
                      ),
                      widget.numList.isNotEmpty
                          ? SliverList.builder(
                              itemCount: widget.numList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 1),
                                    child: Container(
                                        height: MediaQuery.of(context).size.height *
                                            0.06,
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
                                                .withRed(
                                                    (Theme.of(context).colorScheme.onTertiaryContainer.red * 0.7)
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
                                        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                          Visibility(
                                              visible: index ==
                                                  widget.numList.length - 1,
                                              child: Row(children: [
                                                Icon(
                                                  Icons.check,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimaryContainer,
                                                  size: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.025,
                                                ),
                                                const SizedBox(width: 10),
                                              ])),
                                          index != widget.numList.length - 1
                                              ? Text(
                                                  formatter
                                                      .format(
                                                          widget.numList[index])
                                                      .toString(),
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.03,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onBackground),
                                                )
                                              : Text(
                                                  formatter.format(
                                                      widget.numList[index]),
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.03,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onBackground,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                          const SizedBox(width: 20),
                                        ])));
                              })
                          : getWhenItemEmpty()
                    ],
                  ),
                ))));
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
            size: MediaQuery.of(context).size.height * 0.13,
            color: Theme.of(context).colorScheme.onBackground),
        const SizedBox(height: 10),
        Text(LocalizationChecker.noProbExecuted,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.03,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onBackground))
      ])),
    ));
  }
}
