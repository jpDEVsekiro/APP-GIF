import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class gifpage extends StatelessWidget {
  @override
  final Map gifData;
  gifpage(this.gifData);

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(gifData["title"]),
        backgroundColor: Colors.black,
        actions: [IconButton(icon: Icon(Icons.share_rounded),
        onPressed: (){
          Share.share(gifData["images"]["fixed_height"]["url"]);

        },)],
      ),
      body: Center(
        child: Image.network(gifData["images"]["fixed_height"]["url"]),
      ),
    );
  }
}
