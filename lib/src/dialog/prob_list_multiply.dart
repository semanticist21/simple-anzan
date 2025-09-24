import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600, maxHeight: 600),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  // Fixed Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'problemList.checkProb'.tr(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              CupertinoIcons.xmark,
                              size: 16,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Scrollable Content
                  Expanded(
                    child: widget.numList.isNotEmpty
                        ? ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: widget.numList.length,
                            itemBuilder: (context, index) {
                              final isCurrentAnswer = index == widget.numList.length - 1;
                              final isMultiply = widget.mode[index];
                              final question = isMultiply
                                  ? '${formatter.format(widget.numList[index].item1)} × ${formatter.format(widget.numList[index].item2)}'
                                  : '${formatter.format(widget.numList[index].item1)} ÷ ${formatter.format(widget.numList[index].item2)}';
                              final answer = isMultiply
                                  ? formatter.format(widget.numList[index].item1 * widget.numList[index].item2)
                                  : formatter.format(widget.numList[index].item1 / widget.numList[index].item2);

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isCurrentAnswer
                                      ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.08)
                                      : Theme.of(context).colorScheme.surface,
                                  border: Border.all(
                                    color: isCurrentAnswer
                                        ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
                                        : Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            color: isCurrentAnswer
                                                ? Theme.of(context).colorScheme.primary
                                                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${index + 1}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: isCurrentAnswer
                                                    ? Colors.white
                                                    : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            question,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                              color: Theme.of(context).colorScheme.onSurface,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ),
                                        if (isCurrentAnswer)
                                          Icon(
                                            CupertinoIcons.checkmark_circle_fill,
                                            size: 20,
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        const SizedBox(width: 36), // Align with question text
                                        Icon(
                                          CupertinoIcons.equal,
                                          size: 16,
                                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          answer,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: isCurrentAnswer ? FontWeight.w600 : FontWeight.w500,
                                            color: Theme.of(context).colorScheme.onSurface,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        : _buildEmptyState(),
                  ),
                ],
              ),
            )));
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(
              CupertinoIcons.doc_text,
              size: 40,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'problemList.noProbExecuted'.tr(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
