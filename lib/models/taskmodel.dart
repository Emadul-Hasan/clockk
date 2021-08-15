class MyTask {
  String title;
  String id;
  String time;
  String totalCount;

  MyTask(this.title, this.id, this.time, this.totalCount);
}

class MySubTask {
  String title;
  String id;
  bool isDone;
  String time;
  bool visible;

  MySubTask({this.title, this.id, this.isDone, this.time});
}
