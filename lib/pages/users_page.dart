import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minimalsocialmedia/components/my_back_button.dart';
import 'package:minimalsocialmedia/components/my_list_tile.dart';
import 'package:minimalsocialmedia/helper/helper_fuction.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Users').snapshots(),
          builder: (context, snapshot) {
            //any error
            if (snapshot.hasError) {
              displayMessageToUser('Something went Wrong', context);
            }
            //show loading circle
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.data == null) {
              return const Center(child: Text('No Data..'));
            }
            //get all users
            final users = snapshot.data!.docs;
            return Column(
              children: [
                //back button
                const Padding(
                  padding: EdgeInsets.only(left: 25, top: 50),
                  child: Row(
                    children: [
                      MyBackButton(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: users.length,
                      padding: const EdgeInsets.all(10),
                      itemBuilder: (context, index) {
                        //get individual user
                        final user = users[index];

                        //get data from each user
                        String username = user['username'];
                        String email = user['email'];
                        return MyListTile(title: username, subtitle: email);
                      }),
                ),
              ],
            );
          }),
    );
  }
}
