/*
 * @Author: your name
 * @Date: 2021-01-09 15:58:28
 * @LastEditTime: 2021-01-10 14:44:18
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter/udemy_flutter_sec13/lib/widget/location_input.dart
 */
import 'package:flutter/material.dart';
import 'package:location/location.dart'; //同样需要在iOS里添加permit
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../helper/location_helper.dart';
import '../page/map_page.dart';

class LocationInput extends StatefulWidget {
  //把用户选择的地址的信息用此方法传递给add_place_page.dart
  final Function selectPlace;
  LocationInput(this.selectPlace);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageURL;

  //根据传入的经纬度生成对应的地址图片url
  void _showPreview(double latitude, double longitude) {
    //使用google map来把经纬度转换成对应的地图图片
    //获取到对应图片的url
    final staticMapImageURL = LocationHelper.generateLocationPreviewImage(
      latitude: latitude,
      longitude: longitude,
    );
    setState(() {
      _previewImageURL = staticMapImageURL;
    });
  }

//直接根据当前地址的经纬度生成图片
  Future<void> _getCurrentLocation() async {
    try {
      //获取当前地址数据
      final locationData = await Location().getLocation();
      
       //根据当前地址数据生成图片并保存到_previewImageURL
    _showPreview(locationData.latitude, locationData.longitude);
    //把用户的地址信息传递给add_place_page.dart
    widget.selectPlace(locationData.latitude, locationData.longitude);
    } catch (err) {
      return;
    }
  }

//打开google map选择location
  Future<void> _selectOnMap() async {
    //获取用户从google map中选择的地址对象
    final selectedLocation =
        await Navigator.of(context).push<LatLng>(MaterialPageRoute(
      fullscreenDialog: true, //左上角显示叉按钮
      builder: (ctx) => MapPage(
        isSelecting: true,
      ),
    ));
    if (selectedLocation == null) {
      return;
    }
    //根据该地址生成对应图片
    //selectedLocation类型为LatLng，保存了用户点击选择的地点的信息
    _showPreview(selectedLocation.latitude, selectedLocation.longitude);
    //把用户的地址信息传递给add_place_page.dart
    widget.selectPlace(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //1.展示图片
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 170,
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          child: _previewImageURL == null
              ? Text(
                  'No Location Chosen',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageURL,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        //2.展示location
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton.icon(
              icon: Icon(Icons.location_on),
              label: Text('current location'),
              textColor: Theme.of(context).primaryColor,
              onPressed: _getCurrentLocation,
            ),
            FlatButton.icon(
              icon: Icon(Icons.map),
              label: Text('select on map'),
              textColor: Theme.of(context).primaryColor,
              onPressed: _selectOnMap,
            ),
          ],
        ),
      ],
    );
  }
}
