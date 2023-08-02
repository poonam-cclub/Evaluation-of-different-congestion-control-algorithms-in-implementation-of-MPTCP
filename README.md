# Evaluation-of-different-congestion-control-algorithms-in-implementation-of-MPTCP


The following repository consists of experiment scripts to emulate mptcp in the linux network namespaces. It makes use of the out-of-tree version mptcp implementaion in the linux kernel.



  



### Pre-requisites:
- Ubuntu 16.04 machine with Linux kernel version 4.19.2.34 having the out-of-tree implementation
  of Multipath TCP.
- Install build-essential, git, iperf, iperf3 packages in the Ubuntu machine 
    ```bash
    sudo apt install build-essential git iperf iperf3
    ```
- Install [mptcpd](https://github.com/intel/mptcpd)  for userspace path management

### Step1 - 1 (Compiling the MPTCP Linux Kernel):
- The MPTCP out-of-tree implementation is present in the Linux kernel version 4.19.2.34.
  So for performing the experiment we first have to compile and install the MPTCP
  Linux kernel on the UBuntu 16.04 machine. Compiling the Linux kernel refers to the
  process of building the kernel source code into a binary executable that can be loaded
  into memory and executed by the computer’s hardware.
   ```bash
   follow these steps https://github.com/poonam-cclub/Linux-Kernel-Compilation .
    ```
### Experiment - 2 (Creating the topology using Linux Network Namespaces):
- **Step-1:** We configure the different congestion control algorithm and path manager as full mesh using the following commands shown.
   ```bash
   
  sysctl net . mptcp . mptcp_scheduler=congestion control algorithm name
  sysctl net . mptcp . mptcp_path_manager=fullmesh
   
   ```
- **Step-2:** On running the iperf for 20 seconds we obtained the output
- **Step-3:**  shows the result of different types of Congestion Control Algorithms and
   its average throughput. LIA, which is the standard congestion control algorithm of
   MPTCP, provides poor throughput when it compares with CUBIC algorithm. OLIA
   is giving better bandwidth compare to LIA.
 
   
.

