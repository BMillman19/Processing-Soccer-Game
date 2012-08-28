class MainScene implements Scene {
  
//  SkyBox mySkyBox;
  
//  public MainScene(SkyBox skybox)
//  {
//    mySkyBox = skyBox;
//  }
  
  Scene update() {
    background(0xFF000000);
    nightSkyBox.render();
    
    return this;
  }
}
