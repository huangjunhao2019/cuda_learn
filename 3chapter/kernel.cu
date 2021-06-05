#include<iostream>
#include<cuda.h>
using namespace std;
__global__ void multiply(int *a,int *b,int *devc){
    int i=blockIdx.x;
    devc[i]=a[i]*b[i];
//    return devc;
}
int main(){
    const int N=10;
    int *a,*b,*devc,*temp;
    temp=new int[N];
    cudaMalloc(&a,N*sizeof(int));
    cudaMalloc(&b,N*sizeof(int));
    cudaMalloc(&devc,N*sizeof(int));

    for(int i=0;i<N;i++)
        temp[i]=i;
    cudaMemcpy(a,temp,N*sizeof(int),cudaMemcpyHostToDevice);

    for(int i=0;i<N;i++)
        temp[i]=2*i;
    cudaMemcpy(b,temp,N*sizeof(int),cudaMemcpyHostToDevice);

    multiply<<<N,1>>>(a,b,devc);
    int *result;
    result=new int[N];
    cudaMemcpy(result,devc,sizeof(int)*N,cudaMemcpyDeviceToHost);
    for(int i=0;i<N;i++)
        cout<<result[i]<<endl;
    cudaFree(a);
    cudaFree(b);
    cudaFree(devc);
    return 0;
}