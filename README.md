#The TLUT tool flow: An introduction
The TLUT tool flow is a tool flow that generates FPGA configurations. Its biggest difference with the traditional FPGA flow is the use of a new technology mapper, the TLUT mapper. The TLUT tool flow was developed to implement Dynamic Circuit Specialization (DCS) on FPGAs. A DCS implementation of an application specializes its circuit for the current values of a number of specific inputs, called parameters. This specialized circuit is smaller, and in some cases faster, than the original circuit. However, it is only correct for one set of parameter values. Each time the parameters change value, a new specialized circuit is generated. This new specialized circuit is then loaded into the FPGA using partial run-time reconfiguration.

The TLUT tool flow offers an efficient implementation of DCS because it uses the concept of parameterized configurations. A parameterized configuration is a configuration in which some bits are expressed as Boolean functions of the parameters. Before the FPGA can be configured, the parameter values are used to evaluate the Boolean functions. This generates the specialized configuration. Several papers on the academic underpinnings of the TLUT tool flow are listed in the wiki of this project. There you can also find more information on our current research on extending and improving the TLUT tool flow. The TLUT tool flow itself and how to use it, is described in much more detail in this user guide.

##Roadmap
We are releasing the TLUT tool flow in two phases. First, we have made the adapted TLUT technology mapper public. This will allow you to compare its results with a conventional technology mapper. We have included a framework to make this comparison very easy. The user guide provides clear examples and shows how to adapt the framework for you own uses.

In the second phase, which will be released soon, we will provide you with the scripts and information necessary to integrate the TLUT technology mapper with the Xilinx FPGA tool flow. This will allow you to implement your DCS implementations on commercial Xilinx FPGAs. Our first target FPGA is the Virtex II Pro. We are currently working on extending this tool flow to more modern FPGAs, such as the Virtex 5 or 6.

##Installation and usage manual
For installation instructions and an introduction to using the tool flow, please read [documentation/user_guide.pdf](raw/master/documentation/user_guide.pdf)

##Contact information
The TLUT tool flow is released by Ghent University, ELIS department, Hardware and Embedded Systems (HES) group ([hes.elis.ugent.be](http://hes.elis.ugent.be)).

If you encounter bugs, want to use the TLUT tool flow but need support or want to tell us about your results, please contact us.
We can be reached at [hes@elis.ugent.be](mailto:hes@elis.ugent.be)
