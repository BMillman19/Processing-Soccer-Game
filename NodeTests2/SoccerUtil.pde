  void boundBall()
  {
    if (ball.position.y + ball.radius >= LOWER_Y_BOUND)
     {
       ball.speed.y *= -.8;
       ball.position.y = LOWER_Y_BOUND - ball.radius -1;
     }
     if (ball.position.y - ball.radius <= UPPER_Y_BOUND)
     {
       ball.speed.y *= -.8;
       ball.position.y = UPPER_Y_BOUND + ball.radius +1;
     }
     if (ball.position.x + ball.radius >= LOWER_X_BOUND)
     {
       ball.speed.x *= -.8;
       ball.position.x = LOWER_X_BOUND - ball.radius -1;
     }
     if (ball.position.x - ball.radius <= UPPER_X_BOUND)
     {
       ball.speed.x *= -.8;
       ball.position.x = UPPER_X_BOUND + ball.radius +1;
     }
     if (ball.position.z + ball.radius >= LOWER_Z_BOUND)
     {
       ball.speed.z *= -.8;
       ball.position.z = LOWER_Z_BOUND - ball.radius -1;
     }
     if (ball.position.z - ball.radius <= UPPER_Z_BOUND)
     {
       ball.speed.z *= -.8;
       ball.position.z = UPPER_Z_BOUND + ball.radius +1;
     }
        
  }
  void resetBall()
  {
   ball.position.x = 0;
   ball.position.y = -10;
   ball.position.z = 0;
   ball.speed.x = 0;
   ball.speed.y = 0;
   ball.speed.z = 0;
  }

  void checkGoal()
  {
    
    if (ball.position.z + ball.radius >= LOWER_Z_BOUND - 20)
     {
       if (isWithinGoalDimensions())
       {
         spectatorCheer(homeSpectators);
         spectatorGroan(awaySpectators);
         cheerSound.play(0);
         resetBall();
       }
     }
     
     if (ball.position.z - ball.radius <= UPPER_Z_BOUND + 20)
     {
       if (isWithinGoalDimensions())
       {
         spectatorCheer(awaySpectators);
         spectatorGroan(homeSpectators);
         cheerSound.play(0);
         resetBall();
       }
     }
     
     

    
  }
  
  void spectatorCheer(List<Spectator> spectatorList)
  {
    for(Spectator s:spectatorList)
       {
         int duration = int(random(3,5));
         float frequency = int(random (15,25));
          s.cheer(duration, TWO_PI/frequency);
       }
  }
  
  void spectatorShiver(List<Spectator> spectatorList)
  {
    for(Spectator s:spectatorList)
       {
         int duration = int(random(4,5));
         float frequency = int(random (15,20));
          s.shiver(duration, TWO_PI/frequency);
       }
  }
  
  void spectatorGroan(List<Spectator> spectatorList)
  {
    for(Spectator s:spectatorList)
          s.groan();
  }
  
  boolean isWithinGoalDimensions()
  {
    return (ball.position.y > -100 && ball.position.x < 100 && ball.position.x > -100);
  }
  
    PVector makeVectorFromString (String s)
  {
    String temp = s.substring(1, s.length() - 1);
    String[] components = temp.split(",");
    return new PVector(new Float(components[0]), new Float(components[1]), new Float(components[2])); 
  }

   List<PVector> getCurveFromText (String s)
  {
     String[] curvePoints = loadStrings(s);
     List<PVector> result = new ArrayList<PVector>();
     for(String str2: curvePoints)
     {
       result.add(makeVectorFromString(str2));
     }
     return result;
  }
