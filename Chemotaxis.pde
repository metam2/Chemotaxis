Snake[] snek = new Snake[10];
int FoodX, FoodY;
float bias = 0.5;
int a = 0;

void setup()
{
  size(800,800);
  colorMode(HSB, 100);
  for(int i = 0; i < snek.length; i++)
  {
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
  fill(0, 80, 80);
  ellipse(FoodX, FoodY, 10,10);
  for(int i = 0; i < snek.length; i++)
  {
    snek[i].move();
    snek[i].show();
  }

  if(keyPressed)
  {
    if(key == 's')
    {
      if(bias < 1)
        bias += 0.01;
    }
    if(key == 'a')
    {
      if(bias > 0)
        bias -= 0.01;
    }
  }

  fill((int)(bias * 100), 10, 100);
  stroke((int)(bias * 100), 20, 100);
  rect(0, 20, (int)(bias * 800), 20);


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
  //body is array of ordered pairs
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

          //chance to set snake to turn until it is going in the general direction of the Food
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
    else if(timer < 0 ) //timer is negative if snake is turning until it is going in the general direction of the Food
    {
      PVector vFood = new PVector(FoodX - body[0], FoodY - body[1]);
      double angleOfRot;
      
      float vAngle = getAngle(v.x, v.y);
      float foodAngle = getAngle(vFood.x, vFood.y);

      if(abs(vAngle - foodAngle) == PI)
        println(vAngle);
      
      if ((vAngle < foodAngle && changeInAngle > 0) ||  (vAngle > foodAngle && changeInAngle < 0))
        angleOfRot = abs(vAngle - foodAngle);
      else 
      {
        angleOfRot = 2 * PI - abs(vAngle - foodAngle);
      }
      
      if(angleOfRot > PI)
        changeInAngle = -changeInAngle;

      fill(0, 0, 0);

      if(vAngle >= foodAngle - 0.25 && vAngle <= foodAngle + 0.25)
      {
        timer = 0;
      }
    }
    else
      timer--;
    
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
        ellipse(body[i] , body[i + 1] , (int)(snakeWidth * a), (int)(snakeWidth * a));
      
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


void keyReleased()
{
    if(key == 'w')
    {
      Snake[] tempSnek = (Snake[])append(snek, new Snake());
      snek = tempSnek;
    }

    if(key == 'q')
    {
      if(snek.length > 0)
      snek = (Snake[])shorten(snek);
    }

}