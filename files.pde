import java.io.File;

static interface Serializable {
    public JSONObject serialize();
}


// --


boolean fileExists(String fullPath) {
  String[] fullPath_split = fullPath.split("/");
  String filenameToSearch = fullPath_split[fullPath_split.length - 1];
  String dir = "";
  for (int i = 0; i < fullPath_split.length - 1; i++) dir += fullPath_split[i] + (i < fullPath_split.length - 2 ? "/" : "");
  
  java.io.File dirObj = new java.io.File(dir);
  String[] dir_files = dirObj.list();
  
  boolean fileExists = false;
  for (String filename : dir_files) {
    if (filename.equals(filenameToSearch)) {
      fileExists = true;
      break;
    }
  }
  
  return fileExists;
}


// --


void initSets() {
  // check savedata
  boolean savedataExists = fileExists(dataPath(Config.SAVEDATA_FOLDER_NAME));
  if (savedataExists) Console.verbose("savedata found.");
  
  // create savedata folder
  else {
    Console.verbose("savedata not found. creating..." );
    
    try {
      createOutput(dataPath(Config.SAVEDATA_FOLDER_NAME + "/" + Config.SAVEDATA_META_FILENAME));
    } catch (Exception err) {
      Console.error("error creating savedata: [", err, "]");
      exit();
    }
    Console.verbose("created savedata.");
  }
  
  
// --
  
  
  String metadata_path = dataPath(Config.SAVEDATA_FOLDER_NAME + "/" + Config.SAVEDATA_META_FILENAME);
  boolean metadata_exists = fileExists(metadata_path);
  if (!savedataExists) metadata_exists = false;
  
  
  JSONObject metadata = new JSONObject();
  
  JSONObject metadata_blank = new JSONObject().setJSONArray("sets", new JSONArray());
  JSONArray setNames_JSON = metadata_blank.getJSONArray("sets");
  String[] setNames_str = new String[0];
  
  // load metadata
  if (metadata_exists) {
    try {
      metadata = loadJSONObject(metadata_path);
      setNames_JSON = metadata.getJSONArray("sets");
      setNames_str = setNames_JSON.toStringArray();
      
      saveJSONObject(metadata, metadata_path);
    } catch (Exception err) {
      Console.error("error parsing metadata: [", err, "]");
      exit();
    }
    Console.verbose("metadata loaded.");
  }
  
  // create metadata
  else {
    if (savedataExists) Console.verbose("metadata not found. creating...");
    createOutput(metadata_path);
    
    try {
      createOutput(metadata_path);
    } catch (Exception err) {
      Console.error("error creating metadata: [", err, "]");
      exit();
    }
    
    metadata = metadata_blank;
    saveJSONObject(metadata, metadata_path);
    Console.verbose("created metadata.");
  }
  
  
  // --
  
  
  // parse sets
  
  int setsAmount = setNames_str.length;
  Console.verbose("\nloading", setsAmount, "set" + (setsAmount == 1 ? "" : "s") + "...");
  
  HashMap<String, Table> setsCSV = new HashMap<String, Table>();
  StringList setsLoaded = new StringList();
  
  for (String setName : setNames_str) {
    String setCSV_path = dataPath(Config.SAVEDATA_FOLDER_NAME + "/" + setName + ".csv");
    boolean setExists = fileExists(setCSV_path);
    
    if (setExists) {
      Console.verboseNB("> parsing \"" + setName + "\"...");
      
      boolean setParsed = true;
      Table setCSV = new Table();
      
      try {
        setCSV = loadTable(setCSV_path);
      } catch (Exception err_parse) {
        setParsed = false;
        Console.verbose();
        Console.error("--> error parsing set: [", err_parse, "]");
      }
      
      if (setParsed) {
        setsCSV.put(setName, setCSV);
        setsLoaded.append(setName);
        Console.verbose("done.");
      }
    } else {
      Console.error("> set not found: \"" + setName + "\"");
    }
  }
  
  int setsLoadedAmount = setsLoaded.size();
  int setsErrorsAmount = setsAmount - setsLoadedAmount;
  
  String setsErrorStatus = "(" + str(setsErrorsAmount) + " error" + (setsErrorsAmount == 1 ? "" : "s") + ")";
  Console.verbose("loaded", setsLoadedAmount, "set" + (setsLoadedAmount == 1 ? "" : "s") + ". " + setsErrorStatus);
}
