import 'package:intl/intl.dart';

class Task {
  String _id,
      _name,
      _description,
      _ownerId,
      _assignedId,
      _status,
      _startDate,
      _finishDate;

  bool isMy = false;
  bool assignToMe = false;

  Task.full(this._id, this._name, this._description, this._ownerId,
      this._assignedId, this._status, this._startDate, this._finishDate);

  Task.setStatus(this._id, this._status);

  Task(this._ownerId) {
    this.id = '';
    this.name = '';
    this.status = "New";
    this.description = '';
    this.assignedId = '';
    this.startDate = '0';
    this.finishDate = '0';
  }

  String get name => _name;

  get id => _id;

  get description => _description;

  get startDate => _dataConvert(_startDate);

  get finishDate => _dataConvert(_finishDate);

  get ownerId => _ownerId;

  get assignedId => _assignedId;

  get status => _status;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'startDate': (startDate),
        'finishDate': (finishDate),
        'ownerId': ownerId,
        'assignedId': assignedId,
        'status': status,
      };

  String _dataConvert(String time) {
    var formatter = new DateFormat('yyyy-MM-dd HH:mm');
    if (time != null && time != "0" && time != "") {
      return formatter.format(DateTime.parse(time).toLocal());
    } else {
      return '';
    }
  }

  String dataDuration(Task task) {
    DateTime sTime = DateTime.fromMillisecondsSinceEpoch(task.startDate);
    DateTime fTime = DateTime.fromMillisecondsSinceEpoch(task.finishDate);

    return fTime.difference(sTime).inMinutes.toString();
  }

  set id(String value) {
    _id = value;
  }

  set status(value) {
    _status = value;
  }

  set assignedId(value) {
    _assignedId = value;
  }

  set ownerId(value) {
    _ownerId = value;
  }

  set finishDate(value) {
    _finishDate = (value);
  }

  set startDate(value) {
    _startDate = (value);
  }

  set description(value) {
    _description = value;
  }

  set name(value) {
    _name = value;
  }
}
