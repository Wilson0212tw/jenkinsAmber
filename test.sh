echo $1 
echo $2
echo $3

if [ $1  == stg  ]; then 
  if  [ $2 == 1 ]; then 
         echo " is stag:  $(($2 == stg))"
   else 
   echo "!====="
   fi
else 
   echo "nono"
fi
