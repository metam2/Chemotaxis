/*//////////
mag and heading doesnt work.....
heading atan(vFood.y/vFood.x)
atan(v.y/v.x);
v.normalize();
v.set(v.x * speed, v.y * speed);

*/

// add or remove snesk; increase/decrease bias with meter showing levels; set speed into parameter
Snake[] snek = new Snake[1];
int FoodX, FoodY;
float bias = 0.5;

void setup()
{
  size(500,500);
  colorMode(HSB, 100);
  for(int i = 0; i < snek.length; i++)
  {
    /*
    float x, y;
    x = ((float)Math.random() * width);
    y = ((float)Math.random() * height);
    int colour = (int)(Math.random() * 100);
    int size = (int)(Math.random() * 150) + 10;
    int radius = (int)(Math.random() * 10) + 5;
    snek[i] = new Snake(x, y, colour, size, radius);
    */
    snek[i] = new Snake();
  }
  FoodX = (int)(Math.random() * width);
  FoodY = (int)(Math.random() * height);
}

void draw()
{
  noStroke();
  fill(0, 5, 100);
  rect(0, 0, width, height);
  
  stroke(100, 100, 100);
  fill(200, 80, 80);
  ellipse(FoodX, FoodY, 10,10);
  for(int i = 0; i < snek.length; i++)
  {
    snek[i].move();
    snek[i].show();
  }

  if(keyPressed)
  {
    if(key == 'q' || key == 'Q')
    {
      Snake[] tempSnek = (Snake[])append(snek, new Snake());
      
      System.out.println(snek.length);
    }

  }
}

void mousePressed()
{
  FoodX = mouseX;
  FoodY = mouseY;
}

class Snake {
  int timer, snakeWidth, hue, length;
  float x, y, changeInAngle, speed, targetAngle;
  PVector v;
  //length is array of ordered pairs
  float[] body;
  
  Snake()
  {
    x = ((float)Math.random() * width);
    y = ((float)Math.random() * height);

    int size = (int)(Math.random() * 150) + 10;
    body = new float[size * 2];
    for(int i = 0; i < body.length; i+=2)
    {
      body[i] = x;
      body[i + 1] = y;
    }
    v = new PVector((float)Math.random(), (float)Math.random());
    //sets random speed of snek btwn [0.5, 2.5)
    speed = (float)Math.random() * 2 + 0.5;

    snakeWidth = (int)(Math.random() * 10) + 5;
    hue = (int)(Math.random() * 100);
  }

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
    //v.normalize();
    //v.set(v.x * speed, v.y * speed);

    snakeWidth = radius;
    hue = colour;
  }
  
  void move()
  {
    
    if(timer == 0)
    {
        //chance to either turn or move straight
        double chance = Math.random();
        if(chance < 0.5)
        {
          //0.3 chance to make a wider turn
          if(chance < 0.3)
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

          //50% chance to set snake to turn until it is going in the general direction of the Food
          if (Math.random() < bias)
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
    else if(timer < 0) //timer is negative if snake is turning until it is going in the general direction of the Food
    {
      PVector vFood = new PVector(FoodX - body[0], FoodY - body[1]);
      float angleOfRot;
      
      float vAngle = getAngle(v.x, v.y);
      float foodAngle = getAngle(vFood.x, vFood.y);
        
      if ((vAngle < foodAngle && changeInAngle > 0) ||  (vAngle > foodAngle && changeInAngle < 0))
        angleOfRot = abs(vAngle - foodAngle);
      else 
      {
        angleOfRot = 2 * PI - (vAngle - foodAngle);
      }
      
      if(angleOfRot >  PI)
      {
        changeInAngle = -changeInAngle;
      }
      //////
      /*
      fill(200, 100, 100);
      rect(0, height / 2, 10, v.heading() * height / 2 / PI);
      rect(10, height / 2, 20, vFood.heading() * height / 2 / PI);
      */
      ///////
      
      //if(vAngle != v.heading())
        //System.out.println(vAngle - v.heading());
      /*
      float vAngle = atan(v.y/v.x);
      float foodAngle = atan(vFood.x/vFood.y);
      if (v.x < 0 && v.y < 0)
        vAngle -= PI;
      else if(v.x < 0 && v.y > 0)
        vAngle += PI;
      if (vFood.x < 0 && vFood.y < 0)
        foodAngle -= PI;
      else if(vFood.x < 0 && vFood.y > 0)
        foodAngle += PI;
        */
        
      //if(atan(v.y/v.x) >= atan(vFood.y/vFood.x) - 0.25 && atan(v.y/v.x) <= atan(vFood.y/vFood.x) + 0.25)
      if(vAngle >= foodAngle - 0.25 && vAngle <= foodAngle + 0.25)
      {
        timer = 0;
      }
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
    
    v.set(cos(getAngle(v.x, v.y) + changeInAngle), sin(getAngle(v.x, v.y) + changeInAngle));
    v.normalize();
    v.set(v.x * speed, v.y * speed);
    //v.rotate(changeInAngle);
    
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
        ellipse((int)body[i] , (int)body[i + 1] , (int)(snakeWidth * a), (int)(snakeWidth * a));
      
    }

  }
  
  float getAngle(float xComp, float yComp)
  {
    float angle = atan(yComp/xComp);
    if (xComp <= 0 && yComp <= 0)
      angle -= PI;
    else if(xComp <= 0 && yComp >= 0)
      angle += PI;
      
    return angle;
  }
}


