Snake snek;

void setup()
{
  size(500,500);
  colorMode(HSB, 100);
  float x, y;
  x = ((float)Math.random() * width);
  y = ((float)Math.random() * height);
  int colour = (int)(Math.random() * 100);
  int size = (int)(Math.random() * 90) + 10;
  int radius = (int)(Math.random() * 10) + 5;
  snek = new Snake(x, y, colour, size, radius);
  
}

float min = 0;
float max = 0;
void draw()
{
  fill(0, 0, 80);
  rect(0, 0, width, height);
  snek.move();
  snek.show();
}

class Snake {
  //the snek will continue its current movement until the timer hits 0
  int timer, snakeWidth, hue, sat, bright, length;
  float x, y, angle, changeInAngle, speed;
  PVector v;
  //length is array of ordered pairs
  float[] body;
  
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
  }
  
  void move()
  {
    
    if(timer == 0)
    {
        //chance to either turn or move straight
        double chance = Math.random();
        if(chance > 0.5)
        {
          //0.4 chance to make a wider turn
          if(chance > 0.6)
            changeInAngle = (float)(Math.random() * 0.07) + 0.03;
          else
            //smaller turn
            changeInAngle = (float)(Math.random() * 0.4) + 0.1;
            
          //0.5 chance to turn CCW
          if (Math.random() > 0.5)
            changeInAngle = -changeInAngle;
            
          //rotation is btwn 1pi/3 and 5pi/3
          float range = abs(4 * PI / 3 / changeInAngle);
          timer = (int)(Math.random() * range + 1 * PI / 3 / abs(changeInAngle));
          
        }
        else //move straight
        {
          changeInAngle = 0;
          timer = (int)(Math.random() * 20) + 5;
        }
    }
    else
      timer--;
    
    if(body[0] < 0 )
      v.set((float)Math.random(), v.y);
    else if (body[0] > width)
      v.set((float)-Math.random(), v.y);
            
    if(body[1] < 0)
      v.set(v.x, (float)Math.random());
    else if(body[1] > height)
      v.set(v.x, (float)-Math.random());
    
    v.setMag(speed);
    v.rotate(changeInAngle);
    
  }
  
  void show()
  {
    for(int a = 2; a >= 1; a--)
    {
      if(a == 2)
      {
        //stroke(hue, 80, 50);
        fill(hue, 20, 100);
      }
      else
      {
        noStroke();
        fill(hue, 30, 100);
        
      System.out.println(a);
      }
      for(int i = body.length - 1; i > 1; i --)
        body[i] = body[i-2];
      body[0] += v.x;
      body[1] += v.y;
      for(int i = 0; i < body.length; i+=2)
        ellipse(body[i] , body[i + 1] , snakeWidth * a, snakeWidth * a);
      
    }
  }
}
