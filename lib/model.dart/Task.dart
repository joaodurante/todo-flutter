class Task {
  int _id;
  String _description;
  bool _done;
  DateTime _createdAt;
  DateTime _updateAt;

  Task(this._id, this._description, this._done, this._createdAt, [this._updateAt]);

  int get id {
    return _id;
  }

  String get description {
    return _description;
  }

  bool get done {
    return _done;
  }

  DateTime get createdAt {
    return _createdAt;
  }

  DateTime get updateAt {
    return _updateAt;
  }
}