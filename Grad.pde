// Inner class to speed upp gradient computations
// (In Java, array access is a lot slower than member access)
  
private static class Grad
  {
    double x, y, z, w;

    Grad(double x, double y, double z)
    {
      this.x = x;
      this.y = y;
      this.z = z;
    }

    Grad(double x, double y, double z, double w)
    {
      this.x = x;
      this.y = y;
      this.z = z;
      this.w = w;
    }
  }