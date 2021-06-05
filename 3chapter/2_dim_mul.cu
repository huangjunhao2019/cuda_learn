//本质上来说，几维的数组其实都是一维数组，不过是变变表现形式而已，二维数组加法没什么意思，
//就是一维数组加法，还是二维数组乘法有点意思
//这个方法，还不是高并发，高并发，应该是把求和那一块for也并发了。估计要用device，现在的并发度是4
#include<iostream>
#include<cuda.h>
using namespace std;
__global__ void mul(int *a,int *b,int *c){
    int row=blockIdx.x;
    int col=threadIdx.x;
    int temp_sum=0;
   for(int i=0;i<blockDim.x;i++){
        //temp_sum+=a[row][i]*b[i][row];
      temp_sum+=a[row*blockDim.x+i]*b[i*blockDim.x+col];
       // temp_sum+=row+col;
//       temp_sum=a[row*blockDim.x+col];
  }
   // c[row][col]=temp_sum;
   c[row*blockDim.x+col]=temp_sum;

}
int main(){
    int *a,*b,*dev_a,*dev_b,*dev_c,*c;
    const int N=2;
    a=new int[N*N];
    b=new int [N*N];
    c=new int[N*N];
    for(int i=0;i<N;i++){
        for(int j=0;j<N;j++){
            a[i*N+j]=i*N+j;
            b[i*N+j]=i*N+j;
            cout<<a[i*N+j]<<endl; 
        }
    }
    cudaMalloc(&dev_a,N*N*sizeof(int));
    cudaMalloc(&dev_b,N*N*sizeof(int));
    cudaMalloc(&dev_c,N*N*sizeof(int));
    cudaMemcpy(dev_a,a,N*N*sizeof(int),cudaMemcpyHostToDevice);
    cudaMemcpy(dev_b,b,N*N*sizeof(int),cudaMemcpyHostToDevice);

    mul<<<N,N>>>(dev_a,dev_b,dev_c);
    cudaMemcpy(c,dev_c,N*N*sizeof(int),cudaMemcpyDeviceToHost);
    for(int i=0;i<N;i++){
        for(int j=0;j<N;j++){
            cout<<c[i*N+j]<<" ";
        }
        cout<<endl;
    }
    return 0;

}