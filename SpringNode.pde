class SpringNode {
  PVector pos, vel, acc;
  float mass;
  
  SpringNode (PVector pos, float mass) {
    this.pos = pos;
    this.mass = mass;
    
    vel = new PVector(0, 0, 0);
    acc = new PVector(0, 0, 0);
  }
  
  void Update(float dt) {
    vel.add(acc.mult(dt));
    pos.add(vel.mult(dt));
    acc = new PVector(0, 0, 0);
  }
  
  void ApplyForce(PVector force) {
    acc.add(force.div(mass));
  }
  
  void Display() {
    translate(pos.x, pos.y, pos.z);
    rect(0, 0, 10, 10);
  }
}
