import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:skan/data/scan_file.dart';
import 'package:skan/data/scan_file_storage.dart';

import '../skan_colors.dart';
import '../widgets/file_item.dart';

class FileView extends StatefulWidget{

  const FileView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => FileViewState();

}

class FileViewState extends State<FileView> {

  List<ScanFile> files = [];

  @override
  void initState() {
    super.initState();
    loadLocalData();
  }

  Future loadLocalData() async {
    files = await ScanFileStorage?.getFiles() ?? [];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print("rebuild file");
    return Container(
        decoration: BoxDecoration(color: AdaptiveTheme.of(context).theme.backgroundColor),
        padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
        child: ListView.builder(
          itemCount: files.length,
          itemBuilder: (ctx, index) {
            return FileItem(
                file_name: files[index].name,
                file_type: files[index].type,
                transcription: files[index].transcription,
                upload: files[index].cloud)
            ;
          },
          padding: const EdgeInsets.all(15),
          // children: [
          //   for (ScanFile sf in files) ,
          //   FileItem(file_name: "siema1", file_type: "photo / text", file_lang: "PL", transcription: STATUS.NONE, upload: STATUS.DONE),
          //   FileItem(file_name: "siema1", file_type: "type 1", file_lang: "BR", transcription: STATUS.DONE, upload: STATUS.RUNNING),
          //   FileItem(file_name: "siema1", file_type: "type 1", transcription: STATUS.NONE, upload: STATUS.RUNNING),
          //   FileItem(file_name: "siema1", file_type: "type 1", transcription: STATUS.RUNNING, upload: STATUS.NONE),
          //   FileItem(file_name: "siema1", file_type: "type 1", transcription: STATUS.NONE, upload: STATUS.RUNNING),
          //   FileItem(file_name: "siema1", file_type: "type 1", transcription: STATUS.NONE, upload: STATUS.RUNNING),
          //   FileItem(file_name: "siema1", file_type: "type 1", transcription: STATUS.NONE, upload: STATUS.RUNNING),
          //   FileItem(file_name: "siema1", file_type: "type 1", transcription: STATUS.NONE, upload: STATUS.RUNNING),
          //   FileItem(file_name: "siema1", file_type: "type 1", transcription: STATUS.NONE, upload: STATUS.RUNNING),
          //   FileItem(file_name: "siema1", file_type: "type 1", transcription: STATUS.NONE, upload: STATUS.RUNNING),
          //   FileItem(file_name: "siema1", file_type: "type 1", transcription: STATUS.NONE, upload: STATUS.RUNNING),
          // ],
        )
    );
  }

}