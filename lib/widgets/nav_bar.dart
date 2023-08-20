import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavX extends ConsumerStatefulWidget {
  
  const NavX({
    required this.currentIndex, 
    required this.onTap, 
    super.key, 
    required this.items,
  });

  final List<({IconData iconData, String text})> items;
  final int currentIndex;
  final void Function(int) onTap;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NavXState();
}

class _NavXState extends ConsumerState<NavX> {

  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.generate(widget.items.length, (int index) {
      return _buildTabItem(
        item: widget.items[index],
        index: index,
      );
    });
    items.insert(items.length >> 1, _buildMiddleTabItem());

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
    );
  }

  Widget _buildMiddleTabItem() {
    return Expanded(
      child: SizedBox(
        height: 50.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 26.0),
            Text("Post",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).primaryColor.withAlpha(180),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required ({IconData iconData, String text}) item,
    required int index,
  }) {
    Color color = widget.currentIndex == index ? Theme.of(context).primaryColor : Theme.of(context).unselectedWidgetColor;
    return Expanded(
      child: SizedBox(
        height: 50.0,
        child: Material(
          type: MaterialType.transparency,
          child: Consumer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(item.iconData, color: color, size: 30.0),
                Text(
                  item.text,
                  style: TextStyle(color: color),
                )
              ],
            ),
            builder: (context, ref, child) {
              return InkWell(
                onTap: () {
                  widget.onTap(index);
                },
                child: child,
              );
            }
          ),
        ),
      ),
    );
  }
}