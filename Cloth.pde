int numHorizontalNodes = 4;
int numVerticalNodes = 3;

// Spring constant
float ks = 20;

// Damp constant
float kd = 10;

PVector gravity = new PVector(0, 200, 0);

// Rest length
float l0 = 3;

SpringNode[][] springNodes = new SpringNode[numHorizontalNodes][numVerticalNodes];

void setup() {
  size(600, 600, P3D);
  surface.setTitle("Cloth");
  rectMode(CENTER);
  
  InitCloth();
}

void draw() {
  background(0);
  //SimulateCloth();
  
  for (int i = 0; i < numHorizontalNodes; i++) {
    for (int j = 0; j < numVerticalNodes; j++) {
      springNodes[i][j].Update(0.1);
      springNodes[i][j].Display();
      
      println(springNodes[i][j].pos);
    }
  }
}

void InitCloth() {
  for (int i = 0; i < numHorizontalNodes; i++) {
    for (int j = 0; j < numVerticalNodes; j++) {
      PVector nodePos = new PVector(50 + 10*i, 50 + 10*j, 0);
      float nodeMass = 1.0;
      springNodes[i][j] = new SpringNode(nodePos, nodeMass);
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
      
      // But no gravity to the top row
      springNodes[0][j].vel = new PVector(0, 0, 0);
      
      // Update position and display
      springNodes[i][j].Update(0.1);
      springNodes[i][j].Display();
    }
  }
}

void ApplySpringForce(int i, int j, int otherI, int otherJ) {
  if (otherI < numHorizontalNodes && otherJ < numVerticalNodes) {
    SpringNode thisNode = springNodes[i][j];
    SpringNode otherNode = springNodes[otherI][otherJ];
    
    PVector e = otherNode.pos.sub(thisNode.pos);
    float l = e.mag();
    e.normalize();
    float v1 = e.dot(thisNode.vel);
    float v2 = e.dot(otherNode.vel);
    PVector springF = e.mult(-ks * (l0 - l) - kd * (v1 - v2));
    thisNode.ApplyForce(springF);
    otherNode.ApplyForce(springF.mult(-1));
  }
}
