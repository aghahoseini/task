#!/bin/bash

declare -A status_code

declare -A which_replica

declare -A time

one_xx=0;
two_xx=0;
three_xx=0;
four_xx=0;
five_xx=0;
other_xx=0;


replica_1=0;
replica_2=0;
replica_3=0;
replica_4=0;
replica_5=0;



for i in {0..20}
do
   
   curl -s -w "\nTotal: %{time_total}s\n"  -i  http://37.152.180.112/ > xx.txt;

    time[$i]=$(cat xx.txt | tail -n 1 | cut -d " " -f 2 | rev | cut -c2- | rev );
    status_code[$i]=$(cat xx.txt | head -n 1 | cut -d " " -f 2);
    which_replica[$i]=$(cat xx.txt | grep "<br/>" |  cut -d " " -f 5 | cut -d "<" -f 1);

done


for value in "${status_code[@]}"
do
    v=${value:0:1}
    case $v in

        1)
            ((one_xx++));
        ;;

        2)
            ((two_xx++));
        ;;


        3)
            ((three_xx++));
        ;;


        4)
            ((four_xx++));
        ;;


        5)
            ((five_xx++));
        ;;


        *)
             ((other++));
        ;;
    esac
done



for value in "${which_replica[@]}"
do
    case $value in

        1)
            ((replica_1++));
        ;;

        2)
            ((replica_2++));
        ;;

        3)
            ((replica_3++));
        ;;

        4)
            ((replica_4++));
        ;;

        5)
            ((replica_5++));
        ;;
    esac
done




echo " ===========Results===================== ";
#echo $two_xx;
printf 'number of 1xx responses = %s \n' "$one_xx"
printf 'number of 2xx responses = %s \n' "$two_xx"
printf 'number of 3xx responses = %s \n' "$three_xx"
printf 'number of 4xx responses = %s \n' "$four_xx"
printf 'number of 5xx responses = %s \n' "$five_xx"
printf 'number of otherxx responses = %s \n' "$other_xx"

printf ' \n'

printf 'number of requests routed to server1 = %s \n' "$replica_1"
printf 'number of requests routed to server2 = %s \n' "$replica_2"
printf 'number of requests routed to server3 = %s \n' "$replica_3"
printf 'number of requests routed to server4 = %s \n' "$replica_4"
printf 'number of requests routed to server5 = %s \n' "$replica_5"




