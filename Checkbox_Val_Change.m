function [Data_array] = Checkbox_Val_Change (toggle_state,Data_array,Channel_Selection,Ch)
switch toggle_state
    case 1 
            if  ~isempty(find(Channel_Selection) == 1) || isempty(Channel_Selection) % if '1' is not at the array
                Channel_Selection = [Ch Channel_Selection];
            end
    case 0
            Channel_Selection(Channel_Selection == Ch) = [];   
end
    Data_array{19,2} = sort(Channel_Selection);
end