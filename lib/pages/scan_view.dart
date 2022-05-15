import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:skan/data/scan_file.dart';
import 'package:skan/provider/scan_file_storage.dart';
import 'package:skan/widgets/scan/scan_image_preview.dart';

class ScanViewState extends State<ScanView> {
  late final ScanFileStorage _provider;
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<ScanFileStorage>(context, listen: false);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Future loadTempImages() async {
    return await _provider.getTempImageLocation() ?? [];
  }

  Future<void> _add(String path) async {
    var tempImages = await _provider.getTempImageLocation() ?? [];
    tempImages.add(path);
    _provider.setTempImageLocation(tempImages);
  }

  Future<void> _reorder(int oldIndex, int newIndex) async {
    var tempImages = await _provider.getTempImageLocation() ?? [];
    String tmp = tempImages.removeAt(oldIndex);
    tempImages.insert(newIndex, tmp);
    _provider.setTempImageLocation(tempImages);
  }

  Future<void> _remove(int index) async {
    var tempImages = await _provider.getTempImageLocation() ?? [];
    String value = tempImages.removeAt(index);
    File(value).delete();
    _provider.setTempImageLocation(tempImages);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadTempImages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const CircularProgressIndicator();
        } else {
          return Container(
              decoration: BoxDecoration(
                  color: AdaptiveTheme.of(context).theme.backgroundColor),
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).viewPadding.top,
                  left: 8,
                  right: 8),
              child: SingleChildScrollView(
                  child: Column(children: [
                ScanImagePreview(
                    add: _add,
                    reorder: _reorder,
                    reload: loadTempImages,
                    remove: _remove,
                    files: snapshot.data as List<String>),
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                AdaptiveTheme.of(context).theme.highlightColor),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      hintText: 'Nazwa pliku',
                    ),
                  ),
                ),
                GestureDetector(
                    onTap: () async {
                      String name = textController.text;

                      if (name == '') {
                        return;
                      }

                      var temp = await _provider.getTempImageLocation() ?? [];

                      if (temp.isEmpty) {
                        return;
                      }

                      ScanFile sf = ScanFile(
                          name: name,
                          type: "image",
                          cloud: STATUS.NONE,
                          transcription: STATUS.NONE,
                          created: DateTime.now(),
                          files: temp);
                      _provider.addFiles(sf);
                      _provider.setTempImageLocation([]);
                      textController.text = "";
                      widget.moveBack(0);

                      setState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      margin: const EdgeInsets.only(bottom: 14 + 65, top: 14),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(16)),
                        color: AdaptiveTheme.of(context).theme.primaryColor,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              child: Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 15,
                            children: [
                              Icon(FontAwesomeIcons.file,
                                  size: 24,
                                  color: AdaptiveTheme.of(context)
                                      .theme
                                      .iconTheme
                                      .color),
                              Text(
                                "Zapisz plik",
                                style: AdaptiveTheme.of(context)
                                    .theme
                                    .textTheme
                                    .headline1,
                                textAlign: TextAlign.center,
                              )
                            ],
                          ))
                        ],
                      ),
                    ))
              ])));
        }
      },
    );
  }
}

class ScanView extends StatefulWidget {
  final void Function(int) moveBack;

  const ScanView({Key? key, required this.moveBack}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ScanViewState();
}
