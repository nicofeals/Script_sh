# push
push will check with a makefile if the project compile well.
If it does, it will push and tag.
__BE CAREFULL__, it doen't excute a testsuite and doesn't check if the prog is ok.
Then it will try to push all on the remote named epita if it exists

## Usage:
  
    ./push [tagname]

## Config:
Needs a git repo.
Needs a Makefile.
Optional: a remote named epita on wich it will push the same things.

## What next ? *TODO*
    ./push [-r remote name]  [-t <continue>=N]  [-m <build>=makefile]  [tagname]

-r: push also on the remote: *remote name*
(note than it won't push automaticly on epita)

-t: try to run the testsuite from makefile.
if errors occure and \<continue> is: N it won't push.
set to Y to force the push.

-m: change the build system:
build system supported:
- Makefile -> *makefile* (default)
- CMake -> *cmake*
- autotools -> *autotools*
