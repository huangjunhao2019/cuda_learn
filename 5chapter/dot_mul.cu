#include<iostream>
#include<cuda.h>
using namespace std;
//这种__shared__其实没什么，就是一个block内的线程能够维护一个全局变量
#define imin(a,b) (a<b?a:b)
const int N=33*1024;
const int threadsPerBlock=256;
const int blocksPerGrid=imin(32,(N+threadsPerBlock-1)/threadsPerBlock);
__global__ void dot(float *a,float *b,float *c){
    __shared__ float cache[threadsPerBlock];
    int tid=threadIdx.x+blockIdx.x*blockDim.x;
    int cacheIndex=threadIdx.x;

    float temp=0;
    while(tid<N){
        temp+=a[tid]*b[tid];
        tid+=blockDim.x*gridDim.x;
    }
    cache[cacheIndex]=temp;
    __syncthreads();

    float sum=0;
    for(int i=0;i<threadsPerBlock;i++)
        sum+=cache[i];
    c[blockIdx.x]=sum;
}
int main(){
    float *a,*b,*c;
    float *dev_a,*dev_b,*dev_c;
    a=new float[N*sizeof(float)];
    b=new float[N*sizeof(float)];
    c=new float[N*sizeof(float)];

    cudaMalloc(&dev_a,N*sizeof(float));
    cudaMalloc(&dev_b,N*sizeof(float));
    cudaMalloc(&dev_c,N*sizeof(float));

    for(int i=0;i<N;i++){
        a[i]=i;
        b[i]=i*2;
    }
    
    cudaMemcpy(dev_a,a,N*sizeof(float),cudaMemcpyHostToDevice);
    cudaMemcpy(dev_b,b,N*sizeof(float),cudaMemcpyHostToDevice);
    dot<<<blocksPerGrid,threadsPerBlock>>>(dev_a,dev_b,dev_c);
    cudaMemcpy(c,dev_c,N*sizeof(float),cudaMemcpyDeviceToHost);
    float sum=0;
    for(int i=0;i<blocksPerGrid;i++)
        sum+=c[i];
    cout<<"Summary="<<sum<<endl;
    cudaFree(dev_a);
    cudaFree(dev_b);
    cudaFree(dev_c);
    free(a);
    free(b);
    free(c);
    return 0;
}