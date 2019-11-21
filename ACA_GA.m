clc
clear
close all



% parameters
ax = 128; % grid number
iter_num = 2000;
Pp = 0.8; % pick up probability
Pd = 0.8; % drop down probability
AntNumber = 500; % ant number
obj_num_red = 100; % red object number
obj_num_blue = 100; % blue object number
obj_total = obj_num_red+obj_num_blue;

[X,Y]=meshgrid(0:ax);
figure; hold on;
h1 = plot(X,Y,'k');
h2 = plot(Y,X,'k');
axis off;
axis([0 ax 0 ax])
obj_array_red = [];
obj_array_blue = [];
ant_array = [];
j = 1;
t = 1;
DirectionMatrix = [-1 -1; 0 -1; 1 -1; -1 1; 0 1; 1 1;-1 0; 1 0];
DM = [-1 -1; 0 -1; 1 -1; -1 1; 0 1; 1 1;-1 0; 1 0];


%spreading objects
for i = 1:1:obj_total
    randx = randi([0 ax-1],1,1)+0.5;
    randy = randi([0 ax-1],1,1)+0.5;
    if i < obj_num_red+1
        % objects might overlap, ignore overlapping
        h3 = plot(randx,randy,'or');
         delete(h3)
        obj_array_red = [obj_array_red; randx,randy];
    else
        h4 = plot(randx,randy,'ob');
         delete(h4)
        obj_array_blue = [obj_array_blue; randx,randy];
    end
end
obj_array = [obj_array_red; obj_array_blue]; % all objects array

% placing ants
while j <= AntNumber 
    randx = randi([0 ax-1],1,1)+0.5;
    randy = randi([0 ax-1],1,1)+0.5;
    if any(obj_array(:,1) == randx) ~= 1 || any(obj_array(:,2) == randy) ~= 1
        h5 = plot(randx,randy,'*k');
        ant_array = [ant_array; randx,randy,0];
        j = j+1;
        delete(h5)
    end
end 


% main loop, clustering
while t <= iter_num
    for ii = 1:1:AntNumber
        if ant_array(ii,3) == 0 % unloaded ant
            if ismember(ant_array(ii,1:2),obj_array_red,'rows') == 1 % cell occupied by red
                % pick up red
                ant_array(ii,3) = 1;
                % delete corresponding red
                [decision, location] = ismember(ant_array(ii,1:2),obj_array_red,'rows');
                obj_array_red(location,:) = [];
            elseif ismember(ant_array(ii,1:2),obj_array_blue,'rows') == 1 % cell occupied by blue
                % pick up blue
                ant_array(ii,3) = -1;
                % delete corresponding blue
                [decision, location] = ismember(ant_array(ii,1:2),obj_array_blue,'rows');
                obj_array_blue(location,:) = [];
            end
        else % obviously loaded ant
            % 1 represents loaded by red, -1 represensts loaded by blue
            if ant_array(ii,3) == 1 && ismember(ant_array(1,1:2),obj_array_red,'rows') == 0 ...
                    && ismember(ant_array(1,1:2),obj_array_blue,'rows') == 0 && ...
                     (ismember(ant_array(ii,1:2)+DM(1,:),obj_array_red,'rows') == 1 || ...
                     ismember(ant_array(ii,1:2)+DM(2,:),obj_array_red,'rows') == 1 || ...
                     ismember(ant_array(ii,1:2)+DM(3,:),obj_array_red,'rows') == 1 || ...
                     ismember(ant_array(ii,1:2)+DM(4,:),obj_array_red,'rows') == 1 || ...
                     ismember(ant_array(ii,1:2)+DM(5,:),obj_array_red,'rows') == 1 || ...
                     ismember(ant_array(ii,1:2)+DM(6,:),obj_array_red,'rows') == 1 || ...
                     ismember(ant_array(ii,1:2)+DM(7,:),obj_array_red,'rows') == 1 || ...
                     ismember(ant_array(ii,1:2)+DM(8,:),obj_array_red,'rows') == 1)
                % ant loaded by red && cell empty --- done 
                % && red object nearby --- pending
                % drop down red
                ant_array(ii,3) = 0;
                % insert object in red
                obj_array_red = [obj_array_red; ant_array(ii,1:2)];
            elseif ant_array(ii,3) == -1 && ismember(ant_array(1,1:2),obj_array_red,'rows') == 0 ...
                    && ismember(ant_array(1,1:2),obj_array_blue,'rows') == 0 && ...
                    (ismember(ant_array(ii,1:2)+DM(1,:),obj_array_blue,'rows') == 1 || ...
                    ismember(ant_array(ii,1:2)+DM(2,:),obj_array_blue,'rows') == 1 || ...
                    ismember(ant_array(ii,1:2)+DM(3,:),obj_array_blue,'rows') == 1 || ...
                    ismember(ant_array(ii,1:2)+DM(4,:),obj_array_blue,'rows') == 1 || ...
                    ismember(ant_array(ii,1:2)+DM(5,:),obj_array_blue,'rows') == 1 || ...
                    ismember(ant_array(ii,1:2)+DM(6,:),obj_array_blue,'rows') == 1 || ...
                    ismember(ant_array(ii,1:2)+DM(7,:),obj_array_blue,'rows') == 1 || ...
                    ismember(ant_array(ii,1:2)+DM(8,:),obj_array_blue,'rows') == 1)
                % ant loaded by blue && cell empty --- done
                % && blue object nearby --- pending
                % drop down blue
                ant_array(ii,3) = 0;
                % insert object in blue
                obj_array_blue = [obj_array_blue; ant_array(ii,1:2)];
            end
        end
        
        randx = ant_array(ii,1) - 0.5;
        randy = ant_array(ii,2) - 0.5;
        
        randx = de2bi(randx); 
        randy = de2bi(randy);
        [k1,k2] = size(randx);
        [l1,l2] = size(randy);
        m = randi([1 7],1,1);
        n = randi([1 7],1,1);
        while k2 < 7 
            randx = [randx,0];
            k2 = k2+1;
        end
        while l2 < 7 
            randy = [randy,0];
            l2 = l2+1;
        end
        randx(1,m) = ~randx(1,m); 
        randy(1,n) = ~randy(1,n); 
        randx = binaryVectorToDecimal(randx,'LSBFirst')';
        randy = binaryVectorToDecimal(randy,'LSBFirst')';
        
        ant_array(ii,1) = randx + 0.5;
        ant_array(ii,2) = randy + 0.5;
        
       % move ant randomly to adjacent grid
       MoveStep = randi([1 8],1,1);  
       MoveDirection = DirectionMatrix(MoveStep,:);
       ant_temp = ant_array(ii,:); % copying current location of the ant
       ant_array(ii,1) = ant_array(ii,1) + MoveDirection(:, 1);
       ant_array(ii,2) = ant_array(ii,2) + MoveDirection(:, 2);
       while max(ant_array(ii,1:2)) >= ax || min(ant_array(ii,1:2)) <=0 % if ant goes outside grid do again
           ant_array(ii,:) = ant_temp;
           MoveStep = randi([1 8],1,1);  
           MoveDirection = DirectionMatrix(MoveStep,:);
           ant_array(ii,1) = ant_array(ii,1) + MoveDirection(:, 1);
           ant_array(ii,2) = ant_array(ii,2) + MoveDirection(:, 2);
           % ant's might overlap, ignore overlapping
       end
       
    end
    delete(h3)
    delete(h4)
    delete(h5)
    h3 = plot(obj_array_red(:,1),obj_array_red(:,2),'or');
    h4 = plot(obj_array_blue(:,1),obj_array_blue(:,2),'ob');
    h5 = plot(ant_array(:,1),ant_array(:,2),'*k');
    drawnow;
%     F(t) = getframe(gcf);
%     pause(0.001);
    t = t+1;
end

% video = VideoWriter('Vid','MPEG-4');
% video.FrameRate = 60;
% open(video)
% writeVideo(video,F);
% close(video)






