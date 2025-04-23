static class Console {
  static void error(Object... objs) {
    logLevel(0, objs);
  }
  static void errorNB(Object... objs) {
    logLevelNB(0, objs);
  }
  
  static void status(Object... objs) {
    logLevel(1, objs);
  }
  static void statusNB(Object... objs) {
    logLevelNB(1, objs);
  }
  
  static void verbose(Object... objs) {
    logLevel(2, objs);
  }
  static void verboseNB(Object... objs) {
    logLevelNB(2, objs);
  }
  
  // --
  
  static void logLevel(int logLevel, Object[] objs) {
    if (logLevel <= Config.LOG_LEVEL) {
      for (int i = 0; i < objs.length; i++) {
        Object obj = objs[i];
        
        String objEnd = i == objs.length - 1 ? "\n" : "";
        print(obj, objEnd);
      }
    }
  }
  
  static void logLevelNB(int logLevel, Object[] objs) {
    if (logLevel <= Config.LOG_LEVEL) {
      for (Object obj : objs) print(obj, "");
    }
  }
}
