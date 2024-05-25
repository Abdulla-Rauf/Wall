import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minimalsocialmedia/components/my_drawer.dart';
import 'package:minimalsocialmedia/components/my_list_tile.dart';
import 'package:minimalsocialmedia/components/my_post_button.dart';
import 'package:minimalsocialmedia/components/my_textfield.dart';
import 'package:minimalsocialmedia/database/firestore.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  //firestore access
  final FirestoreDatabase database = FirestoreDatabase();
  //text cobtroller
  final TextEditingController newPostController = TextEditingController();

  //post message
  void postMessage() {
    //only post message if there is something in the textfield
    if (newPostController.text.isNotEmpty) {
      String message = newPostController.text;
      database.addPost(message);
    }

    //clear the controller
    newPostController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text('W A L L'),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(25),
          child: Row(
            children: [
              //textfield
              Expanded(
                child: MyTextField(
                    hintText: 'Say something',
                    controller: newPostController,
                    obsecureText: false),
              ),
              //postbutton
              PostButton(
                onTap: postMessage,
              ),
            ],
          ),
        ),
        //posts
        StreamBuilder(
            stream: database.getPostsStream(),
            builder: (context, snapshot) {
              //show loading circle
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              //get all posts
              final posts = snapshot.data!.docs;
              //no data
              if (snapshot.data == null || posts.isEmpty) {
                return const Center(
                    child: Padding(
                  padding: EdgeInsets.all(25),
                  child: Text('No posts yet. Post Something!'),
                ));
              }
              return Expanded(
                  child: ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        //get each individual post
                        final post = posts[index];

                        //get data frome each post
                        String message = post['PostMessage'];
                        String userEmail = post['UserEmail'];
                        Timestamp timestamp = post['Timestamp'];

                        //return as list
                        return MyListTile(title: message, subtitle: userEmail);
                      }));
            })
      ]),
    );
  }
}
