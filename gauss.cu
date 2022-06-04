#include <stdio.h>
#include <cuda.h>
#include <device_launch_parameters.h>
#include <cuda_runtime.h>
#define ROW 10
#define COLUMN 11

#define ARRAY_BYTES (ROW * COLUMN * sizeof(float))
#define NUMTHREADS 10
#define NUMBLOCKS 1

__global__ void gauss(float** d_out,float** d_in)
{
	int x = threadIdx.x;
	for (int i = x; i < 10; i++)
	{
		float factor = d_in[i][x]/d_in[x][x];
		//printf("%f factor\n", factor);
		for(int p=x;p<11;p++)
        {		
		d_out[i][p] = d_in[i][p] - (factor * (d_in[x][p]));
              //printf("%f output\n",  d_out[i][p]);
		
		}
	}



}
void printans(float output[][COLUMN])
{
for (int o = 0; o < 10; o++)
		{for (int i = 0; i < 11; i++)
			printf("%f " , output[o][i]);
			printf("\n");}
				
}

int main(int argc, char** argv)
{ 
	float random[10][11];
	float** d_in;
	float** d_out;
	float ranoutput[10][11];
	// generating matrix
	for (int o = 0; o < 10; o++)
		for (int i = 0; i < 11; i++)
		 random[o][1] = rand()%100;
	
	//allocating memory

	cudaMalloc((void**)&d_in, ARRAY_BYTES);
	cudaMalloc((void**)&d_out, ARRAY_BYTES);
	cudaMemcpy(d_in, random, ARRAY_BYTES, cudaMemcpyHostToDevice);

   //launching kernel

	gauss << <NUMBLOCKS, NUMTHREADS >> > (d_out,d_in);
	cudaDeviceSynchronize();
	cudaMemcpy(d_out, ranoutput, ARRAY_BYTES, cudaMemcpyDeviceToHost);
	
	// print output
	printans(ranoutput);

    cudaFree(d_in);
	cudaFree(d_out);
	return 0;

}
