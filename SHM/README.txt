Install the required MATLAB toolboxes (Signal Processing Toolbox, etc).

1) Copy the file "monitorDATfile.m" to "C:/temp" --> This folder is used by Abaqus as the working directory.

2) Run the script "runVMT.m" with "VMTinpfileconstrarch.m" located in the ***same folder.
***Do not forget to update the variable inputFolder accordingly.

3) After the Abaqus analysis is finished, run the MATLAB function "readHistoryOdbPyScript" --> making sure that the Python script is located in C:/temp

      odbfile = 'C:\temp\VMTRS_job1.odb';
      filename = 'VMTRS_job1';
      FolderName_Input = 'C:\temp';
      outfile = 'C:\temp';
      readHistoryOdbPyScript(odbfile, filename, FolderName_Input, outfile)

4) Using readHistoryOdb.m, execute the following function:

      filename = 'VMTRS_job1';
      [disp1, load1] = readHistoryOdb(filename);

5) Done!
With the generated file *_loaddisp.txt, you can now run the script "graphicRun.m"
