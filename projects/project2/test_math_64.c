// test_math_64.c  test dot and cross product of two vectors
#include <stdio.h>
#include "math_64.h"

int main()
{
  long int n = 4;
  double x[4] = {2.0,  3.0, 4.0, 5.0};
  double y[4] = {5.0, -3.0, 2.0, 4.0};
  double z[4] = {-1.0, -1.0, -1.0, 1.0}; // initial junk
  double sum;

  printf("test_math_64.c running, n=%ld \n", n);
  printf("x = %f %f %f %f \n", x[0], x[1], x[2], x[3]);
  printf("y = %f %f %f %f \n", y[0], y[1], y[2], y[3]);
  sum = dot(n, x, y);
  printf("dot(n, x, y) = %f \n", sum);
  printf(" \n");
  printf("x = %f %f %f %f \n", x[0], x[1], x[2], x[3]);
  printf("y = %f %f %f %f \n", y[0], y[1], y[2], y[3]);
  cross(n, x, y, z);
  printf("x cross y = z = %f, %f, %f, %f \n", z[0], z[1], z[2], z[3]);
  return 0;
} // end test_math_64.c
