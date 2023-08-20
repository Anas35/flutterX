import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_x/src/tweet/tweet_provider.dart';
import 'package:flutter_x/src/user/user_provider.dart';
import 'package:flutter_x/utils/extension.dart';
import 'package:flutter_x/widgets/tweet_card.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key, this.uid});

  final String? uid;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profile = ref.watch(getUserProvider(widget.uid ?? FirebaseAuth.instance.currentUser!.uid));
    return profile.withDefault(data: (data) {
      final tweets = ref.watch(getUserTweet(data.id));
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 150.0,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0, bottom: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (widget.uid == null) ...{
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        padding: const EdgeInsets.all(0),
                      ),
                      onPressed: () {
                        context.pushNamed('setting');
                      },
                      child: const Icon(Icons.settings),
                    ),
                  } else ...{
                    Text('@${data.userName}', style: theme.textTheme.headlineMedium?.copyWith(color: theme.primaryColor)),
                  },
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.large(
          onPressed: () {},
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              image: DecorationImage(image: NetworkImage(data.profileUrl), fit: BoxFit.fill),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        body: Column(
          children: [
            if (widget.uid == null) ...{
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, top: 10),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.pushNamed('editprofile');
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text("Edit Profile"),
                  ),
                ),
              ),
            } else ...{
              const SizedBox(height: 50.0),
            },
            tweets.withDefault(
              data: (data) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return TweetCard(tweet: data[index]);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }
}
