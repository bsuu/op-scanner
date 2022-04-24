import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skan/data/scan_file.dart';
import 'package:skan/provider/scan_file_storage.dart';

import '../widgets/file/file_item.dart';
import 'item_view.dart';

class FileView extends StatefulWidget {
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

  Future<void> _save() async {
    _provider.setFiles(files);
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
        decoration: BoxDecoration(
            color: AdaptiveTheme.of(context).theme.backgroundColor),
        padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
        child: FutureBuilder(
          future: loadLocalData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const CircularProgressIndicator();
            } else {
              files = snapshot.data as List<ScanFile>;
              return ListView.builder(
                  itemCount: files.length,
                  itemBuilder: (ctx, index) {
                    return GestureDetector(
                      child: FileItem(
                          scanFile: files[index],
                          index: index,
                          onRemove: _remove,
                          onSave: _save),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ItemView(scanFile: files[index])));
                      },
                    );
                  },
                  padding: const EdgeInsets.all(15));
            }
          },
        ));
  }
}
