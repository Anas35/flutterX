import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_x/src/search/search_repository.dart';
import 'package:flutter_x/src/tweet/tweet.dart';
import 'package:flutter_x/src/user/user.dart';
import 'package:flutter_x/utils/credential.dart';
import 'package:flutter_x/widgets/tweet_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  late final tabController = TabController(length: 2, vsync: this);
  final textEdittingController = TextEditingController();
  final tweetPagingController = PagingController<int, Tweet>(firstPageKey: 0);
  final userPagingController = PagingController<int, XUser>(firstPageKey: 0);

  final _tweetSearcher = HitsSearcher(
    applicationID: Credential.algoliaApplicationID,
    apiKey: Credential.algoliaAPIKey,
    indexName: 'flutterX',
  );

  final _userSearcher = HitsSearcher(
    applicationID: Credential.algoliaApplicationID,
    apiKey: Credential.algoliaAPIKey,
    indexName: 'userIndex',
  );

  Stream<HitsPage> get _searchTweetPage => _tweetSearcher.responses.map(HitsPage.fromResponse);

  Stream<HitsPageUser> get _searchUserPage => _userSearcher.responses.map(HitsPageUser.fromResponse);

  @override
  void initState() {
    super.initState();

    textEdittingController.addListener(() {
      _tweetSearcher.applyState(
        (state) => state.copyWith(
          query: textEdittingController.text,
          analytics: false,
          page: 0,
        ),
      );
      _userSearcher.applyState(
        (state) => state.copyWith(
          query: textEdittingController.text,
          page: 0,
          analytics: false,
        ),
      );
    });

    _searchTweetPage.listen((page) {
      if (page.pageKey == 0) {
        tweetPagingController.refresh();
      }
      tweetPagingController.appendPage(page.items, page.nextPageKey);
    }).onError((error) => tweetPagingController.error = error);

    _searchUserPage.listen((page) {
      if (page.pageKey == 0) {
        userPagingController.refresh();
      }
      userPagingController.appendPage(page.items, page.nextPageKey);
    }).onError((error) => userPagingController.error = error);

    tweetPagingController.addPageRequestListener((pageKey) {
      _tweetSearcher.applyState((state) {
        return state.copyWith(
          page: pageKey,
        );
      });
    });

    userPagingController.addPageRequestListener((pageKey) {
      _userSearcher.applyState((state) {
        return state.copyWith(
          page: pageKey,
        );
      });
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    tweetPagingController.dispose();
    userPagingController.dispose();
    _tweetSearcher.dispose();
    _userSearcher.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: textEdittingController,
          decoration: const InputDecoration(
            hintText: 'Search',
            contentPadding: EdgeInsets.only(left: 10.0),
            prefixIcon: Icon(Icons.search),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              SizedBox(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Search powered by: ",
                        style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        "Algolia",
                        style: textTheme.bodyLarge?.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                child: TabBar(
                  controller: tabController,
                  tabs: const [
                    Tab(text: "Tweets"),
                    Tab(text: "User"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          PagedListView<int, Tweet>(
            pagingController: tweetPagingController,
            builderDelegate: PagedChildBuilderDelegate<Tweet>(
              noItemsFoundIndicatorBuilder: (_) => const Center(
                child: Text('No results found'),
              ),
              itemBuilder: (context, item, index) {
                return TweetCard(tweet: item);
              },
            ),
          ),
          PagedListView<int, XUser>.separated(
            pagingController: userPagingController,
            builderDelegate: PagedChildBuilderDelegate<XUser>(
              noItemsFoundIndicatorBuilder: (_) => const Center(
                child: Text('No results found'),
              ),
              itemBuilder: (context, item, index) {
                return ListTile(
                  leading: CircleAvatar(
                    foregroundImage: NetworkImage(item.profileUrl),
                  ),
                  title: Text('@${item.userName}'),
                  subtitle: Text(item.name),
                );
              },
            ),
            separatorBuilder: (context, index) {
              return const Divider();
            },
          ),
        ],
      ),
    );
  }
}
