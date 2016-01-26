
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
import java.util.Map;
import java.util.Iterator;
import SimpleOpenNI.*;



/////////////////////////KINECT///////////////////////
SimpleOpenNI context;
//PVector com = new PVector();
//PVector com2d = new PVector();

float frame;
int trigger_Rready = 0;
int trigger_Lready = 0;
int trigger_start = 0;
//for chart//////////////
int[] data = new int[2];
float angle_1 = 0;
float angle_2 = data[0];
float num = 0;
PImage ring;
PFont font = createFont("arial", 20, true);
/////////////////////////////
Minim audio;
AudioPlayer[] song = new AudioPlayer[5];
AudioSample effect;
//////////////////////////////////
int check = 1;
int mb = 0, wb = 0;
int mar = 0, war = 0; // mar : m arrive of nth present
int SDspeed = 50; // sending frame
float cursorX = 0, cursorY = 0;

int song_time;
int song_type;
int song_i;





PImage cursor;
PImage bgimage;
PImage green;
PImage[] back = new PImage[2];
PImage[] button = new PImage[3];
PImage[] santa = new PImage[5];
PImage[] present = new PImage[5];
PImage[] people = new PImage[5];
Stack[] stackm = new Stack[100];
Stack[] stackw = new Stack[100];
int select_a = 3, select_b = 3;
int page = 0;
int trigger = 0;
//int size = 150;
int imgsize = 40;
int tt = 0;

//for location of button
int np_mx, np_my, np_wx, np_wy;
float np_w, np_h, time0, time1;
int press_mx, press_my, press_wx, press_wy;
int press_w, press_h;


int rand_n, rand_x, rand_y;
float curx, cury, purx, pury, velocity = 10; // curx : current x, purx : purpose x
int m, w, np1, np2;

// page 2 //
float ax1, ax2, ax3, ax4, ax5, ay1, ay3, m1, m2, xdistance, minsize ;  // x,y of select a
float bx1, bx2, bx3, bx4, bx5, by1, by3 ; // x,y of select b
float Hya, Hyb, Hmina, Hmaxa, Hminb, Hmaxb; // Hya:Hand in control box of a, Hmin : starting point, Hmax : ending point
float  Sxa1, Sxa2, Sxa3, Sxa4, Sxa5, SxaMin, Sxb1, Sxb2, Sxb3, Sxb4, Sxb5, SxbMin, Lba, Ubb; // Sxa1 : standard coordinate of x, SxaMin : past coordinate of sxa1
int loose, fast, NPspeed ; // loose : break for velocity, fast : multiple movement, NPspeed : speed of button going to page 0


/////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////FOR SNOWING///////////////////////////////////////////
int maxStarSize = 14;
String graphicsMode =  P2D;
ArrayList fallingChars;
///////////////////////////////////////////////////////////////////////


void setup(){
song_time = 0;
song_type = 0;
  song_i = 0;
  audio = new Minim(this);
  effect = audio.loadSample("WHOOSH26.WAV", 1024);
  //song.loop();
  //////////////////////KINECT///////////////////////
  context = new SimpleOpenNI(this);
  if(context.isInit() == false)
  {
    println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
    exit();
    return;  
  }
  // enable depthMap generation 
  context.enableDepth();
  // enable skeleton generation for all joints
  context.enableUser();
  //////////////////////////////////////////////////////////










  size(1024, 576);
  rectMode(CENTER);
  imageMode(CENTER);

  textFont(font);
  ring = loadImage("chart.png");
  cursor = loadImage("cursor.png");
  bgimage = loadImage("back.jpg");
  //back[0] = loadImage("treeback2.png");
  back[0]= loadImage("tree.png");
  back[1]= loadImage("tree.png");

  button[0] = loadImage("M.png");
  button[1] = loadImage("w.png");
  button[2] = loadImage("gibu.png");

  santa[0] = loadImage("santa0.png");
  santa[1] = loadImage("santa1.png");
  santa[2] = loadImage("santa2.png");
  santa[3] = loadImage("santa3.png");
  santa[4] = loadImage("santa4.png");

  present[0] = loadImage("1.png");
  present[1] = loadImage("2.png");
  present[2] = loadImage("3.png");
  present[3] = loadImage("4.png");
  present[4] = loadImage("5.png"); 
  green = loadImage("green.png");

  people[0] = loadImage("people1.png");
  people[1] = loadImage("people2.png");
  people[2] = loadImage("people3.png");
  people[3] = loadImage("people4.png");
  people[4] = loadImage("people5.png");

  //initialize location of option


  //initialize location of button
  np_mx = width*3/8;
  np_my = height*7/8;
  np_wx = width*5/8;
  np_wy = height*7/8;
  time0 = 0;
  time1 = 0;

  press_mx = int(width/4);
  press_my = int(height*17/20);
  press_wx = int(width*3/4);
  press_wy = int(height*17/20);
  press_w = 200;
  press_h = 70;

  //initialize for stack
  m = 0 ;
  w = 0 ;
  np1 = 0 ;
  np2 = 0 ;
  frame = 0;
  // page 1& 2 //

  ay1 = height/5 ;
  ay3 = height*3/10 ; // center y //
  by1 = height*4/5 ;
  by3 = height*7/10 ; 
  loose = 15 ;
  fast = 2 ;
  NPspeed = 20;



////////////////////////////////////////////////////
fallingChars = new ArrayList();  // Create an empty ArrayList
  for(int j = 0; j< 60; j++)      // now add some elements for initial seeding 
    CreateChar(1); 

}

void draw(){

  int i; //for index
noTint();
  image(bgimage, 0, 0, 2*1024, 2*576);

  imageMode(NORMAL);
  if(page!=0){
   tint(255, 180);
  } 
  image(back[0],imgsize,imgsize,width/2-imgsize,height-imgsize);
  image(back[1],width/2+imgsize,imgsize,width-imgsize,height-imgsize);
  
  ///////////////////////chart///////////////////////
  fill(100);
  smooth();
  noStroke();
  data[0] = m;
  data[1] = w;
  angle_1 = 0;
  num = 0;
  for (int chart_i=0; chart_i<data.length; chart_i++) {
    num += data[chart_i];
  }
  if(num!=0){
    num = 360/ num;
    for (int chart_i = 0; chart_i < data.length; chart_i++) {
      angle_2 = angle_1;
      angle_1 += data[chart_i] * num;

      if(chart_i==0){fill(37,132,64);}
      else{fill(183,30,42);}
      arc(width/2, height/6, height/7, height/7, radians(angle_2)+PI/2, radians(angle_1)+PI/2);
      fill(0);

    }
    

  }
  imageMode(CENTER);
  image(ring, width/2, height/6, height/4, height/4);

  /////////////////////////////////
////////////////////////////////FOR SNOW////////////////////
for (int j = fallingChars.size()-1; j >= 0; j--)
  {   // An ArrayList doesn't know what it is storing so we have to cast the object coming out
    fallingStar fc = (fallingStar) fallingChars.get(j);
    if (fc.notVisible() ) fallingChars.remove(j);
    else
    {
      fc.fall();
      fc.display();
    }
  }
  if ((frameCount & 2) > 0 )
  {
    int x = (int)random(4);
    for (int k = 0; k < x; k++)
    {
      CreateChar(4);  // top 1/4th
      CreateChar(8);  // top 1/8th
    }
  }






  //////////////////////////stack draw

  if( m >= 100 ){
    for(i=m%100; i<100; i++){
      stackm[i].drawstack();
    } 
    for(i=0; i<m%100-mb; i++){
      stackm[i].drawstack();
    } 
  } else {  
    for(i=0; i<m%100-mb; i++){
      stackm[i].drawstack();
    }
  }

  if( w >= 100 ){
    for(i=w%100; i<100; i++){
      stackw[i].drawstack();
    } 
    for(i=0; i<w%100-wb; i++){
      stackw[i].drawstack();
    } 
  } else {  
    for(i=0; i<w%100-wb; i++){
      stackw[i].drawstack();
    }
  }
  imageMode(CENTER);
/////////////////////////////////////////
    imageMode(CENTER);
    np_w = 50; //+ 10 * sin(time0/30) ;
    np_h = 100; //+ 20 * sin(time0/30) ;
    tint(80+70*sin(frame/30),80-70*sin(frame/30),50);
    image(button[0],np_mx,np_my,np_w,np_h);
    tint(80-70*sin(frame/30),80+70*sin(frame/30),50);
    image(button[1],np_wx,np_wy,np_w,np_h);
    noFill();
    noTint();

if((m+w)!=0){
  fill(255);
  textSize(25);
  textAlign(CENTER,TOP);
    text(m, width/2-100, height/6);
    text(w, width/2+100, height/6);
}
//////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////// page = 0 //////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
  if(page == 0){
 if(time1>10){
  noTint();
} else {
  tint(255,120+12*time1);
}
    if( time0 > 1 && mar == 0 && mb == 1 ){
      image(present[select_b-1],cursorX,cursorY,400,400);
    }      
    else if(mar>0){ 
      if( mar > SDspeed ){
        mar = 0;
        mb = 0;
      } else {
        image(present[select_b-1],curx,cury,400-300*mar/SDspeed,400-300*mar/SDspeed);
        curx = curx + (rand_x-curx)/velocity ;
        cury = cury + (rand_y-cury)/velocity ;

        mar++;
      }
    }


    if( time0 > 1 && war == 0 && wb == 1 ){
      image(present[select_b-1],cursorX,cursorY,400,400);
    }
    else if( war > 0 ){
      if( war > SDspeed ){
        war = 0;
        wb = 0;
      } else {
        image(present[select_b-1],curx,cury,400-300*war/SDspeed,400-300*war/SDspeed);
        curx = curx + (rand_x-curx)/velocity ;
        cury = cury + (rand_y-cury)/velocity ;
        war++;
      }
    }    





    if( cursorX<np_mx+np_w/2 && cursorX>np_mx-np_w/2 && cursorY<np_my+np_h/2 && cursorY>np_my-np_h/2 && mar == 0 && war == 0 && check == 1){
      page = 1 ;   
      ax1 = width/15 + width/2 ;
      ax3 = width/4 + width/2 ; // center x //
      bx1 = width/15 + width/2 ;
      bx3 = width/4 + width/2 ;
      // auto setting //
      xdistance = (ax3-ax1)/4 ;
      m1 = (ay1-ay3)/(ax1-ax3)/(ax1-ax3);
      m2 = (by1-by3)/(bx1-bx3)/(bx1-bx3);
      ax5 = 2*ax3-ax1 ;
      ax2 = (ax1+ax3)/2 ;
      ax4 = 2*ax3-ax2 ;
      bx5 = 2*bx3-bx1 ;
      bx2 = (bx1+bx3)/2 ;
      bx4 = 2*bx3-bx2 ;
      minsize = 70;
      Sxa1 = ax1 ;
      SxaMin = Sxa1 ;
      Sxb1 = bx1 ;
      SxbMin = Sxb1 ;
      Hmina = 0 ;
      Hmaxa = 0 ;
      Hya = 0 ;
      Hminb = 0 ;
      Hmaxb = 0 ;
      Hyb = 0 ;
      Lba = ay3 + ((ay3-ay1)*3/5+minsize)/2 ; // Lower bound for a //
      Ubb = by3 - ((by1-by3)*3/5+minsize)/2 ;
      time0 = 0;
      check = 0;


    }
    else if( cursorX<np_wx+np_w/2 && cursorX>np_wx-np_w/2 && cursorY<np_wy+np_h/2 && cursorY>np_wy-np_h/2 && mar == 0 && war == 0 && check == 1){
      page = 2 ;

      ax1 = width/15 ;
      ax3 = width/4 ; // center x //
      bx1 = width/15 ;
      bx3 = width/4 ;
      // auto setting //
      xdistance = (ax3-ax1)/4 ;
      m1 = (ay1-ay3)/(ax1-ax3)/(ax1-ax3);
      m2 = (by1-by3)/(bx1-bx3)/(bx1-bx3);
      ax5 = 2*ax3-ax1 ;
      ax2 = (ax1+ax3)/2 ;
      ax4 = 2*ax3-ax2 ;
      bx5 = 2*bx3-bx1 ;
      bx2 = (bx1+bx3)/2 ;
      bx4 = 2*bx3-bx2 ;
      minsize = 70;
      Sxa1 = ax1 ;
      SxaMin = Sxa1 ;
      Sxb1 = bx1 ;
      SxbMin = Sxb1 ;
      Hmina = 0 ;
      Hmaxa = 0 ;
      Hya = 0 ;
      Hminb = 0 ;
      Hmaxb = 0 ;
      Hyb = 0 ;
      Lba = ay3 + ((ay3-ay1)*3/5+minsize)/2 ; // Lower bound for a //
      Ubb = by3 - ((by1-by3)*3/5+minsize)/2 ;
      time0 = 0 ;
      check = 0;
    }

    //draw next-page button
   



  }


  ///////////////////////////////////////////// // page = 1 // /////////////////////////////////////////

  if(page == 1){
    imageMode(NORMAL);   
    //image(back[0], width/2, 0, width, height); // draw background tree
    noFill();
    imageMode(CENTER);
if(time0>20){
  noTint();
} else {
  tint(255,12*time0);
}
    //a//
    image(santa[0],Sxa1,m1*(ax3-Sxa1)*(ax3-Sxa1)+ay3,(m1*(ax3-Sxa1)*(ax3-Sxa1)+ay3-ay1)*3/5+minsize,(m1*(ax3-Sxa1)*(ax3-Sxa1)+ay3-ay1)*3/5+minsize);
    image(santa[1],Sxa2,m1*(ax3-Sxa2)*(ax3-Sxa2)+ay3,(m1*(ax3-Sxa2)*(ax3-Sxa2)+ay3-ay1)*3/5+minsize,(m1*(ax3-Sxa2)*(ax3-Sxa2)+ay3-ay1)*3/5+minsize);
    image(santa[2],Sxa3,m1*(ax3-Sxa3)*(ax3-Sxa3)+ay3,(m1*(ax3-Sxa3)*(ax3-Sxa3)+ay3-ay1)*3/5+minsize,(m1*(ax3-Sxa3)*(ax3-Sxa3)+ay3-ay1)*3/5+minsize);
    image(santa[3],Sxa4,m1*(ax3-Sxa4)*(ax3-Sxa4)+ay3,(m1*(ax3-Sxa4)*(ax3-Sxa4)+ay3-ay1)*3/5+minsize,(m1*(ax3-Sxa4)*(ax3-Sxa4)+ay3-ay1)*3/5+minsize);
    image(santa[4],Sxa5,m1*(ax3-Sxa5)*(ax3-Sxa5)+ay3,(m1*(ax3-Sxa5)*(ax3-Sxa5)+ay3-ay1)*3/5+minsize,(m1*(ax3-Sxa5)*(ax3-Sxa5)+ay3-ay1)*3/5+minsize);
    //line(ax1,Lba,ax5,Lba);


    if (cursorY<Lba && Hya == 0 && cursorX > ax1 && cursorX < +ax5 ){
      if ( Hmina == Hmaxa ){
        SxaMin = Sxa1 ;
      } else {
        SxaMin = SxaMin + int((Hmaxa-Hmina)/xdistance)*xdistance*fast ;
      }
      Hmina = constrain(cursorX, ax1, ax5) ;
    }else if (cursorY>=Lba && Hya == 1 && cursorX > ax1 && cursorX < ax5 ){
      Hmaxa = constrain(cursorX, ax1, ax5) ;
    }
    if (cursorY<Lba && cursorX > ax1 && cursorX < ax5 ){
      Hya = 1 ;
      Hmaxa = constrain(cursorX, ax1, ax5) ;
      tt = 0;
    } else { Hya = 0 ;
    }

    ///////////////pop-up//////////////////

    if ( abs(Sxa1-ax3) < xdistance ){
      select_a = 1;
    } else if ( abs(Sxa2-ax3) < xdistance ){
      select_a = 2;
    } else if ( abs(Sxa3-ax3) < xdistance ){
      select_a = 3;        
    } else if ( abs(Sxa4-ax3) < xdistance ){
      select_a = 4;
    } else if ( abs(Sxa5-ax3) < xdistance ){
      select_a = 5;  
    }   



    if ( abs(Sxa1-SxaMin-int((Hmaxa-Hmina)/xdistance)*xdistance*fast) < xdistance ){
      if( tt > 255){
        noTint();
        image(people[select_a-1],width/4,height/2,width*3/8,height/2);
        tint(255,255-np1);
            image(button[2],press_mx, press_my, press_w, press_h);  
        noTint();
      } else {
        tint(255,tt);    
        imageMode(CENTER);
        image(people[select_a-1],width/4,height/2,width*3/8,height/2);
            image(button[2],press_mx, press_my, press_w, press_h);  
        tt = tt + 15;
      }
    }
    noTint();
    ///////////////pop-up//////////////////




    if( Sxa1 < ax1 -  xdistance ){
      Sxa1 = Sxa1 + ax5 - ax1 +  xdistance*2 ;
      SxaMin = SxaMin + ax5 - ax1 +  xdistance*2 ;
    } else if ( Sxa1 > ax5 +  xdistance ){
      Sxa1 = Sxa1 + ax1 - ax5 -  xdistance*2;
      SxaMin = SxaMin + ax1 - ax5 -  xdistance*2 ;
    } else { Sxa1 = Sxa1 + (SxaMin-Sxa1+int((Hmaxa-Hmina)/xdistance)*xdistance*fast)/loose ;
    }
    if ( Sxa1 > ax4 +  xdistance ){Sxa2 = Sxa1 - ax5 + ax1  ;
    } else { Sxa2 = Sxa1 + ax2-ax1 ;
    }
    if ( Sxa1 > ax3 +  xdistance ){Sxa3 = Sxa1 - ax5 + ax2  ;
    } else { Sxa3 = Sxa1 + ax3-ax1 ;
    }
    if ( Sxa1 > ax2 +  xdistance ){Sxa4 = Sxa1 - ax5 + ax3  ;
    } else { Sxa4 = Sxa1 + ax4-ax1 ;
    }
    if ( Sxa1 > ax1 +  xdistance ){Sxa5 = Sxa1 - ax5 + ax4  ;
    } else { Sxa5 = Sxa1 + ax5-ax1 ;
    }


if(time0>20){
  noTint();
} else {
  tint(255,12*time0);
}



    //b//
    image(green,Sxb1,m2*(bx3-Sxb1)*(bx3-Sxb1)+by3,(-m2*(bx3-Sxb1)*(bx3-Sxb1)+by1-by3)*3/5+minsize,(-m2*(bx3-Sxb1)*(bx3-Sxb1)+by1-by3)*3/5+minsize);
    image(green,Sxb2,m2*(bx3-Sxb2)*(bx3-Sxb2)+by3,(-m2*(bx3-Sxb2)*(bx3-Sxb2)+by1-by3)*3/5+minsize,(-m2*(bx3-Sxb2)*(bx3-Sxb2)+by1-by3)*3/5+minsize);
    image(green,Sxb3,m2*(bx3-Sxb3)*(bx3-Sxb3)+by3,(-m2*(bx3-Sxb3)*(bx3-Sxb3)+by1-by3)*3/5+minsize,(-m2*(bx3-Sxb3)*(bx3-Sxb3)+by1-by3)*3/5+minsize);
    image(green,Sxb4,m2*(bx3-Sxb4)*(bx3-Sxb4)+by3,(-m2*(bx3-Sxb4)*(bx3-Sxb4)+by1-by3)*3/5+minsize,(-m2*(bx3-Sxb4)*(bx3-Sxb4)+by1-by3)*3/5+minsize);
    image(green,Sxb5,m2*(bx3-Sxb5)*(bx3-Sxb5)+by3,(-m2*(bx3-Sxb5)*(bx3-Sxb5)+by1-by3)*3/5+minsize,(-m2*(bx3-Sxb5)*(bx3-Sxb5)+by1-by3)*3/5+minsize);

    image(present[0],Sxb1,m2*(bx3-Sxb1)*(bx3-Sxb1)+by3,(-m2*(bx3-Sxb1)*(bx3-Sxb1)+by1-by3)*3/5+minsize,(-m2*(bx3-Sxb1)*(bx3-Sxb1)+by1-by3)*3/5+minsize);
    image(present[1],Sxb2,m2*(bx3-Sxb2)*(bx3-Sxb2)+by3,(-m2*(bx3-Sxb2)*(bx3-Sxb2)+by1-by3)*3/5+minsize,(-m2*(bx3-Sxb2)*(bx3-Sxb2)+by1-by3)*3/5+minsize);
    image(present[2],Sxb3,m2*(bx3-Sxb3)*(bx3-Sxb3)+by3,(-m2*(bx3-Sxb3)*(bx3-Sxb3)+by1-by3)*3/5+minsize,(-m2*(bx3-Sxb3)*(bx3-Sxb3)+by1-by3)*3/5+minsize);
    image(present[3],Sxb4,m2*(bx3-Sxb4)*(bx3-Sxb4)+by3,(-m2*(bx3-Sxb4)*(bx3-Sxb4)+by1-by3)*3/5+minsize,(-m2*(bx3-Sxb4)*(bx3-Sxb4)+by1-by3)*3/5+minsize);
    image(present[4],Sxb5,m2*(bx3-Sxb5)*(bx3-Sxb5)+by3,(-m2*(bx3-Sxb5)*(bx3-Sxb5)+by1-by3)*3/5+minsize,(-m2*(bx3-Sxb5)*(bx3-Sxb5)+by1-by3)*3/5+minsize);
    //line(bx1,Ubb,bx5,Ubb);

    if (cursorY>Ubb && Hyb == 0 && cursorX > bx1 && cursorX < bx5 ){
      if ( Hminb == Hmaxb ){
        SxbMin = Sxb1 ;
      } else {
        SxbMin = SxbMin + int((Hmaxb-Hminb)/xdistance)*xdistance*fast ;
      }
      Hminb = constrain(cursorX, bx1, bx5) ;
    }else if (  cursorY<=Ubb && Hyb == 1 && cursorX > bx1 && cursorX < bx5 ){
      Hmaxb = constrain(cursorX, bx1, bx5) ;
    }
    if (  cursorY>Ubb  && cursorX > bx1 && cursorX < bx5 ){
      Hyb = 1 ;
      Hmaxb = constrain(cursorX, bx1, bx5) ;
    } else { Hyb = 0 ;
    }



    if( Sxb1 < bx1 -  xdistance ){
      Sxb1 = Sxb1 + bx5 - bx1 +  xdistance*2 ;
      SxbMin = SxbMin + bx5 - bx1 +  xdistance*2 ;
    } else if ( Sxb1 > bx5 +  xdistance ){
      Sxb1 = Sxb1 + bx1 - bx5 -  xdistance*2;
      SxbMin = SxbMin + bx1 - bx5 -  xdistance*2 ;
    } else { Sxb1 = Sxb1 + (SxbMin-Sxb1+int((Hmaxb-Hminb)/xdistance)*xdistance*fast)/loose ;
    }
    if ( Sxb1 > bx4 +  xdistance ){Sxb2 = Sxb1 - bx5 + bx1  ;
    } else { Sxb2 = Sxb1 + bx2-bx1 ;
    }
    if ( Sxb1 > bx3 +  xdistance ){Sxb3 = Sxb1 - bx5 + bx2  ;
    } else { Sxb3 = Sxb1 + bx3-bx1 ;
    }
    if ( Sxb1 > bx2 +  xdistance ){Sxb4 = Sxb1 - bx5 + bx3  ;
    } else { Sxb4 = Sxb1 + bx4-bx1 ;
    }
    if ( Sxb1 > bx1 +  xdistance ){Sxb5 = Sxb1 - bx5 + bx4  ;
    } else { Sxb5 = Sxb1 + bx5-bx1 ;
    }



    // select //



    fill(255,0,0);
    if ( np1 > 250 ){
      if ( abs(Sxb1-bx3) < xdistance ){
        select_b = 1;
      } else if ( abs(Sxb2-bx3) < xdistance ){
        select_b = 2;
      } else if ( abs(Sxb3-bx3) < xdistance ){
        select_b = 3;        
      } else if ( abs(Sxb4-bx3) < xdistance ){
        select_b = 4;
      } else if ( abs(Sxb5-bx3) < xdistance ){
        select_b = 5;  
      }   

      // stack //
      rand_n = int(random(500,12000));
      rand_y = int(sqrt(rand_n -1))*4;
      rand_x = width/4+2*(rand_n - int(sqrt(rand_n-1))*(int(sqrt(rand_n-1))+1));


      if(select_b == 1){
        stackm[m%100] = new Stack(present[0], rand_x, rand_y);
      }
      else if(select_b == 2){
        stackm[m%100] = new Stack(present[1], rand_x, rand_y);
      }
      else if(select_b == 3){
        stackm[m%100] = new Stack(present[2], rand_x, rand_y);
      }
      else if(select_b == 4){
        stackm[m%100] = new Stack(present[3], rand_x, rand_y);
      }
      else if(select_b == 5){
        stackm[m%100] = new Stack(present[4], rand_x, rand_y);
      } 
      m++;
      mb = 1;
      wb = 0;
      time0 = 0;
      time1 = 0;
      page = 0;
      trigger_Rready = 0;
      trigger_Lready = 0;      
      
      np1 = 0;
      fill(0,255,0);
    } else if ( abs(cursorX-press_mx) < press_w/2 && abs(cursorY-press_my) < press_h/2 ){
      fill(255-np1,np1,0);
      np1 = np1 + NPspeed ;
    } else { np1 = 0;
    }



 tint(255,120);
  }


  // end page = 1 // 
  // page = 2 //

  else if(page == 2){
    imageMode(NORMAL);   
    //image(back[0], 0, 0, width/2, height); // draw background tree
    noFill();
    imageMode(CENTER);


if(time0>20){
  noTint();
} else {
  tint(255,12*time0);
}
    // a //

    image(santa[0],Sxa1,m1*(ax3-Sxa1)*(ax3-Sxa1)+ay3,(m1*(ax3-Sxa1)*(ax3-Sxa1)+ay3-ay1)*3/5+minsize,(m1*(ax3-Sxa1)*(ax3-Sxa1)+ay3-ay1)*3/5+minsize);
    image(santa[1],Sxa2,m1*(ax3-Sxa2)*(ax3-Sxa2)+ay3,(m1*(ax3-Sxa2)*(ax3-Sxa2)+ay3-ay1)*3/5+minsize,(m1*(ax3-Sxa2)*(ax3-Sxa2)+ay3-ay1)*3/5+minsize);
    image(santa[2],Sxa3,m1*(ax3-Sxa3)*(ax3-Sxa3)+ay3,(m1*(ax3-Sxa3)*(ax3-Sxa3)+ay3-ay1)*3/5+minsize,(m1*(ax3-Sxa3)*(ax3-Sxa3)+ay3-ay1)*3/5+minsize);
    image(santa[3],Sxa4,m1*(ax3-Sxa4)*(ax3-Sxa4)+ay3,(m1*(ax3-Sxa4)*(ax3-Sxa4)+ay3-ay1)*3/5+minsize,(m1*(ax3-Sxa4)*(ax3-Sxa4)+ay3-ay1)*3/5+minsize);
    image(santa[4],Sxa5,m1*(ax3-Sxa5)*(ax3-Sxa5)+ay3,(m1*(ax3-Sxa5)*(ax3-Sxa5)+ay3-ay1)*3/5+minsize,(m1*(ax3-Sxa5)*(ax3-Sxa5)+ay3-ay1)*3/5+minsize);
    // line(ax1,Lba,ax5,Lba);

    if (cursorY<Lba && Hya == 0 && cursorX > ax1 && cursorX < ax5 ){
      if ( Hmina == Hmaxa ){
        SxaMin = Sxa1 ;
      } else {
        SxaMin = SxaMin + int((Hmaxa-Hmina)/xdistance)*xdistance*fast ;
      }
      Hmina = constrain(cursorX, ax1, ax5) ;
    }else if (cursorY>=Lba && Hya == 1 && cursorX > ax1 && cursorX < ax5 ){
      Hmaxa = constrain(cursorX, ax1, ax5) ;
    }
    if (cursorY<Lba && cursorX > ax1 && cursorX < ax5 ){
      Hya = 1 ;
      Hmaxa = constrain(cursorX, ax1, ax5) ;
    } else { Hya = 0 ;
    }

    if( Sxa1 < ax1 -  xdistance ){
      Sxa1 = Sxa1 + ax5 - ax1 +  xdistance*2 ;
      SxaMin = SxaMin + ax5 - ax1 +  xdistance*2 ;
    } else if ( Sxa1 > ax5 +  xdistance ){
      Sxa1 = Sxa1 + ax1 - ax5 -  xdistance*2;
      SxaMin = SxaMin + ax1 - ax5 -  xdistance*2 ;
    } else { Sxa1 = Sxa1 + (SxaMin-Sxa1+int((Hmaxa-Hmina)/xdistance)*xdistance*fast)/loose ;
    }
    if ( Sxa1 > ax4 +  xdistance ){Sxa2 = Sxa1 - ax5 + ax1  ;
    } else { Sxa2 = Sxa1 + ax2-ax1 ;
    }
    if ( Sxa1 > ax3 +  xdistance ){Sxa3 = Sxa1 - ax5 + ax2  ;
    } else { Sxa3 = Sxa1 + ax3-ax1 ;
    }
    if ( Sxa1 > ax2 +  xdistance ){Sxa4 = Sxa1 - ax5 + ax3  ;
    } else { Sxa4 = Sxa1 + ax4-ax1 ;
    }
    if ( Sxa1 > ax1 +  xdistance ){Sxa5 = Sxa1 - ax5 + ax4  ;
    } else { Sxa5 = Sxa1 + ax5-ax1 ;
    }

    // end a //  
    
    if(time0>20){
  noTint();
} else {
  tint(255,12*time0);
}
    
    // b //
    image(green,Sxb1,m2*(bx3-Sxb1)*(bx3-Sxb1)+by3,(-m2*(bx3-Sxb1)*(bx3-Sxb1)+by1-by3)*3/5+minsize,(-m2*(bx3-Sxb1)*(bx3-Sxb1)+by1-by3)*3/5+minsize);
    image(green,Sxb2,m2*(bx3-Sxb2)*(bx3-Sxb2)+by3,(-m2*(bx3-Sxb2)*(bx3-Sxb2)+by1-by3)*3/5+minsize,(-m2*(bx3-Sxb2)*(bx3-Sxb2)+by1-by3)*3/5+minsize);
    image(green,Sxb3,m2*(bx3-Sxb3)*(bx3-Sxb3)+by3,(-m2*(bx3-Sxb3)*(bx3-Sxb3)+by1-by3)*3/5+minsize,(-m2*(bx3-Sxb3)*(bx3-Sxb3)+by1-by3)*3/5+minsize);
    image(green,Sxb4,m2*(bx3-Sxb4)*(bx3-Sxb4)+by3,(-m2*(bx3-Sxb4)*(bx3-Sxb4)+by1-by3)*3/5+minsize,(-m2*(bx3-Sxb4)*(bx3-Sxb4)+by1-by3)*3/5+minsize);
    image(green,Sxb5,m2*(bx3-Sxb5)*(bx3-Sxb5)+by3,(-m2*(bx3-Sxb5)*(bx3-Sxb5)+by1-by3)*3/5+minsize,(-m2*(bx3-Sxb5)*(bx3-Sxb5)+by1-by3)*3/5+minsize);

    image(present[0],Sxb1,m2*(bx3-Sxb1)*(bx3-Sxb1)+by3,(-m2*(bx3-Sxb1)*(bx3-Sxb1)+by1-by3)*3/5+minsize,(-m2*(bx3-Sxb1)*(bx3-Sxb1)+by1-by3)*3/5+minsize);
    image(present[1],Sxb2,m2*(bx3-Sxb2)*(bx3-Sxb2)+by3,(-m2*(bx3-Sxb2)*(bx3-Sxb2)+by1-by3)*3/5+minsize,(-m2*(bx3-Sxb2)*(bx3-Sxb2)+by1-by3)*3/5+minsize);
    image(present[2],Sxb3,m2*(bx3-Sxb3)*(bx3-Sxb3)+by3,(-m2*(bx3-Sxb3)*(bx3-Sxb3)+by1-by3)*3/5+minsize,(-m2*(bx3-Sxb3)*(bx3-Sxb3)+by1-by3)*3/5+minsize);
    image(present[3],Sxb4,m2*(bx3-Sxb4)*(bx3-Sxb4)+by3,(-m2*(bx3-Sxb4)*(bx3-Sxb4)+by1-by3)*3/5+minsize,(-m2*(bx3-Sxb4)*(bx3-Sxb4)+by1-by3)*3/5+minsize);
    image(present[4],Sxb5,m2*(bx3-Sxb5)*(bx3-Sxb5)+by3,(-m2*(bx3-Sxb5)*(bx3-Sxb5)+by1-by3)*3/5+minsize,(-m2*(bx3-Sxb5)*(bx3-Sxb5)+by1-by3)*3/5+minsize);
    //line(bx1,Ubb,bx5,Ubb);

    if (cursorY>Ubb && Hyb == 0 && cursorX > bx1 && cursorX < bx5 ){
      if ( Hminb == Hmaxb ){
        SxbMin = Sxb1 ;
      } else {
        SxbMin = SxbMin + int((Hmaxb-Hminb)/xdistance)*xdistance*fast ;
      }
      Hminb = constrain(cursorX, bx1, bx5) ;
    }else if ( cursorY<=Ubb && Hyb == 1 && cursorX > bx1 && cursorX < bx5 ){
      Hmaxb = constrain(cursorX, bx1, bx5) ;
    }
    if (  cursorY>Ubb  && cursorX > bx1 && cursorX < bx5 ){
      Hyb = 1 ;
      Hmaxb = constrain(cursorX, bx1, bx5) ;
      tt = 0 ;
    } else { Hyb = 0 ;
    }


    ///////////////pop-up//////////////////
    if ( abs(Sxa1-ax3) < xdistance ){
      select_a = 1;
    } else if ( abs(Sxa2-ax3) < xdistance ){
      select_a = 2;
    } else if ( abs(Sxa3-ax3) < xdistance ){
      select_a = 3;        
    } else if ( abs(Sxa4-ax3) < xdistance ){
      select_a = 4;
    } else if ( abs(Sxa5-ax3) < xdistance ){
      select_a = 5;  
    }   

    if ( abs(Sxa1-SxaMin-int((Hmaxa-Hmina)/xdistance)*xdistance*fast) < xdistance ){
      if( tt > 255){
        noTint();
        image(people[select_a-1],width*3/4,height/2,width*3/8,height/2);
                    tint(255,255-np2);
            image(button[2],press_wx, press_wy, press_w, press_h);  
        noTint();    
      } else {
        tint(255,tt);    
        imageMode(CENTER);
        image(people[select_a-1],width*3/4,height/2,width*3/8,height/2);
           image(button[2],press_wx, press_wy, press_w, press_h);  
           tt = tt + 15;
      }
    }
    noTint();

    ///////////////pop-up//////////////////


    if( Sxb1 < bx1 -  xdistance ){
      Sxb1 = Sxb1 + bx5 - bx1 +  xdistance*2 ;
      SxbMin = SxbMin + bx5 - bx1 +  xdistance*2 ;
    } else if ( Sxb1 > bx5 +  xdistance ){
      Sxb1 = Sxb1 + bx1 - bx5 -  xdistance*2;
      SxbMin = SxbMin + bx1 - bx5 -  xdistance*2 ;
    } else { Sxb1 = Sxb1 + (SxbMin-Sxb1+int((Hmaxb-Hminb)/xdistance)*xdistance*fast)/loose ;
    }
    if ( Sxb1 > bx4 +  xdistance ){Sxb2 = Sxb1 - bx5 + bx1  ;
    } else { Sxb2 = Sxb1 + bx2-bx1 ;
    }
    if ( Sxb1 > bx3 +  xdistance ){Sxb3 = Sxb1 - bx5 + bx2  ;
    } else { Sxb3 = Sxb1 + bx3-bx1 ;
    }
    if ( Sxb1 > bx2 +  xdistance ){Sxb4 = Sxb1 - bx5 + bx3  ;
    } else { Sxb4 = Sxb1 + bx4-bx1 ;
    }
    if ( Sxb1 > bx1 +  xdistance ){Sxb5 = Sxb1 - bx5 + bx4  ;
    } else { Sxb5 = Sxb1 + bx5-bx1 ;
    }

    // end b //
    // send button //

    fill(255,0,0);
    if ( np2 > 250 ){
      if ( abs(Sxb1-bx3) < xdistance ){
        select_b = 1;
      } else if ( abs(Sxb2-bx3) < xdistance ){
        select_b = 2;
      } else if ( abs(Sxb3-bx3) < xdistance ){
        select_b = 3;        
      } else if ( abs(Sxb4-bx3) < xdistance ){
        select_b = 4;
      } else if ( abs(Sxb5-bx3) < xdistance ){
        select_b = 5;  
      }

      // stack //
      rand_n = int(random(500,12000));
      rand_y = int(sqrt(rand_n -1))*4;
      rand_x = width*3/4+2*(rand_n - int(sqrt(rand_n-1))*(int(sqrt(rand_n-1))+1));

      if(select_b == 1){
        stackw[w%100] = new Stack(present[0], rand_x, rand_y);
      }
      else if(select_b == 2){
        stackw[w%100] = new Stack(present[1], rand_x, rand_y);
      }
      else if(select_b == 3){
        stackw[w%100] = new Stack(present[2], rand_x, rand_y);
      }
      else if(select_b == 4){
        stackw[w%100] = new Stack(present[3], rand_x, rand_y);
      }
      else if(select_b == 5){
        stackw[w%100] = new Stack(present[4], rand_x, rand_y);
      } 
      w++;
      mb = 0;
      wb = 1;

      page = 0;
      trigger_Rready = 0;
      trigger_Lready = 0;     
      time0 = 0;
      time1 = 0;
      np2 = 0;
      fill(0,255,0);
    } else if ( abs(cursorX-press_wx) < press_w/2 && abs(cursorY-press_wy) < press_h/2 ){
      fill(255-np2,np2,0);
      np2 = np2 + NPspeed ;
    } else { np2 = 0;
    }



tint(255,120);

  }
  //end page = 2//











  ///////////////////////////KINECT/////////////////////////////////
  /////////////////////////
 imageMode(CENTER);
  context.update();

  //draw user
  //image(context.userImage(),0,0);

  //draw sckel
  int[] userList = context.getUsers();

  for(i=0; i< userList.length; i++){ 
if(context.isTrackingSkeleton(userList[i])){
  noTint();
    image(cursor, cursorX, cursorY, 40, 40);
  
  
  if(song_type==0){
    if(song_i==0){
  song[0] = audio.loadFile("song1.mp3", 1024);
      song_time = millis();
      song_i++;
    }
    song[0].play();
    if((millis() - song_time) > 144000){
      song[0].close();
      song_i = 0;
      song_type++;
    }
  }
  else if(song_type==1){
    if(song_i==0){
  song[1] = audio.loadFile("song2.mp3", 1024);
      song_time = millis();
      song_i++;
    }
    song[1].play();
    if((millis() - song_time) > 184000){
      song[1].close();
      song_i=0;
      song_type++;
    }
  }
  else if(song_type==2){
    if(song_i==0){
  song[2] = audio.loadFile("song3.mp3", 1024);
      song_time = millis();
      song_i++;
    }
    song[2].play();
    if((millis() - song_time) > 125000){
      song[2].close();
      song_i = 0;
      song_type++;
    }
  }
  else if(song_type==3){
    if(song_i==0){
  song[3] = audio.loadFile("song4.mp3", 1024);
      song_time = millis();
      song_i++;
    }
    song[3].play();
    if((millis() - song_time) > 125000){
      song[3].close();
      song_i = 0;
      song_type++;
    }
  }
  else if(song_type==4){
    if(song_i==0){
  song[4] = audio.loadFile("song5.mp3", 1024);
      song_time = millis();
      song_i++;
    }
    song[4].play();
    if((millis() - song_time) > 231000){
      song[4].close();
      song_i = 0;
      song_type = 0;
    }
  }
}
    //get center of mass
    //context.getCoM(userList[0],com);
    //context.convertRealWorldToProjective(com,com2d);

    //for trigger get joint position
    PVector joint_Rshoulder = new PVector();
    PVector joint_Rhand = new PVector();
    PVector joint_Lshoulder = new PVector();
    PVector joint_Lhand = new PVector();
    PVector joint_torso = new PVector();
    PVector joint_head = new PVector();
    float confidence;
    confidence = context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_RIGHT_SHOULDER, joint_Rshoulder);
    confidence = context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_RIGHT_HAND, joint_Rhand);
    confidence = context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_LEFT_SHOULDER, joint_Lshoulder);
    confidence = context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_LEFT_HAND, joint_Lhand);
    confidence = context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_TORSO, joint_torso);
    confidence = context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_HEAD, joint_head);


    float Rdist = distance(joint_Rshoulder, joint_Rhand);
    float Ldist = distance(joint_Lshoulder, joint_Lhand);

    if(page == 0 && time1 > 10){
      if(Rdist<150000 || Ldist<150000)
      {
        if(Rdist<150000 & Rdist>1){trigger_Rready = 1;}
        if(Ldist<150000 & Ldist>1){trigger_Lready = 1;}
      }
      if(trigger_Rready==1 & Rdist>300000 & joint_torso.y<joint_Rhand.y)
      {
        trigger += 1;
        trigger_start = 1;
        trigger_Rready = 0;
        trigger_Lready = 0;
      }
      if(trigger_Lready==1 & Ldist>300000 & joint_torso.y<joint_Lhand.y)
      {
        trigger += 1;
        trigger_start = 1;
        trigger_Rready = 0;
        trigger_Lready = 0;
      }
      if(trigger_start==1 && mar == 0 && war == 0 && check == 0)
      { 
        curx = cursorX ;
        cury = cursorY ;
        time0 = 0;
        imageMode(CENTER);
        if(mb == 1){
          mar = 1;
        }
        else if(wb == 1){
          war = 1;
        }
        check = 1;
        effect.trigger();
        trigger_start = 0;

      }

    }





    /////////////////for handmouse///////////////////
    rectMode(CENTER);
    noTint();
    image(cursor, cursorX, cursorY, 40, 40);
    cursorX = cursorXfc(joint_Rhand, joint_head, joint_Lshoulder, page, mb, wb);
    cursorY = cursorYfc(joint_Rhand, joint_head, joint_torso);




  } 

  /////// end draw //////// 


    time0 ++;
    time1 ++;
    frame ++;

textSize(50);
  


}

float cursorYfc(PVector p, PVector head, PVector torso){
  float basis = (head.y-torso.y)/2;
  return (height*(350 + constrain(basis-p.y, -350, 350))/700);
}
float cursorXfc(PVector p, PVector head, PVector Lsholder, int page, int mb, int wb){
  float x = width*(constrain(p.x-Lsholder.x - ((head.x-Lsholder.x)/2), 0, 800)/800);
//  float y = constrain(x*3/2+width/4,0,width);
//  float z = constrain(x*3/2-width/2,0,width);


  float z = width*(constrain(p.x-Lsholder.x - ((head.x-Lsholder.x)/2), 0, 1100)/400) - width*5/8;
  float y = width*(constrain(p.x-Lsholder.x - ((head.x-Lsholder.x)/2), -300, 800)/800) + width/4;
  if(page == 1 || mb ==1){
    return y;
  }
  else if(page == 2 || wb ==1){
    return z;
  }
  else{
    return x;
  }
}

///////////////////////////////////FORSNOW////////////////////////////
void CreateChar(int n)
{
  int x = (int)random(width);
  int y = (int)random(height/ n);
  if (n == 1) // Start by adding some elements to whole screen
    fallingChars.add(new fallingStar(x, y)); 
  else // top-up
    fallingChars.add(new fallingStar(x, -y));  // Start by adding some elements
}
void star(int nPoints, float rad1, float rad2)
{
  float angle = TWO_PI / nPoints;
  float angle2 = angle / 2;
  float origAngle = 0.0;
  beginShape();
  fill(255,255,255);
  stroke(255,255,255);
  strokeWeight(1);
  for (int i = 0; i < nPoints; i++)
  {
    float y1 = rad1 * sin(origAngle);
    float x1 = rad1 * cos(origAngle);
    float y2 = rad2 * sin(origAngle + angle2);
    float x2 = rad2 * cos(origAngle + angle2);
    vertex(x1, y1);
    vertex(x2, y2);
    origAngle += angle;
  }
  endShape(CLOSE);
}




////////////////////FOR KINECT///////////////////////////////////////////


float distance(PVector shoulder, PVector hand)
{
  float out;
  out = (shoulder.x - hand.x)*(shoulder.x - hand.x) + (shoulder.y - hand.y)*(shoulder.y - hand.y) + (shoulder.z - hand.z)*(shoulder.z - hand.z);
  return out;
}

//////////////////////////////////////////////////////////////////////////////

// draw the skeleton with the selected joints
void drawSkeleton(int userId)
{
  // to get the 3d joint data
  

  context.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);

  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);

  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);

  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);

  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);

  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);  
}

// -----------------------------------------------------------------
// SimpleOpenNI events

void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");

  curContext.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  //println("onVisibleUser - userId: " + userId);
}
