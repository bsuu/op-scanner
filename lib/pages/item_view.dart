import 'dart:io';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skan/data/scan_file.dart';
import 'package:skan/provider/scan_file_storage.dart';

import '../widgets/file/file_item.dart';

class ItemView extends StatefulWidget{
  final String fileName;
  List<String> files;

  ItemView(
      {Key? key,
        required this.fileName,
        required this.files})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ItemViewState();

}

class ItemViewState extends State<ItemView> {
  @override
  Widget build(BuildContext context) {
    double widthSize = (MediaQuery.of(context).size.width - 48) / 3;
    double heightSize = (widthSize / 9) * 14;
    return Container(
        decoration: BoxDecoration(color: AdaptiveTheme.of(context).theme.backgroundColor),
        padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
        child: Column(
          children: [
            Container(
              constraints: const BoxConstraints(maxHeight: 75),
              padding: const EdgeInsets.all(14),
              margin: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: AdaptiveTheme.of(context).theme.primaryColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.fileName, style: AdaptiveTheme.of(context).theme.textTheme.headline1,)
                ],
              ),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (int i = 0; i < widget.files.length; i++)
                  GestureDetector(
                    child: Container(
                        height: heightSize,
                        width: widthSize,
                        child: ClipRRect(
                          child: Image.file(
                            File(widget.files[i]),
                            fit: BoxFit.fill,
                            ),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          color: AdaptiveTheme.of(context).theme.backgroundColor,
                        )),
                  ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(top: 6, bottom: 10, left: 14, right: 14),
              margin: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: AdaptiveTheme.of(context).theme.primaryColor,
              ),
              child: Row(
                children: <Widget>[
                  Flexible(
                      child: Text('Tutaj ma być docelowo tekst przeczytany za pomocą ML Kita z zdjęć', style: AdaptiveTheme.of(context).theme.textTheme.bodyText1,))
                ],
              ),
            ),
          ],
        ),
    );
  }

}