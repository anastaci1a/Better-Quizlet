static class Config {
  // window
  static final String WINDOW_TITLE  = "Quizlet (but better)";
  static final int    WINDOW_WIDTH  = 1024;
  static final int    WINDOW_HEIGHT = 720;
  
  // files
  static final String SAVEDATA_FOLDER_NAME   = "Saved Sets";
  static final String SAVEDATA_META_FILENAME = "meta.json";
  
  // logging
  static final int LOG_LEVEL = 2; /**
                                   * 0: errors only
                                   * 1: above + status msgs
                                   * 2: above + verbose
                                   */
}


// --


void cfgSurface() {
  surface.setTitle(Config.WINDOW_TITLE);
  surface.setResizable(true);
  
  int windowX = (displayWidth / 2) - (width / 2);;
  int windowY = (displayHeight / 2) - int(height / 1.5); // slightly above center
  surface.setLocation(windowX, windowY);
}
