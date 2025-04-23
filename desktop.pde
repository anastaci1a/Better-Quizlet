import java.util.List;

// TODO we should not use raw window coordinates, since resizing the window will mess with that
// TODO allowing the user to change the color of flash cards would be cool. Maybe a marker object? Maybe a Highlighter? or maybe we just have different stacks of index cards.
// TODO maybe you can bend the corner to "mark" specific index cards?
// TODO maybe you can write on them using a pencil or store images on them? idk just ideas lol

// TODO control schemes
// PC controls: Click to pick up, then click to use
// Mobile controls: Drag & Drop?

// Desktop = Set of flash cards, their positions, and the other objects and their positions (stack of cards, trash can, etc.)
class Desktop implements Serializable {
  public String name;
  public color backgroundColor;
  
  public List<DesktopItem> items;
  
  public float clickX, clickY;
  public DesktopItem heldItem;
  
  public Desktop(String name, color backgroundColor) {
    this.name = name;
    this.backgroundColor = backgroundColor;
    this.items = new ArrayList<>();
    this.items.add(new FlashCard(100, 100, "Test", "Hello"));
    this.items.add(new FlashCard(100, 100, "Test", "Hello"));
    this.items.add(new FlashCard(100, 100, "Test", "Hello"));
    this.items.add(new FlashCard(100, 100, "Test", "Hello"));
    this.items.add(new FlashCard(100, 100, "Test", "Hello"));
    this.items.add(new FlashCard(100, 100, "Test", "Hello"));
  }
  public Desktop(JSONObject from) {
    this.name = from.getString("name");
    this.backgroundColor = from.getInt("backgroundColor");
    this.items = new ArrayList<>();
  }
  public JSONObject serialize() {
    JSONObject obj = new JSONObject();
    obj.setString("name", this.name);
    obj.setInt("backgroundColor", this.backgroundColor);
    return obj;
  }
  
  public void update() {
    if(this.heldItem != null) {
      this.heldItem.moveBy(mouseX - pmouseX, mouseY - pmouseY);
    }
  }
  public void draw() {
    background(this.backgroundColor);
    
    pushMatrix();
    for(DesktopItem item : this.items) {
      translate(0, 0, 1);
      item.draw();
    }
    popMatrix();
  }
  public void mousePressed() {
    int hover = this.getHoveredIndex();
    if(hover >= 0) {
      DesktopItem item = this.items.get(hover);
      if(mouseButton == LEFT) {
        if(this.heldItem == null) {
          this.pickUp(hover);
        } else {
          item.interact(this.heldItem, LEFT);
        }
      }
      if(mouseButton == RIGHT) {
        item.interact(this.heldItem, RIGHT);
      }
    }
  }
  public void mouseReleased() {
    if(mouseButton == LEFT) {
      this.drop();
    }
  }
  
  public void addItem(DesktopItem item) {
    this.items.add(item);
  }
  public int getHoveredIndex() {
    // Loop backwards so we pick up items on top first
    for(int i = this.items.size() - 1; i >= 0; i--) {
      if(items.get(i).intersects(mouseX, mouseY)) {
        return i;
      }
    }
    return -1;
  }
  public void pickUp(int n) {
    if(this.heldItem != null) {
      this.heldItem.drop();
    }
    
    this.heldItem = items.get(n);
    this.heldItem.pickUp();
    // Move item on top for rendering purposes
    this.items.add(this.items.remove(n));
  }
  public void drop() {
    if(this.heldItem != null) {
      this.heldItem.drop();
      this.heldItem = null;
    }
  }
}

// Processing weirdness kinda prevents doing this in a neater way unless I use static classes... I guess this is fine.
public DesktopItem desktopItemFromJSON(JSONObject from) {
  String type = from.getString("type");
  switch(type) {
    case "FlashCard": return new FlashCard(from);
  }
  throw new IllegalArgumentException("Invalid/Missing type: " + type);
}

// Desktop item = anything that can be moved around on the desktop.
abstract class DesktopItem implements Serializable {
  public float x, y, w, h;
  public boolean held; // Whether this is being moved by the mouse
  
  public DesktopItem() {}
  public DesktopItem(JSONObject from) {
    this.x = from.isNull("x") ? 0.0F : from.getFloat("x");
    this.y = from.isNull("y") ? 0.0F : from.getFloat("y");
    this.w = from.isNull("w") ? 0.0F : from.getFloat("w");
    this.h = from.isNull("h") ? 0.0F : from.getFloat("h");
  }
  public JSONObject serialize() {
    JSONObject obj = new JSONObject();
    obj.setFloat("x", this.x);
    obj.setFloat("y", this.y);
    obj.setFloat("w", this.w);
    obj.setFloat("h", this.h);
    return obj;
  }
  
  public abstract void update();
  public abstract void draw();
  public void interact(DesktopItem held, int button) {}
  
  public void moveTo(float x, float y) {
    this.x = x;
    this.y = y;
  }
  public void moveToCentered(float x, float y) {
    this.x = x - this.w / 2;
    this.y = y - this.h / 2;
  }
  public void moveBy(float x, float y) {
    this.x += x;
    this.y += y;
  }
  public void pickUp() {
    this.held = true;
  }
  public void drop() {
    this.held = false;
  }
  public boolean intersects(float ix, float iy) {
    return ix >= this.x && iy >= this.y && ix <= this.x + this.w && iy <= this.y + this.h;
  }
}

// TODO default constructor?
class FlashCard extends DesktopItem {
  public static final color defaultCardColor = #d9d9d7;
  public static final color defaultCardStrokeColor = #acaca8;
  public static final float defaultWidth = 296.0F;
  public static final float defaultHeight = 210.0F;
  
  public String front, back;
  public boolean flipped; // flipped = back, not flipped = front displayed
  
  public color cardColor;
  
  // TODO flipping animation
  // TODO lines on card
  // TODO sounds when picking up and putting down
  
  public FlashCard(float x, float y, String front, String back) {
    this.x = x;
    this.y = y;
    this.w = defaultWidth;
    this.h = defaultHeight;
    
    this.front = front;
    this.back = back;
    this.cardColor = defaultCardColor;
  }
  public FlashCard(JSONObject from) {
    super(from);
    this.front = from.isNull("front") ? "" : from.getString("front");
    this.back = from.isNull("back") ? "" : from.getString("back");
    this.flipped = from.isNull("flipped") ? false : from.getBoolean("flipped");
    this.cardColor = from.isNull("cardColor") ? defaultCardColor : from.getInt("cardColor");
  }
  public JSONObject serialize() {
    JSONObject obj = super.serialize();
    obj.setString("front", this.front);
    obj.setString("back", this.back);
    obj.setInt("cardColor", this.cardColor);
    obj.setBoolean("flipped", this.flipped);
    return obj;
  }
  
  public void flip() {
    this.flipped = !this.flipped;
  }
  public String getTopText() {
    return this.flipped ? this.back : this.front;
  }
  public String getBottomText() {
    return this.flipped ? this.front : this.back;
  }
  
  public void update() {
    
  }
  public void draw() {
    float drawX, drawY;
    
    if(this.held) {
      drawX = this.x;
      drawY = this.y - 16;
      noStroke();
      fill(#000000, 128);
      rect(x, y, w, h);
    } else {
      drawX = this.x;
      drawY = this.y;
    }
    
    stroke(defaultCardStrokeColor);
    strokeWeight(8.0F);
    fill(this.cardColor);
    rect(drawX, drawY, w, h);
    
    String str = this.getTopText();
    fill(#000000);
    textSize(32);
    textAlign(CENTER, CENTER);
    text(str, drawX, drawY, w, h);
  }
  public void interact(DesktopItem held, int button) {
    if(button == RIGHT) {
      this.flip();
    }
  }
}
