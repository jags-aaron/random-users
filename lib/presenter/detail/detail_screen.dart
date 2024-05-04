import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import '../../domain/entity/user.dart';
import 'detail_model.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({
    super.key,
    required this.model,
  });

  final DetailModel model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(model.user.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            UserCard(user: model.user),
          ],
        ),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final User user;

  const UserCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Gender: ${user.gender}'),
            Text('Nationality: ${user.nationality}'),
            Text('Location: ${user.location}'),
            Text('Email: ${user.email}'),
            Text('Date of Birth: ${user.dob}'),
            Text('Phone: ${user.phone}'),
            Text('ID: ${user.id}'),
            SizedBox(
              height: 150,
              width: 150,
              child: Image.network(user.picture, fit: BoxFit.cover),
            ),
          ],
        ),
      ),
    );
  }
}
