bold=$'%{\e[1m%}'
reset=$'%{\e[0m%}'
red=$'%{\e[31m%}'
time=$'%{\e[36m%}%T'
code="$red%(?.. [%?])"

id=`id -u`

if [ "$id" -eq 0 ]; then
	user=$'%{\e[34m%}%n'
else
	user=$'%{\e[31m%}%n'
fi

at=$'%{\e[33m%}@'
dir=$'%{\e[32m%}%~'
host=$'%{\e[37m%}%m'
separator=$'%{\e[33m%}#'
lf=$'\n'

export PROMPT="$bold$time $user$at$host $dir$code $separator$reset "
