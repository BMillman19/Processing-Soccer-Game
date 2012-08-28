    /*
  *  Stuff added in for microphone input.
  */
  import ddf.minim.*;
  import ddf.minim.effects.LowPassFS;
//  import processing.core.*;
  /*
  *
  */
  import processing.opengl.*;
  final int WIDTH  = 1000;
  final int HEIGHT = 600;
   
  final float ASPECT = 9.0 / 16.0;
   
  final int SCREEN_HEIGHT = round(WIDTH * ASPECT);
  final int SCREEN_TOP    = round((HEIGHT - SCREEN_HEIGHT) / 2.0);
  final int SCREEN_BOTTOM = HEIGHT - SCREEN_TOP;
   
  final String FONT_NAME = "cinecaption-12.vlw";
  final int    FONT_SIZE = 12;
   
  PFont font;
  AudioPlayer cheerSound;
  AudioPlayer booSound;
  AudioPlayer windSound;
   
  //SkyBox daySkyBox;
  SkyBox nightSkyBox;
  Scene  scene;
  boolean isRunning = true;
  boolean drawMode = true;
  boolean transitionMode = true;
  boolean isAnimating = false;
  static final int XDIRECTION = 0;
  static final int YDIRECTION = 1;
  static final int ZDIRECTION = 2;
  
  static final float LOWER_Y_BOUND = -1;
  static final float UPPER_Y_BOUND = -300;
  static final float LOWER_X_BOUND = 300;
  static final float UPPER_X_BOUND = -300;
  static final float LOWER_Z_BOUND = 500;
  static final float UPPER_Z_BOUND = -500;
  
  GroupNode universe;
  PVector position;
  Ball ball;
  Spectator firstGuy;
  List<Collideable> collisionList;
  float absorb = .8;
  boolean texturesON = true;
  boolean skyBoxON = true;

  float rotx = 98.95987;
  float roty = 0;
  float scaleValue = 1;
  List<Spectator> homeSpectators;
  List<Spectator> awaySpectators;
  List<Player> players;
  List<List<PVector>> playerCurves;
  PVector center;
  
  float t = 0;
  // nearest curve point for interpolation 
  int idx = 0;
  
  /*
  *  Stuff added in for microphone input.
  */
  Minim minim;
  AudioInput blow;
  LowPassFS lowpass;
  public void setupMicVariables(){
	minim = new Minim(this);
	blow = minim.getLineIn();
	lowpass = new LowPassFS(200, blow.sampleRate());
	blow.addEffect(lowpass);
  }
  float n = 0;
  float x = 0;
  float lastblowf = 0;
  
  public boolean isBlow(){
     for(float f : blow.mix.toArray()){
	if(f>0.4){
		return true;
	}
    } 
    return false;
  }
  /*
  *
  */
  
  void setup()
  {
    setupMicVariables();
    size(WIDTH, HEIGHT, P3D);
    frameRate(30);
    scene = new Loading();
    center = new PVector(width/2,height/2,0);
    collisionList = new ArrayList<Collideable>();
    homeSpectators = new ArrayList<Spectator>();
    awaySpectators = new ArrayList<Spectator>();
    players = new ArrayList<Player>();
    playerCurves = new ArrayList<List<PVector>>();

    universe = new GroupNode();
    universe.addTransform(new PartialRotateTransform(2, 1));
      
    GroupNode goalAndLights1 = new GroupNode();
    goalAndLights1.addTransform(new TranslateTransform(0, -50, -450));
    goalAndLights1.addChild(read(new XMLElement(this, "goal.xml")));
    GroupNode light1 = new GroupNode();
    GroupNode light2 = new GroupNode();
    goalAndLights1.addChild(light1,light2);
    light1.addTransform(new TranslateTransform(350, 0, -100));
    light1.addTransform(new PartialRotateTransform(-4,1));
    light1.addChild(read(new XMLElement(this, "lightpost.xml")));
    
    light2.addTransform(new TranslateTransform(-350, 0, -100));
    light2.addTransform(new PartialRotateTransform(4,1));
    light2.addChild(read(new XMLElement(this, "lightpost.xml")));
    
  
    
    GroupNode goalAndLights2 = new GroupNode();
    goalAndLights2.addTransform(new TranslateTransform(0, -50, 450));
    goalAndLights2.addTransform(new PartialRotateTransform(1,1)); 
    goalAndLights2.addChild(read(new XMLElement(this, "goal.xml")));
    GroupNode light3 = new GroupNode();
    GroupNode light4 = new GroupNode();
    goalAndLights2.addChild(light3,light4);
    light3.addTransform(new TranslateTransform(350, 0, -100));
    light3.addTransform(new PartialRotateTransform(-4,1));
    light3.addChild(read(new XMLElement(this, "lightpost.xml")));
    
    light4.addTransform(new TranslateTransform(-350, 0, -100));
    light4.addTransform(new PartialRotateTransform(4,1));
    light4.addChild(read(new XMLElement(this, "lightpost.xml")));
  
    
    
    universe.addChild(goalAndLights1);
    universe.addChild(goalAndLights2);
    universe.addChild(read(new XMLElement(this, "field.xml")));
    
    
    PVector speed = new PVector(0,4,0);
    PVector position = new PVector (0, -100, 0);
    ball = new Ball(speed,10, position);
  
    homeSpectators.add(new Spectator(new PVector(0, -30, -350)));
    homeSpectators.add(new Spectator(new PVector(100, -30, -350)));
    homeSpectators.add(new Spectator(new PVector( -100,-30, -350)));
    homeSpectators.add(new Spectator(new PVector(200, -30, -350)));
    homeSpectators.add(new Spectator(new PVector( -200,-30, -350)));
    
    awaySpectators.add(new Spectator(new PVector(0, -30, 350), new PVector(0, 0, -1)));
    awaySpectators.add(new Spectator(new PVector(100, -30, 350), new PVector(0, 0, -1)));
    awaySpectators.add(new Spectator(new PVector( -100,-30, 350), new PVector(0, 0, -1)));
    awaySpectators.add(new Spectator(new PVector(200, -30, 350), new PVector(0, 0, -1)));
    awaySpectators.add(new Spectator(new PVector( -200,-30, 350), new PVector(0, 0, -1)));
    
    cheerSound =  minim.loadFile("cheer-03.wav", 512);
    booSound =  minim.loadFile("boo.wav", 512);    
    windSound =  minim.loadFile("wind.wav", 512);


   
  }
  
  void draw()
  {
    if(isBlow()){
       spectatorShiver(awaySpectators);
       spectatorShiver(homeSpectators);
       ball.speed.y -= 3;
       System.out.println("blow detected"); 
       windSound.play(0);
    }
    //background(0xFFFFFFFF);
    for(float f : blow.mix.toArray()){
      f*=200;
      stroke(255,0,0);
      line(x-1,lastblowf,0,x,f,0);
      x++;
      lastblowf = f;
      if(x>width){
        x=0;
      }
      if(f>50){
        System.out.println(f);
        n++;
      }
    }
    
    //camera(400, -400, 400, 0, 0, 0, 0, 1, 0);
    background(40, 180, 250);
    
    lights();
    pushMatrix();
    translate(width/2, height/2, 0);

    rotateX(rotx);
    rotateY(roty);
    scale(scaleValue);
    

    //background(0xFFFFFFFF);
    if(skyBoxON)
      scene = scene.update();
      
    universe.draw();
    //scene = scene.update();
    //scene = scene.update();
    

    //ball.display();
  //  for (Collideable c : collisionList)
  //    c.collide();
    
    
    boundBall();
    checkGoal();
    
    if(drawMode)
    {
      //stroke(0);
      if (playerCurves.size() != 0)
      {
        for (int i = 0; i < playerCurves.get(playerCurves.size() - 1).size(); i++)
        {
          if(true)
          {
            PVector p = playerCurves.get(playerCurves.size() - 1).get(i);
            pushMatrix();
              translate(p.x, 0, p.y);
              noFill();
              stroke(255, 255, 255);
              sphere(5);
            popMatrix();
          }
        }
      }
    
      
    }
    else
    {

      for (Spectator s : homeSpectators)
        s.display();
        
      for (Spectator s : awaySpectators)
        s.display();
        
    }
    
    for (Player p : players)
    {
      p.display();
      p.collide();
    }
    
    popMatrix();
    
  }
  


  
interface Scene {
  Scene update();
}
 
class Loading implements Scene {
  private boolean loading;
   
  Loading() {
    loading = true;
    new Thread() {
      public synchronized void run() {      
        nightSkyBox = new SkyBox("frontdark.jpg",
                                 "rightdark.jpg",
                                 "backdark.jpg",
                                 "leftdark.jpg",
                                 "topdark.jpg",
                                 "botdark.jpg");
        loading = false;
      }
    }.start();
  }
  Scene update() {
    background(0xFF000000);
    if(loading) return this;
    return new MainScene();
  }
}

  GroupNode read (XMLElement root)
  {
    if (root.getString("file") != null)
    {
      return read(new XMLElement(this, root.getString("file").toLowerCase()));
    }
    
    GroupNode result = new GroupNode();
    for (XMLElement node : root.getChildren())
    {
      if (node.getName().equalsIgnoreCase("transform"))
      {
        result.addTransform(createTransform(node));
      }
      else if (node.getName().equalsIgnoreCase("shape"))
      {
        result.addChild(createShape(node));
      }
      else if (node.getName().equalsIgnoreCase("group"))
      {
        result.addChild(read(node));
      }
    }
    return result;
  }
  
  Transform createTransform (XMLElement root)
  {
    String type = root.getString("type").toLowerCase();
    
    if (type.equals("translate"))
    {
      return new TranslateTransform(createVector(root.getChild(0).getContent().trim()));
    }
    else if (type.equals("rotate_continuous"))
    {
        float rotateFactor = Float.valueOf(root.getChild(0).getContent().trim()).floatValue();
        int direction = 0;
        if (root.getChild(1).getContent().equalsIgnoreCase("x"))
          direction = 0;
        if (root.getChild(1).getContent().equalsIgnoreCase("y"))
          direction = 1;  
        if (root.getChild(1).getContent().equalsIgnoreCase("z"))
          direction = 2;  
        return new ContinuousRotateTransform(rotateFactor,direction);
    }
    else if (type.equals("rotate_partial"))
    {
        float rotateFactor = Float.valueOf(root.getChild(0).getContent().trim()).floatValue();
        int direction = 0;
        if (root.getChild(1).getContent().equalsIgnoreCase("x"))
          direction = 0;
        if (root.getChild(1).getContent().equalsIgnoreCase("y"))
          direction = 1;  
        if (root.getChild(1).getContent().equalsIgnoreCase("z"))
          direction = 2;  
        return new PartialRotateTransform(rotateFactor,direction);
    }
    else if (type.equals("scale"))
    {
        float scaleFactor = Float.valueOf(root.getChild(0).getContent().trim()).floatValue();
        return new ScaleTransform(scaleFactor);
    }
    else
      return null;
    
  }
  
  ShapeNode createShape (XMLElement root)
  {
    String type = root.getString("type").toLowerCase();
    ShapeNode result = null;
    
    if (type.equals("sphere"))
    {
      result = createSphere(root);
    }
    else if (type.equals("plane"))
    {
      result = createPlane(root);
    }
    else if (type.equals("cylinder"))
    {
      result = createCylinder(root);
    }
    else if (type.equals("box"))
    {
      result = createBox(root);
    }
  
    collisionList.add(result);
    return result;
  }
  
  SphereNode createSphere (XMLElement root)
  {
    PVector sphereColor = null;
    float sphereRadius = 0;
    String inputTexture = null;
    boolean hasLight = false;
    
    for (XMLElement node : root.getChildren())
    {
      if (node.getName().equalsIgnoreCase("color"))
      {
        sphereColor = createVector(node.getContent().trim());
      }
      if (node.getName().equalsIgnoreCase("radius"))
      {
        sphereRadius = Float.valueOf(node.getContent().trim()).floatValue();
      }
      if (node.getName().equalsIgnoreCase("texture"))
      {
        inputTexture = node.getContent().trim();
      }
      if (node.getName().equalsIgnoreCase("light"))
      {
        hasLight = (Float.valueOf(node.getContent().trim()).floatValue() == 1);
      }
    }
    
    return new SphereNode(inputTexture, sphereColor, sphereRadius, hasLight);  
  }  
  
  PlaneNode createPlane (XMLElement root)
  {
    PVector planeColor = null;
    float planeWidth = 0;
    float planeLength = 0;
    String inputTexture = null;
    
    for (XMLElement node : root.getChildren())
    {
      if (node.getName().equalsIgnoreCase("color"))
      {
        planeColor = createVector(node.getContent().trim());
      }
      if (node.getName().equalsIgnoreCase("width"))
      {
        planeWidth = Float.valueOf(node.getContent().trim()).floatValue();
      }
      if (node.getName().equalsIgnoreCase("length"))
      {
        planeLength = Float.valueOf(node.getContent().trim()).floatValue();
      }
      if (node.getName().equalsIgnoreCase("texture"))
      {
        inputTexture = node.getContent().trim();
      }
    }
    return new PlaneNode(inputTexture, planeColor, planeWidth, planeLength);  
  } 
  
  CylinderNode createCylinder (XMLElement root)
  {
    PVector cylinderColor = null;
    float cylinderWidth = 0;
    float cylinderHeight = 0;
    String inputTexture = null;
  
    for (XMLElement node : root.getChildren())
    {
      if (node.getName().equalsIgnoreCase("color"))
      {
        cylinderColor = createVector(node.getContent().trim());
      }
      if (node.getName().equalsIgnoreCase("width"))
      {
        cylinderWidth = Float.valueOf(node.getContent().trim()).floatValue();
      }
      if (node.getName().equalsIgnoreCase("height"))
      {
        cylinderHeight = Float.valueOf(node.getContent().trim()).floatValue();
      }
      if (node.getName().equalsIgnoreCase("texture"))
      {
        inputTexture = node.getContent().trim();
      }
    }
    return new CylinderNode(inputTexture, cylinderColor, cylinderWidth, cylinderHeight);  
  } 
  
  BoxNode createBox (XMLElement root)
  {
    PVector boxColor = null;
    float boxWidth = 0;
    float boxHeight = 0;
    float boxDepth = 0;
    String inputTexture = null;
    
    for (XMLElement node : root.getChildren())
    {
      if (node.getName().equalsIgnoreCase("color"))
      {
        boxColor = createVector(node.getContent().trim());
      }
      if (node.getName().equalsIgnoreCase("width"))
      {
        boxWidth = Float.valueOf(node.getContent().trim()).floatValue();
      }
      if (node.getName().equalsIgnoreCase("height"))
      {
        boxHeight = Float.valueOf(node.getContent().trim()).floatValue();
      }
      if (node.getName().equalsIgnoreCase("depth"))
      {
        boxDepth = Float.valueOf(node.getContent().trim()).floatValue();
      }
      if (node.getName().equalsIgnoreCase("texture"))
      {
        inputTexture = node.getContent().trim();
      }
    }
    return new BoxNode(inputTexture, boxColor, boxWidth, boxHeight, boxDepth); 
  }
    
    
  PVector createVector (String input)
  {
    float[] nums = float(split(input, " "));
    return new PVector(nums[0],
                       nums.length > 1 ? nums[1] : 0, 
                       nums.length > 2 ? nums[2] : 0);
  }
  
  void keyPressed()
  {    
    if (key == 't')
    {
        texturesON = !texturesON;
    }
    if (key == 'y')
    {
        skyBoxON = !skyBoxON;
    }
     if (key =='c')
     {
       spectatorCheer(awaySpectators);
     }
     if (key =='g')
     {
       spectatorGroan(homeSpectators);
     }
     
     if (key == 'x')
       spectatorShiver(homeSpectators);
     if (key == 'f')
       ball.isWireFrame = !ball.isWireFrame;
     if (key == 'n')
     {
       if(drawMode)
       {
         Timer t = new Timer();
         TimerTask task = new TimerTask()
         {
           public void run()
           {
             if( (scaleValue > .5 || rotx < 100) && transitionMode )
             {
               if(scaleValue > .5)
                 scaleValue -= .00125;
               if(rotx < 100)
                 rotx += .0025;
             }
             else
             {
                transitionMode = false;
             } 
             drawMode = false;
           }                 
         };
    
         t.scheduleAtFixedRate(task, 0, 5);
         universe.addChild(ball);
       }
     }
        
    if (key == ' '){
      if(isRunning)
      {
        noLoop();
        isRunning = false;
      }
      else
      {
        loop();
        isRunning = true;
      }
    }
    if (key == 'a')
      ball.speed.z -= .8;
     if (key == 'd')
      ball.speed.z += .8;
     if (key == 'w')
      ball.speed.x += .8;
     if (key == 's')
      ball.speed.x -= .8;
     if (key == 'p')
       //playSound("cheer-03.wav");
     if (key == 'r')
     {
       resetBall();
     }

    if (key == CODED)
    {
      if (keyCode == UP)
      {
        if(!drawMode)
          scaleValue+=.02;
      }
      if (keyCode == DOWN)
        if(scaleValue > .34)
          if(!drawMode)
            scaleValue-=.02;
    }
    
  }
  
  void mousePressed ()
  {
    if(drawMode)
    {
      //if(playerCurves.size() != 0)
        //playerCurves.get(playerCurves.size() - 1).clear();
      //curvePoints.add(new PVector(mouseX, mouseY));
      isAnimating = false;
      playerCurves.add(new ArrayList<PVector>());
      playerCurves.get(playerCurves.size() - 1).add(new PVector(mouseX - (WIDTH/2), mouseY - (HEIGHT/2)));
    }
  }

void mouseDragged ()
{
  if(drawMode)
    playerCurves.get(playerCurves.size() - 1).add(new PVector(mouseX - (WIDTH/2), mouseY - (HEIGHT/2)));
  else
  {
    float rate = 0.01;
    rotx += (pmouseY-mouseY) * rate;
    roty += (mouseX-pmouseX) * rate;
  }
}

void mouseReleased ()
{
  if(drawMode)
  {
    playerCurves.get(playerCurves.size() - 1).add(new PVector(mouseX - (WIDTH/2), mouseY - (HEIGHT/2)));
    isAnimating = true;
    t = 0;
    for(int i = 0; i < playerCurves.get(playerCurves.size() - 1).size(); i++)
    {
      PVector p = playerCurves.get(playerCurves.size() - 1).get(i);
      //println(p);
    }
    
    if(playerCurves.get(playerCurves.size() - 1).size() < 10)
      playerCurves.remove(playerCurves.size() - 1);
    else
      players.add(new Player(playerCurves.get(playerCurves.size() - 1))); 
  }  
}

  
void stop()
{
  blow.close();
  booSound.close();
  cheerSound.close();
  windSound.close();
  minim.stop();
  super.stop();
}


