
class Player implements Collideable
{
  PVector myLocation;
  float myRadius;
  PVector myDirection;
  PVector mySpeed = new PVector();
  PVector myAbsoluteLocation = new PVector();
  List<PVector> myCurve;
  final PVector initialDirection = new PVector(1,0,0);
  
  float time = 0;
  // nearest curve point for interpolation 
  int step = 0;
  // key control variables
  float speed = 5.0;
  boolean forward = true;
  
  Player (List<PVector> inputCurve)
  {

    myCurve = inputCurve;
    myRadius = 30;
    myLocation = new PVector(myCurve.get(0).x, myRadius * -1, myCurve.get(0).y);
    myDirection = initialDirection;
    myDirection.normalize();
  }
  
  Player (String inputFile)
  {
    this(getCurveFromText(inputFile));
  }
  
  public void increaseSpeed(){
    speed+=0.001;
  }
  
  void display()
  {
    pushMatrix();
    PVector a = myCurve.get(step);
    PVector b = myCurve.get(step+1);
    PVector c = myCurve.get(step+2);
    PVector d = myCurve.get(step+3);
    
    if (!forward)
    {
      d = a;
      a = d;
      b = c;
      c = b;
    }
    float x = curvePoint(a.x, b.x, c.x, d.x, time);
    float y = curvePoint(a.y, b.y, c.y, d.y, time);
    
    translate(x, myLocation.y, y);
    //this.rotateTo(new PVector(x - myLocation.x, 0, y-myLocation.z));

    
    myLocation.x = x;
    myLocation.z = y;


    //ellipse(x, y, 20, 20);

    update(b, c);
    
    this.rotateTo(initialDirection);
    this.makeHead();
    popMatrix();
    PVector tempLocation = myAbsoluteLocation.get();
    myAbsoluteLocation.x = modelX(myLocation.x,myLocation.y,myLocation.z);
    myAbsoluteLocation.y = modelY(myLocation.x,myLocation.y,myLocation.z);
    myAbsoluteLocation.z = modelZ(myLocation.x,myLocation.y,myLocation.z);
    mySpeed = PVector.sub(myAbsoluteLocation,tempLocation);
  }
  
  void update (PVector start, PVector end)
  {
    // note, just uses linear distance
    time += speed / PVector.dist(start, end);
    if (time >= 1.0)
    {
      time = 0;
      if(forward)
        step++;
      else
        step--;
      if (step > myCurve.size() - 4)
      {
        forward = !forward;
        step--;
      }
      if (step == 0)
      {
        forward = !forward;
        step++;
      }
    }
  }
  
   void collide()
  {
//    println("Player Location" + myAbsoluteLocation);
//    println("Ball Location: " + ball.location);
     if (myAbsoluteLocation.dist(ball.location) < (myRadius+ ball.radius)) {
         println("Collision!");
         resetBall();
         booSound.play(0);

          //bounce();
        }

  }
  
   void bounce()
 { 
//    PVector ab = new PVector();
//    ball.speed.mult(-.8);
//    ab.set(ball.speed);
//    ab.normalize();
//    while(ball.location.dist(myAbsoluteLocation) < (ball.radius + myRadius)) 
//    {  
//      ball.location.add(ab);
//    }
    
    PVector ab = new PVector();
    ab.set(ball.location);
    ab.sub(myAbsoluteLocation);
    ab.normalize();
    while(ball.location.dist(myAbsoluteLocation) < (ball.radius + myRadius)) {   //*spring) {
      ball.location.add(ab);
    }
    PVector n = PVector.sub(ball.location, myAbsoluteLocation);
    n.normalize();
    PVector u = PVector.sub(ball.speed, mySpeed);
    PVector un = componentVector(u,n);
    u.sub(un);
    ball.speed = PVector.add(u, mySpeed);
 }
 
 PVector componentVector (PVector vector, PVector directionVector) {
    directionVector.normalize();
    directionVector.mult(vector.dot(directionVector));
    return directionVector;
  }
  void makeHead()
  {
    fill(255, 255, 255);

    sphere(myRadius);
    
    fill(0,0,0);
    pushMatrix();
    translate(myRadius * .8, -1 * (myRadius/2), myRadius * .5);
    sphere(myRadius/6);
    popMatrix();
          
    pushMatrix();
    translate(myRadius * .8, -1 * (myRadius/2), myRadius * -.5);
    sphere(myRadius/6);
    popMatrix(); 

    pushMatrix();
    translate(myRadius * .8, 1 * (myRadius/2), 0);
    sphere(myRadius/6);
    popMatrix();   
  }
  

  
    PVector findAngles(PVector a, PVector b)
  {
    PVector result = new PVector();
    
    result.x = this.angleBetween(new PVector(0, a.y, a.z), new PVector(0, b.y, b.z) );
    if((new PVector(0, a.y, a.z)).cross(new PVector(0, b.y, b.z)).x < 0)
      result.x = (2*PI - result.x);
      
    result.y = this.angleBetween(new PVector(a.x, 0, a.z), new PVector(b.x, 0, b.z) );
    if((new PVector(a.x, 0, a.z)).cross(new PVector(b.x, 0, b.z)).y < 0)
      result.y = (2*PI - result.y);
      
    result.z = this.angleBetween(new PVector(a.x, a.y, 0), new PVector(b.x, b.y, 0) );
    if((new PVector(a.x, a.y, 0)).cross(new PVector(b.x, b.y, 0)).z < 0)
      result.z = (2*PI - result.z);

    //println (result.x + ", " + result.y + ", " + result.z);
    return result;
  }
  
  void rotateTo(PVector a)
  {
    PVector rotateValues = this.findAngles(a,myDirection);
    if (!Float.isNaN(rotateValues.x))
      rotateX(rotateValues.x);
    if (!Float.isNaN(rotateValues.y))
      rotateY(rotateValues.y);
    if (!Float.isNaN(rotateValues.z))
      rotateZ(rotateValues.z);
    
  }
  
  float angleBetween(PVector a, PVector b)
  {
    return (float)Math.acos(a.dot(b) / a.mag() / b.mag());
  }
}






class Spectator
{
  PVector myLocation;
  float myRadius;
  PVector myDirection;
  final PVector initialDirection = new PVector(1,0,0);
  float a = 0.0;
  float a2 = 0.0;
  float inc = TWO_PI/25.0;
  float inc2 = TWO_PI/500.0;
  boolean isCheering = false;
  boolean isGroaning = false;
  boolean isShivering = false;
  
  Spectator(PVector inputLocation, PVector inputDirection, float inputRadius)
  {
    myLocation = inputLocation;
    myRadius = inputRadius;
    myDirection = inputDirection;
    myDirection.normalize();
  }
  
  Spectator(PVector inputLocation)
  {
    this(inputLocation, new PVector(0, 0, 1), 30);
  }
  
  Spectator(PVector inputLocation, PVector inputDirection)
  {
    this(inputLocation, inputDirection, 30);
  }
  

  
  void display()
  {
    pushMatrix();
    translate(myLocation.x,myLocation.y,myLocation.z);
    if (isCheering)
    {
      translate(0, -30.0*abs(sin(a)) ,0);
      a = a + inc;
    }
    
    if (isShivering)
    {
      translate(-3*sin(100*a), 0 ,0);
      a = a + inc;
    }
    if (isGroaning)
    {
      rotateX(-10*sin(a2));
      if (10*sin(a2) < PI/2)
        a2 = a2 + inc2;
      
    }
    this.rotateTo(initialDirection);
    //this.rotateTo(ball.vectorFrom(myLocation));
    this.makeHead();
    popMatrix();
  }
  
  void cheer(int seconds, float frequency)
  {
    isCheering = true;
    Timer t = new Timer();
    inc = frequency;
    TimerTask task = new TimerTask()
    {
      public void run()
      {
        isCheering=false;
      }
    };
    
    t.schedule(task, seconds*1000);
  }
  
   void shiver(int seconds, float frequency)
  {
    isShivering = true;
    Timer t = new Timer();
    inc = frequency;
    TimerTask task = new TimerTask()
    {
      public void run()
      {
        isShivering=false;
      }
    };
    
    t.schedule(task, seconds*1000);
  }
  
  void groan()
  {
    isGroaning = true;
    a2 = 0.0;
    Timer t = new Timer();
    //inc2 = frequency;
    TimerTask task = new TimerTask()
    {
      public void run()
      {
        isGroaning=false;
      }
    };
    
    t.schedule(task, 1000);
  }
  
  void makeHead()
  {
    fill(255, 255, 255);

    sphere(myRadius);
    
    fill(0,0,0);
    pushMatrix();
    translate(myRadius * .8, -1 * (myRadius/2), myRadius * .5);
    sphere(myRadius/6);
    popMatrix();
          
    pushMatrix();
    translate(myRadius * .8, -1 * (myRadius/2), myRadius * -.5);
    sphere(myRadius/6);
    popMatrix(); 

    pushMatrix();
    translate(myRadius * .8, 1 * (myRadius/2), 0);
    sphere(myRadius/6);
    popMatrix();   
  }
  
  PVector findAngles(PVector a, PVector b)
  {
    PVector result = new PVector();
    
    result.x = this.angleBetween(new PVector(0, a.y, a.z), new PVector(0, b.y, b.z) );
    if((new PVector(0, a.y, a.z)).cross(new PVector(0, b.y, b.z)).x < 0)
      result.x = (2*PI - result.x);
      
    result.y = this.angleBetween(new PVector(a.x, 0, a.z), new PVector(b.x, 0, b.z) );
    if((new PVector(a.x, 0, a.z)).cross(new PVector(b.x, 0, b.z)).y < 0)
      result.y = (2*PI - result.y);
      
    result.z = this.angleBetween(new PVector(a.x, a.y, 0), new PVector(b.x, b.y, 0) );
    if((new PVector(a.x, a.y, 0)).cross(new PVector(b.x, b.y, 0)).z < 0)
      result.z = (2*PI - result.z);

    //println (result.x + ", " + result.y + ", " + result.z);
    return result;
  }
  
  void rotateTo(PVector a)
  {
    PVector rotateValues = this.findAngles(a,myDirection);
    if (!Float.isNaN(rotateValues.x))
      rotateX(rotateValues.x);
    if (!Float.isNaN(rotateValues.y))
      rotateY(rotateValues.y);
    if (!Float.isNaN(rotateValues.z))
      rotateZ(rotateValues.z);
    
  }
  
  float angleBetween(PVector a, PVector b)
  {
    return (float)Math.acos(a.dot(b) / a.mag() / b.mag());
  }
  

}
