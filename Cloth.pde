int numHorizontalNodes = 7;
int numVerticalNodes = 5;

float dt = 0.3;

// Spring constant
float ks = 40;

// Damp constant
float kd = 20;

float mass = 30;

PVector gravity = new PVector(0, 20, 0);

// Rest length
float l0 = 40;

SpringNode[][] springNodes = new SpringNode[numHorizontalNodes][numVerticalNodes];

void setup() {
  size(500, 500, P3D);
  surface.setTitle("Cloth");
  rectMode(CENTER);
  
  InitCloth();
}

void draw() {
  background(0);
  
  SimulateCloth();
}

void InitCloth() {
  for (int i = 0; i < numHorizontalNodes; i++) {
    for (int j = 0; j < numVerticalNodes; j++) {
      PVector nodePos = new PVector(150 + l0*i, 120 + l0*j + random(-10, 10), 0);
      springNodes[i][j] = new SpringNode(nodePos, mass);
    }
  }
}

void SimulateCloth() {
  for (int i = 0; i < numHorizontalNodes; i++) {
    for (int j = 0; j < numVerticalNodes; j++) {
      
      // Make horizontal connections
      ApplySpringForce(i, j, i+1, j);
      
      // Make vertical connections
      ApplySpringForce(i, j, i, j+1);
      
      // Apply gravity
      springNodes[i][j].ApplyForce(gravity);
      
      // No gravity for first row
      if (j == 0) {
        springNodes[i][j].vel = new PVector(0, 0, 0);
        springNodes[i][j].acc = new PVector(0, 0, 0);
        springNodes[i][j].col = color(255, 0, 0);
      }
      
      // Update position and display
      springNodes[i][j].Update(dt);
      springNodes[i][j].Display();
      
      //println("index:", i, j, "; pos =", springNodes[i][j].pos);
      //println("index:", i, j, "; vel =", springNodes[i][j].vel);
      //println("index:", i, j, "; acc =", springNodes[i][j].acc);
    }
  }
}

void ApplySpringForce(int i, int j, int otherI, int otherJ) {
  if (otherI < numHorizontalNodes && otherJ < numVerticalNodes) {
    SpringNode thisNode = springNodes[i][j];
    SpringNode otherNode = springNodes[otherI][otherJ];
    
    PVector e = PVector.sub(otherNode.pos, thisNode.pos);
    float l = e.mag();
    e.normalize();
    float v1 = e.dot(thisNode.vel);
    float v2 = e.dot(otherNode.vel);
    float springF = (-ks * (l0 - l)) + (-kd * (v1 - v2));
    thisNode.ApplyForce(PVector.mult(e, springF/thisNode.mass));
    otherNode.ApplyForce(PVector.mult(e, -springF/thisNode.mass));

    //println("index:", i, j, "; thisNode.vel =", thisNode.vel);
    //println("index:", i, j, "; thisNode.acc =", thisNode.acc);
    //println("index:", i, j, "; otherNode.vel =", otherNode.vel);
    
    // Draw spring line
    stroke(255);
    line(thisNode.pos.x, thisNode.pos.y, otherNode.pos.x, otherNode.pos.y);
  }
}
