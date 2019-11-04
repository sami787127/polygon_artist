
final float CIRCLE_RADIUS = 30.0*(1.0/640);


float mousePosX=-1, mousePosY=1;
float panelX = -1, panelY = 1;
float lineX = mousePosX, lineY = mousePosY;
int count = 0;
boolean drawingMode = false;
boolean mouseClicked = false;
ArrayList<float[]> vertices = new ArrayList();
ArrayList<ArrayList<float[]> > polygons = new ArrayList();
final float PANEL_MARGIN= (-1.0+2.0/8.0+2.0/8.0);
void setup(){
  size(640, 640, P3D);
  ortho(-1, 1, 1, -1);
  resetMatrix();
  noLoop();
}

void draw(){
  background(255,255,224);
  if(mouseClicked && mousePosX >= -1.0 && mousePosX <= PANEL_MARGIN){
    panelX = mousePosX;
    panelY = mousePosY;
    
  }
  else if(mouseClicked){
    setMode();
    if(drawingMode){
      vertices.add(new float[]{mousePosX, mousePosY});
    }
  }
  colorPanel(panelX, panelY);
  drawCircles();
  
  drawRubberLine();
  
  mouseClicked = false;
}

void colorPanel(float mPosX, float mPosY){
  float x1 = -1;
  float y1 = 1;
  float x2 = (2.0/8.0)-1;
  float y2 = 1;
  float x3 = (2.0/8.0)-1;
  float y3 = 1-(2.0/8.0);
  float x4 = -1;
  float y4 = 1-(2.0/8.0);
  int fillColor = 200;
  
  for(int i = 0; i<8; i++){
    
    fill(fillColor);
    if(mPosX>=x1 && mPosX<x2 && mPosY<= y1 && mPosY> y3){
      stroke(255);
      strokeWeight(5);
      
    }
    else{
      noStroke();
    }
    beginShape(QUADS);
    vertex(x1, y1);
    vertex(x2, y2);
    vertex(x3, y3);
    vertex(x4, y4);
    endShape();
    fillColor -= 15;
    y1 = y4;
    y2 = y3;
    y3 = y3- (2.0/8.0);
    y4 = y4 - (2.0/8.0);
  }
  
  x1 = -1.0+(2.0/8.0);
  y1 = 1;
  x2 = x1 + (2.0/8.0);
  y2 = 1;
  x3 = x2;
  y3 = 1-(2.0/8.0);
  x4 = x1;
  y4 = 1-(2.0/8.0);
  fillColor = 220;
  
  for(int i = 0; i<8; i++){
    if(mPosX>=x1 && mPosX<x2 && mPosY<= y1 && mPosY> y3){
      strokeWeight(5);
      stroke(255);
    }
    else{
      noStroke();
    }
    fill(fillColor);
    beginShape(QUADS);
    vertex(x1, y1);
    vertex(x2, y2);
    vertex(x3, y3);
    vertex(x4, y4);
    endShape();
    y1 = y4;
    y2 = y3;
    y3 = y3- (2.0/8.0);
    y4 = y4 - (2.0/8.0);
    fillColor -= 15;
  }
 
}

void setMode(){
  if(vertices.isEmpty()){
    drawingMode = true;
  }
  else{
     float[] pos =  vertices.get(0);
     if(sqrt(sq(pos[0]-mousePosX)+sq(pos[1]-mousePosY))<=CIRCLE_RADIUS ){
       drawingMode = false;
       polygons.add(vertices);
       vertices = new ArrayList();
     }
  }
}

void drawCircles(){
  strokeWeight(1);
  fill(0, 255 , 0);
  stroke(0);
  for(int i = 0; i<vertices.size(); i++){
    float[] center = vertices.get(i);
    ellipse(center[0], center[1], CIRCLE_RADIUS, CIRCLE_RADIUS);
  }
}

void mouseClicked(){
  mousePosX = 2.0*mouseX/640-1;
  mousePosY = 1-2.0*mouseY/640;
  //println("clicked"+" "+mousePosX+" "+mousePosY);
  mouseClicked = true;
  redraw();
}

void mouseMoved(){
  mousePosX = 2.0*mouseX/640-1;
  mousePosY = 1-2.0*mouseY/640;
  if(drawingMode && !(mousePosX >= -1.0 && mousePosX <= PANEL_MARGIN)){
    redraw();
  }
}


void drawRubberLine(){
  if(!vertices.isEmpty()){
    beginShape(LINES);
    stroke(0);
    strokeWeight(1);
    float[] point = vertices.get(vertices.size()-1);
    vertex(point[0], point[1]);
    if(!(mousePosX >= -1.0 && mousePosX <= PANEL_MARGIN)){
      lineX = mousePosX;
      lineY = mousePosY;
    }
    vertex(lineX, lineY);
    endShape();
  }
}
