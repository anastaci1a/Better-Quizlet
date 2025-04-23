class GUI {
  IntVector windowDims;
  
  GUI() {
    windowDims = new IntVector(width, height);
  }
  
  void initScaling() {
    
  }
  
  void windowResized() {
    IntVector windowDims_compare = new IntVector(width, height);
    
    if (!windowDims.equals(windowDims_compare)) windowResized();
  }
}


// --


class IntVector {
  int x, y, z;
  
  IntVector(int x, int y) {
    this.x = x;
    this.y = y;
    this.z = 0;
  }
  
  IntVector(int x, int y, int z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  
  // --
  
  
  boolean equals(IntVector v) {
    return (v.x == x) && (v.y == y) && (v.z == z);
  }
  
  IntVector copy() {
    return new IntVector(x, y, z);
  }
  
  
  // --
  
  
  IntVector set(int x, int y) {
    this.x = x;
    this.y = y;
    
    return this;
  }
  
  IntVector set(int x, int y, int z) {
    this.x = x;
    this.y = y;
    this.z = z;
    
    return this;
  }
  
  IntVector add(int x, int y) {
    this.x += x;
    this.y += y;
    
    return this;
  }
  
  IntVector add(int x, int y, int z) {
    this.x += x;
    this.y += y;
    this.z += z;
    
    return this;
  }
  
  IntVector add(IntVector v) {
    x += v.x;
    y += v.y;
    z += v.z;
    
    return this;
  }
  
  IntVector sub(IntVector v) {
    x -= v.x;
    y -= v.y;
    z -= v.z;
    
    return this;
  }
}
