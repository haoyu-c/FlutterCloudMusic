import 'dart:math';

import 'package:FlutterCloudMusic/component/cmtextformfield.dart';
import 'package:FlutterCloudMusic/entrance/application.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import '../utils.dart';

class MomentPostPage extends StatefulWidget {
  @override
  _MomentPostPageState createState() => _MomentPostPageState();
}

class _MomentPostPageState extends State<MomentPostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
    );
  }

  Widget get body {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: "发个动态吧",
              border: InputBorder.none
            ),
            maxLines: 5,
            style: TextStyle(color: Colors.black),
          ),
          10.h,
          selectedImageGridView
        ],
      ),
    );
  }
  List<Asset> selectedImages = [];
  Widget get selectedImageGridView {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10
        ),
        itemBuilder: (context, index) {
          if (index == selectedImages.length) {
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: CMImage.named('AddImage', fit: BoxFit.cover),
              onTap: loadImages,
            );
          } else {
            return LayoutBuilder(
              builder: (context, constraint) {
                return AssetThumb(asset: selectedImages[index], width: constraint.maxHeight.toInt(), height:  constraint.maxHeight.toInt(),);
              },
            );
          }
        },
        itemCount: min(selectedImages.length + 1, 9),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
    );
  }

  Future loadImages() async {
    List<Asset> imageList = [];
    try {
      imageList = await MultiImagePicker.pickImages(
        maxImages: 9,
        enableCamera: false,
        selectedAssets: selectedImages
      );
    } on Exception catch(e) {
      print(e.toString());
    }
    if (!mounted) {
      return;
    }
    setState(() {
      selectedImages = imageList;
    });
  }

  AppBar get appBar {
    return AppBar(
      backgroundColor: blackWhiteBg,
      title: CMText(text: "动态", fontWeight: FontWeight.bold,),
      elevation: 0,
      brightness: ThemeDataExtension.appBar(context),
      actions: [
        GestureDetector(
          child: Center(
            child: Padding(padding: EdgeInsets.only(right: 20),child:CMText(text: "发布", fontSize: 17, fontWeight: FontWeight.bold)),
          ),
          onTap: () {}
        )
      ],
    );
  }

  postComment() {
    Application.shared.dio.post('');
  }

}
