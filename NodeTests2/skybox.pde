class SkyBox {
  private PImage front;
  private PImage right;
  private PImage back;
  private PImage left;
  private PImage top;
  private PImage bottom;
   
  SkyBox(String frontTextureFileName,
         String rightTextureFileName,
         String backTextureFileName,
         String leftTextureFileName,
         String topTextureFileName,
         String bottomTextureFileName) {
     
    front   = loadImage(frontTextureFileName);
    right   = loadImage(rightTextureFileName);
    back    = loadImage(backTextureFileName);
    left    = loadImage(leftTextureFileName);
    top     = loadImage(topTextureFileName);
    bottom  = loadImage(bottomTextureFileName);
  }
   
  private int halfWidth    = 1500;
  private int halfHeight   = 1500;
  private int halfDistance = 1499;
   
  private int   dx = 100;
  private int   dy = 100;
  private float textureDY = (float)dy / (2 * halfHeight);  
   
  void render() {
    pushMatrix();
    noStroke();
    noLights();
     
    textureMode(NORMALIZED);
    
  
    
    for(int y = -halfHeight; y < halfHeight; y += dy) {
      float textureY = (float)(y + halfHeight) / (2 * halfHeight);
      beginShape(QUAD_STRIP);
      texture(front);
      for(int x = -halfWidth; x <= halfWidth; x += dx) {
        float textureX = (float)(x + halfWidth) / (2 * halfWidth);
        vertex(x, y,      -halfDistance, textureX, textureY);
        vertex(x, y + dy, -halfDistance, textureX, textureY + textureDY);
      }
      endShape();
    }
     
    rotateY(HALF_PI);
    for(int y = -halfHeight; y < halfHeight; y += dy) {
      float textureY = (float)(y + halfHeight) / (2 * halfHeight);
      beginShape(QUAD_STRIP);
      texture(left);
      for(int x = -halfWidth; x <= halfWidth; x += dx) {
        float textureX = (float)(x + halfWidth) / (2 * halfWidth);
        vertex(x, y,      -halfDistance, textureX, textureY);
        vertex(x, y + dy, -halfDistance, textureX, textureY + textureDY);
      }
      endShape();
    }
     
    rotateY(HALF_PI);
    for(int y = -halfHeight; y < halfHeight; y += dy) {
      float textureY = (float)(y + halfHeight) / (2 * halfHeight);
      beginShape(QUAD_STRIP);
      texture(back);
      for(int x = -halfWidth; x <= halfWidth; x += dx) {
        float textureX = (float)(x + halfWidth) / (2 * halfWidth);
        vertex(x, y,      -halfDistance, textureX, textureY);
        vertex(x, y + dy, -halfDistance, textureX, textureY + textureDY);
      }
      endShape();
    }
 
    rotateY(HALF_PI);
    for(int y = -halfHeight; y < halfHeight; y += dy) {
      float textureY = (float)(y + halfHeight) / (2 * halfHeight);
      beginShape(QUAD_STRIP);
      texture(right);
      for(int x = -halfWidth; x <= halfWidth; x += dx) {
        float textureX = (float)(x + halfWidth) / (2 * halfWidth);
        vertex(x, y,      -halfDistance, textureX, textureY);
        vertex(x, y + dy, -halfDistance, textureX, textureY + textureDY);
      }
      endShape();
    }
    popMatrix();
     
    pushMatrix();
    rotateX(HALF_PI);
    for(int y = -halfHeight; y < halfHeight; y += dy) {
      float textureY = (float)(y + halfHeight) / (2 * halfHeight);
      beginShape(QUAD_STRIP);
      texture(bottom);
      for(int x = -halfWidth; x <= halfWidth; x += dx) {
        float textureX = (float)(x + halfWidth) / (2 * halfWidth);
        vertex(x, y,      -halfDistance, textureX, textureY);
        vertex(x, y + dy, -halfDistance, textureX, textureY + textureDY);
      }
      endShape();
    }
    rotateX(PI);
    for(int y = -halfHeight; y < halfHeight; y += dy) {
      float textureY = (float)(y + halfHeight) / (2 * halfHeight);
      beginShape(QUAD_STRIP);
      texture(top);
      for(int x = -halfWidth; x <= halfWidth; x += dx) {
        float textureX = (float)(x + halfWidth) / (2 * halfWidth);
        vertex(x, y,      -halfDistance, textureX, textureY);
        vertex(x, y + dy, -halfDistance, textureX, textureY + textureDY);
      }
      endShape();
    }   
     
    popMatrix();
  }
}

