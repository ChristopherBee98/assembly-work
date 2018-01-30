// plotc_64.c  simple plot of cos(x)
#include <stdio.h>

#define ncol 41
#define nrow 21
int main(int argc, char *srgv[])
{
  char points[nrow][ncol]; // char == byte
  char point = '*';
  char space = ' ';
  long int i, j, k, rcx;
  double af[] = {1.0, 0.0, -0.5, 0.0,
                 0.041667, 0.0, -0.001389, 0.0, 0.000025};
  long int n = 8;
  double xf, y;
  double dx = 0.15708; // 6.2832/40.0

  // clear points to space ' '
  for(i=0; i<nrow; i++)
    for(j=0; j<ncol; j++)
      points[i][j] = space;

  printf("a2 blanked \n");
  
  // compute points
  xf = -3.14159; // X0
  for(j=0; j<ncol; j++)
    {
      y = af[n]; // modified horners
      for(rcx=n; rcx>0; rcx--) y = y*xf + af[rcx-1]; // loop
      k = (int)(20.0 + (y+1.0)*(-10.0)); // scale 1.0 to -1.0, 0 to 20
      printf("xf=%f, y=%f, k=%d \n", xf, y, k);
      fflush(stdout);

      points[k][j] = point;
      xf = xf + dx;
    }

  // print points
  for(i=0; i<nrow; i++)
    {
      for(j=0; j<ncol; j++)
	printf("%c", points[i][j]);
      printf("\n");
    }
  return 0;
} // end plot_64.c
