import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_x/src/comments/comments.dart';
import 'package:flutter_x/src/comments/comments_provider.dart';
import 'package:flutter_x/src/language/language_provider.dart';
import 'package:flutter_x/src/language/language_repository.dart';
import 'package:flutter_x/src/tweet/tweet.dart';
import 'package:flutter_x/src/tweet/tweet_provider.dart';
import 'package:flutter_x/src/user/user_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

class TweetCard extends ConsumerStatefulWidget {
  const TweetCard({super.key, required this.tweet});

  final Tweet tweet;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TweetCardState();
}

class _TweetCardState extends ConsumerState<TweetCard> {
  String? languageCode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final translateValue = ref.watch(translateProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
              child: Row(
                children: [
                  CircleAvatar(
                    foregroundImage: NetworkImage(widget.tweet.userUrl),
                  ),
                  TextButton(
                    child: Text(
                      widget.tweet.userName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.primaryColor,
                      ),
                    ),
                    onPressed: () {
                      context.pushNamed("otherprofile", pathParameters: {"uid": widget.tweet.userId});
                    },
                  ),
                  const Spacer(),
                  Text(timeago.format(widget.tweet.timestamp.toLocal())),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 10.0),
              child: Text(widget.tweet.text),
            ),
            if (languageCode != null) ...{
              Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 10),
                child: Text("Translation:",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(decoration: TextDecoration.underline)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(translateValue.valueOrNull ?? translateValue.error?.toString() ?? 'Loading...'),
              ),
            },
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StatsCard(icon: Icons.comment, label: widget.tweet.replies.length.toString()),
                  Consumer(builder: (context, ref, _) {
                    final uid = ref.watch(getCurrentUserProvider).valueOrNull?.id;
                    final isLiked = widget.tweet.likes.contains(uid);
                    return StatsCard(
                      icon: isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                      label: widget.tweet.likes.length.toString(),
                      onPressed: () {
                        if (isLiked) {
                          ref.read(tweetRemoveLikeProvider(widget.tweet.id));
                        } else {
                          ref.read(tweetLikeProvider(widget.tweet.id));
                        }
                      },
                    );
                  }),
                  TextButton(
                    onPressed: () async {
                      languageCode = await context.pushNamed("language");
                      if (languageCode != null) {
                        ref.read(translateProvider.notifier).translateData(
                            Translate(tweetId: widget.tweet.id, input: widget.tweet.text, languageCode: languageCode!));
                      }
                    },
                    child: const Text('Translate'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatsCard extends StatelessWidget {
  const StatsCard({super.key, required this.icon, required this.label, this.onPressed});

  final IconData icon;
  final String label;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
        ),
        Text(label),
      ],
    );
  }
}

class CommentCard extends StatelessWidget {
  const CommentCard({super.key, required this.comments});

  final Comments comments;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
              child: Row(
                children: [
                  CircleAvatar(
                    foregroundImage: NetworkImage(comments.userUrl),
                  ),
                  const SizedBox(width: 20.0),
                  Text(comments.userName),
                  const Spacer(),
                  Text(timeago.format(comments.timestamp.toLocal())),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(comments.text),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StatsCard(icon: Icons.comment, label: comments.replies.length.toString()),
                  Consumer(builder: (context, ref, _) {
                    final uid = ref.watch(getCurrentUserProvider).valueOrNull?.id;
                    final isLiked = comments.likes.contains(uid);
                    return StatsCard(
                      icon: isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                      label: comments.likes.length.toString(),
                      onPressed: () {
                        if (isLiked) {
                          ref.read(commentRemoveLikeProvider(comments.id));
                        } else {
                          ref.read(commentLikeProvider(comments.id));
                        }
                      },
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
