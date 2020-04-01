This document is to provide you the instructions to reproduce the results. It is assumed that the host system is a Windows machine with MATLAB installed.

1. Using VirtualBox, start a Linux virtual machine (Arch Linux is preferred). Set and configure the shared_folder. Also, enable port forwarding and forward TCP 3490 port in the host machine to the same TCP port in the virtual machine.
2. On the Linux virtual machine, install Finite-Element Analysis Program (FEAP) version 8.5. For more info: http://projects.ce.berkeley.edu/feap/
3. Install MATFEAP (version 0.8 or older) to the host (Windows) system. MATFEAP is the interface between MATLAB and FEAP. For more info: http://www.cs.cornell.edu/~bindel/sw/matfeap/
4. Start MATLAB and the Virtual Machine.
5. Copy the contents of this folder to a new folder in MATLAB and locate that folder in MATLAB
6. Create a subfolder named "n_tmp" and move the files Ibase_single640s and Ibase_single640se to this subfolder. These are the FEAP input files for modal analysis and harmonic response analysis.
6. In MATLAB command window, run the following commands to start MATFEAP:
matfeap_init;
feaps_tcp;
7. In MATLAB, change the current folder to the folder you created in Step 5 and open "sh_opt_slv_se.m"
8. Modify lines 28 & 29 with the "shared_folder" locations of the Windows host and Linux VM. The shared_folder for the Linux VM was already set at Step 1.
9. If you plan to run the optimization for a single mass value, open 'feap_prm.mat' in MATLAB, modify the mass value (units: kg) and save file.
10. Run the script "mass_sh_opt_swp.m" to compute & plot the optimal shapes and stress distributions for the tip mass values array: [0,1,2.5,5,10,20,50]*1e-3 kg. To perform shape optimization for another tip mass value, use the command: fminsearch(@sh_opt_slv_se,opt_prms,optimset('disp','iter')), where opt_prms is the initial guess for the 3x1 shape parameter vector. As an example, you can use: opt_prms = [0.5,0.5,0.5];
