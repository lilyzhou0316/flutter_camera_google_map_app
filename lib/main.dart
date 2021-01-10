/*
 * @Author: your name
 * @Date: 2021-01-08 15:12:14
 * @LastEditTime: 2021-01-10 15:03:14
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter/udemy_flutter_sec13/lib/main.dart
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udemy_flutter_sec13/page/place_list_page.dart';

import './provider/places.dart';
import './page/add_place_page.dart';
import './page/place_detail_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      //监听places
      create: (ctx) => Places(),
      child: MaterialApp(
        title: 'Great Places',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey, //主色调
          accentColor: Colors.amber,
        ),
        home: PlaceListPage(),
        //注册routes
        routes: {
          AddPlacePage.routeName: (ctx) => AddPlacePage(),
          PlaceDetailPage.routeName: (ctx) => PlaceDetailPage(),
        },
      ),
    );
  }
}
