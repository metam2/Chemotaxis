// add or remove snesk; increase/decrease bias with meter showing levels; set speed into parameter
Snake[] snek = new Snake[10];
int fruitX, fruitY;

void setup()
{
  size(500,500);
  colorMode(HSB, 100);
  for(int i = 0; i < snek.length; i++)
  {
    float x, y;
    x = ((float)Math.random() * width);
    y = ((float)Math.random() * height);
    int colour = (int)(Math.random() * 100);
    int size = (int)(Math.random() * 150) + 10;
    int radius = (int)(Math.random() * 10) + 5;
    snek[i] = new Snake(x, y, colour, size, radius);
  }
  fruitX = (int)(Math.random() * width);
  fruitY = (int)(Math.random() * height);
}

void draw()
{
  noStroke();
  fill(0, 5, 100);
  rect(0, 0, width, height);
  
  stroke(100, 100, 100);
  fill(200, 80, 80);
  ellipse(fruitX, fruitY, 10,10);
  for(int i = 0; i < snek.length; i++)
  {
    snek[i].move();
    snek[i].show();
  }
}

void mousePressed()
{
  fruitX = mouseX;
  fruitY = mouseY;
}

class Snake {
  //the snek will continue its current movement until the timer hits 0
  int timer, snakeWidth, hue, length;
  float x, y, changeInAngle, speed, targetAngle;
  PVector v;
  //length is array of ordered pairs
  float[] body;
  PVector vFruit;
  
  Snake(float x0, float y0, int colour, int size, int radius)
  {
    x = x0;
    y = y0;
    body = new float[size * 2];
    for(int i = 0; i < body.length; i+=2)
    {
      body[i] = x;
      body[i + 1] = y;
    }
    v = new PVector((float)Math.random(), (float)Math.random());
    //sets random speed of snek btwn [0.5, 2.5)
    speed = (float)Math.random() * 2 + 0.5;
    v.setMag(speed);
    snakeWidth = radius;
    hue = colour;
    vFruit = new PVector(fruitX - body[0], fruitY - body[1]);
  }
  
  void move()
  {
    
    if(timer == 0)
    {
        //chance to either turn or move straight
        double chance = Math.random();
        if(chance < 0.5)
        {
          //0.4 chance to make a wider turn
          if(chance < 0.4)
            changeInAngle = (float)(Math.random() * 0.07) + 0.03;
          else
            //smaller turn
            changeInAngle = (float)(Math.random() * 0.4) + 0.1;
            
          //0.5 chance to turn CCW
          if (Math.random() < 0.5)
            changeInAngle = -changeInAngle;
            
          //rotation is btwn 1pi/3 and 5pi/3
          float range = abs(4 * PI / 3 / changeInAngle);
          timer = (int)(Math.random() * range + 1 * PI / 3 / abs(changeInAngle));
          
          //50% chance to set snake to turn until it is going in the general direction of the fruit
          if (Math.random() < 0.5)
          {
            timer = -1;
          }
        }
        else //move straight
        {
          changeInAngle = 0;
          timer = (int)(Math.random() * 20) + 5;
        }
    }
    else if(timer < 0) //timer is negative if snake is turning until it is going in the general direction of the fruit
    {
      stroke(40, 80, 80);
      vFruit = new PVector(fruitX - body[0], fruitY - body[1]);
      float angleOfRot;
      if ((v.heading() < vFruit.heading() && changeInAngle > 0) ||  (v.heading() > vFruit.heading() && changeInAngle < 0))
        angleOfRot = abs(v.heading() - vFruit.heading());
      else 
      {
        angleOfRot = 2 * PI - (abs(v.heading() - vFruit.heading()));
      }
      
      if(angleOfRot >  PI)
      {
        changeInAngle = -changeInAngle;
      }
      //////
      /*
      fill(200, 100, 100);
      rect(0, height / 2, 10, v.heading() * height / 2 / PI);
      rect(10, height / 2, 20, vFruit.heading() * height / 2 / PI);
      */
      ///////
      if(v.heading() >= vFruit.heading() - 0.25 && v.heading() <= vFruit.heading() + 0.25)
        timer = 0;
    }
    else
      timer--;
    //if tan same sign; else if cos same sign; else
    
    if(body[0] < 0 )
      v.set((float)Math.random(), v.y);
    else if (body[0] > width)
      v.set(-(float)Math.random(), v.y);
            
    if(body[1] < 0)
      v.set(v.x, (float)Math.random());
    else if(body[1] > height)
      v.set(v.x, -(float)Math.random());
      
    for(int i = body.length - 1; i > 1; i --)
      body[i] = body[i-2];
    body[0] += v.x;
    body[1] += v.y;
      
    v.setMag(speed);
    v.rotate(changeInAngle);
    
  }
  
  void show()
  {
    noStroke();
    for(int a = 2; a >= 1; a--)
    {
      if(a == 2)
      {
        fill(hue, 20, 100);
      }
      else
      {
        fill(hue, 30, 100);
      }
      for(int i = 0; i < body.length; i+=2)
        ellipse(body[i] , body[i + 1] , snakeWidth * a, snakeWidth * a);
      
    }

  }
}
