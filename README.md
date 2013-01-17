#The TLUT tool flow: An introduction
The TLUT tool flow is a tool flow that generates FPGA configurations. 
Its biggest difference with the traditional FPGA flow is the use of a new technology mapper, the TLUT mapper. 
The TLUT tool flow was developed to implement Dynamic Circuit Specialization (DCS) on FPGAs. 
A DCS implementation of an application specializes its circuit for the current values of a number of specific inputs, called parameters. 
This specialized circuit is smaller, and in some cases faster, than the original circuit. 
However, it is only correct for one set of parameter values. 
Each time the parameters change value, a new specialized circuit is generated. 
This new specialized circuit is then loaded into the FPGA using partial run-time reconfiguration.

The TLUT tool flow offers an efficient implementation of DCS because it uses the concept of parameterized configurations. 
A parameterized configuration is a configuration in which some bits are expressed as Boolean functions of the parameters. 
Before the FPGA can be configured, the parameter values are used to evaluate the Boolean functions. 
This generates the specialized configuration. 
Several papers on the academic underpinnings of the TLUT tool flow are listed in the wiki of this project or are contained in the documentation directory. 
There you can also find more information on our current research on extending and improving the TLUT tool flow. 
The TLUT tool flow itself and how to use it, is described in much more detail in this user guide.

##What can I do with this tool flow?
First, you can evaluate our adapted TLUT technology mapper. 
This  allows you to compare its results with a conventional technology mapper and see for yourself if Dynamic Circuit Specialization can be used to optimize your application. 
We have included a framework to make this comparison very easy. 
The following pages provide clear examples and show how to adapt the framework for you own uses.

Second, our tool flow has been integrated with the Xilinx FPGA tool flow so that you can perform DCS on a commercial Virtex 2 Pro or Virtex 5 FPGA.
A number of examples that you can run right away on either the XUPV2P board (Virtex 2 Pro) or ML507 board (Virtex 5) are included in this repository.
Information on creating your own project is also included in this document.
The tool flow may be extended in the future to support more FPGAs, such as the Virtex 6 and 7.

##Installation and usage manual
For installation instructions and an introduction to using the tool flow, please read documentation/user_guide.pdf

##Dependencies

The user should provide the following dependencies:

- A UNIX operating system (tools used: gcc, bash, minicom, curl, stty, ...)
- Quartus II (tested with Web Edition version 11, Web Edition v12 may work but is not supported), Altera Corporation, <http://www.altera.com>
- Java (tested with version 1.6.0), Oracle, <http://www.java.com>
- Python 2.7, <http://www.python.org>

Optional:

- A Xilinx XUP Virtex-II Pro Development System (XUPV2P board) and Xilinx Design Suite 9 (tested with version 9.1 SP2), Xilinx Inc., <http://www.xilinx.com><br>
Version 9 is old, but newer versions don't work well with the Virtex-II Pro.
- A Xilinx ML507 Virtex-5 Development System and Xilinx Design Suite (tested with version 13.4), Xilinx Inc.

##Contact us
The TLUT tool flow is released by Ghent University, ELIS department, Hardware and Embedded Systems (HES) group (<http://hes.elis.ugent.be>).

If you encounter bugs, want to use the TLUT tool flow but need support or want to tell us about your results, please contact us.
We can be reached at <hes@elis.ugent.be>

##Referencing the TLUT tool flow
If you use the TLUT tool flow in your work, please reference in your publications the following paper:

*Karel Bruneel, Wim Heirman, and Dirk Stroobandt. 2011. “Dynamic Data Folding with Parameterizable FPGA Configurations.” ACM Transactions on Design Automation of Electronic Systems 16 (4).*

You may also refer to one of our others papers if you think it is more related.
[![githalytics.com alpha](https://cruel-carlota.pagodabox.com/5797f3a5e4b76d465ee2c3dd03a8928e "githalytics.com")](http://githalytics.com/UGent-HES/tlut_flow)
