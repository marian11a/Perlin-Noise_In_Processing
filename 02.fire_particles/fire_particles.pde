int cols, rows;
int scl = 20;

PVector[][] flowfield;
ArrayList<Particle> particles = new ArrayList<Particle>();

void setup() {
  size(800, 800, P2D);
  cols = floor(width / scl);
  rows = floor(height / scl);
  flowfield = new PVector[cols][rows];
  for (int i = 0; i < 50; i++) {
    particles.add(new Particle());
  }
}

void draw() {
  background(0);
  float time = millis() * 0.007; // Time component for Perlin noise
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      float theta = map(noise(i * 0.1, j * 0.1, time), 0, 1, 0, TWO_PI);
      flowfield[i][j] = PVector.fromAngle(theta);
    }
  }
  
  pushMatrix();
  translate(width / 2, height / 2);
  rotate(HALF_PI);
  translate(-width / 2, -height / 2);
  
  for (Particle p : particles) {
    p.follow(flowfield);
    p.update();
    p.edges();
    p.show();
  }
  
  popMatrix();
}

class Particle {
  PVector pos;
  PVector vel;
  PVector acc;
  float maxSpeed = 8;
  color dotColor;

  Particle() {
    pos = new PVector(random(width), random(height));
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    dotColor = color(random(153, 256), random(69, 116), 0); // Generate random orange color
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
    stroke(dotColor);
    strokeWeight(5);
    point(pos.x, pos.y);
  }
}
