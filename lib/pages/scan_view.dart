import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';
import 'package:skan/data/scan_file.dart';
import 'package:skan/provider/scan_file_storage.dart';
import 'package:skan/octicons_icons.dart';
import 'package:skan/pages/camera_view.dart';
import 'package:skan/widgets/scan_image_widget.dart';
import 'package:toggle_switch/toggle_switch.dart';

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

  Future<void> _reorder(int oldIndex, int newIndex) async {
    var tempImages = await _provider.getTempImageLocation() ?? [];
    String tmp = tempImages.removeAt(oldIndex);
    tempImages.insert(newIndex, tmp);
    _provider.setTempImageLocation(tempImages);
  }

  @override
  Widget build(BuildContext context) {
    print("rebuid scan");
    return FutureBuilder(
      future: loadTempImages(),
      builder: (context, snapshot) {
        print(snapshot.data);
        if (snapshot.connectionState != ConnectionState.done) {
          return const CircularProgressIndicator();
        } else {
          return Container(
              decoration: BoxDecoration(
                  color: AdaptiveTheme
                      .of(context)
                      .theme
                      .backgroundColor),
              padding: EdgeInsets.only(top: MediaQuery
                  .of(context)
                  .viewPadding
                  .top, left: 8, right: 8),
              child: SingleChildScrollView(child: Column(children: [
                ReorderableWrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (String img in snapshot.data as List<String>)
                        ScanImageWidget(
                          child: Image.file(
                            File(img),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ReorderableWidget(
                          child: ScanImageWidget(
                            border: true,
                            child: GestureDetector(
                              child: Icon(
                                Octicons.plus_16,
                                size: 48,
                              ),
                              onTap: () {
                                print("next page");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (
                                            context) => const CameraView()));
                              },
                            ),
                          ),
                          reorderable: false,
                          key: ValueKey('Enable drag'))
                    ],
                    onReorder: _reorder),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AdaptiveTheme
                            .of(context)
                            .theme
                            .highlightColor),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      hintText: 'Nazwa pliku',
                    ),
                  ),

                ),
                Container(
                  padding: const EdgeInsets.only(left: 14),
                  margin: const EdgeInsets.only(top: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    color: AdaptiveTheme
                        .of(context)
                        .theme
                        .primaryColor,
                  ),
                  child: Row(
                    children: [
                      Text('Nie wiem w sumie co tu lol', style: AdaptiveTheme.of(context).theme.textTheme.bodyText1,),
                      Expanded(child: Wrap(
                        alignment: WrapAlignment.end,
                        children: [
                          ToggleSwitch(
                            totalSwitches: 2,
                            minWidth: 55,
                            minHeight: 30,
                            onToggle: (index) {
                              if (index == 0) {

                              } else {

                              }
                            },
                            customIcons: [
                              Icon(Octicons.heart_16, color: Colors.red, size: 16,),
                              Icon(Octicons.heart_fill_16, color: AdaptiveTheme.of(context).theme.primaryColor, size: 16,)
                            ],
                          )
                        ],
                      )),
                    ],
                  ),
                ),
                GestureDetector(
                    onTap: () async {

                      String name = textController.text;

                      if (name == '') {
                        return;
                      }

                      var temp = await _provider.getTempImageLocation() ?? [];
                      ScanFile sf = ScanFile(name: name,
                          type: "image",
                          cloud: STATUS.NONE,
                          transcription: STATUS.NONE,
                          files: temp);
                      _provider.addFiles(sf);
                      _provider.setTempImageLocation([]);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      margin: const EdgeInsets.only(bottom: 14 + 65, top: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        color: AdaptiveTheme
                            .of(context)
                            .theme
                            .primaryColor,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 15,
                                children: [
                                  Icon(Octicons.file_16,
                                      size: 24,
                                      color: AdaptiveTheme
                                          .of(context)
                                          .theme
                                          .iconTheme
                                          .color),
                                  Text(
                                    "Zapisz plik",
                                    style: AdaptiveTheme
                                        .of(context)
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
  const ScanView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ScanViewState();
}
