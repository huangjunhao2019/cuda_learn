#include<iostream>
#include<cuda.h>
using namespace std;
__global__ void get_block(int *c){
    c[0]=blockDim.x;
    c[1]=gridDim.x;
}
int main(){
    int c[2];
    int *dev_c;
    cudaMalloc(&dev_c,2*sizeof(int));
    get_block<<<10,10>>>(dev_c);
    cudaMemcpy(c,dev_c,2*sizeof(int),cudaMemcpyDeviceToHost);
    for(int i=0;i<2;i++)
        cout<<c[i]<<endl;
  //  cout<<"threadPerBlock="<<threadsPerBlock<<endl;
  //  cout<<"blocksPerGrid="<<blocksPerGrid<<endl; 16，17两个cout均显示相关变量没有定义，这说明这两个变量就是一般变量，
  //需要先声明，在使用
    return 0;
}