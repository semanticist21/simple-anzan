import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:universal_io/io.dart';

class ProbList extends StatefulWidget {
  const ProbList({super.key, required this.numList});
  final List<int> numList;

  @override
  State<ProbList> createState() => _ProbListState();
}

class _ProbListState extends State<ProbList> {
  final formattter = NumberFormat('#,##0');

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: FractionallySizedBox(
                heightFactor: 0.7,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics()),
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      backgroundColor:
                          Theme.of(context).colorScheme.onBackground,
                      leading: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          size: MediaQuery.of(context).size.height * 0.025,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        splashRadius: 10,
                      ),
                      title: Text('문제 & 정답 확인',
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.018,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer)),
                    ),
                    widget.numList.isNotEmpty
                        ? SliverList.builder(
                            itemCount: widget.numList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 1),
                                  child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.06,
                                      width: double.infinity,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onTertiaryContainer,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
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
                                            Text(
                                              index != widget.numList.length - 1
                                                  ? formattter
                                                      .format(
                                                          widget.numList[index])
                                                      .toString()
                                                  : formattter.format(
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
                                                      .onBackground),
                                            ),
                                            const SizedBox(width: 20),
                                          ])));
                            })
                        : getWhenItemEmpty()
                  ],
                ))));
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
            size: MediaQuery.of(context).size.height * 0.13),
        const SizedBox(height: 10),
        Text('실행된 문제가 없습니다.',
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.03,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onBackground))
      ])),
    ));
  }
}
