import 'package:flutter/material.dart';
import 'package:flutter_x/utils/language.dart';
import 'package:go_router/go_router.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {

  List<(String, String)> filteredLangague = List.from(language);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 160.0,
        automaticallyImplyLeading: false,
        flexibleSpace: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    context.pop();
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search Country',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    filteredLangague = language.where((element) => element.$1.toLowerCase().contains(value)).toList();
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView.separated(
        itemCount: filteredLangague.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              context.pop(filteredLangague[index].$2);
            },
            title: Text(filteredLangague[index].$1),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
      ),
    );
  }
}
