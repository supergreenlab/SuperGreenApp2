enum Status {
  NOT_SET,
  LOADED_FROM_CACHE,
  LOADED,
  LOAD_ERROR,
}

class ParamData<T> {
  final String deviceId;
  final String moduleName;

  final String key;
  T value;

  Status status = Status.NOT_SET;

  ParamData(this.deviceId, this.moduleName, this.key);
}