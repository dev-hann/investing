import 'package:flutter/material.dart';

class EventSearchView extends StatefulWidget {
  const EventSearchView({super.key});

  @override
  State<EventSearchView> createState() => _EventSearchViewState();
}

class _EventSearchViewState extends State<EventSearchView> {
  AppBar appBar() {
    return AppBar(
      title: const Text("Event Search View"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: const Center(
        child: Text("Work In Progress"),
      ),
    );
  }
}
