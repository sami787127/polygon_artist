
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

float unitLength = 0.2;
float[] origin = {0,0}; 
//float[] u = {1,0};
//float[] v = {0,1};
//float[] o = {0,0};
ArrayList<float[]> matrices = new ArrayList();
float[] xUnit = {0,0};
float[] yUnit = {0,0};
boolean mPressed = false;
float prevX = -1, prevY = -1;
boolean mousePressedOnUnit = false;
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
 
  drawVertexCircle();
  if(selectedPolygon!=-1){
    drawUnitCoord(origin);
  }
  
  mouseClicked = false;
}

void drawVertexCircle(){
  if(selectedPolygon!=-1){
    ArrayList<float[]> polygon = polygons.get(selectedPolygon);
    for(int j= 0; j<polygon.size(); j++){
      strokeWeight(1);
      fill(0, 255 , 0);
      stroke(0);
      float[] matrix = matrices.get(selectedPolygon);
      applyMatrix(matrix[0], matrix[1], matrix[2],matrix[3],matrix[4],matrix[5]);
      float[] center = polygon.get(j);
      ellipse(center[0], center[1], CIRCLE_RADIUS, CIRCLE_RADIUS);
      resetMatrix();
    }
  }
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
       matrices.add(new float[]{1,0,0,0,1,0});
       colors.add(currColor);
     }
  }
}

void drawCircles(){
  strokeWeight(1);
  fill(0, 255 , 0);
  stroke(0);
  if(!vertices.isEmpty()){
    float[] center = vertices.get(0);
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
  //printMatrix();
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
      float[] matrix = matrices.get(i);
      applyMatrix(matrix[0], matrix[1], matrix[2],matrix[3],matrix[4],matrix[5]);
      printMatrix();
      fill(colors.get(i));
      
      beginShape(POLYGON);
      for(int j = 0; j<polygon.size(); j++){
        float[] point = polygon.get(j);
        vertex(point[0], point[1]);
      }
      float[] point = polygon.get(0);
      vertex(point[0], point[1]);
      endShape();
      resetMatrix();
    }
  }
}

float[] getOrigin(ArrayList<float[]> polygon){
  float sumX = 0.0;
  float sumY = 0.0;
  for(int i = 0; i<polygon.size(); i++){
    float[] point = polygon.get(i);
    sumX += point[0];
    sumY += point[1];
  }
  
  float x = sumX/polygon.size();
  float y = sumY/polygon.size();
  
  return new float[]{x,y};
}

void drawUnitCoord(float[] origin){
  stroke(255,0,0);
  strokeWeight(2);
  beginShape(LINES);
  vertex(origin[0], origin[1]);
  vertex(xUnit[0], xUnit[1]);
  vertex(origin[0], origin[1]);
  vertex(yUnit[0], yUnit[1]);
  endShape();
  
  strokeWeight(1);
  
  fill(200, 200, 0);
  ellipse(xUnit[0], xUnit[1], CIRCLE_RADIUS, CIRCLE_RADIUS);
  ellipse(yUnit[0], yUnit[1], CIRCLE_RADIUS, CIRCLE_RADIUS);
}

boolean checkPolygon(){
  if(!polygons.isEmpty()){
      for(int i = polygons.size()-1; i>=0; i--){
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
            origin = getOrigin(polygon);
            xUnit = new float[]{origin[0]+unitLength, origin[1]};
            yUnit = new float[]{origin[0], origin[1]+unitLength};
            return true;
        }
      }
      
  }
  
  return false;
}

void mouseDragged(){
  mousePosX = 2.0*mouseX/640-1;
  mousePosY = 1-2.0*mouseY/640;
  //int selectedVertex = -1;
  boolean mouseOnVertex = false;
  if(selectedPolygon!=-1){
    ArrayList<float[]> polygon = polygons.get(selectedPolygon);
    
    for(int i = 0; i<polygon.size(); i++){
      float[] vertex = polygon.get(i);
      if(sqrt( sq(vertex[0]-mousePosX) + sq(vertex[1]-mousePosY) ) <=CIRCLE_RADIUS){
        polygon.remove(i);
        polygon.add(i, new float[]{mousePosX, mousePosY});
        mouseOnVertex = true;
      }
    }
    
    
    if(sqrt( sq(xUnit[0]-mousePosX) + sq(xUnit[1]-mousePosY) ) <=CIRCLE_RADIUS){
      float[] matrix = matrices.get(selectedPolygon);
      matrix[0] += (mousePosX-xUnit[0])/unitLength;
      xUnit[0] = mousePosX;
        
      matrix[3] += (mousePosY-xUnit[1])/unitLength;
      xUnit[1] = mousePosY;
      
      mouseOnVertex = true;
    }
    else if(sqrt( sq(yUnit[0]-mousePosX) + sq(yUnit[1]-mousePosY) ) <=CIRCLE_RADIUS){
      float[] matrix = matrices.get(selectedPolygon);
      matrix[1] += (mousePosX-yUnit[0])/unitLength;
      yUnit[0] = mousePosX;
      matrix[4] += (mousePosY-yUnit[1])/unitLength;
      yUnit[1] = mousePosY;
      mouseOnVertex = true;
    }

  }
  
  if(!mouseOnVertex && !mousePressedOnUnit){
    //if(mPressed){
      
    //}
    if(selectedPolygon!=-1){
      float[] vector = {mousePosX-prevX, mousePosY-prevY};
      ArrayList<float[]> polygon = polygons.get(selectedPolygon);
      
      for(int i = 0; i<polygon.size(); i++){
        float[] vertex = polygon.get(i);
        vertex[0] += vector[0];
        vertex[1] += vector[1];
      }
      
      origin[0] += vector[0];
      origin[1] += vector[1];
      xUnit[0] += vector[0];
      
      xUnit[1] += vector[1];
      
      yUnit[0] += vector[0];
      yUnit[1] += vector[1];
      prevX = mousePosX;
      prevY = mousePosY;
      
      //matrices.remove(selectedPolygon);
      //matrices.add(selectedPolygon, matrix);
    }
  }

  
  redraw();
}

void mousePressed(){
  mPressed = true;
  mousePosX = 2.0*mouseX/640-1;
  mousePosY = 1-2.0*mouseY/640;
  if(isInside()){
      prevX = mousePosX;
      prevY = mousePosY;
  }
  if(sqrt( sq(xUnit[0]-mousePosX) + sq(xUnit[1]-mousePosY) ) <=CIRCLE_RADIUS){
        xUnit[0] = mousePosX;
        xUnit[1] = mousePosY;
        mousePressedOnUnit = true;
    }
    else if(sqrt( sq(yUnit[0]-mousePosX) + sq(yUnit[1]-mousePosY) ) <=CIRCLE_RADIUS){
        yUnit[0] = mousePosX;
        yUnit[1] = mousePosY;
        mousePressedOnUnit = true;
    }
  
}

void mouseReleased(){
  mousePressedOnUnit = false;
}




boolean isInside(){
  if(selectedPolygon!=-1){
    ArrayList<float[]> polygon = polygons.get(selectedPolygon);
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
      return true;
    }
  }
  return false;
  
}

void keyPressed(){
  if(key=='q'){
    if(selectedPolygon!=-1){
      matrices.remove(selectedPolygon);
      matrices.add(selectedPolygon, new float[]{1,0,0,0,1,0});
      xUnit = new float[]{origin[0]+unitLength, origin[1]};
      yUnit = new float[]{origin[0], origin[1]+unitLength};
      redraw();
    }
  }
  else if(key == 'w'){
    for(int i = 0; i<matrices.size(); i++){
      float[] matrix = matrices.get(i);
      matrix[5] += 0.1;
      
    }
    redraw();
  }
  
  else if(key=='a'){
   for(int i = 0; i<matrices.size(); i++){
     float[] matrix = matrices.get(i);
      matrix[2] -= 0.1;
      
    }
    redraw();
  }
  
  else if(key=='s'){
   for(int i = 0; i<matrices.size(); i++){
     float[] matrix = matrices.get(i);
     matrix[5] -= 0.1;
      
   }

   redraw();
    
  }
  else if(key=='d'){
   for(int i = 0; i<matrices.size(); i++){
     float[] matrix = matrices.get(i);
      matrix[2] += 0.1;
      
    }
    redraw();
  }
  
  else if(key == 'z'){
    for(int i = 0; i<matrices.size(); i++){
     float[] matrix = matrices.get(i);
      matrix[0] *= 1.1;
      matrix[1] *= 1.1;
      matrix[3] *= 1.1;
      matrix[4] *= 1.1;
      
    }
    
    redraw();
  }
  
  else if(key =='c'){
        for(int i = 0; i<matrices.size(); i++){
     float[] matrix = matrices.get(i);
      matrix[0] *= 0.9;
      matrix[1] *= 0.9;
      matrix[3] *= 0.9;
      matrix[4] *= 0.9;
      
    }
    
    redraw();
  }
  
  else if(key == 'x'){
    for(int i = 0; i<matrices.size(); i++){
      matrices.remove(i);
      matrices.add(i, new float[]{1,0,0,0,1,0});
      
    }
    redraw();
  }
}
