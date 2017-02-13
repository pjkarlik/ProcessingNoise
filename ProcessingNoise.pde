/*
 *  3D Simplex Noise Demo
 *  Paul J Karlik | pjkarlik@gmail.com
 *  
 */  

SimplexNoise SimplexNoise;
// Screen Vars                                
int width = 640;
int height = 640;
int width_half = width / 2;
int height_half = height / 2;

// Grid Vars
int grid = 20;
int spacing = width / grid;
double time = 0; 
float camera = 0;
float iteration = 0.085;
float halfSize = spacing * grid / 2;

// Color Vars
float r = 0.0;
float g = 0.0;
float b = 0.0;

// Camera Vars
float zoom = -200;
float camX = width_half;
float camY = height;
float tempX = width_half;
float tempY = height_half;
float thisX = width_half;
float thisY = height_half;

// Vector Vars
PVector[][] vectors = new PVector[grid][grid];

// Basic Setup
void setup()
{
  println("starting project");
  size(640, 640, P3D);

  SimplexNoise = new SimplexNoise();
  generateMesh();
}

void generateMesh()
{
  for (int j = 0; j < grid; j++) {
        for (int i = 0; i < grid; i++) {
          float nPoint = abs((float)SimplexNoise.noise(iteration * i, iteration * j, time * 0.005));
          float zVector = nPoint * 50;
          vectors[i][j] = new PVector( i*spacing, j*spacing, zVector);
        }
    }
  
}
void draw()
{ 
  time+=1;
  background(0,0,0);
  
  generateMesh();
  lighting();
  cameraView();
  
  float centerValue = (spacing * grid / 2);
  translate(-centerValue, -centerValue, 0);

  for (int j = 0; j < grid; j ++) {
    for (int i = 0; i < grid; i++) {

        float zOffset = abs(vectors[i][j].z) * .8;
        noStroke();
        sphereDetail(8);
        // Color shading // 
        r = sin(zOffset * 0.1) * 255;
        g = cos(zOffset * 0.05 + ((float)time * 0.01)) * 155;
        b = 255 - r;
        
        //float m = cos(vectors[i][j].z * .055);
        //float o = sin(vectors[i][j].z * .055);
        //r = floor(m * 255);
        //b = floor(o * 255);
        //g = b;
      
        emissive(r,g,b);
        pushMatrix();
        translate(vectors[i][j].x, vectors[i][j].y, -vectors[i][j].z - (zOffset / 2));
        sphere(zOffset);
        popMatrix();
 
    }
  }
  
}

void lighting()
{
  directionalLight(50, 50, 50, 1, 0.5, 0);
  directionalLight(120, 60, 190, 1, 0, -1);
}

void cameraView()
{
    // If mouse is inactive pick the center of the screen
    tempX = mousePressed ? mouseX : tempX;
    tempY = mousePressed ? mouseY : tempY;
    thisX = thisX - (thisX - tempX) * 0.01;
    thisY = thisY - (thisY - tempY) * 0.01;
    camX = (width_half - thisX) * 0.006;
    camY = (height_half - thisY)* 0.01;
    float centerValue = (spacing * grid / 2);
    translate(centerValue, centerValue, -zoom);
    rotateX((-90) - camY);
    rotateZ(45 - camX);
    // Make it auto Rotate
    // rotateZ(frameCount *0.005);
}

void mouseWheel(MouseEvent event) {
  zoom += event.getCount() * 5;
}