import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skan/data/scan_file.dart';
import 'package:skan/provider/scan_file_storage.dart';

import '../skan_colors.dart';
import '../widgets/file_item.dart';

class FileView extends StatefulWidget{

  const FileView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => FileViewState();

}

class FileViewState extends State<FileView> {

  late final ScanFileStorage _provider;
  @override
  void initState() {
    super.initState();
    _provider = Provider.of<ScanFileStorage>(context, listen: false);
  }

  Future loadLocalData() async {
    return await _provider.getFiles() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: AdaptiveTheme.of(context).theme.backgroundColor),
        padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
        child: FutureBuilder(
          future: loadLocalData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const CircularProgressIndicator();
            } else {
              print(snapshot);
              List<ScanFile> files = snapshot.data as List<ScanFile>;
              return ListView.builder(
                  itemCount: files.length,
                  itemBuilder: (ctx, index) {
                return FileItem(
                    file_name: files[index].name,
                    file_type: files[index].type,
                    transcription: files[index].transcription,
                    upload: files[index].cloud)
                ;
              },
            padding: const EdgeInsets.all(15)
              );
            }
          },
        )
        );
  }

}