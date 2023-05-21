if (($# < 1))
then
    echo "Usage: ./run.sh <task_name>"
    exit
fi

if [ ! -f "./"$1 ];
then
    ./new.sh $1
    echo "Task doesn't exist, has created "$1"\n"
fi

path="./"$1"/"

exe=$path$1".exe"
obj=$path$1".obj"
rm -rf $exe $obj

dosbox -c "mount c ." -c "c:" -c "cd "$1 -c "..\TOOLS\MASM "$1".asm;" -c "..\TOOLS\LINK "$1";" -c $1