import 'package:cloud_firestore/cloud_firestore.dart';

class Tweet {
  final String id;
  final String text;
  final List<String> imagesUrl;
  final String userId;
  final String userName;
  final DateTime timestamp;
  final String userUrl;
  final List<String> likes;
  final List<String> replies;
  final int shares;

  Tweet({
    required this.id,
    required this.text,
    required this.imagesUrl,
    required this.userId,
    required this.userName,
    required this.timestamp,
    required this.userUrl,
    this.likes = const [],
    this.replies = const [],
    this.shares = 0,
  });

  factory Tweet.fromSnapshot(DocumentSnapshot snapshot) {
    return Tweet(
      id: snapshot.id,
      text: snapshot['text'],
      imagesUrl: (snapshot['imagesUrl'] as List).cast<String>(),
      userId: snapshot['userId'],
      userName: snapshot['userName'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(snapshot['timestamp']),
      likes: (snapshot['likes'] as List).cast<String>(),
      replies: (snapshot['replies'] as List).cast<String>(),
      shares: snapshot['shares'],
      userUrl: snapshot['userUrl']
    );
  }

  factory Tweet.fromJson(Map<String, dynamic> json) {
    return Tweet(
      id: json['id'],
      text: json['text'],
      imagesUrl: (json['imagesUrl'] as List).cast<String>(),
      userId: json['userId'],
      userName: json['userName'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
      likes: (json['likes'] as List).cast<String>(),
      replies: (json['replies'] as List).cast<String>(),
      shares: json['shares'],
      userUrl: json['userUrl']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'imagesUrl': imagesUrl,
      'userId': userId,
      'userName': userName,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'likes': likes,
      'replies': replies,
      'shares': shares,
      'userUrl': userUrl,
    };
  }
}
