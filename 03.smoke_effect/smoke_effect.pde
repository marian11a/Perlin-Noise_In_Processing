int cols, rows;
int scl = 20;

PVector[][] flowfield;
ArrayList<Particle> particles = new ArrayList<Particle>();

void setup() {
  size(800, 800, P2D);
  cols = floor(width / scl);
  rows = floor(height / scl);
  flowfield = new PVector[cols][rows];
  for (int i = 0; i < 1000; i++) {
    particles.add(new Particle());
  }
  background(255);
}

void draw() {
  
  float time = millis() * 0.0001; // Time component for Perlin noise
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      float theta = map(noise(i * 0.1, j * 0.1, time), 0, 1, 0, TWO_PI);
      flowfield[i][j] = PVector.fromAngle(theta);
    }
  }
   for (Particle p : particles) {
    p.follow(flowfield);
    p.update();
    p.edges();
    p.show();
  }
  // Optional: visualize the flow field
  //for (int i = 0; i < cols; i++) {
  //  for (int j = 0; j < rows; j++) {
  //    PVector v = flowfield[i][j];
  //    stroke(0, 50);
  //    pushMatrix();
  //    translate(i * scl, j * scl);
  //    rotate(v.heading());
  //    line(0, 0, scl / 2, 0);
  //    popMatrix();
  //  }
  //}
}

class Particle {
  PVector pos;
  PVector vel;
  PVector acc;
  float maxSpeed = 3;

  Particle() {
    pos = new PVector(random(width), random(height));
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
  }

  void follow(PVector[][] vectors) {
    int x = floor(pos.x / scl);
    int y = floor(pos.y / scl);
    x = constrain(x, 0, cols - 1);
    y = constrain(y, 0, rows - 1);
    PVector force = vectors[x][y];
    applyForce(force);
  }

  void applyForce(PVector force) {
    acc.add(force);
  }

  void update() {
    vel.add(acc);
    vel.limit(maxSpeed);
    pos.add(vel);
    acc.mult(0);
  }

  void edges() {
    if (pos.x > width) pos.x = 0;
    if (pos.x < 0) pos.x = width;
    if (pos.y > height) pos.y = 0;
    if (pos.y < 0) pos.y = height;
  }

  void show() {
    stroke(0, 30); // Adjust alpha for trail effect
    strokeWeight(1);
    point(pos.x, pos.y);
  }
}
