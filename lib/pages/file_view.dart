import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skan/data/scan_file.dart';
import 'package:skan/provider/scan_file_storage.dart';

import '../skan_colors.dart';
import '../widgets/file/file_item.dart';

class FileView extends StatefulWidget{

  const FileView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => FileViewState();

}

class FileViewState extends State<FileView> {

  late final ScanFileStorage _provider;

  List<ScanFile> files = [];

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<ScanFileStorage>(context, listen: false);
  }

  Future loadLocalData() async {
    return await _provider.getFiles() ?? [];
  }


   Future<void> _remove(int index) async {
     var temp = await _provider.getFiles() ?? [];
     temp.removeAt(index);
     _provider.setFiles(temp);
     var data = await loadLocalData();
     setState(() {
      files = data as List<ScanFile>;
    });
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
              files = snapshot.data as List<ScanFile>;
              print(files);
              return ListView.builder(
                  itemCount: files.length,
                  itemBuilder: (ctx, index) {
                return FileItem(scanFile: files[index], index: index, onRemove: _remove,)
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