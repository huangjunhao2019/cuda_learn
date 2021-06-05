#include<iostream>
#include<cuda.h>
using namespace std;
int main(){
    cudaDeviceProp prop;

    int count;
    cudaGetDeviceCount(&count);
    for(int i=0;i<count;i++){
        cudaGetDeviceProperties(&prop,i);
        cout<<"--- General Information for device "<<i<<endl;
        cout<<"Name: "<<prop.name<<endl;
        cout<<"Compute capability: "<<prop.major<<", "<<prop.minor<<endl;
        cout<<"Clock rate: "<<prop.clockRate<<endl;
        cout<<"Device copy overlap: "<<prop.deviceOverlap<<endl;
        cout<<"Total global memory: "<<prop.totalGlobalMem<<endl;
        cout<<"Total const memory: "<<prop.totalConstMem<<endl;
        return 0;
    }
}