import 'package:flutter/cupertino.dart';
import 'package:FlutterCloudMusic/util/cmimage.dart';

class DiscoverNavigationBar extends StatefulWidget {
  @override
  _DiscoverNavigationBarState createState() => _DiscoverNavigationBarState();
}

class _DiscoverNavigationBarState extends State<DiscoverNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(top: true,
      child: Container(
        height: 44,
        child: Row(children: [ 
          SizedBox(width: 12,),
          Container(child: CMImage.named("Micphone"), width: 22, height:  22,),
          Spacer(),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              width: 250,
              height: 30,
              color: Color(0xffefeff4),
              child: Center(child: Text("周杰伦"),),
            ),
          ),
          Spacer(),
          Container(child: CMImage.named("Micphone"), width: 22, height:  22,),
          SizedBox(width: 12,),
        ],),
      ),
    );
  }
}
