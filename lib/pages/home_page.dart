import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_x/src/tweet/tweet.dart';
import 'package:flutter_x/src/tweet/tweet_repository.dart';
import 'package:flutter_x/src/user/user_provider.dart';
import 'package:flutter_x/widgets/tweet_card.dart';
import 'package:go_router/go_router.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    ref.watch(getCurrentUserProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
      ),
      body: FirestoreListView<Tweet>(
        pageSize: 5,
        query: TweetRepository.tweetCollection.orderBy('timestamp', descending: true),
        itemBuilder: (context, doc) {
          return GestureDetector(
            onTap: () {
              context.goNamed("tweetpage", pathParameters: {"id": doc.data().id});
            },
            child: TweetCard(tweet: doc.data()),
          );
        },
      ),
    );
  }
}
