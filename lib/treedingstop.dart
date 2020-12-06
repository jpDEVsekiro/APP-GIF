import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gif/gifpage.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  String search;
  int offset=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network("https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif"),
      centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onSubmitted: (Text){
                setState(() {
                  search=Text;
                });
              },
              decoration: InputDecoration(

                labelText: "pesquisar",
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder:OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white,width: 0.7),
                ),
                  focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white,width: 1.3),
              )),
              style: TextStyle(color:Colors.white,fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
              child: FutureBuilder(
                future: getgifs(),
                builder: (context,snapshot){
                  switch(snapshot.connectionState){
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width:200 ,
                        height:200 ,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white) ,
                          strokeWidth: 5,
                        ),
                      );
                      default:
                        return _createGIFTable(context,snapshot);
                  }
                },
              ))
        ],
      ),
    );
  }

  int _getCount(List data){
    if(search==null){
      return data.length;
    }else{
      return data.length+1;
    }
  }

  Future<Map> getgifs() async{
    if(search==null || search==""){
    http.Response response=await http.get("https://api.giphy.com/v1/gifs/trending?api_key=yySQY7Xva3a3GEkuYbyCYpWXDxeg8co5&limit=500&rating=g");
    return json.decode(response.body);
    }
    else{
      http.Response response=await http.get("https://api.giphy.com/v1/gifs/search?api_key=yySQY7Xva3a3GEkuYbyCYpWXDxeg8co5&q=$search&limit=19&offset=$offset&rating=g&lang=pt");
      return json.decode(response.body);
    }
  }
  Widget _createGIFTable(BuildContext context, AsyncSnapshot snapshot){
    return GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10
        ),
        itemCount: _getCount(snapshot.data["data"]),
      itemBuilder: (context, index){
        if(search==null || index< snapshot.data["data"].length){
          return GestureDetector(
            child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                height: 300,
                fit: BoxFit.cover,
                image: snapshot.data["data"][index]["images"]["fixed_height"]["url"]),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder:(context)=>gifpage(snapshot.data["data"][index])));
            },
            onLongPress: (){
              Share.share(snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
            },
          );}
        else
          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.add, color:Colors.white,size: 70,)
                ],
              ),
              onTap: (){
                setState(() {
                  offset +=19;
                });
              },
            ),
          );
      },
    );

  }
}
