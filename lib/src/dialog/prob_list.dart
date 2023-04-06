import 'package:flutter/material.dart';

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
        child: FractionallySizedBox(
            heightFactor: 0.5,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              slivers: [
                SliverAppBar(
                  pinned: true,
                  backgroundColor: Theme.of(context).colorScheme.onBackground,
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      size: MediaQuery.of(context).size.height * 0.025,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    splashRadius: 10,
                  ),
                  title: Text('문제 확인',
                      style: TextStyle(
                          fontSize:
                              MediaQuery.of(context).size.height * 0.018)),
                ),
                widget.numList.isNotEmpty
                    ? SliverList.builder(
                        itemCount: widget.numList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 1),
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  width: double.infinity,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onTertiaryContainer,
                                  child: Center(
                                    child: Text(
                                      index != widget.numList.length - 1
                                          ? widget.numList[index].toString()
                                          : '정답 : ${widget.numList[index]}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.03,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground),
                                    ),
                                  )));
                        })
                    : getWhenItemEmpty()
              ],
            )));
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
