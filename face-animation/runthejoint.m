cd(fileparts(which('points.out')));
pointpipe = fopen('head-points_pipe','r');
posepipe = fopen('head-poses_pipe','r');

%while true
%pose=fread(posepipe, '%i);
%points=fread(pointpipe,[1 3]);
%disp(pose)
%end

fclose(pointpipe);
fclose(posepipe);