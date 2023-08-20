import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_x/src/comments/comments.dart';
import 'package:flutter_x/src/comments/comments_provider.dart';
import 'package:flutter_x/src/comments/comments_repository.dart';
import 'package:flutter_x/src/tweet/tweet_provider.dart';
import 'package:flutter_x/utils/extension.dart';
import 'package:flutter_x/widgets/tweet_card.dart';

class TweetPage extends ConsumerStatefulWidget {
  const TweetPage({super.key, required this.tweetId});

  final String tweetId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TweetPageState();
}

class _TweetPageState extends ConsumerState<TweetPage> {
  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final tweet = ref.watch(getTweet(widget.tweetId));
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          tweet.withDefault(data: (data) {            
            return TweetCard(tweet: data);
          }),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: commentController,
              decoration: InputDecoration(
                hintText: 'Add Comment',
                suffixIcon: IconButton(
                  onPressed: () {
                    if (commentController.text.isEmpty) {
                      return;
                    }
                    ref.read(addCommentProvider.notifier).comment(widget.tweetId, commentController.text);
                    commentController.clear();
                  }, 
                  icon: const Icon(Icons.send),
                ),
              ),
            ),
          ),
          Expanded(
            child: FirestoreListView<Comments>(
              query: CommentsRepository.commentCollection.where('tweetId', isEqualTo: widget.tweetId),
              itemBuilder: (context, doc) {
                return CommentCard(comments: doc.data());
              },
            ),
          ),
        ],
      ),
    );
  }
}
