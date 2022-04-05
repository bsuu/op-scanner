

import 'package:flutter/cupertino.dart';

import '../skan_colors.dart';
import '../widgets/file_item.dart';

class FileView extends StatefulWidget{

  const FileView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => FileViewState();

}

class FileViewState extends State<FileView> {

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(color: background),
        padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            FileItem(file_name: "siema1", file_type: "photo / text", file_lang: "PL", transcription: STATUS.SADGE, upload: STATUS.DONE),
            FileItem(file_name: "siema1", file_type: "type 1", file_lang: "BR", transcription: STATUS.DONE, upload: STATUS.RUNNING),
            FileItem(file_name: "siema1", file_type: "type 1", transcription: STATUS.SADGE, upload: STATUS.RUNNING),
            FileItem(file_name: "siema1", file_type: "type 1", transcription: STATUS.RUNNING, upload: STATUS.SADGE),
            FileItem(file_name: "siema1", file_type: "type 1", transcription: STATUS.SADGE, upload: STATUS.RUNNING),
            FileItem(file_name: "siema1", file_type: "type 1", transcription: STATUS.SADGE, upload: STATUS.RUNNING),
            FileItem(file_name: "siema1", file_type: "type 1", transcription: STATUS.SADGE, upload: STATUS.RUNNING),
            FileItem(file_name: "siema1", file_type: "type 1", transcription: STATUS.SADGE, upload: STATUS.RUNNING),
            FileItem(file_name: "siema1", file_type: "type 1", transcription: STATUS.SADGE, upload: STATUS.RUNNING),
            FileItem(file_name: "siema1", file_type: "type 1", transcription: STATUS.SADGE, upload: STATUS.RUNNING),
            FileItem(file_name: "siema1", file_type: "type 1", transcription: STATUS.SADGE, upload: STATUS.RUNNING),
          ],
        )
    );
  }

}