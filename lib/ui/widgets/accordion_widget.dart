import 'package:flutter/material.dart';

class Accordion extends StatefulWidget {
  final String? title;
  final Widget? child;

  const Accordion({Key? key, this.title, this.child})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> {
  bool _showContent = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(children: [
        ListTile(
          title: widget.title != null ? Text(widget.title!) : const Text(''),
          trailing: IconButton(
            icon: Icon(
                _showContent ? Icons.arrow_drop_up : Icons.arrow_drop_down),
            onPressed: () {
              setState(() {
                _showContent = !_showContent;
              });
            },
          ),
        ),
        _showContent
            ? Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: widget.child ?? Container(),
              )
            : Container()
      ]),
    );
  }
}
