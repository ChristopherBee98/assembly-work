// math_64.c  computer dot and cross product of two vectors

double dot(long int n, double x[], double y[])
{
  double sum = 0.0;
  long int i;
  for(i=0; i<n; i++) sum = sum + x[i]*y[i];
  return sum;
} // end dot

void cross(long int n, double x[], double y[], double z[])
{
  double sign = 1.0;
  long int m, j, k;
  for(m=0; m<n; m++) // answer
    {
      z[m] = 0.0;
      for(j=0; j<n; j++) // column
	{
	  k = j+m;
	  if(k>=n) k = k-n;
	  z[m] = z[m] + x[j]*y[k];
	} // end j
      z[m] = sign*z[m];
      sign = -sign;
    } // end m
} // end cross
