# push
push will check with a makefile if the project compile well.
If it does, it will push and tag.
__BE CAREFULL__, it doen't excute a testsuite and doesn't check if the prog is ok.
Then it will push on origin and on an optional remote if needed.

## Usage:
  
    ./push [-r remote_name][-t <continue>=N][--tag <tagname>][-h|--help]
    
    -r    	:	also push on 'remote_name'.
    
    -t 		:  	execute a make check and stop if 'continue' is set to N.
              	continue if 'continue' is set to  Y
              
    --tag :   	set the tag 'tagname' (for now tagname is optional)

	-h 	  :	   	display that help
    

## Config:
Needs a git repo.
Needs a Makefile.

## What next ? *TODO*
    ./push [-r remote name][-t <continue>=N][-m <build>=makefile][--tag <tagname>]

-m: change the build system:
build system supported:
- Makefile -> *makefile* (default)
- CMake -> *cmake*
- autotools -> *autotools*
- tpy -> run the *testsuit.py*
- tsh -> run the *testsuit.sh*
