function [Output,index]=Plot_function(buffer,Filter_Flag,index,Newnew_pts,Output,fig,data,offset,Gain,Fs,LPF,HPF)
    index = mod(index,buffer)+1; %  (1%5000=1)+1=2  (2%5000=2)+1=3 (3%5000=3)+1=4 .....(5000%5000=0)+1=1 
    
    if mod(index,Newnew_pts) == 0 && index >= Newnew_pts  % ·í index = 50 ®É and i=50    
         if Filter_Flag == 0  % No Filter
            Output=data(1:(index-1));
         else
             %EEGLab Filter
            Output= EEG_Filter(data(1:index-1),...
                           Fs,...
                           length(data(1:index-1)),...%Point_per_trials,... 
                           LPF,...%Low_Pass_Freq,...
                           HPF,...%High_Pass_Freq,...
                           1650, 0, [], 0);
         end
         set(fig,'ydata',Output(1:index-1)*Gain+offset);
         drawnow limitrate;    
    end
end