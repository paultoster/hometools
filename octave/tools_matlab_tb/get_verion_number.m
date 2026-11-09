function vernum = get_verion_number
%
% vernum = get_verion_number
%
% 1.0				1984		
% 2				1986		
% 3				1987		
% 3.5				1990		Ran on DOS but needed at least a 386 processor; version 3.5m needed math coprocessor
% 4				1992		Ran on Windows 3.1x and Macintosh
% 4.2c				1994		Ran on Windows 3.1x, needed a math coprocessor
% 5.0	Volume 8			1996	December 1996	Unified releases across all platforms
% 5.1	Volume 9			1997	May 1997	
% 5.1.1	R9.1				
% 5.2	R10			1998	March 1998	Last version working on classic Macs
% 5.2.1	R10.1				
% 5.3	R11			1999	January 1999	
% 5.3.1	R11.1			November 1999	
% 6.0	R12	12	1.1.8	2000	November 2000	First release with bundled Java virtual machine (JVM)
% 6.1	R12.1	1.3.0	2001	June 2001	Last release for Windows 95
% 6.5	R13	13	1.3.1	2002	July 2002	
% 6.5.1	R13SP1		2003		
% 6.5.2	R13SP2			Last release for Windows 98, Windows ME, IBM/AIX, Alpha/TRU64, and SGI/IRIX[48]
% 7	R14	14	1.4.2	2004	June 2004	Introduced anonymous and nested functions[49]
% Re-introduced for Mac (under Mac OS X)
% 
% 7.0.1	R14SP1		October 2004	
% 7.0.4	R14SP2	1.5.0	2005	March 7, 2005	Support for memory-mapped files[50]
% 7.1	R14SP3	1.5.0	September 1, 2005	First 64-bit version available for Windows XP 64-bit
% 7.2	R2006a	15	1.5.0	2006	March 1, 2006	
% 7.3	R2006b	16	1.5.0	September 1, 2006	HDF5-based MAT-file support
% 7.4	R2007a	17	1.5.0_07	2007	March 1, 2007	New bsxfun function to apply element-by-element binary operation with singleton expansion enabled[51]
% 7.5	R2007b	18	1.6.0	September 1, 2007	Last release for Windows 2000 and PowerPC Mac; License Server support for Windows Vista;[52] new internal format for P-code
% 7.6	R2008a	19	1.6.0	2008	March 1, 2008	Major enhancements to object-oriented programming abilities with a new class definition syntax,[53] and ability to manage namespaces with packages[54]
% 7.7	R2008b	20	1.6.0_04	October 9, 2008	Last release for processors w/o SSE2. New Map data structure:[55] upgrades to random number generators[56]
% 7.8	R2009a	21	1.6.0_04	2009	March 6, 2009	First release for Microsoft 32-bit & 64-bit Windows 7, new external interface to .NET Framework[57]
% 7.9	R2009b	22	1.6.0_12	September 4, 2009	First release for Intel 64-bit Mac, and last for Solaris SPARC; new use for the tilde operator (~) to ignore arguments in function calls[58][59]
% 7.9.1	R2009bSP1	1.6.0_12	2010	April 1, 2010	bug fixes.
% 7.10	R2010a	23	1.6.0_12	March 5, 2010	Last release for Intel 32-bit Mac
% 7.11	R2010b	24	1.6.0_17	September 3, 2010	Add support for enumerations[60]
% 7.11.1	R2010bSP1	1.6.0_17	2011	March 17, 2011	bug fixes and updates
% 7.11.2	R2010bSP2	1.6.0_17	April 5, 2012[61]	bug fixes
% 7.12	R2011a	25	1.6.0_17	April 8, 2011	New rng function to control random number generation[62][63][64]
% 7.13	R2011b	26	1.6.0_17	September 1, 2011	Access-change parts of variables directly in MAT-files, without loading into memory;[65] increased maximum local workers with Parallel Computing Toolbox from 8 to 12[66]
% 7.14	R2012a	27	1.6.0_17	2012	March 1, 2012	Last version with 32-bit Linux support.[67]
% 8	R2012b	28	1.6.0_17	September 11, 2012	First release with Toolstrip interface;[68] MATLAB Apps.[69] redesigned documentation system
% 8.1	R2013a	29	1.6.0_17	2013	March 7, 2013	New unit testing framework[70]
% 8.2	R2013b	30	1.7.0_11	September 6, 2013[71]	Built in Java Runtime Environment (JRE) updated to version 7;[72] New table data type[73]
% 8.3	R2014a	31	1.7.0_11	2014	March 7, 2014[74]	Simplified compiler setup for building MEX-files; USB Webcams support in core MATLAB; number of local workers no longer limited to 12 with Parallel Computing Toolbox
% 8.4	R2014b	32	1.7.0_11	October 3, 2014	New class-based graphics engine (a.k.a. HG2);[75] tabbing function in GUI;[76] improved user toolbox packaging and help files;[77] new objects for time-date manipulations;[78] Git-Subversion integration in IDE;[79] big data abilities with MapReduce (scalable to Hadoop);[80] new py package for using Python from inside MATLAB,[81] new engine interface to call MATLAB from Python;[82] several new and improved functions: webread (RESTful web services with JSON/XML support), tcpclient (socket-based connections), histcounts, histogram, animatedline, and others
% 8.5	R2015a	33	1.7.0_60	2015	March 5, 2015	Last release supporting Windows XP and Windows Vista
% 8.5	R2015aSP1	1.7.0_60	October 14, 2015	
% 8.6	R2015b	34	1.7.0_60	September 3, 2015	New MATLAB execution engine (a.k.a. LXE);[83] graph and digraph classes to work with graphs and networks;[84] MinGW-w64 as supported compiler on Windows;[85] Last version with 32-bit support
% 9.0	R2016a	35	1.7.0_60	2016	March 3, 2016	Live Scripts: interactive documents that combine text, code, and output (in the style of Literate programming);[86] App Designer: a new development environment for building apps (with new kind of UI figures, axes, and components);[87] pause execution of running programs using a Pause Button
% 9.1	R2016b	36	1.7.0_60	September 15, 2016	define local functions in scripts;[88] automatic expansion of dimensions (previously provided via explicit call to bsxfun); tall arrays for Big data;[89] new string type;[90] new functions to encode/decode JSON;[91] official MATLAB Engine API for Java[36]
% 9.2	R2017a	37	1.7.0_60	2017	March 9, 2017	MATLAB Online: cloud-based MATLAB desktop accessed in a web browser;[92] double-quoted strings; new memoize function for Memoization; expanded object properties validation;[93] mocking framework for unit testing;[94] MEX targets 64-bit by default; new heatmap function for creating heatmap charts[95]
% 9.3	R2017b	38	1.8.0_121	September 21, 2017	
% 9.4	R2018a	39	1.8.0_144	2018	March 15, 2018[96]	
% 9.5	R2018b	40	1.8.0_152	September 12, 2018	
% 9.6	R2019a	41	1.8.0_181	2019	March 20, 2019	MATLAB Projects.
% 9.7	R2019b	42	1.8.0_202	2019	September 11, 2019	


  v = version;
  list = str_split(v,'.');
  if( length(list) > 1 )
    t    = [list{1},'.',list{2}];
  else
    t    = '';
  end
  vernum = str2double(t);
  
  

end