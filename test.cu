#include<iostream>
#include<cuda.h>
using namespace std;
__global__ void add(int *a,const int *b){
    int i=blockIdx.x;
    a[i]+=b[i];
}
int main(){
    const int N=10;
    int *a,*b,*temp;

    temp=new int[N];
    
    cudaMalloc(&a,N*sizeof(int));
    cudaMalloc(&b,N*sizeof(int));

    for(int i=0;i<N;i++)
        temp[i]=i;
    
    cudaMemcpy(a,temp,N*sizeof(int),cudaMemcpyHostToDevice);
    
    for(int i=0;i<N;i++)
        temp[i]=2*i;
    cudaMemcpy(b,temp,N*sizeof(int),cudaMemcpyHostToDevice);
    add<<<N,1>>>(a,b);

    cudaMemcpy(temp,a,N*sizeof(int),cudaMemcpyDeviceToHost);
    for(int i=0;i<N;i++)
        cout<<temp[i]<<endl;
    delete[] temp;
    cudaFree(a);
    cudaFree(b);


    
}
