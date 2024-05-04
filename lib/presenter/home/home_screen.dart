import 'package:flutter/material.dart';

import 'home_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.model,
  });

  final HomeModel model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(model.title),
        actions: [
          IconButton(
            key: const Key('button-filter-key'),
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: model.showSettings,
          ),
        ],
      ),
      body: Center(
        child: ListView.builder(
          itemCount: model.users.length,
          itemBuilder: (context, index) {
            final user = model.users[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 2,
                child: ListTile(
                  key: Key('user-list-tile-key-${user.id}'),
                  title: Text(
                    user.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    user.email,
                  ),
                  onTap: () {
                    model.userPressed(user);
                  },
                  trailing: Image.network(
                    user.picture,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
