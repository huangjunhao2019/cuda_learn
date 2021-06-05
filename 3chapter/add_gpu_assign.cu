#include<iostream>
#include<cuda.h>
using namespace std;
__global__ void assign(int *a,int N){
 //using gpu to assign value for a  
    int i=blockIdx.x;
    if(i<N)
        a[i]=i*i;
}
int main(){
    const int N=10;
    int *a,*dev_a,*b,*dev_b;
    a=new int[N];
    b=new int[N];
    cudaMalloc(&dev_a,N*sizeof(int));
    cudaMalloc(&dev_b,N*sizeof(int));
    assign<<<N,1>>>(dev_a,N);
    assign<<<N,1>>>(dev_b,N);
    cudaMemcpy(a,dev_a,N*sizeof(int),cudaMemcpyDeviceToHost);
    cudaMemcpy(b,dev_b,N*sizeof(int),cudaMemcpyDeviceToHost);
    for(int i=0;i<N;i++)
        cout<<a[i]<<endl;
    for(int i=0;i<N;i++)
        cout<<b[i]<<endl;
    cudaFree(dev_a);
    cudaFree(dev_b);
    return 0;

}