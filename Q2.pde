
final float CIRCLE_RADIUS = 30.0*(1.0/640);

int currColor = 200;
float mousePosX=-1, mousePosY=1;
float panelX = -1, panelY = 1;
float lineX = mousePosX, lineY = mousePosY;
int count = 0;
boolean drawingMode = false;
boolean mouseClicked = false;
ArrayList<float[]> vertices = new ArrayList();
ArrayList<ArrayList<float[]> > polygons = new ArrayList();
ArrayList<Integer> colors = new ArrayList();
final float PANEL_MARGIN= (-1.0+2.0/8.0+2.0/8.0);
int selectedPolygon = -1;

void setup(){
  size(640, 640, P3D);
  ortho(-1, 1, 1, -1);
  resetMatrix();
  noLoop();
}

void draw(){
  background(255,255,224);
  
  boolean recent = false;
  if(selectedPolygon!=-1){
    recent = true;
  }
  if(mouseClicked && !drawingMode && !(mouseClicked && mousePosX >= -1.0 && mousePosX <= PANEL_MARGIN)){
    if(!checkPolygon()){
      selectedPolygon = -1;
    
    }
  }
  if(mouseClicked && mousePosX >= -1.0 && mousePosX <= PANEL_MARGIN){
    panelX = mousePosX;
    panelY = mousePosY;
    
  }
  else if(mouseClicked && selectedPolygon==-1 && !recent){
    setMode();
    if(drawingMode){
      vertices.add(new float[]{mousePosX, mousePosY});
    }
  }
  
  
  colorPanel(panelX, panelY);
  drawPolygons();
  
  
  if(selectedPolygon==-1){
    drawRubberLine();
    drawLines();
    drawCircles();
  }
  
  
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
      currColor = fillColor;
      if(selectedPolygon!=-1 && mousePosX >= -1.0 && mousePosX <= PANEL_MARGIN){
        colors.remove(selectedPolygon);
        colors.add(selectedPolygon, fillColor);
      }
      
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
      currColor = fillColor;
      if(selectedPolygon!=-1 && (mousePosX >= -1.0 && mousePosX <= PANEL_MARGIN)){
        colors.remove(selectedPolygon);
        colors.add(selectedPolygon, fillColor);
      }
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
       colors.add(currColor);
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

void drawLines(){
  if(!vertices.isEmpty()){
    beginShape(LINE_STRIP);
    stroke(0);
    strokeWeight(1);
    for(int i = 0; i<vertices.size(); i++){
      float[] point = vertices.get(i);
      vertex(point[0], point[1]);
    }
    endShape();
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

void drawPolygons(){
  if(!polygons.isEmpty()){
    for(int i =0; i<polygons.size(); i++){
      ArrayList<float[]> polygon = polygons.get(i);
      
      if(selectedPolygon!=-1 && i==selectedPolygon){
        stroke(0,0,255);
        strokeWeight(2);
      }
      else{
        stroke(255, 0 ,0);
        strokeWeight(1);
      }
      fill(colors.get(i));
      
      beginShape(POLYGON);
      for(int j = 0; j<polygon.size(); j++){
        float[] point = polygon.get(j);
        vertex(point[0], point[1]);
      }
      float[] point = polygon.get(0);
      vertex(point[0], point[1]);
      endShape();
      if(i==selectedPolygon){
        for(int j= 0; j<polygon.size(); j++){
          
          strokeWeight(1);
          fill(0, 255 , 0);
          stroke(0);
          float[] center = polygon.get(j);
          ellipse(center[0], center[1], CIRCLE_RADIUS, CIRCLE_RADIUS);
        }
      }
    }
  }
}


boolean checkPolygon(){
  if(!polygons.isEmpty()){
      for(int i = 0; i<polygons.size(); i++){
        ArrayList<float[]> polygon = polygons.get(i);
        int countCross = 0;
        for(int j = 0; j<polygon.size(); j ++){
          //println(polygon.get(j));
          float[] point1;
          float[] point2;
          if(j!=polygon.size()-1){
            point1 = polygon.get(j);
            point2 = polygon.get(j+1);
          }
          else{
            point1 = polygon.get(j);
            point2 = polygon.get(0);
          }
          float x3 = mousePosX;
          //(((mousePosY+1.0)/2.0)*640.0)+0.5
          float y3 = mousePosY;
          float x4 = 1.0;
          float y4 = y3;
          //println("mouse"+" "+x3+","+y3+"  "+x4+","+y4);
          float x1 = point1[0];
          float y1 = point1[1];
          float x2 = point2[0];
          float y2 = point2[1];
          //println("lines"+" "+x1+","+y1+"  "+x2+","+y2);
          float ta = ( (x4-x3)*(y1-y3)-(y4-y3)*(x1-x3) )/( (y4-y3)*(x2-x1)-(x4-x3)*(y2-y1) );
          float tb = ( (x2-x1)*(y1-y3)-(y2-y1)*(x1-x3) )/( (y4-y3)*(x2-x1)- (x4-x3)*(y2-y1) );
          
          if(ta>=0.0 && ta<=1.0 && tb>=0.0 && tb<=1.0){
            if(y1<y3 && y2>y3){
              countCross++;
            }
            else{
              countCross--;
            }
          
          }
          
          
          
        }
        if(countCross!=0){
            selectedPolygon = i;
            return true;
        }
      }
      
  }
  
  return false;
}
