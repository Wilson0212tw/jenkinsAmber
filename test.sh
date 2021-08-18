
#!/bin/bash
echo $1 
echo $2
echo $3

a="-1"

if [ $1  == stg  ]; then 
  if  [ $2 == 1 ]; then 
       echo " yes  $a "
            a=$2 
         echo " yes  $a "
   else 
   echo "!====="
   fi
else 
   echo "nono"
fi

echo " what is 2  : $a"
