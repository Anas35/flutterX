import 'package:flutter/material.dart';
import 'package:flutter_x/widgets/nav_bar.dart';
import 'package:go_router/go_router.dart';

class Dashboard extends StatelessWidget {

  const Dashboard({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavX(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          navigationShell.goBranch(index);
        },
        items: const [
          (iconData: Icons.home, text: 'Home'),
          (iconData: Icons.search, text: 'Search'),
          (iconData: Icons.notifications, text: 'Notify'),
          (iconData: Icons.person, text: 'Profile'),
        ],
      ),
      floatingActionButton: MediaQuery.viewInsetsOf(context).bottom <= 0.0 ? Container(
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: FloatingActionButton(
          onPressed: () {
            context.push("/post");
          },
          child: const Icon(Icons.add),
        ),
      ) : const SizedBox.shrink(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: navigationShell,
    );
  }
}
