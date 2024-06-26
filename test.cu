#include <algorithm>
#include <cassert>
#include <iostream>
#include <vector>

// CUDA kernel for vector addition
// __global__ means this is called from the CPU, and runs on the GPU
__global__ void vectorAdd(const int *__restrict a, const int *__restrict b,
                                          int *__restrict c, int N) {
          // Calculate global thread ID
          int tid = (blockIdx.x * blockDim.x) + threadIdx.x;

            // Boundary check
            if (tid < N) c[tid] = a[tid] + b[tid];
}


// Check vector add result and print the operation and its result
void verify_result(std::vector<int> &a, std::vector<int> &b,
                                   std::vector<int> &c) {
          for (int i = 0; i < a.size(); i++) {
                      int expected_result = a[i] + b[i];
                          if (c[i] != expected_result) {
                                        std::cout << "Operation: " << a[i] << " + " << b[i] << " = " << c[i] << " (Expected: " << expected_result << ") [ERROR]\n";
                                                                std::cout << "Id number: " << i ;
                                                                      assert(false); // This will trigger an assertion failure
                                                                          }
                            }
}


int main() {
          cudaError_t cudaStatus;
            // Array size of 2^16 (65536 elements)
            constexpr int N = 1 << 8;
              constexpr size_t bytes = sizeof(int) * N;

                // Vectors for holding the host-side (CPU-side) data
                std::vector<int> a;
                  a.reserve(N);
                    std::vector<int> b;
                      b.reserve(N);
                        std::vector<int> c;
                          c.reserve(N);

                            // Initialize random numbers in each array
                            for (int i = 0; i < N; i++) {
                                        a.push_back(rand() % 100);
                                            b.push_back(rand() % 100);
                                              }

                              //std::cout << "Vector A: ";
                                for (int i = 0; i < N; i++) {
                                            //std::cout << a[i] << " ";
                                              }
                                 // std::cout << std::endl;

                                   // std::cout << "Vector B: ";
                                      for (int i = 0; i < N; i++) {
                                     //             std::cout << b[i] << " ";
                                                    }
                                       // std::cout << std::endl;

                                          // Allocate memory on the device
                                          int *d_a, *d_b, *d_c;
                                            cudaStatus = cudaMalloc(&d_a, bytes);
                                              cudaMalloc(&d_b, bytes);
                                                cudaMalloc(&d_c, bytes);

                                                  // Copy data from the host to the device (CPU -> GPU)
                                                  cudaMemcpy(d_a, a.data(), bytes, cudaMemcpyHostToDevice);
                                                    cudaMemcpy(d_b, b.data(), bytes, cudaMemcpyHostToDevice);

                                                      // Threads per CTA (1024)
                                                      int NUM_THREADS = 1 << 10;

                                                        // CTAs per Grid
                                                        // We need to launch at LEAST as many threads as we have elements
                                                        // This equation pads an extra CTA to the grid if N cannot evenly be divided
                                                        // by NUM_THREADS (e.g. N = 1025, NUM_THREADS = 1024)
                                                        int NUM_BLOCKS = (N + NUM_THREADS - 1) / NUM_THREADS;

                                                        cudaStream_t stream1,stream2;
                                                        cudaStreamCreate(&stream1);
                                                        //cudaStreamCreate(&stream2);
                                                        cudaEvent_t start, stop;
                                                        cudaEventCreate(&start);
                                                        cudaEventCreate(&stop);
                                                        cudaEventRecord(start);
                                                        // Launch the kernel on the GPU
                                                          // Kernel calls are asynchronous (the CPU program continues execution after
                                                          // call, but no necessarily before the kernel finishes)
                                                          vectorAdd<<<NUM_BLOCKS, NUM_THREADS, 0, stream1>>>(d_a, d_b, d_c, N);
                                                          vectorAdd<<<NUM_BLOCKS, NUM_THREADS, 0, stream1>>>(d_a, d_b, d_c, N);
                                                          //vectorAdd<<<NUM_BLOCKS, NUM_THREADS, 0, stream1>>>(d_a, d_b, d_c, N);

                                                          cudaEventRecord(stop);
                                                           cudaStreamSynchronize(stream1);
                                                            //cudaStreamSynchronize(stream2);

                                                          float milliseconds = 0;
                                                             cudaEventElapsedTime(&milliseconds, start, stop);

                                                            // Copy sum vector from device to host
                                                            // cudaMemcpy is a synchronous operation, and waits for the prior kernel
                                                            // launch to complete (both go to the default stream in this case).
                                                            // Therefore, this cudaMemcpy acts as both a memcpy and synchronization
                                                            // barrier.
                                                            cudaMemcpy(c.data(), d_c, bytes, cudaMemcpyDeviceToHost);

                                                              // Print data on the CPU side after kernel launch
                                                             //std::cout << "Vector C: ";
                                                              for (int i = 0; i < N; i++) {
                                                               //          std::cout << c[i] << " ";
                                                                          }
                                                              // std::cout << std::endl;

                                                                 // Check result for errors
                                                                 verify_result(a, b, c);

                                                                   // Free memory on device
                                                                   cudaFree(d_a);
 								       cudaFree(d_b);
                                                                       cudaFree(d_c);


                                                                      // std::cout << "COMPLETED SUCCESSFULLY\n";

                                                                      // std::cout << "Total execution time:  " << milliseconds << " ms\n";

                                                                 return 0;
}
