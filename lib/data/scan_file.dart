
enum STATUS {
  RUNNING,
  DONE,
  NONE
}

class ScanFile {
  String name;
  String type;

  STATUS transcription;
  STATUS cloud;

  ScanFile(this.name, this.type, this.transcription, this.cloud);
}