void setup() {
  size(400, 400, P3D);
  background(167, 167, 167);
  //frameRate(167);
}

class Si {
    float rx = 0;
    float ry = 0;
    float vrx = 0;
    float vry = 0;
    float friction = 0.95;
    float x, y;
    
    float lastRollTime = -1000;
    float rollCooldown = 1000;
    
    boolean rolling = false;

    boolean isMouseDown = false;
    
    PVector[] faceNormals = {
      new PVector(0, 0, 1),
      new PVector(0, 0, -1),
      new PVector(1, 0, 0),
      new PVector(-1, 0, 0),
      new PVector(0, -1, 0),
      new PVector(0, 1, 0)
    };
    
    Si(float x, float y) {   
      this.x = x;
      this.y = y;
    }
    
    void update() {
        if (isMouseDown && millis() - lastRollTime >= rollCooldown) {
          vrx = random(-5, 5);
          vry = random(-5, 5);
          rolling = true;
          lastRollTime = millis();
        }
        
        rx += vrx;
        ry += vry;
        
        vrx *= friction;
        vry *= friction;
        
        if (rolling && abs(vrx) < 0.5 && abs(vry) < 0.5) {
          rx = round(rx/HALF_PI) * HALF_PI;
          ry = round(ry/HALF_PI) * HALF_PI;
          vrx = 0;
          vry = 0;
          rolling = false;
        }
    }
    
    void show() {
        pushMatrix();
        translate(x+mouseX, y, 0);
        rotateX(rx);
        rotateY(ry);
        
        float size = 40;
        for(int i = 0; i < 6; i++) {
          pushMatrix();
          if (i == 0) translate(0, 0, size/2);  // front
          if (i == 1) { rotateY(PI); translate(0, 0, size/2); }  // back
          if (i == 2) { rotateY(HALF_PI); translate(0, 0, size/2);} // right
          if (i == 3) { rotateY(-HALF_PI); translate(0, 0, size/2);} // left
          if (i == 4) { rotateX(-HALF_PI); translate(0, 0, size/2);} // top
          if (i == 5) { rotateX(HALF_PI); translate(0, 0, size/2);} // bottom

          fill(255);
          stroke(0);
          rectMode(CENTER);
          rect(0, 0, size, size);
          
          pushMatrix();
          translate(0, 0, 0.5);
          fill(0);
          noStroke();
          drawFace(i + 1);
          popMatrix();
          
          popMatrix();
        }
        popMatrix();
        
        fill(0);
    }
    
    void drawFace(int num) {
    float pipSize = 6;
    float d = 12;
    if (num == 1) ellipse(0, 0, pipSize, pipSize);
    if (num == 2) { ellipse(-d, -d, pipSize, pipSize); ellipse(d, d, pipSize, pipSize); }
    if (num == 3) { ellipse(-d, -d, pipSize, pipSize); ellipse(0, 0, pipSize, pipSize); ellipse(d, d, pipSize, pipSize); }
    if (num == 4) {
      ellipse(-d, -d, pipSize, pipSize); ellipse(d, -d, pipSize, pipSize);
      ellipse(-d, d, pipSize, pipSize);  ellipse(d, d, pipSize, pipSize);
    }
    if (num == 5) {
      ellipse(-d, -d, pipSize, pipSize); ellipse(d, -d, pipSize, pipSize);
      ellipse(0, 0, pipSize, pipSize);
      ellipse(-d, d, pipSize, pipSize); ellipse(d, d, pipSize, pipSize);
    }
    if (num == 6) {
      ellipse(-d, -d, pipSize, pipSize); ellipse(d, -d, pipSize, pipSize);
      ellipse(-d, 0, pipSize, pipSize); ellipse(d, 0, pipSize, pipSize);
      ellipse(-d, d, pipSize, pipSize); ellipse(d, d, pipSize, pipSize);
    }
  }
    
  PVector rotatedNormal(float rx, float ry, PVector n) {
    PVector r = n.get();
    float cosX = cos(rx);
    float sinX = sin(rx);
    float y1 = r.y * cosX - r.z * sinX;
    float z1 = r.y * sinX + r.z * cosX;
    r.y = y1;
    r.z = z1;
    
    float cosY = cos(ry);
    float sinY = sin(ry);
    float x1 = r.x * cosY + r.z * sinY;
    float z2 = -r.x * sinY + r.z * cosY;
    r.x = x1;
    r.z = z2;
    
    return r;
  }
  
  int getCurrentFace() {
    float maxDot = -999;
    int bestFace = 0;
    PVector viewDir = new PVector(0, 0, -1);
  
    for (int i = 0; i < faceNormals.length; i++) {
      PVector n = rotatedNormal(rx, ry, faceNormals[i]);
      float dot = n.dot(viewDir);
      if (dot > maxDot) {
        maxDot = dot;
        bestFace = i;
      }
    }
  
    return bestFace + 1;
  }
}

void mousePressed() {
  isMouseDown = true;
}

void mouseReleased() {
  isMouseDown = false;
}

Si obama1 = new Si(mouseX-100, 100);
Si obama2 = new Si(mouseX, 100);
Si obama3 = new Si(mouseX+100, 100);
Si obama4 = new Si(mouseX-100, 200);
Si obama5 = new Si(mouseX, 200);
Si obama6 = new Si(mouseX+100, 200);
Si obama7 = new Si(mouseX-100, 300);
Si obama8 = new Si(mouseX, 300);
Si obama9 = new Si(mouseX+100, 300);

void draw() {
  background(167, 167, 167);
  obama1.update();
  obama2.update();
  obama3.update();
  obama4.update();
  obama5.update();
  obama6.update();
  obama7.update();
  obama8.update();
  obama9.update();

  obama1.show();
  obama2.show();
  obama3.show();
  obama4.show();
  obama5.show();
  obama6.show();
  obama7.show();
  obama8.show();
  obama9.show();
  
  int total = 0;
  Si[] dices = {obama1, obama2, obama3, obama4, obama5, obama6, obama7, obama8, obama9};
  
  for (Si d : dices) {
    if (!d.rolling) total += d.getCurrentFace();
  }

  fill(0);
  textSize(20);
  text("Total: " + total, 10, 30);


}
