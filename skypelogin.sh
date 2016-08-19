# Script which decrypts keys and opens Skype instances
read -s -p "Enter Master Key... " masterkey
output=$(java -jar jar/MultiSkypeAuthDecryption.jar $masterkey)
printf 'Skype initializing!\n'

# set IFS, split by delimiter through read into ARR
IFS=';' read -ra ARR <<< "$output" 
for i in "${!ARR[@]}"; do

    # shove AuthLogin details into ARR2, split into array
    IFS=',' read -ra ARR2 <<< ${ARR[i]} 

    name=${ARR2[0]}
    username=${ARR2[1]}
    password=${ARR2[2]}

    echo Logging into $name...

    # If this is the first instance of Skype, open regularly    
    if [ $i = 0 ];
    then 
        (echo $username $password | setsid skype --pipelogin &)
        # echo "IM INTIALIZING FIRST"
    # Otherwise, add --secondary pipe
    else
        (echo $username $password | setsid skype --pipelogin --secondary &)
        # echo 'IM INTIALIZING SECOND OR THIRD OR FOURTH???'
    fi

    # echo i: $i  ARR2 END: $((${#ARR[@]} - 1))

    # If it's not the last instance of Skype opened, sleep for 10 seconds
    if [ $i != $((${#ARR[@]} - 1)) ];
    then
        echo 'Sleeping... for 10 seconds'
        sleep 10 # Can be done in 5, but feels safer this way
    fi

done

echo 'Login successful!'

