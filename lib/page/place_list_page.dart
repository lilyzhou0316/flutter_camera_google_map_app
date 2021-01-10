/*
 * @Author: your name
 * @Date: 2021-01-09 12:53:20
 * @LastEditTime: 2021-01-10 15:05:08
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter/udemy_flutter_sec13/lib/page/places_list_page.dart
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './add_place_page.dart';
import '../provider/places.dart';
import '../page/place_detail_page.dart';

//home页面，展示所有的place
class PlaceListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your place'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlacePage.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<Places>(context, listen: false).fetchAndSetPlaces(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(child: CircularProgressIndicator())
            : Consumer<Places>(
                //监听Places，如果Places发生改变则child发生改变
                builder: (ctx, places, ch) => places.items.length <= 0
                    ? ch
                    : ListView.builder(
                        itemBuilder: (ctx, index) => ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                FileImage(places.items[index].image),
                          ),
                          title: Text(places.items[index].title),
                          subtitle: Text(places.items[index].location.address),
                          onTap: () {
                            //把id传给详情页，并跳转至对应place的详情页
                            Navigator.of(context).pushNamed(
                              PlaceDetailPage.routeName,
                              arguments: places.items[index].id,
                            );
                          },
                        ),
                        itemCount: places.items.length,
                      ),
                //初始显示的内容
                child: Center(
                  child: Text('got no places yet, start adding some!'),
                ),
              ),
      ),
    );
  }
}
