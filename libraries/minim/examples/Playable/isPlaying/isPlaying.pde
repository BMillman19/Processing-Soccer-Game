/**
  * This sketch demonstrates how to use the <code>isPlaying</code> method of a <code>Playable</code> class. 
  * The class used here is <code>AudioPlayer</code>, but you can also check the play status of an <code>AudioSnippet</code>.
  * A <code>Playable</code> is considered to be playing if it is sending audio to the system. 
  * Press 'p' to play the file and 's' to pause it. Text on the screen will indicate the current playstate.
  */

import ddf.minim.*;

Minim minim;
AudioPlayer groove;
WaveformRenderer waveform;

void setup()
{
  size(512, 200, P3D);

  minim = new Minim(this);
  groove = minim.loadFile("groove.mp3", 2048);
  
  waveform = new WaveformRenderer();
  // see the example Recordable >> addListener for more about this
  groove.addListener(waveform);
  
  textFont(createFont("Arial", 12));
  textMode(SCREEN);
}

void draw()
{
  background(0);
  // see waveform.pde for an explanation of how this works
  waveform.draw();
  
  if ( groove.isPlaying() )
  {
    text("The player is playing.", 5, 15);
  }
  else
  {
    text("The player is not playing.", 5, 15);
  }
}

void keyPressed()
{
  if ( key == 'l' )
  {
    groove.loop(1);
  }
  if ( key == 'p' )
  {
    groove.play();
  }
  if ( key == 's' )
  {
    groove.pause();
  }
}

void stop()
{
  // always close Minim audio classes when you are done with them
  groove.close();
  // always stop Minim before exiting.
  minim.stop();
  
  super.stop();
}
