mkfifo points_pipe
mkfifo poses_pipe

a=./points.out>points_pipe &
b=./poses.out>poses_pipe &
echo $a $b
