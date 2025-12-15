Install the toolbox like Signal Processing Toolbox, etc..

1)  Copy de "monitorDATfile.m" to "C:/temp" --> this is the work folder used by Abaqus


2)  Run the script "runVMT.m" with "VMTinpfileconstrarch.m" in the same folder --> dont forget to change de inputFolder


3)  After Abaqus analysis, in Matlab, run the function readHistoryOdbPyScript with the script in "C:/temp" folder:
      odbfile = 'C:\temp\VMTRS_job1.odb';
      filename = 'VMTRS_job1';
      FolderName_Input = 'C:\temp';
      outfile = 'C:\temp';
      readHistoryOdbPyScript(odbfile, filename, FolderName_Input, outfile)


4) With the "readHistoryOdb.m", run this function:
      filename = 'VMTRS_job1';
      [disp1, load1] = readHistoryOdb(filename)

5) Well done, with the "...loaddisp.txt" file you can run the "graphicRun.m" script!!
      
