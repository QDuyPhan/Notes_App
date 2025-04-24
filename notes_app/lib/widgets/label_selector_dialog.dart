import 'package:flutter/material.dart';

import '../ultils/constants.dart';

class LabelSelectorDialog extends StatefulWidget {
  final double width;
  int selectedLabel;
  void Function(int) changeLabelCallback;

  LabelSelectorDialog({
    required this.width,
    required this.selectedLabel,
    required this.changeLabelCallback,
  });

  @override
  State<LabelSelectorDialog> createState() => _LabelSelectorDialogState();
}

class _LabelSelectorDialogState extends State<LabelSelectorDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Note Label", style: TextStyle(fontSize: 20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ColoredLabelWidget(
                callbackFunction: widget.changeLabelCallback,
                labelCallbackIndex: 0,
                labelColor: LABEL_COLOR[0]!,
                showBorder: widget.selectedLabel == 0 ? true : false,
              ),
              ColoredLabelWidget(
                callbackFunction: widget.changeLabelCallback,
                labelCallbackIndex: 1,
                labelColor: LABEL_COLOR[1]!,
                showBorder: widget.selectedLabel == 1 ? true : false,
              ),
              ColoredLabelWidget(
                callbackFunction: widget.changeLabelCallback,
                labelCallbackIndex: 2,
                labelColor: LABEL_COLOR[2]!,
                showBorder: widget.selectedLabel == 2 ? true : false,
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ColoredLabelWidget(
                callbackFunction: widget.changeLabelCallback,
                labelCallbackIndex: 3,
                labelColor: LABEL_COLOR[3]!,
                showBorder: widget.selectedLabel == 3 ? true : false,
              ),
              ColoredLabelWidget(
                callbackFunction: widget.changeLabelCallback,
                labelCallbackIndex: 4,
                labelColor: LABEL_COLOR[4]!,
                showBorder: widget.selectedLabel == 4 ? true : false,
              ),
              ColoredLabelWidget(
                callbackFunction: widget.changeLabelCallback,
                labelCallbackIndex: 5,
                labelColor: LABEL_COLOR[5]!,
                showBorder: widget.selectedLabel == 5 ? true : false,
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ColoredLabelWidget(
                callbackFunction: widget.changeLabelCallback,
                labelCallbackIndex: 6,
                labelColor: LABEL_COLOR[6]!,
                showBorder: widget.selectedLabel == 6 ? true : false,
              ),
              ColoredLabelWidget(
                callbackFunction: widget.changeLabelCallback,
                labelCallbackIndex: 7,
                labelColor: LABEL_COLOR[7]!,
                showBorder: widget.selectedLabel == 7 ? true : false,
              ),
              ColoredLabelWidget(
                callbackFunction: widget.changeLabelCallback,
                labelCallbackIndex: 8,
                labelColor: LABEL_COLOR[8]!,
                showBorder: widget.selectedLabel == 8 ? true : false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ColoredLabelWidget extends StatelessWidget {
  void Function(int) callbackFunction;
  final Color labelColor;
  final int labelCallbackIndex;
  final bool showBorder;

  ColoredLabelWidget({
    required this.callbackFunction,
    required this.labelColor,
    required this.labelCallbackIndex,
    required this.showBorder,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        callbackFunction(labelCallbackIndex);
        Navigator.pop(context);
      },
      child: Container(
        height: width * 0.1,
        width: width * 0.1,
        decoration: BoxDecoration(
          color: labelColor,
          borderRadius: BorderRadius.circular(width),
          border:
              showBorder ? Border.all(color: Colors.blueGrey, width: 5) : null,
        ),
      ),
    );
  }
}
