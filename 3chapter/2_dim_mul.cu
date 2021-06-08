//本质上来说，几维的数组其实都是一维数组，不过是变变表现形式而已，二维数组加法没什么意思，
//就是一维数组加法，还是二维数组乘法有点意思
//这个方法，还不是高并发，高并发，应该是把求和那一块for也并发了。估计要用device，现在的并发度是4
#include<iostream>
#include<cuda.h>
using namespace std;
const int N=2;
__global__ void mul(int *a,int *b,int *c){//并发度为4的矩阵乘法
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
__global__ void mul_8(int *a,int *b,int *c){//实现了2*2*2个线程，每个都进行计算，并行度为8
    int row=blockIdx.x/N;
    int col=blockIdx.x%N;
    __shared__ int mul[N];
    //mul[0]=a[row][0]*b[0][col]
    mul[threadIdx.x]=a[row*N+threadIdx.x]*b[threadIdx.x*N+col];
    //mul[1]=a[row][1]*b[1][col]
    __syncthreads();
    int sum=0;
    for(int i=0;i<blockDim.x;i++)
        sum+=mul[i];
    c[blockIdx.x]=sum;
}
int main(){
    int *a,*b,*dev_a,*dev_b,*dev_c,*c;
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

   // mul<<<N,N>>>(dev_a,dev_b,dev_c);
   cudaEvent_t start,stop;
   cudaEventCreate(&start);
   cudaEventCreate(&stop);
   cudaEventRecord(start,0);

   mul_8<<<N*N,N>>>(dev_a,dev_b,dev_c);
   cudaEventRecord(stop,0);
   cudaEventSynchronize(stop);
   float elapsedTime;
   cudaEventElapsedTime(&elapsedTime,start,stop);
   cout<<"Time: "<<elapsedTime<<endl;
    cudaMemcpy(c,dev_c,N*N*sizeof(int),cudaMemcpyDeviceToHost);
    for(int i=0;i<N;i++){
        for(int j=0;j<N;j++){
            cout<<c[i*N+j]<<" ";
        }
        cout<<endl;
    }
    return 0;

}