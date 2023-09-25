import 'package:flutter/material.dart';
import 'package:hattrick/Homepage.dart';

class LeadHome extends StatelessWidget {
  List<AUser> leads;
  LeadHome({super.key, required this.leads});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: Color(0xFF322653),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: ListView(children: [
          for (var user in leads)
            ListTile(
              title: Text(user.username),
              subtitle: Text('Super Points: ${user.superPoints}'),
              trailing: Text("${leads.indexOf(user) + 1}"),
            )
        ]),
      ),
    );
  }
}
