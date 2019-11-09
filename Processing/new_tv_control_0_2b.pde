/*
 * Программа для Processing (fucking google it)
 * Можно запустить из среды IDE, можно скомпилить.
 * Использует JRE как бек-энд.
 * При нажатии на кнопку соответсвующего телека
 * посылает байт в последовательный порт. 
 * Не помню подробностей, комменты писал для себя
 * стиль кода - говно, т.к. его сочинял механить, 
 * а не программист.
 */
import processing.serial.*;
 
class mySq {
   public int x;
   public int y;
   public int size;
   public boolean rectOver;
   public boolean isPressed;
   public int countDown;
   public boolean isReleased;
   public String btnText;
   
   public mySq(int x, int y, int size, boolean rectOver, boolean isPressed, int countDown, boolean isReleased, String btnText) {
     this.x = x;
     this.y = y;
     this.size = size;
     this.rectOver = rectOver;
     this.isPressed = isPressed;
     this.countDown = countDown;
     this.isReleased = isReleased;
     this.btnText = btnText;
   }
 }
 
Serial myPort;
 
long[] curMin = new long[16];
boolean[] onCountDown = new boolean[16];
boolean[] onSec = new boolean[16];
String[] remoteControl = {"ВКЛ/ВЫКЛ","15 МИН","30 МИН","1 ЧАС"};
String[] min = {" мин", " сек"};
String btn = "Остановить\nтаймер";
PFont f;
PFont f2;
int rectX, rectY, rectYacc, rectXacc; 
int rectSize;
int tvs = 16;
int GridSize = 4;
int rectColor;
color baseColor;
color rectHighlight;
int currentColor;
boolean rectOver = false;
boolean isPressed = false;
ArrayList<mySq> list = new ArrayList<mySq>();
ArrayList<mySq> remote = new ArrayList<mySq>();

void setup() {
  
  //size(800, 660);
  fullScreen();
  //noCursor();
  rectSize = int(width/5.5);
  colorMode(HSB, 160, 100, 100);
  f = createFont("Arial", 24);
  f2 = createFont("Arial", 16);
  //textFont(f);
  textAlign(CENTER, CENTER);
  rectColor = 0;
  rectHighlight = color(51, 51, 51);
  baseColor = color(102,50,50);
  currentColor = baseColor; 
  rectXacc = rectSize + 5;
  rectYacc = rectSize + 5;
  rectX = 5;
  rectY = 5;
  
  String portName = "COM1";
  myPort = new Serial(this, portName, 9600);
  
  for (int i = 0; i < tvs/GridSize; i++){
    for (int j = 0; j < GridSize; j++){
  list.add(new mySq(rectX, rectY, rectSize, false, false, -1, false, "0"));
  rectX = rectX + rectXacc;
    }
    rectX = 5;
  rectY = rectY + rectYacc;
  }
  rectX = width - rectXacc;
  rectY = 5;
  
  for (int i = 0; i < 4; i++)  {
    remote.add(new mySq(rectX, rectY, rectSize, false, false, -1, false, remoteControl[i]));
    rectY = rectY + rectYacc;
    
  }
  for (int i = 0; i < tvs; i++)  {
      onCountDown[i] = false;
      curMin[i] = 0;
    }
}

void draw() {
  
  update();
  background(currentColor);
    for (int i = 0; i < tvs; i++)  {
      updateTimer(i);
      int s;
      if (onSec[i]) s = 1; else s = 0; 
      rectColor = i*10;
      fill(rectColor, 60, 70);

  stroke(255);
  rect(list.get(i).x, list.get(i).y, list.get(i).size, list.get(i).size);
  stroke(0);
  
  if(list.get(i).isPressed)  {
    
    showRemote(i);
    updateRemote();
    fill(160-i*10,30,70);
  
  } else {  
    fill(160 - i*10,100,30);
  }
  textFont(f);
  text("Тв " + (i+1), list.get(i).x+rectSize/2, list.get(i).y+rectSize/2);
  if (onCountDown[i])  {
    fill(0,0,0);
    textFont(f2);
    textLeading(20);
    text("осталось\n" + list.get(i).countDown + min[s], list.get(i).x+rectSize/2, list.get(i).y+0.77*rectSize);
    
  }
  

  }
  
}

void update() {
  for (int i = 0; i < tvs; i++){
  if (overRect(list.get(i).x, list.get(i).y, list.get(i).size, list.get(i).size) ) {
    list.get(i).rectOver = true;
    
  } else {
    
    list.get(i).rectOver = false;
  }
  }
}

void updateRemote() {
  
  for (int i = 0; i < 4; i++){
  if (overRect(remote.get(i).x, remote.get(i).y, remote.get(i).size, remote.get(i).size) ) {
    remote.get(i).rectOver = true;
    
  } else {
    
    remote.get(i).rectOver = false;
  }
  }
}

void mousePressed() {
  for (int i = 0; i < tvs; i++){
  if (!list.get(i).rectOver) {
    currentColor = baseColor;
  }
  }
 for (int i = 0; i < 4; i++)  {
    if (remote.get(i).rectOver)  {
      remote.get(i).isPressed = !remote.get(i).isPressed;
    }
  }
  
}

void mouseReleased()  {
  for (int i = 0; i < 4; i++)  {
    if (remote.get(i).rectOver)  {
      remote.get(i).isPressed = !remote.get(i).isPressed;
      remote.get(i).isReleased = true;
    }
  }
  for (int i = 0; i < tvs; i++){
  if (list.get(i).rectOver) {
    list.get(i).isPressed = !list.get(i).isPressed;
    checkRemote(i);
  } 
  }
  
  
}

boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

void checkRemote(int number)  {
  for (int i = 0; i < tvs; i++)
  {
    if (i!=number)  {
    list.get(i).isPressed = false;
    }
  }
}

void showRemote(int i)  {
  
 /* if (onCountDown[i])  {
    remoteControl[0] = "Остановить\nтаймер";
  } else {
    remoteControl[0] = "ВКЛ/ВЫКЛ";
  }*/
  for (int j = 0; j < 4; j++)  {
     stroke(255);
     if(onCountDown[i] && (j==1 || j==2))  {
       fill(rectColor, 0, 70-j*10);
     }  else  {
       
       fill(rectColor, 60+j*3, 70-j*10);
     }
     
     rect(remote.get(j).x, remote.get(j).y, remote.get(j).size, remote.get(j).size);
     
     stroke(0);
     if (remote.get(j).isPressed) {
       fill(128);
     }  else  {
     fill(0);
     }
     
     textFont(f);
     text(remote.get(j).btnText, remote.get(j).x+rectSize/2, remote.get(j).y+rectSize/2);
     fill(0);
     
      int tmp = i+1;
    fill(0);
    
    if (onCountDown[i])  { 
       remote.get(3).btnText = btn;
       textFont(f);
       text("Тв " + tmp, remote.get(0).x+rectSize/2, remote.get(0).y+rectSize/2);
     }  else  {
       textFont(f2);
       text("Тв " + tmp, remote.get(0).x+rectSize/2, remote.get(0).y+rectSize/5);
     }
     
     
     if (remote.get(j).isReleased && !onCountDown[i])  {
       remote.get(j).isReleased = false;
         
                     switch(j) {
         case 0:  
                                         myPort.write('1'+i);
                                        
                                       /*list.get(i).countDown = -1; onCountDown[i] = false;*/ 
                                       break;                                             // cancel timer and send serial to i-th tv
         case 1:  
                                         curMin[i] = millis();
                                         startTimer(i, 15);
                                         //remote.get(j).btnText = btn;
                                       
                                       break;                                             //if not on countdown start 15 min countdown for i-th tv
         case 2:  
                                         curMin[i] = millis();
                                         startTimer(i, 30);
                                         //remote.get(j).btnText = btn;
                                       
                                       break;                                             // ------------"----------- 30 min ---------"-----------
         case 3:  
                                         curMin[i] = millis();
                                         startTimer(i, 60);
                                         //remote.get(j).btnText = btn;
                                       
                                       break;                                             // ------------"----------- 60 min ---------"-----------
         default: break;
       }
     }  else if (remote.get(j).isReleased)  {
                   remote.get(j).isReleased = false;
                         if (j==3)  {
                                         list.get(i).countDown = -1; 
                                         onCountDown[i] = false;
                         }
                                       
     }  else if(onCountDown[i])  {
                 if (j!=3)  {
                 remote.get(j).btnText = "";
                 }
     }  else  {
       
       remote.get(j).btnText = remoteControl[j];
       
     }
     
     
     
     
     
    }  // closing for loop
    
    
   
    
}

void startTimer(int i, int t)  {
  list.get(i).countDown = t;
  onCountDown[i] = true;
}


void updateTimer(int i) {
  if (list.get(i).countDown == 1 && !onSec[i])  {
    onSec[i] = true;
    list.get(i).countDown = 60;
  }
  if (!onSec[i] && list.get(i).countDown > 0) {  // if anything left to count
    if ((millis() - curMin[i]) > 60000)  {  // check if 60 seconds have passed
    list.get(i).countDown--;  // decrement t if passed
    curMin[i] = millis();
    }
  } else if (onSec[i] && list.get(i).countDown > 0) {
    if ((millis() - curMin[i]) > 1000)  {  // check if 1 second has passed
    list.get(i).countDown--;  // decrement t if passed
    curMin[i] = millis();
    }
  }  else if (onCountDown[i])  {
    onCountDown[i] = false;
    onSec[i] = false;
    myPort.write('1'+i);
  }//if time elapsed execute serial write with tv number    
}

void keyPressed()  {  //disable escape
  if (key==27)
  key=0;
}
