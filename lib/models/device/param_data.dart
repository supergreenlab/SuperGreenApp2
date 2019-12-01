enum Status {
  NOT_SET,
  LOADED_FROM_CACHE,
  LOADED,
  LOAD_ERROR,
}

class ParamData<T> {
  final String controllerId;
  final String module;

  final String key;
  T value;

  Status status = Status.NOT_SET;

  ParamData(this.controllerId, this.module, this.key);
}