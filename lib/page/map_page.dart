/*
 * @Author: your name
 * @Date: 2021-01-09 17:23:08
 * @LastEditTime: 2021-01-10 15:13:37
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter/udemy_flutter_sec13/lib/page/map_page.dart
 */
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/place.dart';

class MapPage extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool isSelecting;
  MapPage({
    this.initialLocation = const PlaceLocation(
      latitude: 37.422,
      longitude: -122.084,
    ),
    //默认用户没有点击选择一个地点
    this.isSelecting = false,
  });

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng _pickedLocation; //保存用户选择的地点

  //实现点击选择地点方法
  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Map'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              icon: Icon(Icons.check),
              onPressed: _pickedLocation == null
                  ? null
                  : () {
                      Navigator.of(context).pop(_pickedLocation);
                    },
            ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.initialLocation.latitude,
            widget.initialLocation.longitude,
          ),
          zoom: 16,
        ),
        //判断用户是否点击地图选择了一个地点，一旦用户点击地图选择一个地点
        //则保存该地点信息
        onTap: widget.isSelecting ? _selectLocation : null,
        //给被选择的地点一个标记或者通过详情页打开的地图上也要显示该地址对应的marker
        //在place_detail_page.dart里设置了isSelecting为false
        markers: (_pickedLocation == null && widget.isSelecting)
            ? null
            : {
                Marker(
                  markerId: MarkerId('m1'),
                  //检查_pickedLocation是否为空，如果为空，说明当前是通过详情页打开的地图
                  position: _pickedLocation ??
                      LatLng(
                        widget.initialLocation.latitude,
                        widget.initialLocation.longitude,
                      ),
                ),
              },
      ),
    );
  }
}
