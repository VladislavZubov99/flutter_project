import 'package:flutter/material.dart';

class CustomScrollViewWithScrollFetch extends StatefulWidget {
  final List<Widget> slivers;
  final void Function() onEndScroll;

  static void _initialEndScroll() {}

  const CustomScrollViewWithScrollFetch({
    Key? key,
    required this.slivers,
    this.onEndScroll = _initialEndScroll,
  }) : super(key: key);

  @override
  State<CustomScrollViewWithScrollFetch> createState() =>
      _CustomScrollViewWithScrollFetchState();
}

class _CustomScrollViewWithScrollFetchState
    extends State<CustomScrollViewWithScrollFetch> {
  final ScrollController _controller = ScrollController();

  void _onScrollEvent() {
    if (_controller.position.pixels >= _controller.position.maxScrollExtent) {
      widget.onEndScroll();
      // fetchNextPage();
    }
  }

  @override
  void initState() {
    _controller.addListener(_onScrollEvent);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_onScrollEvent);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _controller,
      slivers: widget.slivers,
    );
  }
}