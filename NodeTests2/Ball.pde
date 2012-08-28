float gravity = 0.2;

class Ball extends Node{

   int pts = 40; 
  float angle = 0;
  //float radius = 1.0;
  
  // lathe segments
  int segments = 60;
  float latheAngle = 0;
  float latheRadius = 0;
  PVector vertices[], vertices2[];
  PVector location = new PVector();
  PVector position = new PVector();
  PVector speed;
  boolean isWireFrame = false;

  int radius; 

  Ball(PVector speed, int radius) {
    this.speed = speed;
    this.radius = radius;
    position.x = 0;
    position.y = 0;
    position.z = 0;
  }  
  Ball(PVector speed, int radius, PVector position) {
    this.speed = speed;
    this.radius = radius;
    this.position = position;
  }  

  void update() {
    speed.y+= gravity;
    position.add(speed);
    location.x = modelX(position.x,position.y,position.z);
    location.y = modelY(position.x,position.y,position.z);
    location.z = modelZ(position.x,position.y,position.z);

  }

//  void collide() {
//    for (int i=0; i < balls.size() -1; i++) {
//      Ball ballA = (Ball) balls.get(i);
//      for (int j= i+1; j < balls.size(); j++) {
//        Ball ballB = (Ball) balls.get(j);
//        if (!ballA.equals(ballB) && ballA.location.dist(ballB.location) < (ballA.radius+ ballB.radius)) {
//          bounce(ballA,ballB);
//        }
//      }
//    }
//  }

  void roll()
  {
    pushMatrix();
    rotateX(frameCount*speed.z*PI/2000);
    rotateZ(frameCount*speed.x*PI/2000);
    popMatrix();
  }

  void draw() {
    this.update();
    boolean light = false;
    noStroke();
    if (light == true){
      fill(10,200,200);
    }else{
      fill(250,250,0);                    
    }
    pushMatrix();
    translate(position.x,position.y,position.z);
    roll();
    //println(location.x + ", " + location.y + ", " + location.z);
    if (isWireFrame)
      {
        stroke(10, 10, 10);
        noFill();
      } 
    //scale(radius);
    drawSphere();
    popMatrix();
    
    //shadow
//    fill(60);
//    ellipse(location.x,390,radius*2 + radius*2*(390 - location.y)/390,radius*3/4);
    
    
  }


  void setSpeed(PVector speed)
  {
    this.speed = speed;
  }
  void bounce(Ball ballA, Ball ballB) {
    PVector ab = new PVector();
    ab.set(ballA.location);
    ab.sub(ballB.location);
    ab.normalize();
    while(ballA.location.dist(ballB.location) < (ballA.radius + ballB.radius)) {   //*spring) {
      ballA.location.add(ab);
    }
    PVector n = PVector.sub(ballA.location, ballB.location);
    n.normalize();
    PVector u = PVector.sub(ballA.speed, ballB.speed);
    PVector un = componentVector(u,n);
    u.sub(un);
    ballA.speed = PVector.add(u, ballB.speed);
    ballB.speed= PVector.add(un, ballB.speed);
  }

  PVector componentVector (PVector vector, PVector directionVector) {
    directionVector.normalize();
    directionVector.mult(vector.dot(directionVector));
    return directionVector;
  }
  
  PVector vectorFrom (PVector a)
  {
    //println(a);
    return new PVector(location.x - a.x, location.y - a.y, location.z - a.z);
  }
  
   void drawSphere()
{
  // initialize point arrays
  vertices = new PVector[pts+1];
  vertices2 = new PVector[pts+1];

  // fill arrays
  for(int i=0; i<=pts; i++)
  {
    vertices[i] = new PVector();
    vertices2[i] = new PVector();
    vertices[i].x = latheRadius + sin(radians(angle))*radius;
    vertices[i].z = cos(radians(angle))*radius;
    angle+=360.0/pts;
  }

  // draw toroid
  latheAngle = 0;
  for(int i=0; i<=segments; i++)
  {
    beginShape(QUAD_STRIP);
    for(int j=0; j<=pts; j++)
    {
      if (i>0)
      {
        vertex(vertices2[j].x, vertices2[j].y, vertices2[j].z);
      }
      vertices2[j].x = cos(radians(latheAngle))*vertices[j].x;
      vertices2[j].y = sin(radians(latheAngle))*vertices[j].x;
      vertices2[j].z = vertices[j].z;
      vertex(vertices2[j].x, vertices2[j].y, vertices2[j].z);
    }
    latheAngle+=360.0/segments;    
    endShape();
  }
}  
}

