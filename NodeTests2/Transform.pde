abstract class Transform
{
  abstract void applyTransform();
}

class ScaleTransform extends Transform
{
  float myScaleFactor;
  
  ScaleTransform(float scaleFactor)
  {
    myScaleFactor = scaleFactor;
  }
  
  void applyTransform()
  {
    scale(myScaleFactor);
  }
}
class PartialRotateTransform extends Transform
{
  float myRotateFactor;
  int myDirection;
  
  PartialRotateTransform(float rotateFactor, int direction)
  {
    myRotateFactor = rotateFactor;
    myDirection = direction;
  }
  
  void applyTransform()
  {
    switch (myDirection) 
    {
            case 0:  rotateX(PI/myRotateFactor);
                     break;
            case 1:  rotateY(PI/myRotateFactor);
                     break;
            case 2:  rotateZ(PI/myRotateFactor);
                     break;
    }
  }
}

class ContinuousRotateTransform extends Transform
{
  float myRotateFactor;
  int myDirection;
  
  ContinuousRotateTransform(float rotateFactor, int direction)
  {
    myRotateFactor = rotateFactor;
    myDirection = direction;
  }
  
  void applyTransform()
  {
    switch (myDirection) 
    {
            case 0:  rotateX(frameCount*PI/myRotateFactor);
                     break;
            case 1:  rotateY(frameCount*PI/myRotateFactor);
                     break;
            case 2:  rotateZ(frameCount*PI/myRotateFactor);
                     break;
    }
  }
}

class TranslateTransform extends Transform
{
  float myTranslateX;
  float myTranslateY;
  float myTranslateZ;
  
  TranslateTransform (PVector pv)
  {
    this (pv.x, pv.y, pv.z);
  }
  
  TranslateTransform (float x, float y, float z)
  {
    myTranslateX = x;
    myTranslateY = y;
    myTranslateZ = z;
  }
  
  void applyTransform()
  {
    translate(myTranslateX, myTranslateY, myTranslateZ);
  }
}


