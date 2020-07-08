import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final usersEmails = Provider.of<List<String>>(context);

    return ListView.builder(
        itemCount: usersEmails.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              child: Text(usersEmails[index]) //UserTile(users[index]),
//            onTap: () {
//            },
              );
        });
  }
}
