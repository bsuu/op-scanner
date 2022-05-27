import 'dart:convert';
import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:archive/archive_io.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
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
    loadFilesFromClud();
  }

  Future loadLocalData() async {
    return await _provider.getFiles() ?? [];
  }

  void loadFilesFromClud() async {
    final user = FirebaseAuth.instance.currentUser!;
    final String? userMail = user.email;
    if (userMail == null) return;

    Reference fbs = FirebaseStorage.instance.ref();
    Reference fbsf = fbs.child("$userMail");
    ListResult lista = await fbsf.listAll();
    var temp = await _provider.getFiles() ?? [];
    for (var cloudFile in lista.items) {
      bool contains = false;
      for (var localFile in temp) {
        if (cloudFile.fullPath.contains(localFile.uuid)) {
          contains = true;
          break;
        }
      }
      if (!contains) {
        print("Sync plikow");
        Reference fileCloud = FirebaseStorage.instance.ref(cloudFile.fullPath);
        final Directory tempDir = await getTemporaryDirectory();
        File tempFile = File(tempDir.path + "/" + cloudFile.name);
        await fileCloud.writeToFile(tempFile);
        await tempFile.create();

        final Directory scanDir = await getApplicationDocumentsDirectory();

        await extractFileToDisk(tempFile.path, scanDir.path + "/" + cloudFile.name.replaceAll(".zip", ""));
        File data =
            File(scanDir.path + "/" + cloudFile.name.replaceAll(".zip", "") + "/fileData.json");

        Directory test = Directory(scanDir.path + "/" + cloudFile.name.replaceAll(".zip", ""));
        print(test.listSync());

        String dataString = data.readAsStringSync();
        ScanFile scanFile = ScanFile.fromJson(json.decoder.convert(dataString));
        print(scanFile.uuid);
        _provider.addFiles(scanFile);
        setState(() {});
        tempFile.delete();
      }
    }
  }

  Future<void> _save() async {
    _provider.setFiles(files);
  }

  Future<void> _remove(int index) async {
    var temp = await _provider.getFiles() ?? [];
    ScanFile sftemp = temp.removeAt(index);
    String dir = await sftemp.getScanLocation();
    Directory(dir).delete(recursive: true);
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
