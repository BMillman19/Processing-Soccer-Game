abstract class Node
{
  abstract void draw();
}

abstract class ShapeNode extends Node implements Collideable
{
  protected PVector myColor;
  PVector myPosition;
  PImage myTexture = null;
  
  ShapeNode(String inputTexture, PVector inputColor)
  {
    if(inputTexture != null)
      myTexture = loadImage(inputTexture);      
    myColor = inputColor;
    myPosition = new PVector();
  }  
  void draw()
  {
    myPosition.x = modelX(0,0,0);
    myPosition.y = modelY(0,0,0);
    myPosition.z = modelZ(0,0,0);
    noStroke();
    if(myColor != null)
      fill(myColor.x, myColor.y, myColor.z);
    else
      noFill();
  }
   
}

class CylinderNode extends ShapeNode
{
  private float myWidth, myHeight;
  
  CylinderNode(String inputTexture, PVector inputColor, float inputWidth, float inputHeight)
  {
    super(inputTexture, inputColor);
    myWidth = inputWidth;
    myHeight = inputHeight;
  }
  
  void draw()
  {
    super.draw();
    cylinder(myWidth,myHeight);
  }
  
  void collide()
  {
  }
  
  void cylinder(float w, float h)
  {
    int sides = 100;
    float angle;
    float[] x = new float[sides+1];
    float[] z = new float[sides+1];
   
    //get the x and z position on a circle for all the sides
    for(int i=0; i < x.length; i++){
      angle = TWO_PI / (sides) * i;
      x[i] = sin(angle) * w;
      z[i] = cos(angle) * w;
    }
   
    if(texturesON && (myTexture != null))
    {
      beginShape(TRIANGLE_FAN);
      textureMode(NORMALIZED);
      texture(myTexture);
      vertex(0,   -h/2,    0,0,0);
   
      for(int i=0; i < x.length; i++)
      {
        vertex(x[i], -h/2, z[i],1,1);
      }
      endShape();
    }
    else{
    //draw the top of the cylinder
      beginShape(TRIANGLE_FAN);

      vertex(0,   -h/2,    0);
      for(int i=0; i < x.length; i++)
      {
        vertex(x[i], -h/2, z[i]);
      }
      endShape();
    }
   
    //draw the center of the cylinder
    beginShape(QUAD_STRIP); 
   
    for(int i=0; i < x.length; i++){
      vertex(x[i], -h/2, z[i]);
      vertex(x[i], h/2, z[i]);
    }
   
    endShape();
   
    //draw the bottom of the cylinder
    beginShape(TRIANGLE_FAN); 
   
    vertex(0,   h/2,    0);
   
    for(int i=0; i < x.length; i++){
      vertex(x[i], h/2, z[i]);
    }
   
    endShape();
  }
}

class SphereNode extends ShapeNode
{
  private float myRadius;
  private boolean isLightSource;
  
  SphereNode(String inputTexture, PVector inputColor, float inputRadius, boolean hasLight)
  {
    super(inputTexture, inputColor);
    myRadius = inputRadius;
    isLightSource = hasLight;
  }
 
  
  void draw()
  {
    if(isLightSource){
      myPosition.x = modelX(0,0,0);
      myPosition.y = modelY(0,0,0);
      myPosition.z = modelZ(0,0,0);
      noFill();
      if(myColor != null)
        stroke(myColor.x, myColor.y, myColor.z);
      else
        noStroke();
      sphere(myRadius);
      pointLight(100,100,100,0,0,0);
    }
    else{ 
      super.draw();
      sphere(myRadius);
    }
  }  
  
  void collide()
  {
  }
}

class BoxNode extends ShapeNode
{
  private float myWidth,myHeight,myDepth;
  
  BoxNode(String inputTexture,PVector inputColor, float inputWidth, float inputHeight, float inputDepth)
  {
    super(inputTexture,inputColor);
    myWidth = inputWidth;
    myHeight = inputHeight;
    myDepth = inputDepth;
  }
  
  void draw()
  {
    super.draw();
    box(myWidth, myHeight, myDepth);
  } 
 
  void collide()
  {
  } 
  
}

class PlaneNode extends ShapeNode
{
  private float myWidth, myLength;
  private PVector myNormal;
  
  PlaneNode(String inputTexture,PVector inputColor, float inputWidth, float inputLength)
  {
    super(inputTexture, inputColor);
    myWidth = inputWidth/2;
    myLength = inputLength/2;
    myNormal = new PVector();
  }
  
  void draw()
  {
    super.draw();
    myNormal.x = center.x-myPosition.x;
    myNormal.y = center.y-myPosition.y;
    myNormal.z = center.z-myPosition.z;
    myNormal.normalize();
    //print(myNormal);
    if(texturesON && (myTexture != null))
    {
      float widthNum = (float)Math.ceil(myWidth / 200);
      float lengthNum = (float)Math.ceil(myLength / 200);
      
      float widthFactor = myWidth / widthNum;
      float lengthFactor = myLength / lengthNum;
     
      for (int i = 0;  i < widthNum*2; i++)
      {
        for (int j = 0;  j < lengthNum*2; j++)
        {
          beginShape(QUAD_STRIP);
          textureMode(NORMALIZED);
          texture(myTexture);
          vertex(myWidth - (i * widthFactor), 0, myLength - (j * lengthFactor),0,1);    
          vertex(myWidth - ((i + 1) * widthFactor), 0, myLength - (j * lengthFactor),1,0); 
          vertex(myWidth - (i * widthFactor), 0, myLength - ((j + 1) * lengthFactor),1,1);                    
          vertex(myWidth - ((i + 1) * widthFactor), 0, myLength - ((j + 1) * lengthFactor),0,0);                    
          endShape(); 
        }
      }       
    }
    else
    {   
      beginShape(QUAD_STRIP);
      vertex(myWidth,0,myLength);
      vertex(-1 * myWidth,0,myLength);
      vertex(myWidth,0,-1 * myLength);  
      vertex(-1 * myWidth,0,-1 * myLength);
      endShape();    
    }

  }
  
  void collide()
  {
    //print(position);
//   if (ball.location.x > myPosition.x + myWidth || ball.location.x < myPosition.x - myWidth)
//      return;
//   if (ball.location.z > myPosition.z + myWidth || ball.location.z < myPosition.z - myWidth)
//      return;
//   if ((ball.location).y + ball.radius > myPosition.y)
//    {
//      ball.speed.y*=-1;
//      if (abs(ball.speed.y) < .5) 
//        ball.speed.y =0;
//      ball.location.y = myPosition.y - ball.radius;
//    }
    float distance =  PVector.dot(ball.vectorFrom(myPosition), myNormal);
    distance -= ball.radius;
    //println(distance);
    if (distance < 2 && distance > -2) 
    {
      ball.speed.x -= (2 * myNormal.x * (myNormal.x * ball.speed.x) );
      ball.speed.y -= (2 * myNormal.y * (myNormal.y * ball.speed.y) );
      ball.speed.z -= (2 * myNormal.z * (myNormal.z * ball.speed.z) );
      //println (myNormal);
    }
  }
}



class GroupNode extends Node
{
  private List<Node> myChildren;
  private List<Transform> myTransforms;
  
  GroupNode()
  {
    myChildren = new ArrayList<Node>();
    myTransforms = new ArrayList<Transform>();
  }
  
  void addChild(Node... children)
  {
    for (Node n: children)
      myChildren.add(n);
  }
  
  void addTransform(Transform trans)
  {
    myTransforms.add(trans);
  }
  
  void draw()
  {
    pushMatrix();
    for (Transform t: myTransforms)
      t.applyTransform();
        
    for (int i = 0; i < myChildren.size(); i++) 
    {
      Node n = myChildren.get(i);
      n.draw();
    }
    popMatrix();

  }
}
 


