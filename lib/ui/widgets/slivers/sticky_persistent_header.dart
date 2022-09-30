import 'package:flutter/material.dart';
import 'package:project/ui/widgets/slivers/header_delegate.dart';

class StickyPersistentHeader extends StatelessWidget {
  final Widget child;
  final Size size;

  const StickyPersistentHeader({
    Key? key,
    required this.child,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      floating: true,
      delegate: HeaderDelegate(
        child: PreferredSize(
          preferredSize: size,
          child: child,
        ),
      ),
    );
  }
}
