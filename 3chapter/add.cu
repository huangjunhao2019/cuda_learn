#include<iostream>
#include<cuda.h>
using namespace std;
#define N 10
__global__ void add(int *a,int *b,int *c){
    int tid=threadIdx.x;
    if(tid<N)
        c[tid]=a[tid]+b[tid];
}
int main(){
    int a[N],b[N],c[N];
    int *dev_a,*dev_b,*dev_c;
    cudaMalloc(&dev_a,N*sizeof(int));
    cudaMalloc(&dev_b,N*sizeof(int));
    cudaMalloc(&dev_c,N*sizeof(int));
    
    for(int i=0;i<N;i++){
        a[i]=i;
        b[i]=i*i;
    }
    cudaMemcpy(dev_a,a,N*sizeof(int),cudaMemcpyHostToDevice);
    cudaMemcpy(dev_b,b,N*sizeof(int),cudaMemcpyHostToDevice);
    add<<<1,N>>>(dev_a,dev_b,dev_c);//一个计算单元是一个kernel，即一个grid，我觉得第一个数是block数量，第二个是每一个blokc含有的thread数量
    cudaMemcpy(c,dev_c,N*sizeof(int),cudaMemcpyDeviceToHost);
    for(int i=0;i<N;i++){
        cout<<c[i]<<endl;

    }
    cudaFree(dev_a);
    cudaFree(dev_b);
    cudaFree(dev_c);
    return 0;
}