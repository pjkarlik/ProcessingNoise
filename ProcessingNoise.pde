/*
 *  3D Simplex Noise Demo
 *  Paul J Karlik | pjkarlik@gmail.com
 *  
 */  

SimplexNoise SimplexNoise;
// Screen Vars .                               
int width_half;
int height_half;

// Grid Vars.
int grid = 30;
int spacing;
double time = 0; 
float camera = 0;
float iteration = 0.035;
float halfSize;

// Color Vars.
float r = 0.0;
float g = 0.0;
float b = 0.0;

// Camera Vars.
float zoom;
float camX;
float camY;
float tempX;
float tempY;
float thisX;
float thisY;

// Vector Vars.
PVector[][] vectors = new PVector[grid][grid];

// Basic Setup
void setup()
{
  println("starting project");
  // size(640, 640, P3D);
  fullScreen(P3D);
  
  // Vars based on screen size.
  width_half = width / 2;
  height_half = height / 2;
  spacing = width / grid;
  halfSize = spacing * grid / 2;

  // Camera Vars.
  zoom = -200;
  camX = width_half;
  camY = height;
  tempX = width_half;
  tempY = height_half;
  thisX = width_half;
  thisY = height_half;

  SimplexNoise = new SimplexNoise();
  generateMesh();
}
// Generate mesh array grid * grid = total items.
void generateMesh()
{
  float timeStop = (float)time * 0.005;
  for (int j = 0; j < grid; j++) {
        for (int i = 0; i < grid; i++) {
          float nPoint = abs((float)SimplexNoise.noise(iteration * i, iteration * j, timeStop));
          float zVector = nPoint * 100;
          vectors[i][j] = new PVector( i*spacing, j*spacing, zVector);
        }
    }
  
}
// Draw loop - where the action takes place!
void draw()
{ // Clear background and advance time.
  time+=1;
  background(0,0,0);
  // hit functions to pull new mesh array, set lighting and camera view.
  generateMesh();
  lighting();
  cameraView();
  // center the camera before drawing the mesh grid
  float centerValue = (spacing * grid / 2);
  translate(-centerValue, -centerValue, 0);
  float timeStop = (float)time * 0.01;
  for (int j = 0; j < grid; j ++) {
    for (int i = 0; i < grid; i++) {

        float zOffset = abs(vectors[i][j].z) * .99;
        noStroke();
        sphereDetail(8);
        
       /*
        *  Default shading function below.
        *  
        */
        
        r = sin(zOffset * PI / 180) * 255;
        g = cos(zOffset * 0.05 + timeStop) * 155;
        b = 255 - r;
        
       /*
        *  Alt shading function below - still playing for best colors.
        *  
        */
          
        //float m = cos(zOffset * 15 * PI / 180);
        //float o = sin(zOffset * 15 * PI / 180);
        //r = floor(m * 255);
        //b = floor(o * 255);
        //g = b;
      
        // Set material, push matrix - move - draw - pop matrix.
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
    // If mouse is inactive pick the last values.
    tempX = mousePressed ? mouseX : tempX;
    tempY = mousePressed ? mouseY : tempY;
    
    // Easing function 
    thisX = thisX - (thisX - tempX) * 0.01;
    thisY = thisY - (thisY - tempY) * 0.01;
    
    // Set rotation based on center screen.
    camX = (width_half - thisX) * 0.006;
    camY = (height_half - thisY)* 0.01;
    
    // Get out center value based on mesh grid.
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