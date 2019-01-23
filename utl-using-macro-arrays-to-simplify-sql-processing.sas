Using macro arrays to simplify sql processing ;                                                                                    
                                                                                                                                   
  Sum and Sum of squares of arrays                                                                                                 
                                                                                                                                   
  Two Solutions                                                                                                                    
  ==============                                                                                                                   
                                                                                                                                   
   1.  %barray and %bdo_over                                                                                                       
       Bartosz Jablonski                                                                                                           
       yabwon@gmail.com                                                                                                            
       https://tinyurl.com/ybqc6gh9                                                                                                
       https://www.mini.pw.edu.pl/~bjablons/SASpublic/bart_array_v3.sas                                                            
                                                                                                                                   
   2.  %array and %do_over                                                                                                         
       Ted Clay, M.S.   tclay@ashlandhome.net  (541) 482-6435                                                                      
       David Katz, M.S. www.davidkatzconsulting.com                                                                                
                                                                                                                                   
Sometimes SQL can be faster than 'summary' when using teradata or exadata.                                                         
                                                                                                                                   
github                                                                                                                             
https://tinyurl.com/y9xw8oyn                                                                                                       
https://github.com/rogerjdeangelis/utl-using-macro-arrays-to-simplify-sql-processing                                               
                                                                                                                                   
StackOverflow                                                                                                                      
https://tinyurl.com/ycsloycv                                                                                                       
https://stackoverflow.com/questions/54333111/a-proc-sql-alternative-to-a-proc-summmary-approach-when-summing-variables-across      
                                                                                                                                   
macros                                                                                                                             
https://tinyurl.com/y9nfugth                                                                                                       
https://github.com/rogerjdeangelis/utl-macros-used-in-many-of-rogerjdeangelis-repositories                                         
                                                                                                                                   
                                                                                                                                   
data have;                                                                                                                         
 input grp$ d0-d9;                                                                                                                 
cards4;                                                                                                                            
GRP001 1 1 1 1 1 1 1 1 1 1                                                                                                         
GRP001 2 2 2 2 2 2 2 2 2 2                                                                                                         
GRP001 3 3 3 3 3 3 3 3 3 3                                                                                                         
GRP002 4 4 4 4 4 4 4 4 4 4                                                                                                         
GRP002 5 5 5 5 5 5 5 5 5 5                                                                                                         
GRP002 6 6 6 6 6 6 6 6 6 6                                                                                                         
;;;;                                                                                                                               
run;quit;                                                                                                                          
                                                                                                                                   
                                                                                                                                   
 WORK.HAVE total obs=6                  | RULES                                                                                    
                                        |                                                                                          
 GRP     D0 D1 D2 D3 D4 D5 D6 D7 D8 D9  |  TOTAL            TOTSQ                                                                  
                                        |                                                                                          
 GRP001   1  1  1  1  1  1  1  1  1  1  |    10 =(1+1+..1)    10 =(1*1 +1*1 .. 1*1)                                                
 GRP001   2  2  2  2  2  2  2  2  2  2  |    20 =(2+2+..2)    40 =(2*2 +2*2 .. 2*2)                                                
 GRP001   3  3  3  3  3  3  3  3  3  3  |    30               90                                                                   
                                                                                                                                   
 GRP002   4  4  4  4  4  4  4  4  4  4  |    40              160                                                                   
 GRP002   5  5  5  5  5  5  5  5  5  5  |    50              250                                                                   
 GRP002   6  6  6  6  6  6  6  6  6  6  |    60              360                                                                   
                                                                                                                                   
                                                                                                                                   
EXAMPLE OUTPUT                                                                                                                     
--------------                                                                                                                     
                                                                                                                                   
WORK.WANT total obs=6                                                                                                              
                                                                                                                                   
   GRP      TOTAL    TOTSQ                                                                                                         
                                                                                                                                   
  GRP001      10       10                                                                                                          
  GRP001      20       40                                                                                                          
  GRP001      30       90                                                                                                          
  GRP002      40      160                                                                                                          
  GRP002      50      250                                                                                                          
  GRP002      60      360                                                                                                          
                                                                                                                                   
                                                                                                                                   
Process                                                                                                                            
=======                                                                                                                            
                                                                                                                                   
   1.  %barray and %bdo_over                                                                                                       
                                                                                                                                   
       %bdeleteMacArray(idxs); * in case you rerun;                                                                                
                                                                                                                                   
       %barray(idxs[0:9] idxs0-idxs9 (0:9));                                                                                       
       %put _user_;                                                                                                                
                                                                                                                                   
       proc sql ;                                                                                                                  
         create table want_b as                                                                                                    
           select GRP                                                                                                              
                , sum(%bdo_over(idxs,phrase=d&_i_,between=%str(,))) as total                                                       
                , sum(%bdo_over(idxs,phrase=d&_i_**2,between=%str(,))) as totSq                                                    
           from have                                                                                                               
         ;                                                                                                                         
       quit;                                                                                                                       
                                                                                                                                   
   2.  %array and %do_over                                                                                                         
                                                                                                                                   
       %deleteMacArray(idxs); * in case you rerun;                                                                                 
                                                                                                                                   
       %array(idxs, values=0-9);                                                                                                   
       %put _user_;                                                                                                                
                                                                                                                                   
       proc sql ;                                                                                                                  
         create table want as                                                                                                      
           select GRP                                                                                                              
                , sum(%do_over(idxs,phrase=d?,between=comma)) as total                                                             
                , sum(%do_over(idxs,phrase=d?**2,between=comma)) as totSq                                                          
           from have                                                                                                               
       ;quit;                                                                                                                      
                                                                                                                                   
OUTPUT                                                                                                                             
======                                                                                                                             
                                                                                                                                   
see above                                                                                                                          
                                                                                                                                   
                                                                                                                                   
                                                                                                                                   
                                                                                                                                   
                                                                                                                                   
                                                                                                                                   
